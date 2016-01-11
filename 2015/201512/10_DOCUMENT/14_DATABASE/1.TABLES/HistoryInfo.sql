-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Việt Khánh
---- Modified on ... by ...
---- <Example>
IF  not EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HistoryInfo]') AND type in (N'U'))
      CREATE TABLE [dbo].[HistoryInfo](
      [TableID] [varchar](10) NULL,
      [ModifyUserID] [nvarchar](50) NULL,
      [ModifyDate] [datetime] NULL,
      [Action] [tinyint] NULL,
      [VoucherNo] [nvarchar](50) NULL,
      [TransactionTypeID] [nvarchar](50) NULL,
      [DivisionID] [nvarchar](50) NULL
      ) ON [PRIMARY]