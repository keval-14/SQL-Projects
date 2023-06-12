insert into C (c) values (10),(20),(30),(40),(50)

alter function fun_PrintNumber(@a float, @b float, @c float)
returns float
as
begin
    return (@a + @b - @c)/2
end

 select Count(AllData.b) from
(select A.a, B.b, C.c from A,B,c where A.id = B.id and A.id = C.id) as AllData

DECLARE @I INT
SET @I = 1

while @I <= (select Count(AllData.b) from
(select A.a, B.b, C.c from A,B,c where A.id = B.id and A.id = C.id) as AllData)
begin
	select A.a, B.b, C.c from A,B,c where A.id = B.id and A.id = C.id
	select dbo.fun_PrintNumber(5,5,5) as [Average Sum]
	SET @I = @I + 1
end 



