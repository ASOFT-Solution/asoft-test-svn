IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DMMauSoHD]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[DMMauSoHD](
	[FormID] [varchar](16) NOT NULL,
	[Stt] [int] IDENTITY(1,1) NOT NULL,
	[FormName] [nvarchar](512) NOT NULL,
	[FormSymbol] [nvarchar](512) NOT NULL,
	[Disabled] [bit] NULL,
 CONSTRAINT [PK_DMMauSoHD] PRIMARY KEY CLUSTERED 
(
	[FormID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


ALTER TABLE [dbo].[DMMauSoHD] ADD  CONSTRAINT [DF_DMMauSoHD_Disabled]  DEFAULT ('0') FOR [Disabled]

END