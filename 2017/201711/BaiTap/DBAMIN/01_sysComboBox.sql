/****** Object:  Table [dbo].[sysComboBox]    Script Date: 1/21/2016 1:57:41 PM ******/
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[sysComboBox]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE [dbo].[sysComboBox](
	[sysComboBoxID] [int] IDENTITY(1,1) NOT NULL,
	[DisplayMember] [varchar](50) NULL,
	[ValueMember] [varchar](50) NULL,
	[StoreName] [varchar](20) NULL,
	[StoreParameter] [varchar](MAX) NULL,
	[SQLQuery] [nvarchar](MAX) NULL,
	[VViewTable] [varchar](50) NULL,
	[ComboBoxID] [varchar](50) NULL,
 CONSTRAINT [PK_sysComboBox] PRIMARY KEY CLUSTERED 
(
	[sysComboBoxID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysComboBox'  and col.name = 'sysTableID')
BEGIN
 ALTER TABLE sysComboBox ADD sysTableID varchar(50) NULL
END

IF EXISTS (SELECT * FROM sysobjects WHERE NAME='sysComboBox' AND xtype='U')
BEGIN
	IF EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='sysComboBox' AND col.name='StoreParameter')
	Alter Table sysComboBox
		Alter column StoreParameter varchar(MAX) NULL ;
    IF EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='sysComboBox' AND col.name='SQLQuery')
	Alter Table sysComboBox
		Alter column SQLQuery varchar(MAX) NULL ;
END