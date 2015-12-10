USE [CDT]

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sysFormatString]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[sysFormatString](
	[sysFormatStringID] [int] IDENTITY(1,1) NOT NULL,
	[_Key] [nvarchar](128) NOT NULL,
	[Fieldname] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_sysFormatString] PRIMARY KEY CLUSTERED 
(
	[sysFormatStringID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] 

END