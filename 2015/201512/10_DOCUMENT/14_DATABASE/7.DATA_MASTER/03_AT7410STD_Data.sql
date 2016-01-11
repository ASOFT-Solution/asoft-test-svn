-- <Summary>
---- 
-- <History>
---- Create on 17/08/2013 by Huỳnh Tấn Phú
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'AT7410STD' AND col.name = 'VATTypeID5')
    ALTER TABLE [dbo].[AT7410STD] ADD [VATTypeID5] NVARCHAR(100) NULL 

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'AT7410STD' AND col.name = 'VATGroupID5')
    ALTER TABLE [dbo].[AT7410STD] ADD [VATGroupID5] NVARCHAR(100) NULL 

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'AT7410STD' AND col.name = 'VATTypeID6')
    ALTER TABLE [dbo].[AT7410STD] ADD [VATTypeID6] NVARCHAR(100) NULL 

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'AT7410STD' AND col.name = 'VATGroupID6')
    ALTER TABLE [dbo].[AT7410STD] ADD [VATGroupID6] NVARCHAR(100) NULL 

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'AT7410STD' AND col.name = 'VATTypeID7')
    ALTER TABLE [dbo].[AT7410STD] ADD [VATTypeID7] NVARCHAR(100) NULL 

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'AT7410STD' AND col.name = 'VATGroupID7')
    ALTER TABLE [dbo].[AT7410STD] ADD [VATGroupID7] NVARCHAR(100) NULL 
GO
UPDATE AT7410STD SET VATTypeID5 = '' WHERE VATTypeID5 IS NULL
UPDATE AT7410STD SET VATGroupID5 = '' WHERE VATGroupID5 IS NULL
UPDATE AT7410STD SET VATTypeID6 = '' WHERE VATTypeID6 IS NULL
UPDATE AT7410STD SET VATGroupID6 = '' WHERE VATGroupID6 IS NULL
UPDATE AT7410STD SET VATTypeID7 = '' WHERE VATTypeID7 IS NULL
UPDATE AT7410STD SET VATGroupID7 = '' WHERE VATGroupID7 IS NULL

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'AT7410' AND col.name = 'VATTypeID5')
    ALTER TABLE [dbo].[AT7410] ADD [VATTypeID5] NVARCHAR(100) NULL 

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'AT7410' AND col.name = 'VATGroupID5')
    ALTER TABLE [dbo].[AT7410] ADD [VATGroupID5] NVARCHAR(100) NULL 

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'AT7410' AND col.name = 'VATTypeID6')
    ALTER TABLE [dbo].[AT7410] ADD [VATTypeID6] NVARCHAR(100) NULL 

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'AT7410' AND col.name = 'VATGroupID6')
    ALTER TABLE [dbo].[AT7410] ADD [VATGroupID6] NVARCHAR(100) NULL 

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'AT7410' AND col.name = 'VATTypeID7')
    ALTER TABLE [dbo].[AT7410] ADD [VATTypeID7] NVARCHAR(100) NULL 

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'AT7410' AND col.name = 'VATGroupID7')
    ALTER TABLE [dbo].[AT7410] ADD [VATGroupID7] NVARCHAR(100) NULL 
GO
UPDATE AT7410 SET VATTypeID5 = '' WHERE VATTypeID5 IS NULL
UPDATE AT7410 SET VATGroupID5 = '' WHERE VATGroupID5 IS NULL
UPDATE AT7410 SET VATTypeID6 = '' WHERE VATTypeID6 IS NULL
UPDATE AT7410 SET VATGroupID6 = '' WHERE VATGroupID6 IS NULL
UPDATE AT7410 SET VATTypeID7 = '' WHERE VATTypeID7 IS NULL
UPDATE AT7410 SET VATGroupID7 = '' WHERE VATGroupID7 IS NULL

IF NOT EXISTS(SELECT TOP 1 1 FROM AT1009STD WHERE VATTypeID = N'RGTGT3')
INSERT AT1009STD(VATTypeID, VATTypeName, IsVATIn, Disabled, CreateDate, CreateUserID, LastModifyDate, LastModifyUserID)
VALUES(N'RGTGT3', N'Hàng hóa dịch vụ bán ra không phải tổng hợp trên tờ khai 01/GTGT', 0, 0, '04/10/2011', N'ASOFTADMIN', '04/10/2011', 'ASOFTADMIN')

