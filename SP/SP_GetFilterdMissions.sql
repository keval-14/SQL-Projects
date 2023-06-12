 
-- =======================================================================================================================================
-- Author:		<Keval Mangukiya>
-- Create date: <25-05-2023>
-- Description:	<Dynamic Stored Procedure for getting Filterd Misisons>
-- =======================================================================================================================================


--EXEC SP_GetFilterdMissions @searchTerm='pune', @minRating=2, @pageIndex=1, @pageSize=5
--EXEC SP_GetFilterdMissions @startDate = '2023-06-01', @endDate='2023-06-29', @pageIndex=1, @pageSize=5
--EXEC SP_GetFilterdMissions @searchTerm='mexi', @startDate = '2023-05-28', @maxRating=3, @pageIndex=1, @pageSize=5
--EXEC SP_GetFilterdMissions @startDate='2023-06-05',  @minRating=3, @pageIndex=1, @pageSize=5
--EXEC SP_GetFilterdMissions @minRating=2, @maxRating=3, @pageIndex=1, @pageSize=5
--EXEC SP_GetFilterdMissions @searchTerm='', @startDate = '2023-06-01', @endDate='2023-07-15', @minRating=4,@pageIndex=1, @pageSize=5
--EXEC SP_GetFilterdMissions @searchTerm='Charity', @maxRating=4, @pageIndex=1, @pageSize=5
--EXEC SP_GetFilterdMissions @startDate = '2023-06-01', @endDate='2023-07-10', @maxRating=2, @pageIndex=1, @pageSize=5
--EXEC SP_GetFilterdMissions @pageIndex=1, @pageSize=20, @searchTerm='dancing'
--EXEC SP_GetFilterdMissions @searchTerm='resc', @pageIndex=1, @pageSize=2, @startDate = '2023-06-01', @endDate='2023-07-15', @minRating=3, @pageIndex=1, @pageSize=5
--EXEC SP_GetFilterdMissions null,null, null, null, 'runn, plann', null, null, null, null, 1, 100
--EXEC SP_GetFilterdMissions @startDate = '2023-06-01', @pageIndex=1, @pageSize=5,@minRating=3,@maxRating=4 

--EXEC SP_GetFilterdMissions @pageIndex=1, @pageSize=10, @minRating=3,@maxRating=4 




ALTER PROCEDURE SP_GetFilterdMissions
    @searchTerm NVARCHAR(100) = NULL,
    @city NVARCHAR(100) = NULL,
    @country NVARCHAR(100) = NULL,
    @theme NVARCHAR(100) = NULL,
    @skill NVARCHAR(100) = NULL,
    @startDate DATE = NULL,
    @endDate DATE = NULL,
    @minRating INT = NULL,
    @maxRating INT = NULL,
    @pageIndex INT = 1,
    @pageSize INT = 5
