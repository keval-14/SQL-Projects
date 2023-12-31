
GO
/****** Object:  StoredProcedure [dbo].[SP_Add_Item]    Script Date: 07-06-2023 10.09.27 AM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[SP_AddUpdateItem]
-- Add the parameters for the stored procedure here

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here

    CREATE TABLE #item
    (
        RowNum INT IDENTITY(1, 1),
        ID INT,
        Name NVARCHAR(50)
    );


    INSERT INTO #item
    (
        ID,
        Name
    )
    SELECT ID,
           Name
    FROM dbo.Item;

    DECLARE @Count INT =
            (
                SELECT COUNT(1)FROM #item
            );
    PRINT @Count;
    DECLARE @i INT = 1;

    WHILE (@i <= @Count)
    BEGIN
        DECLARE @primaryID INT =
                (
                    SELECT ID FROM #item WHERE RowNum = @i
                );

        IF NOT EXISTS (SELECT ID FROM dbo.ItemTemp WHERE ID = @primaryID)
        BEGIN
            PRINT 'Not Exist';
            PRINT @primaryID;
            SET IDENTITY_INSERT dbo.ItemTemp ON;
            INSERT INTO dbo.ItemTemp
            (
                ID,
                Name,
                Description,
                DateCreated,
                DateModified
            )
            SELECT ID,
                   Name,
                   Description,
                   DateCreated,
                   DateModified
            FROM dbo.Item
            WHERE ID = @primaryID;
            SET IDENTITY_INSERT dbo.ItemTemp OFF;
        END;
        ELSE
        BEGIN
            PRINT 'Exist';
            PRINT @primaryID;

            DECLARE @Name NVARCHAR(100),
                    @Description NVARCHAR(MAX),
                    @DateCreated DATETIME,
                    @DateModified DATETIME;
            SELECT @Name = Name,
                   @Description = Description,
                   @DateCreated = DateCreated,
                   @DateModified = DateModified
            FROM dbo.Item
            WHERE ID = @primaryID;

            --UPDATE IT
            --SET IT.Name = I.Name,
            --    IT.Description = I.Description,
            --    IT.DateCreated = I.DateCreated,
            --    IT.DateModified = I.DateModified
            --FROM dbo.ItemTemp IT
            --    INNER JOIN dbo.Item I
            --        ON IT.ID = I.ID;

            UPDATE dbo.ItemTemp
            SET Name = @Name,
                Description = @Description,
                DateCreated = @DateCreated,
                DateModified = @DateModified
            WHERE ID = @primaryID;

        END;

        SET @i = @i + 1;
    END;
END;
