-- ===========================================================================================================================================================================
-- Author:		<Keval Mangukiya>
-- Create date: <01-06-2023>
-- Description:	<View for desplay all the records for each Missions like, No. of Documents, No. of Media, No. of Applications, No. of Invitations from all different tables>
-- ===========================================================================================================================================================================


USE [CI-Main]
GO

ALTER VIEW VW_GetMissionData
AS
SELECT A.[Mission Title],
       ISNULL(A.[No. of Docs], 0) AS [No. of Docs],
       ISNULL(B.[No. of Media], 0) AS [No. of Media],
       ISNULL(C.[No. of Applications], 0) AS [No. of Applications],
       ISNULL(I.[No. of Invitations], 0) AS [No. Of Invitations]
FROM
(
    SELECT M.title AS [Mission Title],
           COUNT(MD.mission_id) AS [No. of Docs]
    FROM mission M
        LEFT JOIN mission_document MD
            ON M.mission_id = MD.mission_id
    WHERE status = 1
    GROUP BY M.title
) AS A
    JOIN
    (
        SELECT M.title AS [Mission Title],
               COUNT(MM.mission_id) AS [No. of Media]
        FROM mission M
            LEFT JOIN mission_media MM
                ON MM.mission_id = M.mission_id
        WHERE status = 1
        --AND MM.mission_id = M.mission_id
        GROUP BY M.title
    ) AS B
        ON A.[Mission Title] = B.[Mission Title]
    JOIN
    (
        SELECT M.title AS [Mission Title],
               COUNT(MA.mission_id) AS [No. of Applications]
        FROM mission M
            LEFT JOIN mission_application MA
                ON MA.mission_id = M.mission_id
        WHERE status = 1
        GROUP BY M.title
    ) AS C
        ON A.[Mission Title] = C.[Mission Title]
    JOIN
    (
        SELECT M.title AS [Mission Title],
               COUNT(MI.mission_id) AS [No. of Invitations]
        FROM mission M
            LEFT JOIN mission_invite MI
                ON MI.mission_id = M.mission_id
        WHERE status = 1
        GROUP BY M.title
    ) AS I
        ON A.[Mission Title] = I.[Mission Title];


--SELECT * FROM MISSION	
--SELECT * FROM VW_GetMissionData