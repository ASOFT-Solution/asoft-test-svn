-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Việt Khánh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CT0000STD]') AND type in (N'U'))
CREATE TABLE [dbo].[CT0000STD](
	[DefTranMonth] [int] NOT NULL,
	[DefTranYear] [int] NOT NULL,
	[IsSchedule] [tinyint] NULL,
	[IsDate] [int] NULL,
	[UserID] [nvarchar](50) NULL
) ON [PRIMARY]