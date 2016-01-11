-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Hoang Phuoc
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT5004]') AND type in (N'U'))
CREATE TABLE [dbo].[HT5004](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[DepartmentID] [nvarchar](50) NOT NULL,
	[TeamID] [nvarchar](50) NOT NULL,
	[PayrollMethodID] [nvarchar](50) NOT NULL,
	[IsDetail] [tinyint] NOT NULL,
 CONSTRAINT [PK_HT5004] PRIMARY KEY NONCLUSTERED 
(
	[DivisionID] ASC,
	[DepartmentID] ASC,
	[PayrollMethodID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default 
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT5004_TeamID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT5004] ADD  CONSTRAINT [DF_HT5004_TeamID]  DEFAULT ('%') FOR [TeamID]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__HT5004__IsDetail__1DFB8033]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT5004] ADD  CONSTRAINT [DF__HT5004__IsDetail__1DFB8033]  DEFAULT ((0)) FOR [IsDetail]
END