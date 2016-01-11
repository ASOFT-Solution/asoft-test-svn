-- <Summary>
---- 
-- <History>
---- Create on 17/01/2014 by Bảo Anh
---- Modified on 17/02/2014 by Bảo Anh: add a new column to table
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1215]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1215](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[DetailID] [nvarchar](50) NOT NULL,
	[PaymentID] [nvarchar](50) NOT NULL,
	[StepID] [int] NOT NULL,
	[StepName] [nvarchar](250) NULL,
	[StepDays] [int] NULL,
	[PaymentPercent] [int] NULL,
	[Notes] [nvarchar](250) NULL,
 CONSTRAINT [PK_AT1215] PRIMARY KEY NONCLUSTERED 
(
	[DivisionID] ASC,
	[DetailID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add Columns
If Exists (Select * From sysobjects Where name = 'AT1215' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT1215'  and col.name = 'PaymentAmount')
           Alter Table AT1215 Add PaymentAmount decimal(28,8) Null
End