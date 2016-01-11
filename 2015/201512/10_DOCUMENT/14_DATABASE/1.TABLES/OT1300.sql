-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[OT1300]') AND TYPE IN (N'U'))
BEGIN
     CREATE TABLE [dbo].[OT1300]
     (
      [APK] UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
      [DivisionID] VARCHAR(50) NOT NULL,
      [PriceID] VARCHAR(50) NOT NULL,
      [StandardID] VARCHAR(50) NOT NULL,
      [UnitPrice] DECIMAL(28,8) NULL
    CONSTRAINT [PK_OT1300] PRIMARY KEY CLUSTERED
      (
      [DivisionID],
      [PriceID],
      [StandardID]
      )
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
     )
 ON [PRIMARY]
END