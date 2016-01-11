-- <Summary>
---- 
-- <History>
---- Create on 13/12/2010 by Thanh Trẫm
---- Modified on ... by ...
-- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1009STD]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AT1009STD](
	[VATTypeID] [nvarchar](50) NOT NULL,
	[VATTypeName] [nvarchar](250) NULL,
	[IsVATIn] [tinyint] NOT NULL,
	[Disabled] [tinyint] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL
) ON [PRIMARY]
END
