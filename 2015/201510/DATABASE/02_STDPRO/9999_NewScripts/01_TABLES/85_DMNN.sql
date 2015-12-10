IF NOT EXISTS (SELECT *
           FROM   sysobjects
           WHERE  name = 'DMNN'
                  AND xtype = 'U')
BEGIN

CREATE TABLE [dbo].[DMNN](
	[Stt] [int] IDENTITY(1,1) NOT NULL,
	[VocationID] [varchar](16) NOT NULL,
	[VocationName] [nvarchar](512) NOT NULL,
	[VocationName2] [nvarchar](512) NULL,
	[Notes] [nvarchar](512) NULL,
	[Disabled] [bit] NULL,
	[TaxType] [nvarchar](512) NULL,
 CONSTRAINT [PK_DMNN] PRIMARY KEY CLUSTERED 
(
	[VocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[DMNN] ADD  CONSTRAINT [DF_DMNN_Disabled]  DEFAULT ('0') FOR [Disabled]

END