IF NOT EXISTS(SELECT TOP 1 1 FROM AT1009STD WHERE VATTypeID = N'VGTGT5')
INSERT AT1009STD(VATTypeID, VATTypeName, IsVATIn, Disabled, CreateDate, CreateUserID, LastModifyDate, LastModifyUserID)
VALUES(N'VGTGT5', N'Hàng hóa dịch vụ mua vào không phải tổng hợp trên tờ khai 01/GTGT', 1, 0, '04/10/2011', N'ASOFTADMIN', '04/10/2011', N'ASOFTADMIN')

IF NOT EXISTS(SELECT TOP 1 1 FROM AT1010STD WHERE VATGroupID = N'TZ0')
INSERT AT1010STD(VATGroupID, VATRate, VATGroupName, Disabled, CreateDate, CreateUserID, LastModifyDate, LastModifyUserID)
VALUES(N'TZ0', 0, N'Không có thuế xuất cho những hàng hóa, dịch vụ bán ra không phải tổng hợp trên tờ khai 01/GTGT', 0,  '04/10/2011', N'ASOFTADMIN', '04/10/2011', N'ASOFTADMIN')

IF NOT EXISTS(SELECT TOP 1 1 FROM AT8888STD WHERE ReportID = N'AR7411A')
INSERT INTO AT8888STD(ReportID, ReportName, Title, GroupID, Type, Disabled, SQLstring, Orderby, Description, DescriptionE, TitleE, ReportNameE) 
VALUES(N'AR7411A', N'Bảng kê hàng hoá dịch vụ mua vào (mẫu 03)', N'', 'G99', 4, 0, N'' ,N'', N'', N'' ,N'', N'')

IF NOT EXISTS(SELECT TOP 1 1 FROM AT8888STD WHERE ReportID = N'AR7413A')
INSERT INTO AT8888STD(ReportID, ReportName, Title, GroupID, Type, Disabled, SQLstring, Orderby, Description, DescriptionE, TitleE, ReportNameE) 
VALUES(N'AR7413A', N'Bảng kê hàng hoá dịch vụ bán ra có hoá đơn (mẫu 02)', N'', 'G99', 4, 0, N'' ,N'', N'', N'' ,N'', N'')

IF EXISTS(SELECT TOP 1 1 FROM AT7410STD WHERE ReportCode = N'M02.T28')
	DELETE FROM AT7410STD WHERE ReportCode = N'M02.T28'
INSERT INTO AT7410STD(ReportCode, ReportName1, ReportName2, IsTax, TaxAccountID1From, TaxAccountID1To, TaxAccountID2From, TaxAccountID2To, TaxAccountID3From, TaxAccountID3To, NetAccountID1From, NetAccountID1To, NetAccountID2From, NetAccountID2To, NetAccountID3From, NetAccountID3To, NetAccountID4From, NetAccountID4To, NetAccountID5From, NetAccountID5To, VoucherTypeIDFrom, VoucherTypeIDTo, IsVATType, VATTypeID1, VATTypeID2, VATTypeID3, VATTypeID, IsVATGroup, VATGroupID1, VATGroupID2, VATGroupID3, VATGroupIDFrom, VATGroupIDTo, VATObjectTypeID, VATObjectIDFrom, VATObjectIDTo, VoucherTypeID, ReportID, CreateUserID, LastModifyUserID, CreateDate, LastModifyDate, Disabled, IsVATIn, ObjectIDFrom, ObjectIDTo, Order1, Order2, Order3, Order4, VATTypeID4, VATGroupID4, VATTypeID5, VATGroupID5, VATTypeID6, VATGroupID6, VATTypeID7, VATGroupID7)
VALUES(N'M02.T28', N'Bảng kê hoá đơn đầu ra (02/GTGT)', N'Bảng kê hoá đơn đầu ra (02/GTGT)', 1, N'3331', N'3331z', '', '', '', '', N'5111', N'511Z', N'71', N'7z', '', '', '', '', '', '', '', '', 1, N'RGTGT1', N'RGTGT3', '', N'RGTGT', 1, N'TS0', N'T00', N'T05', '', '', '', '', '', '', N'AR7413A', N'ASOFTADMIN', N'ASOFTADMIN', '04/10/2011', '04/10/2011', 0, 0, '', '', N'VATGroupID', N'InvoiceDate', '', '', '', N'T10', '', N'TZ0', '', '', '', '')

