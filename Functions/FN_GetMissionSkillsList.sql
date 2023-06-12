CREATE FUNCTION FN_GetMissionSkillsList(
@missionId int
)
RETURNS NVARCHAR(MAX)
AS
BEGIN	
DECLARE @SkillsList NVARCHAR(Max)

				SET @SkillsList = ISNULL(STUFF(
                      (
                          SELECT ', ' + S.skill_name
                          FROM dbo.skill S,
                               dbo.mission_skill MS
                          WHERE S.skill_id = MS.skill_id
                                AND MS.mission_id = @missionId
                          ORDER BY S.skill_name
                          FOR XML PATH('')
                      ),
                      1,
                      2,
                      ''
                           ),
                      'No Skills Found'
                     )
	
                
				RETURN @SkillsList
END	
       
SELECT dbo.FN_GetMissionSkillsList(1)
--FN_GetAVGRatings 1