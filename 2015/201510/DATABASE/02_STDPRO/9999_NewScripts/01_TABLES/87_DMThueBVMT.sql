IF  NOT EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[DMThueBVMT]')AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DMThueBVMT](
	[TaxID] [varchar](16) NOT NULL,
	[TaxName] [nvarchar](512) NOT NULL,
	[TaxName2] [nvarchar](512) NULL,
	[TaxHTKK] [varchar](16) NULL,
	[TaxRate] [decimal](28, 6) NULL,
	[TaxUnit] [nvarchar](512) NULL,
	[Notes] [ntext] NULL,
	[Disabled] [bit] NOT NULL,
 CONSTRAINT [PK_DMThueBVMT] PRIMARY KEY CLUSTERED 
(
	[TaxID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
ALTER TABLE [dbo].[DMThueBVMT] ADD  CONSTRAINT [DF_DMThueBVMT_Disabled]  DEFAULT ('0') FOR [Disabled]
END
