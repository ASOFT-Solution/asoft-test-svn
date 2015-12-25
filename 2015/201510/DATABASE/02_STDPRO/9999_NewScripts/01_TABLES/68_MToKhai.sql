if not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MToKhai'  and col.name = 'QuyToKhai')
BEGIN
	ALTER TABLE MToKhai ADD  QuyToKhai [int] NULL
	ALTER TABLE [dbo].[MToKhai] ADD  CONSTRAINT [DF_MToKhai_QuyToKhai]  DEFAULT ('0') FOR [QuyToKhai]
END


--Add column DeclareType
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MToKhai'  and col.name = 'DeclareType')
BEGIN
	ALTER TABLE MToKhai ADD [DeclareType] [int] NULL
END

--Add column AmendedReturnDate
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MToKhai'  and col.name = 'AmendedReturnDate')
BEGIN
	ALTER TABLE MToKhai ADD [AmendedReturnDate] [smalldatetime] NULL
END

--Add column IsExten
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MToKhai'  and col.name = 'IsExten')
BEGIN
	ALTER TABLE MToKhai ADD [IsExten] [bit] NULL CONSTRAINT [DF_MToKhai_IsExten]  DEFAULT ('0')
END

--Add column IsInputAppendix
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MToKhai'  and col.name = 'IsInputAppendix')
BEGIN
	ALTER TABLE MToKhai ADD [IsInputAppendix] [bit] NULL CONSTRAINT [DF_MToKhai_IsInputAppendix]  DEFAULT ('0')
END

--Add column IsOutputAppendix
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MToKhai'  and col.name = 'IsOutputAppendix')
BEGIN
	ALTER TABLE MToKhai ADD [IsOutputAppendix] [bit] NULL CONSTRAINT [DF_MToKhai_IsOutputAppendix]  DEFAULT ('0')
END

--Add column ExperiedDay
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MToKhai'  and col.name = 'ExperiedDay')
BEGIN
	ALTER TABLE MToKhai ADD [ExperiedDay] [int] NULL
END

--Add column ExperiedAmount
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MToKhai'  and col.name = 'ExperiedAmount')
BEGIN
	ALTER TABLE MToKhai ADD [ExperiedAmount] [decimal](28, 6) NULL
END

--Add column PayableAmount
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MToKhai'  and col.name = 'PayableAmount')
BEGIN
	ALTER TABLE MToKhai ADD [PayableAmount] [decimal](28, 6) NULL
END

--Add column PayableCmt
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MToKhai'  and col.name = 'PayableCmt')
BEGIN
	ALTER TABLE MToKhai ADD [PayableCmt] [nvarchar](512) NULL
END

--Add column PayableDate
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MToKhai'  and col.name = 'PayableDate')
BEGIN
	ALTER TABLE MToKhai ADD [PayableDate] [smalldatetime] NULL
END

--Add column ReceivableExperied
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MToKhai'  and col.name = 'ReceivableExperied')
BEGIN
	ALTER TABLE MToKhai ADD [ReceivableExperied] [int] NULL
END

--Add column ReceivableAmount
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MToKhai'  and col.name = 'ReceivableAmount')
BEGIN
	ALTER TABLE MToKhai ADD [ReceivableAmount] [decimal](28, 6) NULL
END

--Add column ExperiedReason
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MToKhai'  and col.name = 'ExperiedReason')
BEGIN
	ALTER TABLE MToKhai ADD [ExperiedReason] [nvarchar](512) NULL
END

--Add column ExtenID
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MToKhai'  and col.name = 'ExtenID')
BEGIN
	ALTER TABLE MToKhai ADD [ExtenID] [varchar](16) NULL
END
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_MToKhai_DMGH25]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
BEGIN
	ALTER TABLE [dbo].[MToKhai]  WITH CHECK ADD  CONSTRAINT [FK_MToKhai_DMGH25] FOREIGN KEY([ExtenID])
	REFERENCES [dbo].[DMGH] ([ExtenID])
	ALTER TABLE [dbo].[MToKhai] CHECK CONSTRAINT [FK_MToKhai_DMGH25]
END

--Add column VocationID
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MToKhai'  and col.name = 'VocationID')
BEGIN
	ALTER TABLE MToKhai ADD [VocationID] [varchar](16) NULL
END
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_MToKhai_DMNN25]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
BEGIN
	ALTER TABLE [dbo].[MToKhai]  WITH CHECK ADD  CONSTRAINT [FK_MToKhai_DMNN25] FOREIGN KEY([VocationID])
	REFERENCES [dbo].[DMNN] ([VocationID])
	ALTER TABLE [dbo].[MToKhai] CHECK CONSTRAINT [FK_MToKhai_DMNN25]
END

--Add column TaxDepartmentID
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MToKhai'  and col.name = 'TaxDepartmentID')
BEGIN
	ALTER TABLE MToKhai ADD [TaxDepartmentID] [varchar](16) NULL
END
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_MToKhai_DMThueCapCuc24]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
BEGIN
	ALTER TABLE [dbo].[MToKhai]  WITH CHECK ADD  CONSTRAINT [FK_MToKhai_DMThueCapCuc24] FOREIGN KEY([TaxDepartmentID])
	REFERENCES [dbo].[DMThueCapCuc] ([TaxDepartmentID])
	ALTER TABLE [dbo].[MToKhai] CHECK CONSTRAINT [FK_MToKhai_DMThueCapCuc24]
END

--Add column TaxDepartID
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'MToKhai'  and col.name = 'TaxDepartID')
BEGIN
	ALTER TABLE MToKhai ADD [TaxDepartID] [varchar](16) NULL
END
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_MToKhai_DMThueCapQL25]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
BEGIN
	ALTER TABLE [dbo].[MToKhai]  WITH CHECK ADD  CONSTRAINT [FK_MToKhai_DMThueCapQL25] FOREIGN KEY([TaxDepartID])
	REFERENCES [dbo].[DMThueCapQL] ([TaxDepartID])
	ALTER TABLE [dbo].[MToKhai] CHECK CONSTRAINT [FK_MToKhai_DMThueCapQL25]
END