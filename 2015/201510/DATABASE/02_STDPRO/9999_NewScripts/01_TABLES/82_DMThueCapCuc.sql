IF NOT EXISTS (SELECT *
           FROM   sysobjects
           WHERE  name = 'DMThueCapCuc'
                  AND xtype = 'U')
BEGIN

CREATE TABLE [dbo].[DMThueCapCuc](
	[Stt] [int] IDENTITY(1,1) NOT NULL,
	[TaxDepartmentID] [varchar](16) NOT NULL,
	[TaxDepartmentName] [nvarchar](512) NOT NULL,
	[ShortTaxDepartment] [nvarchar](512) NOT NULL,
 CONSTRAINT [PK_DMThueCapCuc] PRIMARY KEY CLUSTERED 
(
	[TaxDepartmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

END
