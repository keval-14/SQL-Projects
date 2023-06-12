
-- =======================================================================================================================================
-- Author:		<Keval Mangukiya>
-- Create date: <26-05-2023>
-- Description:	<Dynamic Stored Procedure for all the filters and searching with pagination>
-- =======================================================================================================================================


--TotalSearchInMissions @skillids=2




ALTER PROCEDURE TotalSearchInMissions
    @searchtext VARCHAR(MAX) = NULL,
    @city_id VARCHAR(MAX) = NULL,
    @country_id VARCHAR(MAX) = NULL,
    @theme_id VARCHAR(MAX) = NULL,
    @title VARCHAR(MAX) = NULL,
    @short_description VARCHAR(MAX) = NULL,
                         --@description VARCHAR(MAX) = NULL,
    @start_date DATETIME = NULL,
    @end_date DATETIME = NULL,
    @mission_type VARCHAR(MAX) = NULL,
                         -- @status VARCHAR(MAX) = NULL,
    @organization_name VARCHAR(MAX) = NULL,
                         --@organization_detail VARCHAR(MAX) = NULL,
    @availability VARCHAR(MAX) = NULL,
                         --@created_at DATE = NULL,
                         -- @updated_at VARCHAR(MAX) = NULL,

    @deadline DATETIME = NULL,
    @minimum_rating INT = NULL,
    @maximum_rating INT = NULL,
    @skillids VARCHAR(MAX) = NULL,
    @storyviews INT = NULL,
    @PageNumber INT = 1, -- Page number
    @PageSize INT = 15,  -- Number of records per page
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
    SET @Sql
        = N'
	With A as ( 
	 SELECT DISTINCT miss.[mission_id], miss.[city_id],CI.[name] AS cityName ,miss.[country_id],CO.[name] AS countryName, miss.[theme_id],MT.[title] AS themeName, miss.[title], miss.[short_description], '
          + N'miss.[description], miss.[start_date], miss.[end_date], miss.[mission_type], miss.[status], miss.[deadline], '
          + N'miss.[organization_name], miss.[organization_detail], miss.[availability], miss.[created_at], miss.[updated_at], '
          + N'miss.[deleted_at] ' + N'FROM [dbo].[mission] AS miss '
          + N'LEFT JOIN [dbo].[mission_skill] AS miss_skill ON miss.mission_id = miss_skill.mission_id '
          + N'LEFT JOIN [dbo].[story] AS story ON miss.mission_id = story.mission_id '
          + N'LEFT JOIN [dbo].[city] AS CI ON miss.city_id = CI.city_id '
          + N'LEFT JOIN [dbo].[country] AS CO ON miss.country_id = CO.country_id '
          + N'LEFT JOIN [dbo].[mission_theme] AS MT ON miss.theme_id = MT.mission_theme_id '
          + N'LEFT JOIN [dbo].[mission_rating] AS mr ON miss.mission_id = mr.mission_id ' + N'WHERE 1 = 1 ';

    IF @searchtext IS NOT NULL
    BEGIN

        SET @Sql
            = @Sql + N' AND (miss.[title] LIKE ''%'' + @searchtext + ''%'' '
              + N'OR miss.[short_description] LIKE ''%'' + @searchtext + ''%'' '
              + N'OR CI.[name] LIKE ''%'' + @searchtext + ''%'' ' + N'OR CO.[name] LIKE ''%'' + @searchtext + ''%'' '
              + N'OR MT.[title] LIKE ''%'' + @searchtext + ''%'' '
              + N'OR miss.[description] LIKE ''%'' + @searchtext + ''%'' '
              + N'OR miss.[start_date] LIKE ''%'' + @searchtext + ''%'' '
              + N'OR miss.[end_date] LIKE ''%'' + @searchtext + ''%'' '
              + N'OR miss.[mission_type] LIKE ''%'' + @searchtext + ''%'' '
              + N'OR miss.[status] LIKE ''%'' + @searchtext + ''%'' '
              + N'OR miss.[deadline] LIKE ''%'' + @searchtext + ''%'' '
              + N'OR miss.[organization_name] LIKE ''%'' + @searchtext + ''%'' '
              + N'OR miss.[organization_detail] LIKE ''%'' + @searchtext + ''%'' '
              + N'OR miss.[availability] LIKE ''%'' + @searchtext + ''%'') ';
    END;

    IF @theme_id IS NOT NULL
    BEGIN

        SET @Sql = @Sql + N' AND miss.[theme_id] = @theme_id ';
    END;

    IF @country_id IS NOT NULL
    BEGIN

        SET @Sql = @Sql + N' AND miss.[country_id] = @country_id ';
    END;

    IF @city_id IS NOT NULL
    BEGIN

        SET @Sql = @Sql + N' AND miss.[city_id] = @city_id ';
    END;

    IF @title IS NOT NULL
    BEGIN

        SET @Sql = @Sql + N' AND miss.[title] LIKE ''%'' + @title + ''%'' ';
    END;

    IF @short_description IS NOT NULL
    BEGIN

        SET @Sql = @Sql + N' AND miss.[short_description] LIKE ''%'' + @short_description + ''%'' ';
    END;
    IF @mission_type IS NOT NULL
        SET @Sql = @Sql + N' AND miss.[mission_type] LIKE ''%'' + @mission_type + ''%'' ';

    IF @start_date IS NOT NULL
    BEGIN

        SET @Sql = @Sql + N' AND CAST(miss.[start_date] AS DATE) = @start_date ';
    END;

    IF @end_date IS NOT NULL
    BEGIN

        SET @Sql = @Sql + N' AND CAST(miss.[end_date] AS DATE) = @end_date ';
    END;

    IF @organization_name IS NOT NULL
    BEGIN
        SET @Sql = @Sql + N' AND miss.[organization_name] LIKE ''%'' + @organization_name + ''%'' ';
    END;

    IF @availability IS NOT NULL
    BEGIN
        --SET @availability = REPLACE(@availability, ',', ''',''');
        SET @Sql = @Sql + N' AND miss.[availability] LIKE ''%'' + @availability + ''%'' ';
    END;



    IF @deadline IS NOT NULL
    BEGIN

        SET @Sql = @Sql + N' AND CAST(miss.[deadline] AS DATE) = @deadline ';
    END;


    IF @minimum_rating IS NOT NULL
       OR @maximum_rating IS NOT NULL
    BEGIN
        SET @minimum_rating = REPLACE(@minimum_rating, ',', ''',''');
        SET @maximum_rating = REPLACE(@maximum_rating, ',', ''',''');
        SET @Sql
            = @Sql
              + N' AND EXISTS (
                    SELECT 1
                    FROM mission_rating AS rating
                    WHERE rating.mission_id = miss.mission_id
                    GROUP BY rating.mission_id
                    HAVING AVG(rating.rating) > @minimum_rating OR AVG(rating.rating) < @maximum_rating
                ) ';
    END;

    IF @skillids IS NOT NULL
    BEGIN

        SET @Sql = @Sql + N' AND miss_skill.skill_id IN (SELECT value FROM STRING_SPLIT(@skillids, '','')) ';
    END;

    IF @storyviews IS NOT NULL
    BEGIN

        SET @Sql = @Sql + N' AND story.views < @storyviews ';
    END;

    SET @Sql
        = @Sql + N'), B as (
	SELECT ROW_NUMBER() OVER (ORDER BY ' + @Expression + N' ' + CASE
                                                                    WHEN @IsSortByAsc = 1 THEN
                                                                        'ASC'
                                                                    ELSE
                                                                        'DESC'
                                                                END
          + N') AS RowNum, A.*, (Select count(1) FROM A) as TotalCount
	    FROM A ) SELECT B.RowNum, B.[mission_id],
		B.[theme_id],themeName,[country_id],countryName, [city_id],cityName, [title], [short_description],[start_date],[end_date], [mission_type], [organization_name] , [availability],[deadline], B.TotalCount 
		FROM B where RowNum >=  @Offset  AND RowNum <= @Offset + @PageSize';


    PRINT (@Sql);
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
        --[created_at] VARCHAR(20),
        [deadline] DATETIME,
        [TotalCount] INT
    );
    INSERT INTO @MissionResult
    EXEC sp_executesql @Sql,
                       N'@SearchText varchar(MAX), 
		@theme_id varchar(MAX), 
		@country_id varchar(MAX), 
		@city_id varchar(MAX), 
		@title varchar(128), 
		@short_description varchar(MAX), 
		@start_date datetime, 
		@end_date datetime, 
		@mission_type varchar(20), 
		@organization_name varchar(255), 
		@availability varchar(20), 
		--@created_at DATE, 
		@deadline datetime, 
		@minimum_rating int, 
		@maximum_rating int, 
		@skillids varchar(128), 
		@storyviews int,
		@Offset int,
		@PageSize int,
		@Expression NVARCHAR(MAX),
   @IsSortByAsc BIT',
                       @searchtext,
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
                       --@created_at,
                       @deadline,
                       @minimum_rating,
                       @maximum_rating,
                       @skillids,
                       @storyviews,
                       @Offset,
                       @PageSize,
                       @Expression,
                       @IsSortByAsc;
    SELECT *
    FROM @MissionResult;

--exec TotalSearchInMissions @Expression = 'title'
END;
