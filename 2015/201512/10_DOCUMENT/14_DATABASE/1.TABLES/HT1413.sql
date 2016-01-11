-- <Summary>
---- 
-- <History>
---- Create on 06/12/2013 by Thanh Sơn
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[HT1413]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[HT1413]
     (
      [APK] UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
      [DivisionID] VARCHAR (50) NOT NULL,
      [EmployeeID] VARCHAR (50) NOT NULL,
      [D01] DATETIME NULL,
      [D02] DATETIME NULL,
      [D03] DATETIME NULL,
      [D04] DATETIME NULL,
      [D05] DATETIME NULL,
      [N01] NVARCHAR (250) NULL,
      [N02] NVARCHAR (250) NULL,
      [N03] NVARCHAR (250) NULL,
      [N04] NVARCHAR (250) NULL,
      [N05] NVARCHAR (250) NULL,
      [N06] NVARCHAR (250) NULL,
      [N07] NVARCHAR (250) NULL,
      [N08] NVARCHAR (250) NULL,
      [N09] NVARCHAR (250) NULL,
      [N10] NVARCHAR (250) NULL
    CONSTRAINT [PK_HT1413] PRIMARY KEY CLUSTERED
      (
      [DivisionID],
      [EmployeeID]
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END