IF EXISTS(SELECT TOP 1 1 FROM AT7410STD WHERE ReportCode = N'M03.T28')
	DELETE FROM AT7410STD WHERE ReportCode = N'M03.T28'
INSERT INTO AT7410STD(ReportCode, ReportName1, ReportName2, IsTax, TaxAccountID1From, TaxAccountID1To, TaxAccountID2From, TaxAccountID2To, TaxAccountID3From, TaxAccountID3To, NetAccountID1From, NetAccountID1To, NetAccountID2From, NetAccountID2To, NetAccountID3From, NetAccountID3To, NetAccountID4From, NetAccountID4To, NetAccountID5From, NetAccountID5To, VoucherTypeIDFrom, VoucherTypeIDTo, IsVATType, VATTypeID1, VATTypeID2, VATTypeID3, VATTypeID, IsVATGroup, VATGroupID1, VATGroupID2, VATGroupID3, VATGroupIDFrom, VATGroupIDTo, VATObjectTypeID, VATObjectIDFrom, VATObjectIDTo, VoucherTypeID, ReportID, CreateUserID, LastModifyUserID, CreateDate, LastModifyDate, Disabled, IsVATIn, ObjectIDFrom, ObjectIDTo, Order1, Order2, Order3, Order4, VATTypeID4, VATGroupID4, VATTypeID5, VATGroupID5, VATTypeID6, VATGroupID6, VATTypeID7, VATGroupID7)
VALUES(N'M03.T28', N'Bảng kê hoá đơn đầu vào (03/GTGT)', N'Bảng kê hoá đơn đầu vào (03/GTGT)', N'1', N'1331', N'1331z', '', '', '', '', N'151', N'15z', N'211', N'211z', N'611', N'6z', N'811', N'8z', '', '', '', '', 1, N'VGTGT1', N'VGTGT2', N'VGTGT3', N'VGTGT', 0, '', '', '', '', '', '', '', '', '', N'AR7411A', N'ASOFTADMIN', N'ASOFTADMIN', '04/10/2011', '04/10/2011', 0, 1, '', '', N'VATTypeID', N'InvoiceDate', '', '', N'VGTGT4', '', N'VGTGT5', '', '', '', '', '')

DECLARE 
@DivisionID NVARCHAR(50)

DECLARE cur_AllDivision CURSOR FOR
SELECT DivisionID FROM AT1101
		
