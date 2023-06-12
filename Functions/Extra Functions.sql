SELECT *
FROM
(
    SELECT NTILE(2) OVER (ORDER BY mission.mission_id) AS nTile,
           *
    FROM mission
) M
WHERE M.nTile = 1;


SELECT U.first_name + ' ' + U.last_name AS [Name],
       M.title AS [Title]
FROM dbo.users U
    CROSS JOIN dbo.mission M;


--split values from string to table
SELECT TRIM(value) FROM STRING_SPLIT('gdfgdfg, dfgdfgdf,gdfgdfg', ',')