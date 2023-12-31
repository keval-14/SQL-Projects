ALTER PROCEDURE [dbo].[SP_GetMission_Dynamic_with_pagination]
	@SearchText varchar(MAX) = NULL,
	@theme_id varchar(MAX) = NULL,
	@country_id varchar(MAX) = NULL,
	@city_id varchar(MAX) = NULL,
	@title varchar(128) = NULL,
	@short_description varchar(MAX) = NULL,
	@start_date varchar(20) = NULL,
	@end_date varchar(20) = NULL,
	@mission_type varchar(20) = NULL,
	@organization_name varchar(255) = NULL,
	@availability varchar(20) = NULL,
	@created_at varchar(20) = NULL,
	@deadline varchar(20) = NULL,
	@daysToVolunteer varchar(126) = NULL,
	@min_rating int = NULL,
	@max_rating int = NULL,
	@skillids varchar(128) = NULL,
	@storyviews int = NULL,
	@PageNumber int = 1, -- Page number
	@PageSize int = 10 -- Number of records per page
AS
BEGIN
SET NOCOUNT ON;

	DECLARE @Offset int,
			@Sql NVARCHAR(MAX);

	IF @PageNumber <= 0
		SET @PageNumber = 1
	SET @Offset = (@PageNumber - 1) * @PageSize;

	SET @Sql = N'';
	SET @Sql = N'
	With A as ( 
	SELECT DISTINCT M.[mission_id], 
		M.[theme_id],
		M.[country_id],
		M.[city_id],
		M.[title], 
		CONVERT(VARCHAR(MAX), M.[short_description]) AS [short_description], 
		M.[start_date], 
		M.[end_date], 
		M.[mission_type], 
		M.[organization_name], 
		M.[availability],
		M.[created_at],
		M.[deadline], 
		M.[DaysToVolunteer]
	FROM [dbo].[mission] AS M
	LEFT JOIN [dbo].[mission_rating] AS MR ON M.mission_id = MR.mission_id
	LEFT JOIN [dbo].[mission_skill] AS MS ON M.mission_id = MS.mission_id
	LEFT JOIN [dbo].[story] AS S ON M.mission_id = S.mission_id
	WHERE M.[mission_id] IS NOT NULL '

	IF @SearchText IS NOT NULL
	BEGIN
		SET @SearchText = REPLACE(@SearchText, ',', ''',''');
		SET @SQL = @SQL + N' AND (M.[title] LIKE ''%'' + @SearchText + ''%''
		OR M.[short_description] LIKE ''%'' + @SearchText + ''%''
		OR M.[start_date] LIKE ''%'' + @SearchText + ''%''
		OR M.[end_date] LIKE ''%'' + @SearchText + ''%''
		OR M.[mission_type] LIKE ''%'' + @SearchText + ''%''
		OR M.[organization_name] LIKE ''%'' + @SearchText + ''%''
		OR M.[organization_detail] LIKE ''%'' + @SearchText + ''%''
		OR M.[availability] LIKE ''%'' + @SearchText + ''%''
		OR M.[deadline] LIKE ''%'' + @SearchText + ''%'')' 
	END

	IF @theme_id IS NOT NULL
	BEGIN
		SET @theme_id = REPLACE(@theme_id, ',', ''',''');
		SET @SQL = @SQL + N' AND M.[theme_id] LIKE ''%'' + @theme_id + ''%'' ' 
	END

	IF @country_id IS NOT NULL
	BEGIN
		SET @country_id = REPLACE(@country_id, ',', ''',''');
		SET @SQL = @SQL + N' AND M.[country_id] LIKE ''%'' + @country_id + ''%'' ' 
	END

	IF @city_id IS NOT NULL
	BEGIN
		SET @city_id = REPLACE(@city_id, ',', ''',''');
		SET @SQL = @SQL + N' AND M.[city_id] LIKE ''%'' + @city_id + ''%'' ' 
	END

	IF @title IS NOT NULL
	BEGIN
		SET @title = REPLACE(@title, ',', ''',''');
		SET @SQL = @SQL + N' AND M.[title] LIKE ''%'' + @title + ''%'' ' 
	END
	
	IF @short_description IS NOT NULL
	BEGIN
		SET @short_description = REPLACE(@short_description, ',', ''',''');
		SET @SQL = @SQL + N' AND M.[short_description] LIKE ''%'' + @short_description + ''%'' ' 
	END

	IF @start_date IS NOT NULL
	BEGIN
		SET @start_date = REPLACE(@start_date, ',', ''',''');
		SET @SQL = @SQL + N' AND M.[start_date] LIKE ''%'' + @start_date + ''%'' ' 
	END

	IF @end_date IS NOT NULL
	BEGIN
		SET @end_date = REPLACE(@end_date, ',', ''',''');
		SET @SQL = @SQL + N' AND M.[end_date] LIKE ''%'' + @end_date + ''%'' ' 
	END

	IF @organization_name IS NOT NULL
	BEGIN
		SET @organization_name = REPLACE(@organization_name, ',', ''',''');
		SET @SQL = @SQL + N' AND M.[organization_name] LIKE ''%'' + @organization_name + ''%'' ' 
	END
	
	IF @availability IS NOT NULL
	BEGIN
		SET @availability = REPLACE(@availability, ',', ''',''');
		SET @SQL = @SQL + N' AND M.[availability] LIKE ''%'' + @availability + ''%'' ' 
	END

	IF @created_at IS NOT NULL
	BEGIN
		SET @created_at = REPLACE(@created_at, ',', ''',''');
		SET @SQL = @SQL + N' AND M.[created_at] LIKE ''%'' + @created_at + ''%'' ' 
	END

	IF @deadline IS NOT NULL
	BEGIN
		SET @deadline = REPLACE(@deadline, ',', ''',''');
		SET @SQL = @SQL + N' AND M.[deadline] LIKE ''%'' + @deadline + ''%'' ' 
	END

	IF @deadline IS NOT NULL
	BEGIN
		SET @daysToVolunteer = REPLACE(@daysToVolunteer, ',', ''',''');
		SET @SQL = @SQL + N' AND M.[DaysToVolunteer] LIKE ''%'' + @daysToVolunteer + ''%'' ' 
	END
	
	IF @min_rating IS NOT NULL AND @max_rating IS NOT NULL
	BEGIN
		SET @min_rating = REPLACE(@min_rating, ',', ''',''');
		SET @max_rating = REPLACE(@max_rating, ',', ''',''');
		SET @SQL = @SQL + N' AND MR.[avg_rating] BETWEEN @min_rating AND @max_rating ' 
	END

	IF @skillids IS NOT NULL 
	BEGIN
		SET @skillids = REPLACE(@skillids, ',', ''',''');
		SET @SQL = @SQL + N' AND MS.skill_id in (SELECT value FROM STRING_SPLIT(@skillids, '','')) ' 
	END
	
	IF @storyviews IS NOT NULL 
	BEGIN
		SET @storyviews = REPLACE(@storyviews, ',', ''',''');
		SET @SQL = @SQL + N' AND S.story_views < @storyviews ' 
	END

	SET @SQL = @SQL + N'), B as (
	SELECT ROW_NUMBER() OVER(ORDER BY A.mission_id) AS RowNum, A.*, (Select count(1) FROM A) as TotalCount
	    FROM A ) SELECT B.RowNum, B.[mission_id],B.[theme_id],[country_id], [city_id], [title], [short_description], [start_date], [end_date], [mission_type], [organization_name] , [availability], [created_at], [deadline], [DaysToVolunteer], B.TotalCount 
		FROM B where RowNum >=  @Offset  AND RowNum <= @Offset + @PageSize'

	print(@Sql)	;
	DECLARE @MissionResult TABLE									
        (					
		RowNum INT,												
        [mission_id] BIGINT, 
		[theme_id] BIGINT,
		[country_id] BIGINT,
		[city_id] BIGINT,
		[title] VARCHAR(126), 
		[short_description] VARCHAR(MAX), 
		[start_date] VARCHAR(20), 
		[end_date] VARCHAR(20), 
		[mission_type] VARCHAR(20), 
		[organization_name] VARCHAR(255), 
		[availability] VARCHAR(20),
		[created_at] VARCHAR(20),
		[deadline] VARCHAR(20), 
		[DaysToVolunteer] VARCHAR(126),
		[TotalCount] int
		)
    Insert into @MissionResult EXEC sp_executesql @Sql,
        N'@SearchText varchar(MAX), 
		@theme_id varchar(MAX), 
		@country_id varchar(MAX), 
		@city_id varchar(MAX), 
		@title varchar(128), 
		@short_description varchar(MAX), 
		@start_date varchar(20), 
		@end_date varchar(20), 
		@mission_type varchar(20), 
		@organization_name varchar(255), 
		@availability varchar(20), 
		@created_at varchar(20), 
		@deadline varchar(20), 
		@daysToVolunteer varchar(126), 
		@min_rating int, 
		@max_rating int, 
		@skillids varchar(128), 
		@storyviews int, 
		@Offset int, 
		@PageSize int',
        @SearchText,
        @theme_id,
        @country_id,
        @city_id,
        @title,
        @short_description,
        @start_date,
        @end_date,
        @mission_type,
        @organization_name,
        @availability,
        @created_at,
        @deadline,
        @daysToVolunteer,
        @min_rating,
        @max_rating,
        @skillids,
        @storyviews,
        @Offset,
        @PageSize;
		SELECT * FROM @MissionResult;
END