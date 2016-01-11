-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT2103]') AND type in (N'U'))
CREATE TABLE [dbo].[MT2103](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[TransactionID] [nvarchar](50) NOT NULL,
	[EstimateID] [nvarchar](50) NOT NULL,
	[TranMonth] [int] NOT NULL,
	[TranYear] [int] NOT NULL,
	[MaterialID] [nvarchar](50) NULL,
	[MaterialQuantity] [decimal](28, 8) NULL,
	[MDescription] [nvarchar](250) NULL,
	[Orders] [int] NULL,
	[UnitID] [nvarchar](50) NULL,
	[EDetailID] [nvarchar](50) NULL,
	CONSTRAINT [PK_MT2103] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
