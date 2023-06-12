alter PROC SP_GetMissionList1
    @searchTerm NVARCHAR(100) = NULL,
    @startDate  DATE          = NULL,
    @endDate    DATE          = NULL,
    @minRating  INT           = NULL,
    @maxRating  INT           = NULL,
    @pageIndex INT           = NULL,
    @pageSize   INT           = NULL
AS
    BEGIN

        DECLARE @SQLQuery NVARCHAR(4000);
        DECLARE @ParamDefinition NVARCHAR(2000);


		SELECT ROW_NUMBER() OVER(ORDER BY mission.mission_id) AS [No.], mission.title AS [Title], CONCAT(mission.city_id , ',' , city.name) AS [City], CONCAT(mission.country_id, ',',country.name) AS [Country], CONCAT(mission.theme_id,',',mission_theme.title) AS [Theme], description AS [Description], short_description AS [ShortDescription],organization_name AS [OrganizationName], CAST(start_date AS DATE) AS [StartDate], CAST(end_date AS DATE) AS [EndDate],CASE mission_type WHEN 0 THEN 'Time' WHEN 1 THEN 'Goal' ELSE 'Unknown' END AS [MissionType] FROM mission  JOIN city 
		ON city.city_id = mission.city_id 
		JOIN country 
		ON country.country_id = mission.country_id 
		JOIN mission_theme 
		ON mission_theme.mission_theme_id = mission.theme_id
		WHERE @searchTerm IS NOT NULL AND @minRating IS NOT NULL
           AND @maxRating IS NOT NULL 

				AND CONCAT(mission.city_id , ',' , city.name) LIKE '%'+ @searchTerm +'%'
				
		   





        

        --searchTerm, minrating and maxRating is not null

        IF @searchTerm IS NOT NULL
           AND @minRating IS NOT NULL
           AND @maxRating IS NOT NULL
            BEGIN
                SET @SQLQuery
                    = @SQLQuery
                      + N'and CONCAT(mission.city_id , '','' , city.name) like ''%'' + @searchTerm + ''%''
				or (CONCAT(mission.country_id, '','',country.name) like ''%'' + @searchTerm + ''%''
				or CONCAT(mission.theme_id,'','',mission_theme.title) like ''%'' + @searchTerm + ''%''
				or description like ''%'' + @searchTerm + ''%''
				or short_description like ''%'' + @searchTerm + ''%''
				or organization_name like ''%'' + @searchTerm + ''%''
				or CASE mission_type WHEN 0 THEN ''Time'' WHEN 1 THEN ''Goal'' ELSE ''Unknown'' END like ''%'' + @searchTerm + ''%'') and rat.[AVG Rating] BETWEEN @minRating and @maxRating';
            END;

        --searchTerm is null but min and max rating is not null

        ELSE IF @searchTerm IS NULL
                AND @minRating IS NOT NULL
                AND @maxRating IS NOT NULL
            BEGIN
                SET @SQLQuery = @SQLQuery + N'and rat.[AVG Rating] BETWEEN @minRating and @maxRating';
            END;

        --only search term is not null

        ELSE IF @searchTerm IS NOT NULL
            BEGIN
                SET @SQLQuery
                    = @SQLQuery
                      + N'and CONCAT(mission.city_id , '','' , city.name) like ''%'' + @searchTerm + ''%''
				or CONCAT(mission.country_id, '','',country.name) like ''%'' + @searchTerm + ''%''
				or CONCAT(mission.theme_id,'','',mission_theme.title) like ''%'' + @searchTerm + ''%''
				or description like ''%'' + @searchTerm + ''%''
				or short_description like ''%'' + @searchTerm + ''%''
				or organization_name like ''%'' + @searchTerm + ''%''
				or CASE mission_type WHEN 0 THEN ''Time'' WHEN 1 THEN ''Goal'' ELSE ''Unknown'' END like ''%'' + @searchTerm + ''%''
				';
            END;

        --either min or max rating is null or only min and max rating provided 

        ELSE IF @minRating IS NOT NULL
                OR @maxRating IS NOT NULL
            BEGIN
                IF @minRating IS NOT NULL
                    BEGIN
                        SET @SQLQuery = @SQLQuery + N'and rat.[AVG Rating]>=@minRating';
                    END;
                ELSE IF @maxRating IS NOT NULL
                    BEGIN
                        SET @SQLQuery = @SQLQuery + N'and rat.[AVG Rating]<=@maxRating';
                    END;
            END;

        --startdate and endDate

        IF @startDate IS NOT NULL
           OR @endDate IS NOT NULL
            BEGIN
                IF @startDate IS NOT NULL
                    BEGIN
                        SET @SQLQuery = @SQLQuery + N'and CAST(start_date AS DATE) > @startDate ';
                    END;
                IF @endDate IS NOT NULL
                    BEGIN
                        SET @SQLQuery = @SQLQuery + N'and CAST(start_date AS DATE) < @endDate';
                    END;
            END;

        --pagination

        IF @pageIndex IS NOT NULL
           AND @pageSize IS NOT NULL
            BEGIN

                SET @SQLQuery
                    = @SQLQuery
                      + N'ORDER BY mission.mission_id
										offset (@pageIndex-1)*@pageSize rows fetch next @pageSize rows only';
            END;


        SET @ParamDefinition
            = N'@searchTerm nvarchar(100) = NULL,
									@startDate DATE = NULL,
									@endDate DATE= NULL,
									@minRating int = NULL,
									@maxRating int = NULL,
									@pageIndex int = NULL,
									@pageSize int = NULL';

        EXECUTE sp_executesql
            @SQLQuery,
            @ParamDefinition,
            @searchTerm,
            @startDate,
            @endDate,
            @minRating,
            @maxRating,
            @pageIndex,
            @pageSize;
    END;



--SP_GetMissionList1  @pageIndex = 3, @pageSize=5