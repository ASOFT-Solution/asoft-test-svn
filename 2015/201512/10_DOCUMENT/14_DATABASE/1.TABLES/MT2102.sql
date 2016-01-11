-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT2102]') AND type in (N'U'))
CREATE TABLE [dbo].[MT2102](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[EDetailID] [nvarchar](50) NOT NULL,
	[EstimateID] [nvarchar](50) NOT NULL,
	[TranMonth] [int] NOT NULL,
	[TranYear] [int] NOT NULL,
	[ProductID] [nvarchar](50) NULL,
	[ApportionID] [nvarchar](50) NULL,
	[ProductQuantity] [decimal](28, 8) NULL,
	[PDescription] [nvarchar](250) NULL,
	[LinkNo] [nvarchar](50) NULL,
	[UnitID] [nvarchar](50) NULL,
	[Orders] [int] NULL,
 CONSTRAINT [PK_MT2102] PRIMARY KEY NONCLUSTERED 
(
	[EDetailID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
