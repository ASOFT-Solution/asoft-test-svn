-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT1102STD]') AND type in (N'U'))
CREATE TABLE [dbo].[OT1102STD](
	[Code] [tinyint] NOT NULL,
	[Description] [nvarchar](250) NOT NULL,
	[EDescription] [nvarchar](250) NOT NULL,
	[TypeID] [nvarchar](50) NOT NULL
) ON [PRIMARY]
