ALTER FUNCTION FN_GetAVGRatings(
@missionId int
)
RETURNS int
AS
BEGIN	
DECLARE @AVGRating int

               SELECT @AVGRating =
                       AVG(MR.rating)
                FROM mission_rating MR,
                     mission
                WHERE MR.mission_id = @missionId 
				RETURN @AVGRating
END	
       
SELECT dbo.FN_GetAVGRatings(7)
--FN_GetAVGRatings 1