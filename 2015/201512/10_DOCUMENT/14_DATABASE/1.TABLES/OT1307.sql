-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT1307]') AND type in (N'U'))
CREATE TABLE [dbo].[OT1307](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[PackageID] [nvarchar](50) NOT NULL,
	[Disabled] [tinyint] NULL,
	[LengthID] [nvarchar](50) NULL,
	[WeighID] [nvarchar](50) NULL,
	[Length] [decimal](28, 8) NULL,
	[Width] [decimal](28, 8) NULL,
	[High] [decimal](28, 8) NULL,
	[Volume] [decimal](28, 8) NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[Weigh] [decimal](28, 8) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[Description] [nvarchar](250) NULL,
 CONSTRAINT [PK_OT1307_1] PRIMARY KEY CLUSTERED 
(
	[PackageID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_OT1307_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OT1307] ADD  CONSTRAINT [DF_OT1307_Disabled]  DEFAULT ((0)) FOR [Disabled]
END