-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on 21/10/2011 by Phát Danh
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT7801]') AND type in (N'U'))
CREATE TABLE [dbo].[AT7801](
    [APK] [uniqueidentifier] DEFAULT NEWID(),
    [DivisionID] [nvarchar] (3) NOT NULL,
	[AllocationID] [nvarchar](50) NOT NULL,
	[AllocationDesc] [nvarchar](250) NOT NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[Disabled] [tinyint] NOT NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
CONSTRAINT [PK_AT7801] PRIMARY KEY NONCLUSTERED 
(
	[AllocationID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7801_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7801] ADD  CONSTRAINT [DF_AT7801_Disabled]  DEFAULT ((0)) FOR [Disabled]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'AT7801' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT7801'  and col.name = 'IsTransferGeneral')
           Alter Table  AT7801 Add IsTransferGeneral tinyint Null Default(0)
End 