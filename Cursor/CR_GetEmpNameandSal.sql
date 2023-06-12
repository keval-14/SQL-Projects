DECLARE 
    @Emp_Name VARCHAR(MAX), 
    @Salary   DECIMAL;

DECLARE CR_ES CURSOR
FOR SELECT 
        E.FirstName + ' '+ E.LastName, 
        E.Salary
    FROM 
        dbo.Employee E;

OPEN CR_ES;

FETCH NEXT FROM CR_ES INTO 
    @Emp_Name, 
    @Salary;


WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT @Emp_Name + ', ' +CAST(@Salary AS varchar);
        FETCH NEXT FROM CR_ES INTO 
            @Emp_Name, 
            @Salary;
    END;

CLOSE CR_ES;

DEALLOCATE CR_ES;