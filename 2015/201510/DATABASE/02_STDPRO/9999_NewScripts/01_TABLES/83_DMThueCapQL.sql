IF NOT EXISTS (SELECT *
           FROM   sysobjects
           WHERE  name = 'DMThueCapQL'
                  AND xtype = 'U')
BEGIN

CREATE TABLE [dbo].[DMThueCapQL](
	[TaxDepartmentID] [varchar](16) NOT NULL,
	[TaxDepartID] [varchar](16) NOT NULL,
	[TaxDepartName] [nvarchar](512) NOT NULL,
 CONSTRAINT [PK_DmThueCapQL] PRIMARY KEY CLUSTERED 
(
	[TaxDepartID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[DmThueCapQL]  WITH CHECK ADD  CONSTRAINT [FK_DmThueCapQL_DMThueCapCuc2] FOREIGN KEY([TaxDepartmentID])
REFERENCES [dbo].[DMThueCapCuc] ([TaxDepartmentID])

ALTER TABLE [dbo].[DmThueCapQL] CHECK CONSTRAINT [FK_DmThueCapQL_DMThueCapCuc2]

END
