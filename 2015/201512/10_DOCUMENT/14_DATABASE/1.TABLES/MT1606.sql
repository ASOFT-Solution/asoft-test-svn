-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Tố Oanh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT1606]') AND type in (N'U'))
CREATE TABLE [dbo].[MT1606](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[CoefficientID] [nvarchar](50) NOT NULL,
	[CoefficientName] [nvarchar](250) NULL,
	[Disabled] [tinyint] NOT NULL,
	[CoType] [tinyint] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[EmployeeID] [nvarchar](50) NULL,
 CONSTRAINT [PK_MT1606] PRIMARY KEY NONCLUSTERED 
(
	[CoefficientID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT1606_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT1606] ADD  CONSTRAINT [DF_MT1606_Disabled]  DEFAULT ((0)) FOR [Disabled]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT1606_CoType]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT1606] ADD  CONSTRAINT [DF_MT1606_CoType]  DEFAULT ((0)) FOR [CoType]
END