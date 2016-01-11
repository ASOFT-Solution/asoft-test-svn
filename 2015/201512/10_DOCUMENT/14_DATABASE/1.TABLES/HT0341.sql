-- <Summary>
---- 
-- <History>
---- Create on 16/01/2014 by Lưu Khánh Vân
---- Modified on ... by ...
---- <Example>
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT0341]') AND type in (N'U'))
CREATE TABLE [dbo].[HT0341](
	[APK] [uniqueidentifier] NULL,
	[DivisionID] [nvarchar](50) NOT NULL,
	[TransactionID] [nvarchar] (50) Not null,
	[EmployeeID] [nvarchar](50) NOT NULL,
	[TranMonth] [int] Not null,
	[TranYear] [int] Not null,
	[Income01][decimal]  (28,8) NULL,
	[Income02][decimal]  (28,8) NULL,
	[Income03][decimal]  (28,8) NULL,
	[Income04][decimal]  (28,8) NULL,
	[Income05][decimal]  (28,8) NULL,
	[Income06][decimal]  (28,8) NULL,
	[Income07][decimal]  (28,8) NULL,
	[Income08][decimal]  (28,8) NULL,
	[Income09][decimal]  (28,8) NULL,
	[Income10][decimal]  (28,8) NULL,
	[Income11][decimal]  (28,8) NULL,
	[Income12][decimal]  (28,8) NULL,
	[Income13][decimal]  (28,8) NULL,
	[Income14][decimal]  (28,8) NULL,
	[Income15][decimal]  (28,8) NULL,
	[Income16][decimal]  (28,8) NULL,
	[Income17][decimal]  (28,8) NULL,
	[Income18][decimal]  (28,8) NULL,
	[Income19][decimal]  (28,8) NULL,
	[Income20][decimal]  (28,8) NULL,
	[Income21][decimal]  (28,8) NULL,
	[Income22][decimal]  (28,8) NULL,
	[Income23][decimal]  (28,8) NULL,
	[Income24][decimal]  (28,8) NULL,
	[Income25][decimal]  (28,8) NULL,
	[Income26][decimal]  (28,8) NULL,
	[Income27][decimal]  (28,8) NULL,
	[Income28][decimal]  (28,8) NULL,
	[Income29][decimal]  (28,8) NULL,
	[Income30][decimal]  (28,8) NULL,
	[SubAmount01][decimal]  (28,8) NULL,
	[SubAmount02][decimal]  (28,8) NULL,
	[SubAmount03][decimal]  (28,8) NULL,
	[SubAmount04][decimal]  (28,8) NULL,
	[SubAmount05][decimal]  (28,8) NULL,
	[SubAmount06][decimal]  (28,8) NULL,
	[SubAmount07][decimal]  (28,8) NULL,
	[SubAmount08][decimal]  (28,8) NULL,
	[SubAmount09][decimal]  (28,8) NULL,
	[SubAmount10][decimal]  (28,8) NULL,
	[SubAmount11][decimal]  (28,8) NULL,
	[SubAmount12][decimal]  (28,8) NULL,
	[SubAmount13][decimal]  (28,8) NULL,
	[SubAmount14][decimal]  (28,8) NULL,
	[SubAmount15][decimal]  (28,8) NULL,
	[SubAmount16][decimal]  (28,8) NULL,
	[SubAmount17][decimal]  (28,8) NULL,
	[SubAmount18][decimal]  (28,8) NULL,
	[SubAmount19][decimal]  (28,8) NULL,
	[SubAmount20][decimal]  (28,8) NULL,

 CONSTRAINT [PK_HT0341] PRIMARY KEY CLUSTERED 
(
	[DivisionID] ASC,
	[EmployeeID] Asc,
	[TransactionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT0341_APK]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT0341] ADD  CONSTRAINT [DF_HT0341_APK]  DEFAULT (newid()) FOR [APK]
END
---- Add Columns
IF EXISTS (SELECT * FROM sysobjects WHERE name = 'HT0341' AND xtype = 'U') 
BEGIN
		IF  EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'IncomeID')
    ALTER TABLE HT0341 drop column IncomeID
    	IF  EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'IncomeAmount')
    ALTER TABLE HT0341 drop column IncomeAmount		
		IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'Income01')
    ALTER TABLE HT0341 ADD Income01 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'Income02')
    ALTER TABLE HT0341 ADD Income02 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'Income03')
    ALTER TABLE HT0341 ADD Income03 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'Income04')
    ALTER TABLE HT0341 ADD Income04 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'Income05')
    ALTER TABLE HT0341 ADD Income05 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'Income06')
    ALTER TABLE HT0341 ADD Income06 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'Income07')
    ALTER TABLE HT0341 ADD Income07 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'Income08')
    ALTER TABLE HT0341 ADD Income08 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'Income09')
    ALTER TABLE HT0341 ADD Income09 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'Income10')
    ALTER TABLE HT0341 ADD Income10 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'Income11')
    ALTER TABLE HT0341 ADD Income11 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'Income12')
    ALTER TABLE HT0341 ADD Income12 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'Income13')
    ALTER TABLE HT0341 ADD Income13 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'Income14')
    ALTER TABLE HT0341 ADD Income14 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'Income15')
    ALTER TABLE HT0341 ADD Income15 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'Income16')
    ALTER TABLE HT0341 ADD Income16 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'Income17')
    ALTER TABLE HT0341 ADD Income17 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'Income18')
    ALTER TABLE HT0341 ADD Income18 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'Income19')
    ALTER TABLE HT0341 ADD Income19 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'Income20')
    ALTER TABLE HT0341 ADD Income20 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'Income21')
    ALTER TABLE HT0341 ADD Income21 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'Income22')
    ALTER TABLE HT0341 ADD Income22 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'Income23')
    ALTER TABLE HT0341 ADD Income23 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'Income24')
    ALTER TABLE HT0341 ADD Income24 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'Income25')
    ALTER TABLE HT0341 ADD Income25 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'Income26')
    ALTER TABLE HT0341 ADD Income26 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'Income27')
    ALTER TABLE HT0341 ADD Income27 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'Income28')
    ALTER TABLE HT0341 ADD Income28 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'Income29')
    ALTER TABLE HT0341 ADD Income29 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'Income30')
    ALTER TABLE HT0341 ADD Income30 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'SubAmount01')
    ALTER TABLE HT0341 ADD SubAmount01 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'SubAmount02')
    ALTER TABLE HT0341 ADD SubAmount02 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'SubAmount03')
    ALTER TABLE HT0341 ADD SubAmount03 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'SubAmount04')
    ALTER TABLE HT0341 ADD SubAmount04 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'SubAmount05')
    ALTER TABLE HT0341 ADD SubAmount05 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'SubAmount06')
    ALTER TABLE HT0341 ADD SubAmount06 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'SubAmount07')
    ALTER TABLE HT0341 ADD SubAmount07 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'SubAmount08')
    ALTER TABLE HT0341 ADD SubAmount08 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'SubAmount09')
    ALTER TABLE HT0341 ADD SubAmount09 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'SubAmount10')
    ALTER TABLE HT0341 ADD SubAmount10 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'SubAmount11')
    ALTER TABLE HT0341 ADD SubAmount11 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'SubAmount12')
    ALTER TABLE HT0341 ADD SubAmount12 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'SubAmount13')
    ALTER TABLE HT0341 ADD SubAmount13 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'SubAmount14')
    ALTER TABLE HT0341 ADD SubAmount14 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'SubAmount15')
    ALTER TABLE HT0341 ADD SubAmount15 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'SubAmount16')
    ALTER TABLE HT0341 ADD SubAmount16 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'SubAmount17')
    ALTER TABLE HT0341 ADD SubAmount17 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'SubAmount18')
    ALTER TABLE HT0341 ADD SubAmount18 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'SubAmount19')
    ALTER TABLE HT0341 ADD SubAmount19 decimal(28,8)  NULL
        IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
    ON col.id = tab.id WHERE tab.name = 'HT0341' AND col.name = 'SubAmount20')
    ALTER TABLE HT0341 ADD SubAmount20 decimal(28,8)  NULL 
END