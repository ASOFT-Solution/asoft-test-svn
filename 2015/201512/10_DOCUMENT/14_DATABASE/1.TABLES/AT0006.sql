-- <Summary>
----
-- <History>
---- Create on 13/12/2010 by Thanh Trẫm
---- Modified on ... by 
-- <Example>

IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[AT0006]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE [dbo].[AT0006](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[AccountID] [nvarchar](50) NOT NULL,
	[D_C] [nvarchar](100) NULL,
 CONSTRAINT [PK_AT0006] PRIMARY KEY CLUSTERED 
(
	[AccountID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END

