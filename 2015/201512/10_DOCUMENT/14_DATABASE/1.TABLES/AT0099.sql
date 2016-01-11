-- <Summary> Đổ nguồn Combobox, dữ liệu master data (Thay thế dùng view chết load combo bên ERP8)
---- 
-- <History>
---- Create on 13/02/2014 by Thanh Sơn
---- Modified on Phan Thanh Hoàng Vũ on 30/11/2015 4:15:27 PM
---- <Example>
 
IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[AT0099]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].AT0099
     (
      [CodeMaster] VARCHAR(50) NOT NULL,
      [OrderNo] INT NULL,
      [ID] VARCHAR(50) NOT NULL,
      [Description] NVARCHAR(250) NULL,
      [DescriptionE] NVARCHAR(250) NULL,
      [Disabled] TINYINT DEFAULT (0) NULL
    CONSTRAINT [PK_AT0099] PRIMARY KEY CLUSTERED
      (
      [CodeMaster],
      [ID]
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END
