-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Tố Oanh
-- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT0368]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AT0368](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ObjectID] [nvarchar](50) NULL,
	[S1] [nvarchar](50) NULL,
	[S2] [nvarchar](50) NULL,
	[S3] [nvarchar](50) NULL,
	[ObjectName] [nvarchar](250) NULL,
	[ReBeOriginalAmount] [decimal](28, 8) NULL,
	[ReBeConvertedAmount] [decimal](28, 8) NULL,
	[PaBeConvertedAmount] [decimal](28, 8) NULL,
	[PaBeOriginalAmount] [decimal](28, 8) NULL,
	[ObjectAddress] [nvarchar](250) NULL,
	[VATNo] [nvarchar](50) NULL,
	[Tel] [nvarchar](100) NULL,
	[Fax] [nvarchar](100) NULL,
	[Email] [nvarchar](100) NULL,
	[O01ID] [nvarchar](50) NULL,
	[O02ID] [nvarchar](50) NULL,
	[O03ID] [nvarchar](50) NULL,
	[O04ID] [nvarchar](50) NULL,
	[O05ID] [nvarchar](50) NULL,
	[Contactor] [nvarchar](100) NULL,
	CONSTRAINT [PK_AT0368] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON
	)
) ON [PRIMARY]
END

