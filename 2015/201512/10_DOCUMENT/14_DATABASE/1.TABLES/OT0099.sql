-- <Summary>
---- Load dữ liệu cho combo thay vì dùng view chết
-- <History>
---- Create on 15/06/2015 by Phan thanh hoàng Vũ
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[OT0099]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].OT0099
     (
      [CodeMaster] VARCHAR(50) NOT NULL,
      [OrderNo] INT NULL,
      [ID] VARCHAR(50) NOT NULL,
      [Description] NVARCHAR(250) NULL,
      [DescriptionE] NVARCHAR(250) NULL,
      [Disabled] TINYINT DEFAULT (0) NULL
    CONSTRAINT [PK_OT0099] PRIMARY KEY CLUSTERED
      (
      [CodeMaster],
      [ID]
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END
