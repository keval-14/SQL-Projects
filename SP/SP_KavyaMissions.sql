alter VIEW MissionDetails AS
SELECT DISTINCT miss.[mission_id], miss.[city_id], CI.[name] AS cityName, miss.[country_id], CO.[name] AS countryName, miss.[theme_id], MT.[title] AS themeName,
    miss.[title], LEFT(miss.[short_description], 40) AS [short_description], miss.[description], miss.[start_date], miss.[end_date], miss.[mission_type],
    miss.[status], miss.[deadline], miss.[organization_name], miss.[organization_detail], miss.[availability], miss.[created_at], miss.[updated_at], miss.[deleted_at]
FROM [dbo].[mission] AS miss
LEFT JOIN [dbo].[mission_skill] AS miss_skill ON miss.mission_id = miss_skill.mission_id
LEFT JOIN [dbo].[story] AS story ON miss.mission_id = story.mission_id
LEFT JOIN [dbo].[city] AS CI ON miss.city_id = CI.city_id
LEFT JOIN [dbo].[country] AS CO ON miss.country_id = CO.country_id
LEFT JOIN [dbo].[mission_theme] AS MT ON miss.theme_id = MT.mission_theme_id
LEFT JOIN [dbo].[mission_rating] AS mr ON miss.mission_id = mr.mission_id;
go

ALTER PROCEDURE TotalSearchInMissions
	@searchtext VARCHAR(MAX) = NULL,
    @city_id VARCHAR(MAX) = NULL,
    @country_id VARCHAR(MAX) = NULL,
    @theme_id VARCHAR(MAX) = NULL,
    @title VARCHAR(126) = NULL,
    @short_description VARCHAR(MAX) = NULL,
    @start_date DATETIME = NULL,
    @end_date DATETIME = NULL,
    @mission_type VARCHAR(MAX) = NULL,
    @organization_name VARCHAR(MAX) = NULL,
    @availability VARCHAR(MAX) = NULL,
    @deadline DATETIME = NULL,
    @minimum_rating INT = NULL,
    @maximum_rating INT = NULL,
    @skillids VARCHAR(MAX) = NULL,
    @storyviews INT = NULL,
    @PageNumber INT = 1,
	@PageSize INT = 10,
	@Expression NVARCHAR(MAX) = 'mission_id',
    @IsSortByAsc BIT = 1
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Offset INT,
			@Sql NVARCHAR(MAX);

	IF @PageNumber <= 0
		SET @PageNumber = 1;
	SET @Offset = (@PageNumber - 1) * @PageSize;

	SET @Sql = N'';
	SET @Sql = N'
	WITH A AS (
		SELECT *
		FROM MissionDetails
		WHERE 1 = 1 '

	
	IF @SearchText IS NOT NULL
BEGIN
    SET @Sql = @Sql + N' AND (
        [title] LIKE ''%'' + @searchtext + ''%'' 
        OR [short_description] LIKE ''%'' + @searchtext + ''%'' 
        OR cityName LIKE ''%'' + @searchtext + ''%'' 
        OR countryName LIKE ''%'' + @searchtext + ''%'' 
        OR themeName LIKE ''%'' + @searchtext + ''%''
        OR [description] LIKE ''%'' + @searchtext + ''%''
        OR [start_date] LIKE ''%'' + @searchtext + ''%''
        OR [end_date] LIKE ''%'' + @searchtext + ''%''
        OR [mission_type] LIKE ''%'' + @searchtext + ''%''
        OR [status] LIKE ''%'' + @searchtext + ''%''
        OR [deadline] LIKE ''%'' + @searchtext + ''%''
        OR [organization_name] LIKE ''%'' + @searchtext + ''%''
        OR [organization_detail] LIKE ''%'' + @searchtext + ''%''
        OR [availability] LIKE ''%'' + @searchtext + ''%''
    ) '
