-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Minh Lâm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT2422]') AND type in (N'U'))
CREATE TABLE [dbo].[HT2422](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[EmpFileID] [nvarchar](50) NOT NULL,
	[EmployeeID] [nvarchar](50) NOT NULL,
	[TranMonth] [int] NOT NULL,
	[TranYear] [int] NOT NULL,
	[I01] [decimal](28, 8) NULL,
	[I02] [decimal](28, 8) NULL,
	[I03] [decimal](28, 8) NULL,
	[I04] [decimal](28, 8) NULL,
	[I05] [decimal](28, 8) NULL,
	[I06] [decimal](28, 8) NULL,
	[I07] [decimal](28, 8) NULL,
	[I08] [decimal](28, 8) NULL,
	[I09] [decimal](28, 8) NULL,
	[I10] [decimal](28, 8) NULL,
	[I11] [decimal](28, 8) NULL,
	[I12] [decimal](28, 8) NULL,
	[I13] [decimal](28, 8) NULL,
	[I14] [decimal](28, 8) NULL,
	[I15] [decimal](28, 8) NULL,
	[I16] [decimal](28, 8) NULL,
	[I17] [decimal](28, 8) NULL,
	[I18] [decimal](28, 8) NULL,
	[I19] [decimal](28, 8) NULL,
	[I20] [decimal](28, 8) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
 CONSTRAINT [PK_HT2422] PRIMARY KEY CLUSTERED 
(
	[EmpFileID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add Columns
