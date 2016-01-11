-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT5000]') AND type in (N'U'))
CREATE TABLE [dbo].[MT5000](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[DistributionID] [nvarchar](50) NOT NULL,
	[DistributionName] [nvarchar](250) NULL,
	[Disabled] [tinyint] NOT NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
 CONSTRAINT [PK_MT5000] PRIMARY KEY NONCLUSTERED 
(
	[DistributionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT5000_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT5000] ADD  CONSTRAINT [DF_MT5000_Disabled]  DEFAULT ((0)) FOR [Disabled]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT5000_EmployeeID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT5000] ADD  CONSTRAINT [DF_MT5000_EmployeeID]  DEFAULT ((0)) FOR [EmployeeID]
END