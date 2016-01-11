-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Việt Khánh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CT0000]') AND type in (N'U'))
CREATE TABLE [dbo].[CT0000](
    [APK] [uniqueidentifier] DEFAULT NEWID(),
    [DivisionID] [nvarchar] (3) NOT NULL,
	[DefTranMonth] [int] NOT NULL,
	[DefTranYear] [int] NOT NULL,
	[IsSchedule] [tinyint] NULL,
	[IsDate] [int] NULL,
	[UserID] [nvarchar](50) NULL,
CONSTRAINT [PK_CT0000] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
