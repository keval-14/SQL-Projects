USE [OWINAuth]
GO   
/****** Object: StoredProcedure [dbo].[LoginByUsernamePassword] Script Date: 03/15/2016 21:33:52 ******/   
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LoginByUsernamePassword]') AND type in (N'P', N'PC'))   
DROP PROCEDURE [dbo].[LoginByUsernamePassword]   
GO   
/****** Object: Table [dbo].[Login] Script Date: 03/15/2016 21:33:50 ******/   
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Login]') AND type in (N'U'))   
DROP TABLE [dbo].[Login]   
GO   
/****** Object: Table [dbo].[Login] Script Date: 03/15/2016 21:33:50 ******/   
SET ANSI_NULLS ON   
GO   
SET QUOTED_IDENTIFIER ON   
GO   
SET ANSI_PADDING ON   
GO   
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Login]') AND type in (N'U'))   
BEGIN   
CREATE TABLE [dbo].[Login](   
[id] [int] IDENTITY(1,1) NOT NULL,   
[username] [varchar](50) NOT NULL,   
[password] [varchar](50) NOT NULL,   
CONSTRAINT [PK_Login] PRIMARY KEY CLUSTERED   
(   
[id] ASC   
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]   
) ON [PRIMARY]   
END   
GO   
SET ANSI_PADDING OFF   
GO   
SET IDENTITY_INSERT [dbo].[Login] ON   
INSERT [dbo].[Login] ([id], [username], [password]) VALUES (1, N'my-login', N'my-password-123')   
SET IDENTITY_INSERT [dbo].[Login] OFF   
/****** Object: StoredProcedure [dbo].[LoginByUsernamePassword] Script Date: 03/15/2016 21:33:52 ******/   
SET ANSI_NULLS ON   
GO   
SET QUOTED_IDENTIFIER ON   
GO   
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LoginByUsernamePassword]') AND type in (N'P', N'PC'))   
BEGIN   
EXEC dbo.sp_executesql @statement = N'
-- =============================================   
-- Author: <Author,,Asma Khalid>  
-- Create date: <Create Date,,15-Mar-2016>  
-- Description: <Description,,You are Allow to Distribute this Code>  
-- =============================================   
CREATE PROCEDURE [dbo].[LoginByUsernamePassword]   
@username varchar(50),   
@password varchar(50)   
AS   
BEGIN   
SELECT id, username, password   
FROM Login   
WHERE username = @username   
AND password = @password   
END   
'   
END   
GO   