OPEN cur_AllDivision
FETCH NEXT FROM cur_AllDivision INTO @DivisionID
WHILE @@fetch_status = 0
BEGIN
    IF NOT EXISTS(SELECT TOP 1 1 FROM AT1009 WHERE DivisionID = @DivisionID AND VATTypeID = N'RGTGT3')
    INSERT AT1009(DivisionID, VATTypeID, VATTypeName, IsVATIn, Disabled, CreateDate, CreateUserID, LastModifyDate, LastModifyUserID, IsCommon)
    SELECT @DivisionID, *, 0 FROM AT1009STD WHERE VATTypeID = N'RGTGT3' 
    
    IF NOT EXISTS(SELECT TOP 1 1 FROM AT1009 WHERE DivisionID = @DivisionID AND VATTypeID = N'VGTGT5')
    INSERT AT1009(DivisionID, VATTypeID, VATTypeName, IsVATIn, Disabled, CreateDate, CreateUserID, LastModifyDate, LastModifyUserID, IsCommon)
    SELECT @DivisionID, *, 0 FROM AT1009STD WHERE VATTypeID = N'VGTGT5' 
    
    IF NOT EXISTS(SELECT TOP 1 1 FROM AT1010 WHERE DivisionID = @DivisionID AND VATGroupID = N'TZ0')
    INSERT AT1010(DivisionID, VATGroupID, VATRate, VATGroupName, Disabled, CreateDate, CreateUserID, LastModifyDate, LastModifyUserID, IsCommon)
    SELECT @DivisionID, *, 0 FROM AT1010STD WHERE VATGroupID = N'TZ0' 
    
    IF NOT EXISTS(SELECT TOP 1 1 FROM AT8888 WHERE DivisionID = @DivisionID AND ReportID = N'AR7411A')
	INSERT INTO AT8888(DivisionID, ReportID, ReportName, Title, GroupID, Type, Disabled, SQLstring, Orderby, Description, DescriptionE, TitleE, ReportNameE,IsDelete) 
    SELECT @DivisionID, * FROM AT8888STD WHERE ReportID = N'AR7411A'
    
    IF NOT EXISTS(SELECT TOP 1 1 FROM AT8888 WHERE DivisionID = @DivisionID AND ReportID = N'AR7413A')
	INSERT INTO AT8888(DivisionID, ReportID, ReportName, Title, GroupID, Type, Disabled, SQLstring, Orderby, Description, DescriptionE, TitleE, ReportNameE) 
    SELECT @DivisionID, ReportID, ReportName, Title, GroupID, Type, Disabled, SQLstring, Orderby, Description, DescriptionE, TitleE, ReportNameE 
    FROM AT8888STD WHERE ReportID = N'AR7413A'
    
    IF EXISTS(SELECT TOP 1 1 FROM AT7410 WHERE DivisionID = @DivisionID AND ReportCode = N'M02.T28')
    	DELETE FROM AT7410 WHERE DivisionID = @DivisionID AND ReportCode = N'M02.T28'
    INSERT INTO AT7410(DivisionID, ReportCode, ReportName1, ReportName2, IsTax, TaxAccountID1From, TaxAccountID1To, TaxAccountID2From, TaxAccountID2To, TaxAccountID3From, TaxAccountID3To, NetAccountID1From, NetAccountID1To, NetAccountID2From, NetAccountID2To, NetAccountID3From, NetAccountID3To, NetAccountID4From, NetAccountID4To, NetAccountID5From, NetAccountID5To, VoucherTypeIDFrom, VoucherTypeIDTo, IsVATType, VATTypeID1, VATTypeID2, VATTypeID3, VATTypeID, IsVATGroup, VATGroupID1, VATGroupID2, VATGroupID3, VATGroupIDFrom, VATGroupIDTo, VATObjectTypeID, VATObjectIDFrom, VATObjectIDTo, VoucherTypeID, ReportID, CreateUserID, LastModifyUserID, CreateDate, LastModifyDate, Disabled, IsVATIn, ObjectIDFrom, ObjectIDTo, Order1, Order2, Order3, Order4, VATTypeID4, VATGroupID4, VATTypeID5, VATGroupID5, VATTypeID6, VATGroupID6, VATTypeID7, VATGroupID7)
    SELECT @DivisionID, * FROM AT7410STD WHERE ReportCode = N'M02.T28'
    
    IF EXISTS(SELECT TOP 1 1 FROM AT7410 WHERE DivisionID = @DivisionID AND ReportCode = N'M03.T28')
    	DELETE FROM AT7410 WHERE DivisionID = @DivisionID AND ReportCode = N'M03.T28'
    INSERT INTO AT7410(DivisionID, ReportCode, ReportName1, ReportName2, IsTax, TaxAccountID1From, TaxAccountID1To, TaxAccountID2From, TaxAccountID2To, TaxAccountID3From, TaxAccountID3To, NetAccountID1From, NetAccountID1To, NetAccountID2From, NetAccountID2To, NetAccountID3From, NetAccountID3To, NetAccountID4From, NetAccountID4To, NetAccountID5From, NetAccountID5To, VoucherTypeIDFrom, VoucherTypeIDTo, IsVATType, VATTypeID1, VATTypeID2, VATTypeID3, VATTypeID, IsVATGroup, VATGroupID1, VATGroupID2, VATGroupID3, VATGroupIDFrom, VATGroupIDTo, VATObjectTypeID, VATObjectIDFrom, VATObjectIDTo, VoucherTypeID, ReportID, CreateUserID, LastModifyUserID, CreateDate, LastModifyDate, Disabled, IsVATIn, ObjectIDFrom, ObjectIDTo, Order1, Order2, Order3, Order4, VATTypeID4, VATGroupID4, VATTypeID5, VATGroupID5, VATTypeID6, VATGroupID6, VATTypeID7, VATGroupID7)
    SELECT @DivisionID, * FROM AT7410STD WHERE ReportCode = N'M03.T28'
    
    FETCH NEXT FROM cur_AllDivision INTO @DivisionID
END  
CLOSE cur_AllDivision
DEALLOCATE cur_AllDivision
