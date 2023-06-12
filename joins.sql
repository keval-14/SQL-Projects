/*mission docs, media, applications*/

(select b.[Mission Title], isnull(a.[No. of Docs],0) as [No. of Docs], isnull(b.[No. of Media],0) as [No. of Media], isnull(c.[No. of Applications],0) as [No. of Applications] from
(select mission.title as [Mission Title], count(mission_document.mission_id) as [No. of Docs] from mission, mission_document where status = 1 and mission.mission_id = mission_document.mission_id group by mission.title) as a
full join
(select mission.title as [Mission Title], count(mission_media.mission_id) as [No. of Media] from mission,mission_media where status = 1 and mission.mission_id = mission_media.mission_id group by mission.title) as b on a.[Mission Title] = b.[Mission Title]
full join
(select mission.title as [Mission Title], count(mission_application.mission_id) as [No. of Applications] from mission,mission_application where status = 1 and mission.mission_id = mission_application.mission_id group by mission.title) as c on b.[Mission Title] = c.[Mission Title])
 
 /*mission docs, media, apps using SP*/

 alter procedure showMissionDMA @missionId int
 as
 begin 

 (select a.[Mission Title], isnull(a.[No. of Docs],0) as [No. of Docs], isnull(b.[No. of Media],0) as [No. of Media], isnull(c.[No. of Applications],0) as [No. of Applications], ISNULL(I.[No. of Invitations], 0) as [No. Of Invitations] from
(select mission.title as [Mission Title], count(mission_document.mission_id) as [No. of Docs] from mission, mission_document where status = 1 and mission_document.mission_id = @missionId and mission.mission_id = @missionId group by mission.title) as a
join
(select mission.title as [Mission Title], count(mission_media.mission_id) as [No. of Media] from mission,mission_media where status = 1 and  mission_media.mission_id = @missionId and mission.mission_id = @missionId group by mission.title) as b on a.[Mission Title] = b.[Mission Title]
join
(select mission.title as [Mission Title], count(mission_application.mission_id) as [No. of Applications] from mission,mission_application where status = 1 and  mission_application.mission_id = @missionId and mission.mission_id = @missionId group by mission.title) as c on a.[Mission Title] = c.[Mission Title]
join
(select mission.title as [Mission Title], count(mission_invite.mission_id) as [No. of Invitations] from mission,mission_invite where status = 1 and  mission_invite.mission_id = @missionId and mission.mission_id = @missionId group by mission.title) as I on a.[Mission Title] = I.[Mission Title])
 
 end

 exec showMissionDMA 1

 /*get user data by user id*/

 alter proc getUserData @userId int
 as
 begin

 select (users.first_name + SPACE(1) + users.last_name) as [User Name], CONVERT(VARCHAR(10), users.created_at, 105) as [Registered At], isnull(CNT.cName,'Not Found') as [Country], isnull(c.cName,'Not Found') as [City], 
 isnull(MA.[No of Apps],0) as [Total Applications], FM.[No of Fav Misions] as [No of Fav Misions], ISNULL(CMNT.[No of cmnts],0) as [Total Comments] from users
	 left join 
	 (select city.name as [cName],city.city_id as [CID], users.city_id as [UCid], users.user_id from city, users where users.user_id = @userId) as C
	on  C.CID = C.UCid
	left join 
	 (select country.name as [cName],country.country_id as [CNTID], users.country_id as [UCntid], users.user_id from country, users where users.user_id = @userId) as CNT
	on  CNT.UCntid = CNT.CNTID
	left join 
	(select count(mission_application.user_id) as [No of Apps] from mission_application where mission_application.user_id = @userId group by mission_application.user_id) as MA
	on users.user_id = @userId
	left join
	(select count(favorite_mission.user_id) as [No of Fav Misions] from favorite_mission where favorite_mission.user_id = @userId group by favorite_mission.user_id) as FM
	on users.user_id = @userId
	left join
	(select count(comment.user_id) as [No of cmnts] from comment where comment.user_id = @userId group by comment.user_id) as CMNT
	on users.user_id = @userId
	where users.user_id= @userId

 end
 
 /*or*/

 alter proc getUserData @userId int
 as
 begin
 select U.[User Name], U.[Registered At], C.Country from
 (select users.user_id as [UserId], (users.first_name + SPACE(1) + users.last_name) as [User Name], CONVERT(VARCHAR(10), users.created_at, 105) as [Registered At] from users where users.user_id = @userId) as U
 join
 (select users.user_id as [UserId], country.name as [Country], users.first_name as [name] from country,users where users.user_id = @userId and users.country_id = country.country_id) as C on U.UserId = C.UserId
 end


exec getUserData 2


/*avg ratings for all missions*/
select mission.title as [Mission Title], isnull(avg(mission_rating.rating),0) as [Avg Ratings] from mission left join mission_rating on mission.mission_id = mission_rating.mission_id group by mission.title 

 /*mission skills*/

 select mission.title as [Mission Title], STRING_AGG(skill.skill_name, ',') as [Skills] from mission, mission_skill left join skill 
 on skill.skill_id = mission_skill.skill_id 
 where mission.mission_id = mission_skill.mission_id
 group by mission.title
 

 