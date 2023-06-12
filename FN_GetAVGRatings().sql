ALTER FUNCTION FN_GetAVGRatings
(
    @missionId INT
)
RETURNS DECIMAL(5, 2)
AS
BEGIN
    DECLARE @AVGRating DECIMAL(5, 2);

    SELECT @AVGRating = CAST(AVG(MR.rating) AS DECIMAL(5, 2))
    FROM mission_rating MR
    WHERE MR.mission_id = @missionId;

    RETURN @AVGRating;
END;


--FN_GetAVGRatings 1

 --SELECT CAST(AVG(MR.rating) AS DECIMAL(5,2)) FROM mission_rating MR WHERE MR.mission_id = 7
