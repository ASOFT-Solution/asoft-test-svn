IF NOT EXISTS (SELECT *
           FROM   sysobjects
           WHERE  name = 'DMGH'
                  AND xtype = 'U')
BEGIN

CREATE TABLE [dbo].[DMGH](
	[Stt] [int] IDENTITY(1,1) NOT NULL,
	[ExtenID] [varchar](16) NOT NULL,
	[ExtenName] [nvarchar](512) NOT NULL,
	[ExtenName2] [nvarchar](512) NULL,
	[Notes] [nvarchar](512) NULL,
	[Disabled] [bit] NULL,
 CONSTRAINT [PK_DMGH] PRIMARY KEY CLUSTERED 
(
	[ExtenID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[DMGH] ADD  CONSTRAINT [DF_DMGH_Disabled]  DEFAULT ('0') FOR [Disabled]

END