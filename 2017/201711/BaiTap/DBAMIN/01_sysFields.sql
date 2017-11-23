/****** Object:  Table [dbo].[sysFields]    Script Date: 1/21/2016 1:57:41 PM ******/
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[sysFields]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE [dbo].[sysFields](
	[sysFieldID] [int] IDENTITY(1,1) NOT NULL,
	[sysTable] [nvarchar](50) NOT NULL,
	[AllowNull] [int] NOT NULL,
	[ReadOnly] [int] NULL,
	[sysComboBoxID] [int] NULL,
	[Type] [int] NOT NULL,
	[TabIndex] [int] NULL,
	[TabIndexGrid] [int] NULL,
	[TabIndexPopup] [int] NULL,
	[TabIndexView] [int] NULL,
	[MinValue] [int] NULL,
	[MaxValue] [int] NULL,
	[DefaultValue] [nvarchar](100) NULL,
	[Visible] [int] NOT NULL,
	[ColumnName] [varchar](50) NULL,
	[sysRegularID] [int] NULL,
	[sysDataTypeID] [int] NULL,
	[GridVisible] [int] NULL,
	[FieldVisible] [int] NULL,
	[PopupVisible] [int] NULL,
	[ViewVisible] [int] NULL,
	[UniqueField] [int] NULL,
	[RefTable] [nvarchar](50) NULL,
	[GroupID] [varchar](50) NULL,
	[sysEditorTemplateID] [int] NULL,
	[MaxLenght] [int] NULL,
	[SpecialControl] [int] NULL,
	[RefDisplayField] [varchar](50) NULL,
	[RefValueField] [varchar](50) NULL,
	[RefViewTable] [nvarchar](50) NULL,
	[sysClientTemplateID] [int] NULL,
	[FieldID] [varchar](50) NULL,
	[GridWidth] [int] NULL,
 CONSTRAINT [PK_sysFields] PRIMARY KEY CLUSTERED 
(
	[sysFieldID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysFields'  and col.name = 'sysRadioButtonID')
BEGIN
 ALTER TABLE sysFields ADD sysRadioButtonID int NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysFields'  and col.name = 'LanguageID')
BEGIN
 ALTER TABLE sysFields ADD LanguageID varchar(250) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysFields'  and col.name = 'IsImport')
BEGIN
 ALTER TABLE sysFields ADD IsImport tinyint NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysFields'  and col.name = 'GroupOnGrid')
BEGIN
 ALTER TABLE sysFields ADD GroupOnGrid nvarchar(MAX) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysFields'  and col.name = 'CountOnGrid')
BEGIN
 ALTER TABLE sysFields ADD CountOnGrid nvarchar(MAX) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysFields'  and col.name = 'SumOnGrid')
BEGIN
 ALTER TABLE sysFields ADD SumOnGrid nvarchar(MAX) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysFields'  and col.name = 'AverageOnGrid')
BEGIN
 ALTER TABLE sysFields ADD AverageOnGrid nvarchar(MAX) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysFields'  and col.name = 'MaxOnGrid')
BEGIN
 ALTER TABLE sysFields ADD MaxOnGrid nvarchar(MAX) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysFields'  and col.name = 'MinOnGrid')
BEGIN
 ALTER TABLE sysFields ADD MinOnGrid nvarchar(MAX) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysFields'  and col.name = 'LayoutPosition')
BEGIN
 ALTER TABLE sysFields ADD LayoutPosition int NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysFields'  and col.name = 'IsNoUpdate')
BEGIN
 ALTER TABLE sysFields ADD IsNoUpdate tinyint NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysFields'  and col.name = 'GridOneTable')
BEGIN
 ALTER TABLE sysFields ADD GridOneTable varchar(200) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysFields'  and col.name = 'RefField')
BEGIN
 ALTER TABLE sysFields ADD RefField varchar(MAX) NULL
END



------------------------------Cho biết table sysComboboxID----------------------------------------------------
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'sysFields'  and col.name = 'RefTableComboboxID')
BEGIN
 ALTER TABLE sysFields ADD RefTableComboboxID varchar(MAX) NULL
END
