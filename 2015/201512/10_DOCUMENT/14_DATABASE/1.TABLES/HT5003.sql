-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Hoang Phuoc
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT5003]') AND type in (N'U'))
CREATE TABLE [dbo].[HT5003](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[GeneralAbsentID] [nvarchar](50) NOT NULL,
	[AbsentTypeID] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_HT5003] PRIMARY KEY NONCLUSTERED 
(
	[GeneralAbsentID] ASC,
	[AbsentTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

