-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT2009]') AND type in (N'U'))
CREATE TABLE [dbo].[AT2009](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[QuotationID] [nvarchar](50) NOT NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[ObjectID] [nvarchar](50) NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[QuotationNo] [nvarchar](50) NULL,
	[QuotationDate] [datetime] NULL,
	[RefNo1] [nvarchar](100) NULL,
	[RefNo2] [nvarchar](100) NULL,
	[RefNo3] [nvarchar](100) NULL,
	[Attention1] [nvarchar](250) NULL,
	[Attention2] [nvarchar](250) NULL,
	[Dear] [nvarchar](100) NULL,
	[Condition] [nvarchar](100) NULL,
	[Disabled] [tinyint] NOT NULL,
	[Status] [tinyint] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
 CONSTRAINT [PK_AT2009] PRIMARY KEY NONCLUSTERED 
(
	[QuotationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default 
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT2009_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT2009] ADD  CONSTRAINT [DF_AT2009_Disabled]  DEFAULT ((0)) FOR [Disabled]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT2009_Status]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT2009] ADD  CONSTRAINT [DF_AT2009_Status]  DEFAULT ((0)) FOR [Status]
END