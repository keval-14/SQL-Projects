--SP_GetAllEmployee 'salary',0

ALTER PROC SP_GetAllEmployee
    @orderByColumnName VARCHAR(50) = NULL,
    @IsSortByAsc VARCHAR = NULL
AS
BEGIN
    DECLARE @SQLQuery NVARCHAR(MAX);
    IF @orderByColumnName IS NULL
    BEGIN
        SET @SQLQuery
            = N'SELECT * FROM dbo.Employee ORDER BY EmployeeId DESC';
    END;
    ELSE
    BEGIN
        SET @SQLQuery
            = N'SELECT * FROM dbo.Employee ORDER BY ' + @orderByColumnName + N' ' + CASE
                                                                                        WHEN @IsSortByAsc = 1 THEN
                                                                                            'ASC'
                                                                                        ELSE
                                                                                            'DESC'
                                                                                    END + N'';
    END;
    EXEC (@SQLQuery);
    PRINT (@SQLQuery);
END;