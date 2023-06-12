-- =======================================================================================================================================
-- Author:		<Keval Mangukiya>
-- Create date: <01-06-2023>
-- Description:	<DDL Trigger for DDL_TABLE_EVENTS on any database and add records(Logs) in DbLogs table>
-- =======================================================================================================================================

ALTER TRIGGER TR_DBLogs
ON ALL SERVER
FOR DDL_TABLE_EVENTS
AS
BEGIN
	DECLARE @EventData XML
	SELECT @EventData = EVENTDATA()
	INSERT INTO [SQL-Practice].[dbo].[DbLogs]
	(DBName, TableName, EventType, LoginName, SqlQuery, AuditDateTime)
	VALUES(
	@EventData.value('(/EVENT_INSTANCE/DatabaseName)[1]','varchar(250)'),
	@EventData.value('(/EVENT_INSTANCE/ObjectName)[1]','varchar(250)'),
	@EventData.value('(/EVENT_INSTANCE/EventType)[1]','nvarchar(250)'),
	@EventData.value('(/EVENT_INSTANCE/LoginName)[1]','varchar(250)'),
	@EventData.value('(/EVENT_INSTANCE/TSQLCommand)[1]','nvarchar(2500)'),
	GETDATE()
	)

END



CREATE TABLE test2(id int)

SELECT * FROM [SQL-Practice].[dbo].[DbLogs]