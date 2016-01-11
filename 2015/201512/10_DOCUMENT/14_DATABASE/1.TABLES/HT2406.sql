-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Minh Lâm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT2406]') AND type in (N'U'))
CREATE TABLE [dbo].[HT2406](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[TranMonth] [int] NULL,
	[Tranyear] [int] NULL,
	[AbsentCardNo] [nvarchar](50) NOT NULL,
	[AbsentDate] [datetime] NULL,
	[AbsentTime] [nvarchar](100) NULL,
	[MachineCode] [nvarchar](50) NULL,
	[ShiftCode] [nvarchar](50) NULL,
	[IOCode] [tinyint] NULL,
	[InputMethod] [tinyint] NOT NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[Notes] [nvarchar](250) NULL,
	CONSTRAINT [PK_HT2406] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__HT2406__InputMet__7233A33C]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2406] ADD  CONSTRAINT [DF__HT2406__InputMet__7233A33C]  DEFAULT ((0)) FOR [InputMethod]
END