-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Tố Oanh
---- Modified on 06/12/2011 by Nguyễn Bình Minh: Thêm cột IsDirectProfitCost
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT0004]') AND type in (N'U'))
CREATE TABLE [dbo].[AT0004](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ID] [nvarchar](50) NOT NULL,
	[Type] [tinyint] NOT NULL,
	[ExchangeRate] [decimal](28, 8) NULL,
	[IsProfitCost] [tinyint] NOT NULL,
 CONSTRAINT [PK_AT0004] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC,
	[Type] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT0004_Type]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT0004] ADD  CONSTRAINT [DF_AT0004_Type]  DEFAULT ((0)) FOR [Type]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT0004_IsProfitCost]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT0004] ADD  CONSTRAINT [DF_AT0004_IsProfitCost]  DEFAULT ((0)) FOR [IsProfitCost]
END
---- Add Columns
IF(ISNULL(COL_LENGTH('AT0004', 'IsDirectProfitCost'), 0) <= 0)
	ALTER TABLE AT0004 ADD IsDirectProfitCost TINYINT DEFAULT(0) NULL
