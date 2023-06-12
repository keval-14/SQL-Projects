
-- =============================================
-- Author:		<Keval Mangukiya>
-- Create date: <24-05-2023>
-- Description:	<SP for searching and filtering data from mission table with table valued function join>
-- =============================================


--SP_GetMissionList2 @searchTerm='pune', @minRating=2, @pageIndex=1, @pageSize=5
--SP_GetMissionList2 @startDate = '2023-06-01', @endDate='2023-06-29', @pageIndex=1, @pageSize=5
--SP_GetMissionList2 @searchTerm='mexi', @startDate = '2023-05-28', @maxRating=3, @pageIndex=1, @pageSize=5
--SP_GetMissionList2 @startDate='2023-06-05',  @minRating=3, @pageIndex=1, @pageSize=5
--SP_GetMissionList2 @minRating=2, @maxRating=3, @pageIndex=1, @pageSize=5
--SP_GetMissionList2 @searchTerm='', @startDate = '2023-06-01', @endDate='2023-07-15', @minRating=4,@pageIndex=1, @pageSize=5
--SP_GetMissionList2 @searchTerm='Charity', @maxRating=4, @pageIndex=1, @pageSize=5
--SP_GetMissionList2 @startDate = '2023-06-01', @endDate='2023-07-10', @maxRating=3, @pageIndex=1, @pageSize=5
--SP_GetMissionList2 @pageIndex=1, @pageSize=20, @searchTerm='dancing'
--SP_GetMissionList2 @searchTerm='singing', @startDate = '2023-06-01', @endDate='2023-07-15', @minRating=3, @pageIndex=1, @pageSize=5
--EXEC SP_GetMissionList2 'mun,ort', null, null, null, null, 1, 100;
--EXEC SP_GetMissionList2 'mun, ort', null, null, null, null, 1, 100;



ALTER PROCEDURE SP_GetMissionList2
    @searchTerm NVARCHAR(100) = NULL,
    @startDate DATE = NULL,
    @endDate DATE = NULL,
    @minRating INT = NULL,
    @maxRating INT = NULL,
    @pageIndex INT = NULL,
    @pageSize INT = NULL
AS
BEGIN

    DECLARE @StartIndex AS INT;
    DECLARE @EndIndex AS INT;

    SET @StartIndex = ((@pageIndex - 1) * @pageSize) + 1;
    SET @EndIndex = @pageIndex * @pageSize;

    SELECT *
    FROM
    (
        SELECT ROW_NUMBER() OVER (ORDER BY mission.mission_id) AS [No.],
               mission.title AS [Title],
               city.name AS [City],
               CD.CName AS [Country],
               mission_theme.title AS [Theme],
               mission.description AS [Description],
               mission.short_description AS [ShortDescription],
               mission.organization_name AS [OrganizationName],
               CAST(mission.start_date AS DATE) AS [StartDate],
               CAST(mission.end_date AS DATE) AS [EndDate],
               CASE mission.mission_type
                   WHEN 0 THEN
                       'Time'
                   WHEN 1 THEN
                       'Goal'
                   ELSE
                       'Unknown'
               END AS [MissionType],
               --ISNULL(RAT.[AVG Rating], 0) AS [AVGRating],
               ISNULL(dbo.FN_GetAVGRatings(dbo.mission.mission_id), 0) AS [AVGRating],
               dbo.FN_GetMissionSkillsList(dbo.mission.mission_id) AS [SkillList],
               COUNT(1) OVER () AS [TotalRecords]
        FROM mission
            INNER JOIN city
                ON city.city_id = mission.city_id
            INNER JOIN FN_GetCountryData() CD
                ON CD.CID = mission.country_id
            INNER JOIN mission_theme
                ON mission_theme.mission_theme_id = mission.theme_id
        --LEFT JOIN
        --(
        --    SELECT MR.mission_id,
        --           AVG(MR.rating) AS [AVG Rating]
        --    FROM mission_rating MR,
        --         mission
        --    WHERE mission.mission_id = MR.mission_id
        --    GROUP BY MR.mission_id
        --) AS RAT
        --    ON RAT.mission_id = dbo.mission.mission_id
        WHERE (
                  @searchTerm IS NULL
                  OR city.name LIKE '%' + @searchTerm + '%'
                  OR CD.CName LIKE '%' + @searchTerm + '%'
                  OR mission_theme.title LIKE '%' + @searchTerm + '%'
                  OR mission.description LIKE '%' + @searchTerm + '%'
                  --OR mission.short_description LIKE '%' + @searchTerm + '%'
                  OR mission.organization_name LIKE '%' + @searchTerm + '%'
                     --OR dbo.FN_GetMissionSkillsList(dbo.mission.mission_id) IN (SELECT items FROM dbo.Split('ort, mun',','))
                     AND @searchTerm IS NULL
                  OR EXISTS
        (
            SELECT 1
            FROM dbo.mission_skill MS
            WHERE MS.mission_id = dbo.mission.mission_id
                  AND EXISTS
            (
                SELECT 1
                FROM dbo.skill S
                WHERE S.skill_id = MS.skill_id
                      AND EXISTS
                (
                    SELECT 1
                    FROM
                    (SELECT TRIM(items) AS Items FROM dbo.Split(@searchTerm, ',') ) SK
                    WHERE S.skill_name LIKE '%' + SK.Items + '%'
                )
            )
        )
                  OR CASE mission.mission_type
                         WHEN 0 THEN
                             'Time'
                         WHEN 1 THEN
                             'Goal'
                         ELSE
                             'Unknown'
                     END LIKE '%' + @searchTerm + '%'
              )
              AND
              (
                  (
                      @startDate IS NULL
                      OR CAST(mission.start_date AS DATE) >= @startDate
                  )
                  AND
                  (
                      @endDate IS NULL
                      OR CAST(mission.end_date AS DATE) <= @endDate
                  )
              )
              AND
              (
                  (
                      @minRating IS NULL
                      OR ISNULL(dbo.FN_GetAVGRatings(mission.mission_id), 0) >= @minRating
                  )
                  AND
                  (
                      @maxRating IS NULL
                      OR ISNULL(dbo.FN_GetAVGRatings(mission.mission_id), 0) <= @maxRating
                  )
              )
    ) M
    WHERE M.[No.] >= @StartIndex
          AND M.[No.] <= @EndIndex
    ORDER BY M.[No.];


--ORDER BY mission.mission_id OFFSET @StartIndex ROWS FETCH NEXT @pageSize ROWS ONLY;
END;

