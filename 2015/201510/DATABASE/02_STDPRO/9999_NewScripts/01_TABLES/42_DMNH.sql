IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DMNH]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[DMNH](
	[BankID] [varchar](16) NOT NULL,
	[Stt] [int] IDENTITY(1,1) NOT NULL,
	[BankName] [nvarchar](512) NOT NULL,
	[BankName2] [nvarchar](512) NULL,
	[Address] [nvarchar](512) NULL,
	[Telephone] [nvarchar](512) NULL,
	[Disabled] [bit] NULL,
 CONSTRAINT [PK_DMNH] PRIMARY KEY CLUSTERED 
(
	[BankID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


ALTER TABLE [dbo].[DMNH] ADD  CONSTRAINT [DF_DMNH_Disabled]  DEFAULT ('0') FOR [Disabled]

END