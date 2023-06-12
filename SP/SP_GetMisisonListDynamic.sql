
-- =======================================================================================================================================
-- Author:		<Keval Mangukiya>
-- Create date: <25-05-2023>
-- Description:	<Dynamic Stored Procedure for searching and filtering data from mission table with table valued function join>
-- =======================================================================================================================================


--EXEC SP_GetMissionListDynamic @searchTerm='pune', @minRating=2, @pageIndex=1, @pageSize=5
--EXEC SP_GetMissionListDynamic @startDate = '2023-06-01', @endDate='2023-06-29', @pageIndex=1, @pageSize=5
--EXEC SP_GetMissionListDynamic @searchTerm='mexi', @startDate = '2023-05-28', @maxRating=3, @pageIndex=1, @pageSize=5
--EXEC SP_GetMissionListDynamic @startDate='2023-06-05',  @minRating=3, @pageIndex=1, @pageSize=5
--EXEC SP_GetMissionListDynamic @minRating=2, @maxRating=3, @pageIndex=1, @pageSize=5
--EXEC SP_GetMissionListDynamic @searchTerm='', @startDate = '2023-06-01', @endDate='2023-07-15', @minRating=4,@pageIndex=1, @pageSize=5
--EXEC SP_GetMissionListDynamic @searchTerm='Charity', @maxRating=4, @pageIndex=1, @pageSize=5
--EXEC SP_GetMissionListDynamic @startDate = '2023-06-01', @endDate='2023-07-10', @maxRating=2, @pageIndex=1, @pageSize=5
--EXEC SP_GetMissionListDynamic @pageIndex=1, @pageSize=20, @searchTerm='dancing'
--EXEC SP_GetMissionListDynamic @searchTerm='singing', @startDate = '2023-06-01', @endDate='2023-07-15', @minRating=3, @pageIndex=1, @pageSize=5
--EXEC SP_GetMissionListDynamic 'runn, plann', null, null, null, null, 1, 100
--EXEC SP_GetMissionListDynamic @startDate = '2023-06-01', @pageIndex=1, @pageSize=5,@minRating=3,@maxRating=4 

--EXEC SP_GetMissionListDynamic null, null, null, null, null, 1, 100

ALTER PROCEDURE SP_GetMissionListDynamic
    @searchTerm NVARCHAR(100) = NULL,
    @startDate DATE = NULL,
    @endDate DATE = NULL,
    @minRating INT = NULL,
    @maxRating INT = NULL,
    @pageIndex INT = NULL,
    @pageSize INT = NULL
AS
BEGIN

    DECLARE @SQLQuery NVARCHAR(MAX);
    DECLARE @ParamDefinition NVARCHAR(MAX);

    DECLARE @StartIndex AS INT;
    DECLARE @EndIndex AS INT;

    SET @StartIndex = ((@pageIndex - 1) * @pageSize) + 1;
    SET @EndIndex = @pageIndex * @pageSize;

    SET @SQLQuery
        = N'select * from(
        SELECT ROW_NUMBER() OVER (ORDER BY M.mission_id) AS [No.],
               M.title AS [Title],
               C.name AS [City],
               CD.CName AS [Country],
               MT.title AS [Theme],
               M.description AS [Description],
               M.short_description AS [ShortDescription],
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
                  OR MT.title LIKE ''%' + @searchTerm
              + N'%''
                  OR M.description LIKE ''%' + @searchTerm
              + N'%''
                  OR M.short_description LIKE ''%' + @searchTerm
              + N'%''
                  OR M.organization_name LIKE ''%' + @searchTerm
              + N'%''
                     
                  OR EXISTS
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
								(SELECT TRIM(value) as Items FROM STRING_SPLIT(''' + @searchTerm
              + N''', '','') ) SK
								WHERE S.skill_name LIKE CONCAT(''%'',SK.Items,''%'')
							)
						)
					)

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
            = @SQLQuery + N'and ISNULL(dbo.FN_GetAVGRatings(M.mission_id), 0) >= '
              + CAST(@minRating AS VARCHAR(5)) + N'';
    END;



    --maxrating is not null

    IF @maxRating IS NOT NULL
    BEGIN
        SET @SQLQuery
            = @SQLQuery + N'and ISNULL(dbo.FN_GetAVGRatings(M.mission_id), 0)  <= '
              + CAST(@maxRating AS VARCHAR(5)) + N'';
    END;

    SET @SQLQuery
        = @SQLQuery + N') T WHERE T.[No.] >= ' + CAST(@StartIndex AS NVARCHAR(15)) + N'
          AND T.[No.] <= ' + CAST(@EndIndex AS NVARCHAR(15)) + N'
    ORDER BY T.[No.];';


    PRINT (@SQLQuery);
    EXEC (@SQLQuery);

END;