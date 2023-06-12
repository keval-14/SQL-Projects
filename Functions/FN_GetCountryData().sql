--SELECT * FROM dbo.FN_GetCountryData()

ALTER FUNCTION FN_GetCountryData
()
RETURNS TABLE
AS
RETURN SELECT country_id AS [CID],
              name AS [CName],
              iso AS [ISO],
              created_at AS [CAt],
              updated_at AS [UAt],
              deleted_at AS [DAt]
       FROM dbo.country;

            


