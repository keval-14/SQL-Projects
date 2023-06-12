
-- =============================================
-- Author:		<Keval Mangukiya>
-- Create date: <24-05-2023>
-- Description:	<Get City list in Alphabatical Order with countryId and countryName>
-- =============================================
--SP_GetCityList
ALTER PROCEDURE SP_GetCityList
AS
BEGIN
    SELECT CN.country_id AS [CountryId],
           CN.name AS [CountryName],
           ISNULL(STUFF(
                  (
                      SELECT ', ' + C.name
                      FROM dbo.city C
                      WHERE C.country_id = CN.country_id
                      ORDER BY C.name
                      FOR XML PATH('')
                  ),
                  1,
                  2,
                  ''
                       ),
                  'No Cities Found'
                 ) AS [CityList]
    FROM dbo.country AS CN;
END;
GO



