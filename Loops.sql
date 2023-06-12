DECLARE @i INT =10;
WHILE @i <= 30
BEGIN
	PRINT(@i)
	SET @i = @i + 10

	IF @i > 30 BREAK

END