AS
BEGIN

    DECLARE @SQLQuery NVARCHAR(MAX);
    DECLARE @ParamDefinition NVARCHAR(MAX);

    DECLARE @StartIndex AS INT;
    DECLARE @EndIndex AS INT;

    IF @pageIndex <= 0
        SET @pageIndex = 1;

    IF @pageSize <= 0
        SET @pageSize = 5;

    SET @StartIndex = ((@pageIndex - 1) * @pageSize) + 1;
    SET @EndIndex = @pageIndex * @pageSize;


    SET @SQLQuery
        = N'select * from(
        SELECT ROW_NUMBER() OVER (ORDER BY M.mission_id) AS [No],
               M.title AS [Title],
               C.name AS [City],
               CD.CName AS [Country],
               MT.title AS [Theme],
               LEFT(M.description,30) AS [Description],
               LEFT(M.short_description,30) AS [ShortDescription],
               M.organization_name AS [OrganizationName],
               CAST(M.start_date AS DATE) AS [StartDate],
               CAST(M.end_date AS DATE) AS [EndDate],
               CASE M.mission_type
                   WHEN 0 THEN
                       ''Time''
                   WHEN 1 THEN
                       ''Goal''
                   ELSE
                       ''Unknown''
               END AS [MissionType],
               ISNULL(dbo.FN_GetAVGRatings(M.mission_id), 0) AS [AVGRating],
               dbo.FN_GetMissionSkillsList(M.mission_id) AS [SkillList],
               COUNT(1) OVER () AS [TotalRecords]
        FROM mission M
            INNER JOIN city C
                ON C.city_id = M.city_id
            INNER JOIN FN_GetCountryData() CD
                ON CD.CID = M.country_id
            INNER JOIN mission_theme MT
                ON MT.mission_theme_id = M.theme_id
				WHERE 1=1';



    --searchterm is not null

    IF @searchTerm IS NOT NULL
    BEGIN
        SET @SQLQuery
            = @SQLQuery + N'and (C.name LIKE ''%' + @searchTerm + N'%''
                  OR CD.CName LIKE ''%' + @searchTerm + N'%''
                  OR MT.title LIKE ''%' + @searchTerm + N'%''
				  OR M.title LIKE ''%' + @searchTerm + N'%''
                  OR M.description LIKE ''%' + @searchTerm + N'%''
                  OR M.short_description LIKE ''%' + @searchTerm
              + N'%''
                  OR M.organization_name LIKE ''%' + @searchTerm
              + N'%''
				  OR CASE M.mission_type
							 WHEN 0 THEN
								 ''Time''
							 WHEN 1 THEN
								 ''Goal''
							 ELSE
								 ''UNKNOWN''
						 END LIKE ''%' + @searchTerm + N'%''
				 )';
    END;



    --skills 
    IF @skill IS NOT NULL
    BEGIN
        SET @SQLQuery
            = @SQLQuery
              + N'and EXISTS
					(
						SELECT 1
						FROM dbo.mission_skill MS
						WHERE MS.mission_id = M.mission_id
							  AND EXISTS
						(
							SELECT 1
							FROM dbo.skill S
							WHERE S.skill_id = MS.skill_id
								  AND EXISTS
							(
								SELECT 1
								FROM
								(SELECT TRIM(value) as Items FROM STRING_SPLIT(''' + @skill
              + N''', '','') ) SK
								WHERE S.skill_name LIKE CONCAT(''%'',SK.Items,''%'')
							)
						)
					)';

    END;


    --SELECT 1 FROM dbo.mission_theme MT WHERE MT.title = M.theme_id


    --theme 
    IF @theme IS NOT NULL
    BEGIN
        SET @SQLQuery
            = @SQLQuery
              + N'and EXISTS
					(
						SELECT 1 FROM dbo.mission_theme MT WHERE MT.mission_theme_id = M.theme_id
							  AND EXISTS
						(
							SELECT 1
							FROM (SELECT TRIM(value) as Themes FROM STRING_SPLIT(''' + @theme
              + N''', '','') ) TH
							WHERE MT.title LIKE CONCAT(''%'',TH.Themes,''%'')
						)
					)';

    END;




    --city 
    IF @city IS NOT NULL
    BEGIN
        SET @SQLQuery
            = @SQLQuery
              + N'and EXISTS
					(
						SELECT 1 FROM dbo.city C WHERE C.city_id = M.city_id
							  AND EXISTS
						(
							SELECT 1
							FROM (SELECT TRIM(value) as Cities FROM STRING_SPLIT(''' + @city
              + N''', '','') ) CT
							WHERE C.name LIKE CONCAT(''%'',CT.Cities,''%'')
						)
					)';

    END;



    --country 
    IF @country IS NOT NULL
    BEGIN
        SET @SQLQuery
            = @SQLQuery
              + N'and EXISTS
					(
						SELECT 1 FROM dbo.country CNT WHERE CNT.country_id = M.country_id
							  AND EXISTS
						(
							SELECT 1
							FROM (SELECT TRIM(value) as Countries FROM STRING_SPLIT(''' + @country
              + N''', '','') ) CNTS
							WHERE CNT.name LIKE CONCAT(''%'',CNTS.Countries,''%'')
						)
					)';

    END;



    --startdate is not null
    IF @startDate IS NOT NULL
    BEGIN
        SET @SQLQuery = @SQLQuery + N'and M.start_date >=''' + CAST(@startDate AS VARCHAR(20)) + N'''';
    END;



    ----endDate is not null

    IF @endDate IS NOT NULL
    BEGIN
        SET @SQLQuery = @SQLQuery + N'and M.end_date <=''' + CAST(@endDate AS VARCHAR(20)) + N'''';
    END;



    --minrating is not null

    IF @minRating IS NOT NULL
    BEGIN
        SET @SQLQuery
            = @SQLQuery + N'and ISNULL(dbo.FN_GetAVGRatings(M.mission_id), 0) >= ' + CAST(@minRating AS VARCHAR(5))
              + N'';
    END;



    --maxrating is not null

    IF @maxRating IS NOT NULL
    BEGIN
        SET @SQLQuery
            = @SQLQuery + N'and ISNULL(dbo.FN_GetAVGRatings(M.mission_id), 0)  <= ' + CAST(@maxRating AS VARCHAR(5))
              + N'';
    END;

    SET @SQLQuery
        = @SQLQuery + N') T WHERE T.[No] >= ' + CAST(@StartIndex AS NVARCHAR(15)) + N'
          AND T.[No] <= ' + CAST(@EndIndex AS NVARCHAR(15)) + N'
    ORDER BY T.[No]';


    PRINT (@SQLQuery);
    EXEC (@SQLQuery);

END;