END
IF @title IS NOT NULL
	BEGIN
		SET @SQL = @SQL + N' AND [title] LIKE ''%'' + @title + ''%'' '
	END
	IF @theme_id IS NOT NULL
	BEGIN
		SET @SQL = @SQL + N' AND [theme_id] = @theme_id ' 
	END

	IF @country_id IS NOT NULL
	BEGIN
		SET @SQL = @SQL + N' AND [country_id] = @country_id '
	END

	IF @city_id IS NOT NULL
	BEGIN
		SET @SQL = @SQL + N' AND [city_id] = @city_id ' 
	END


	IF @short_description IS NOT NULL
	BEGIN
		SET @SQL = @SQL + N' AND [short_description] LIKE ''%'' + @short_description + ''%'' '
	END
	
	IF @mission_type IS NOT NULL
	BEGIN
		SET @SQL = @SQL + N' AND [mission_type] LIKE ''%'' + @mission_type + ''%'' '
	END

	IF @start_date IS NOT NULL AND @end_date IS NOT NULL
	BEGIN
		SET @SQL = @SQL + N' AND CAST([start_date] AS DATE) <= @end_date AND CAST([end_date] AS DATE) <= @end_date'
	END
	ELSE IF @start_date IS NOT NULL
	BEGIN
		SET @SQL = @SQL + N' AND CAST([start_date] AS DATE) = @start_date'
	END
	ELSE IF @end_date IS NOT NULL
	BEGIN
		SET @SQL = @SQL + N' AND CAST([end_date] AS DATE) = @end_date'
	END
	
   IF @organization_name IS NOT NULL
	BEGIN
		SET @SQL = @SQL + N' AND [organization_name] LIKE ''%'' + @organization_name + ''%'' ' 
	END
	
	IF @availability IS NOT NULL
	BEGIN
		SET @SQL = @SQL + N' AND [availability] LIKE ''%'' + @availability + ''%'' ' 
	END

	IF @deadline IS NOT NULL
	BEGIN
		SET @SQL = @SQL + N' AND CAST([deadline] AS DATE) = @deadline '
	END

	IF @minimum_rating IS NOT NULL OR @maximum_rating IS NOT NULL
	BEGIN
		SET @SQL = @SQL + N' AND EXISTS (
			SELECT 1
			FROM mission_rating AS rating
			WHERE rating.mission_id = [mission_id]
			GROUP BY rating.mission_id
			HAVING AVG(rating.rating) = @minimum_rating OR AVG(rating.rating) = @maximum_rating
		) '
	END

	IF @skillids IS NOT NULL 
	BEGIN
		SET @SQL = @SQL + N' AND skill_id IN (SELECT value FROM STRING_SPLIT(@skillids, '','')) '
	END
	
	IF @storyviews IS NOT NULL 
	BEGIN
		SET @SQL = @SQL + N' AND views < @storyviews '
	END

	SET @SQL = @SQL + N'), B AS (
		SELECT ROW_NUMBER() OVER (ORDER BY ' + @Expression + N' ' + CASE WHEN @IsSortByAsc = 1 THEN 'ASC' ELSE 'DESC' END + N') AS RowNum, A.*, (SELECT COUNT(1) FROM A) AS TotalCount
		FROM A
	) 
	SELECT B.RowNum, B.[mission_id], B.[theme_id], themeName, [country_id], countryName, [city_id], cityName, [title], [short_description], [start_date], [end_date], [mission_type], [organization_name], [availability], [deadline], B.TotalCount, (SELECT AVG(rating) FROM mission_rating WHERE mission_id = B.[mission_id]) AS average_rating
	FROM B 
	WHERE RowNum > @Offset AND RowNum <= @Offset + @PageSize';

	PRINT(@Sql);
	DECLARE @MissionResult TABLE									
	(					
		RowNum INT,												
		[mission_id] BIGINT, 
		[theme_id] BIGINT,
		themeName VARCHAR(255),
		[country_id] BIGINT,
		countryName VARCHAR(255),
		[city_id] BIGINT,
		cityName VARCHAR(255),
		[title] VARCHAR(126), 
		[short_description] VARCHAR(MAX), 
		[start_date] DATETIME, 
		[end_date] DATETIME, 
		[mission_type] VARCHAR(20), 
		[organization_name] VARCHAR(255), 
		[availability] VARCHAR(20),
		[deadline] DATETIME, 
		[TotalCount] INT,
		[average_rating] INT NULL
	);
	INSERT INTO @MissionResult
	EXEC sp_executesql @Sql,
		N'
		@searchtext VARCHAR(MAX),
		@theme_id VARCHAR(MAX), 
		@country_id VARCHAR(MAX), 
		@city_id VARCHAR(MAX), 
		@title VARCHAR(126),
		@short_description VARCHAR(MAX), 
		@mission_type VARCHAR(20),
		@start_date DATETIME, 
		@end_date DATETIME, 
		@organization_name VARCHAR(255), 
		@availability VARCHAR(20), 
		@deadline DATETIME, 
		@minimum_rating INT, 
		@maximum_rating INT, 
		@skillids VARCHAR(MAX), 
		@storyviews INT,
		@Offset INT,
		@PageSize INT,
		@Expression NVARCHAR(MAX),
		@IsSortByAsc BIT',
		@searchtext,
		@theme_id,
		@country_id,
		@city_id,
		@title,
		@short_description,
		@mission_type,
		@start_date,
		@end_date,
		@organization_name,
		@availability,
		@deadline,
		@minimum_rating,
		@maximum_rating,
		@skillids,
		@storyviews,
		@Offset,
		@PageSize,
		@Expression,
		@IsSortByAsc;
		
	SELECT * FROM @MissionResult;

	--exec TotalSearchInMissions @start_date = '2023-01-01' , @end_date = '2023-04-05'
end
GO

