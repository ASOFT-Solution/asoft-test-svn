-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Minh Lam
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS ( SELECT * FROM sys.objects  WHERE object_id = OBJECT_ID(N'[dbo].[HT1410]') AND type IN ( N'U' ) )
CREATE TABLE [dbo].[HT1410]
(
  [APK] [uniqueidentifier] DEFAULT NEWID() ,
  [DivisionID] nvarchar(3) NOT NULL ,
  [RecruitTimeID] [nvarchar](50) NULL ,
  [CostID] [nvarchar](50) NULL ,
  [CostName] [nvarchar](250) NULL ,
  [Costs] [decimal](28,8) NULL ,
  CONSTRAINT [PK_HT1410] PRIMARY KEY NONCLUSTERED ( [APK] ASC ) WITH ( PAD_INDEX = OFF ,
  STATISTICS_NORECOMPUTE = OFF ,
  IGNORE_DUP_KEY = OFF ,
  ALLOW_ROW_LOCKS = ON ,
  ALLOW_PAGE_LOCKS = ON ) ON [PRIMARY] )
ON     [PRIMARY]
