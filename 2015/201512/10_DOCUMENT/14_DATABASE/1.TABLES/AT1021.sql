-- <Summary>
---- 
-- <History>
---- Create on 20/04/2011 by Việt Khánh
---- Modified on 07/11/2013 by Bảo Anh
---- <Example>
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1021]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1021](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ContractDetailID] [nvarchar](50) NOT NULL,
	[ContractID] [nvarchar](50) NOT NULL,
	[StepID] [int] NOT NULL,
	[StepName] [nvarchar](250) NULL,
	[StepDays] [int] NULL,
	[PaymentTerm] [int] NULL,
	[PaymentPercent] [int] NULL,
	[PaymentAmount] [decimal](28, 8) NULL,
	[StepStatus] [tinyint] NULL,
	[CompleteDate] [datetime] NULL,
	[PaymentDate] [datetime] NULL,
	[CorrectDate] [datetime] NULL,
	[PaymentStatus] [tinyint] NULL,
	[Notes] [nvarchar](250) NULL,
 CONSTRAINT [PK_AT1021] PRIMARY KEY NONCLUSTERED 
(
	[DivisionID] ASC,
	[ContractDetailID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1021_StepStatus]') AND type = 'D')
ALTER TABLE [dbo].[AT1021] ADD CONSTRAINT [DF_AT1021_StepStatus]  DEFAULT (0) FOR [StepStatus]
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1021_PaymentStatus]') AND type = 'D')
ALTER TABLE [dbo].[AT1021] ADD CONSTRAINT [DF_AT1021_PaymentStatus]  DEFAULT (0) FOR [PaymentStatus]
---- Add Columns
If Exists (Select * From sysobjects Where name = 'AT1021' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT1021'  and col.name = 'IsTransfer')
           Alter Table  AT1021 Add IsTransfer tinyint NULL           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT1021'  and col.name = 'TransferObjectID')
           Alter Table  AT1021 Add TransferObjectID NVARCHAR(50) NULL
END
---- Alter Columns
if(isnull(COL_LENGTH('AT1021','Paymented'),0)<=0)
ALTER TABLE AT1021 ADD Paymented decimal(28,8) NULL