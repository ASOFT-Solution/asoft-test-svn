-- <Summary>
---- Thông tin giao hàng - AF0047 - Cập nhật đối tượng
-- <History>
---- Create on 03/12/2014 by Lê Thị Hạnh 
---- Modified on ... by 
-- <Example>

IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[AT0047]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[AT0047]
     (
      [APK] UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
      [DivisionID] NVARCHAR(50) NOT NULL,
      [ObjectID] NVARCHAR(50) NOT NULL,
      [StationID] NVARCHAR(50) NOT NULL,
      [Orders] INT DEFAULT(0) NOT NULL,
      [InfoNotes] NVARCHAR(250) NULL,
      [CreateUserID] NVARCHAR(50) NULL,
      [CreateDate] DATETIME NULL,
      [LastModifyUserID] NVARCHAR(50) NULL,
      [LastModifyDate] DATETIME NULL
    CONSTRAINT [PK_AT0047] PRIMARY KEY CLUSTERED
      (
      [DivisionID] ASC,
      [ObjectID] ASC,
      [StationID] ASC
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END

