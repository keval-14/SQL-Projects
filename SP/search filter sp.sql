ALTER PROCEDURE SearchInMissions
    @searchtext VARCHAR(MAX) = NULL,
    @city_id VARCHAR(MAX) = NULL,
    @country_id VARCHAR(MAX) = NULL,
    @theme_id VARCHAR(MAX) = NULL,
    @title VARCHAR(MAX) = NULL,
    @short_description VARCHAR(MAX) = NULL,
    @description VARCHAR(MAX) = NULL,
    @start_date VARCHAR(MAX) = NULL,
    @end_date VARCHAR(MAX) = NULL,
    @mission_type VARCHAR(MAX) = NULL,
    @status VARCHAR(MAX) = NULL,
    @organization_name VARCHAR(MAX) = NULL,
    @organization_detail VARCHAR(MAX) = NULL,
    @availability VARCHAR(MAX) = NULL,
    @created_at VARCHAR(MAX) = NULL,
    @updated_at VARCHAR(MAX) = NULL,
    @deleted_at VARCHAR(MAX) = NULL,
    @deadline VARCHAR(MAX) = NULL,
    @total_seats VARCHAR(MAX) = NULL,
    @minimum_rating INT = NULL,
    @maximum_rating INT = NULL,
    @skillids VARCHAR(MAX) = NULL,
    @storyviews INT = NULL
AS
BEGIN
    DECLARE @PAGINATION AS VARCHAR(MAX) = '';
    DECLARE @START_INDEX AS INT;
    DECLARE @PAGE_SIZE AS INT;
    SET @START_INDEX = 0;
    SET @PAGE_SIZE = 10;
    SELECT DISTINCT
           miss.[mission_id],
           miss.[city_id],
           miss.[country_id],
           miss.[theme_id],
           miss.[title],
           miss.[short_description],
           miss.[description],
           miss.[start_date],
           miss.[end_date],
           miss.[mission_type],
           miss.[status],
           miss.[deadline],
           miss.[organization_name],
           miss.[organization_detail],
           miss.[availability],
           miss.[created_at],
           miss.[updated_at],
           miss.[deleted_at],
           miss.[total_seats]
    FROM mission AS miss
        LEFT JOIN
        (
            SELECT mission_rating.mission_id,
                   AVG(mission_rating.rating) AS [AVG Rating]
            FROM mission_rating,
                 mission
            WHERE mission.mission_id = mission_rating.mission_id
            GROUP BY mission_rating.mission_id
        ) AS Rat
            ON miss.mission_id = Rat.mission_id
        LEFT JOIN [dbo].[mission_skill] AS miss_skill
            ON miss.mission_id = miss_skill.mission_id
        LEFT JOIN [dbo].[story] AS story
            ON miss.mission_id = story.mission_id
    WHERE (
              (
                  @searchtext IS NULL
                  OR
                  (
                      miss.[title] LIKE '%' + @searchtext + '%'
                      OR miss.[short_description] LIKE '%' + @searchtext + '%'
                      OR miss.[description] LIKE '%' + @searchtext + '%'
                      OR miss.[start_date] LIKE '%' + @searchtext + '%'
                      OR miss.[end_date] LIKE '%' + @searchtext + '%'
                      OR miss.[mission_type] LIKE '%' + @searchtext + '%'
                      OR miss.[status] LIKE '%' + @searchtext + '%'
                      OR miss.[deadline] LIKE '%' + @searchtext + '%'
                      OR miss.[organization_name] LIKE '%' + @searchtext + '%'
                      OR miss.[organization_detail] LIKE '%' + @searchtext + '%'
                      OR miss.[availability] LIKE '%' + @searchtext + '%'
                  )
              )
              AND
              (
                  @city_id IS NULL
                  OR miss.[city_id] = @city_id
              )
              AND
              (
                  @country_id IS NULL
                  OR miss.[country_id] = @country_id
              )
              AND
              (
                  @theme_id IS NULL
                  OR miss.[theme_id] = @theme_id
              )
              AND
              (
                  @title IS NULL
                  OR miss.[title] LIKE '%' + @title + '%'
              )
              AND
              (
                  @short_description IS NULL
                  OR miss.[short_description] LIKE '%' + @short_description + '%'
              )
              AND
              (
                  @description IS NULL
                  OR miss.[description] LIKE '%' + @description + '%'
              )
              AND
              (
                  @start_date IS NULL
                  OR miss.[start_date] LIKE '%' + @start_date + '%'
              )
              AND
              (
                  @end_date IS NULL
                  OR miss.[end_date] LIKE '%' + @end_date + '%'
              )
              AND
              (
                  @availability IS NULL
                  OR miss.[availability] LIKE '%' + @availability + '%'
              )
              AND
              (
                  @created_at IS NULL
                  OR miss.[created_at] LIKE '%' + @created_at + '%'
              )
              AND
              (
                  @deadline IS NULL
                  OR miss.[deadline] LIKE '%' + @deadline + '%'
              )
              AND
              (
                  Rat.[AVG Rating] > @minimum_rating
                  OR Rat.[AVG Rating] < @maximum_rating
              )
              AND
              (
                  @storyviews IS NULL
                  OR story.views < @storyviews
              )
              AND
              (
                  @skillids IS NULL
                  OR miss_skill.skill_id IN
                     (
                         SELECT value FROM STRING_SPLIT(@skillids, ',')
                     )
              )
          )
    ORDER BY miss.mission_id;
    offset @START_INDEX rows fetch next @PAGE_SIZE rows only
END;



EXEC SearchInMissions @minimum_rating = '3';