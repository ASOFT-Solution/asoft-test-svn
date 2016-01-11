-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Minh Lâm
---- Modified on 19/08/2013 by Bảo Anh: Bổ sung cột nhận biết dữ liệu tạm ứng có được chuyển từ 1 dữ liệu khác (Thuận Lợi)
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT2500]') AND type in (N'U'))
CREATE TABLE [dbo].[HT2500](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[AdvanceID] [nvarchar](50) NOT NULL,
	[DepartmentID] [nvarchar](50) NULL,
	[TeamID] [nvarchar](50) NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[AdvanceDate] [datetime] NULL,
	[AdvanceAmount] [decimal](28, 8) NULL,
	[Description] [nvarchar](250) NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
 CONSTRAINT [PK_HT2500] PRIMARY KEY NONCLUSTERED 
(
	[AdvanceID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add Columns
If Exists (Select * From sysobjects Where name = 'HT2500' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT2500'  and col.name = 'IsFromOtherData')
           Alter Table  HT2500 Add IsFromOtherData tinyint Null
END
If Exists (Select * From sysobjects Where name = 'HT2500' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT2500'  and col.name = 'IsTranfer')
           Alter Table  HT2500 Add IsTranfer tinyint Null Default(0)
End 