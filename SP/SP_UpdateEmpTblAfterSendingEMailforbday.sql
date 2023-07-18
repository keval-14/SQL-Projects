-- =======================================================================================================================================
-- Author:		<Keval Mangukiya>
-- Create date: <23-06-2023>
-- Description:	<Stored Procedure that Update record in Employee table for thoes employee who got email for birthday reminder>
-- =======================================================================================================================================


--SP_UpdateEmpTblAfterSendingEMail 1
--SELECT * FROM dbo.Employee

ALTER PROC SP_UpdateEmpTblAfterSendingEMail
(
    @EmployeeId INT,
    @outPut INT OUT
)
AS
BEGIN
    UPDATE dbo.Employee
    SET IsMailSent = 'true',
        MailSentDate = GETDATE()
    WHERE EmployeeId = @EmployeeId;

    --IF
    --(
    --    SELECT CAST(MailSentDate AS DATE)
    --    FROM Employee
    --    WHERE EmployeeId = @EmployeeId
    --) = CAST(GETDATE() AS DATE)
    --BEGIN
        SET @outPut = 1;
    --END;
    --ELSE
    --    SET @outPut = 0;
END;
