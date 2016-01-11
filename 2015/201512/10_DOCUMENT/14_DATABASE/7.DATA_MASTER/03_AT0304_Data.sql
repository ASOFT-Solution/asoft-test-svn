-- <Summary>
---- Danh mục thiết lập tờ khai thuế bảo vệ môi trường - AT0304+AT0305 - Hỗ trợ 17/03/2015
-- <History>
---- Create on 25/03/2015 by Lê Thị Hạnh 
DECLARE @VoucherID NVARCHAR(50),
	    @Cur CURSOR,
	    @DivisionID NVARCHAR(50),
	    @TestID NVARCHAR(50)
SET @Cur = CURSOR SCROLL KEYSET FOR
SELECT AT11.DivisionID 
FROM AT1101 AT11
OPEN @Cur
FETCH NEXT FROM @Cur INTO @DivisionID
WHILE @@FETCH_STATUS = 0
BEGIN
SET @TestID = @DivisionID
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0304 WHERE ReportCode = N'01/TBVMT' AND DivisionID = @TestID)
BEGIN

SET @VoucherID = NEWID()
INSERT INTO AT0304(DivisionID, VoucherID, ReportCode, ReportName, ReportTitle,
            ReportID, ETaxVoucherID, [Disabled], IsDefault, CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
SELECT @TestID,@VoucherID,N'01/TBVMT',N'Tờ khai thuế Bảo vệ môi trường', N'TỜ KHAI THUẾ BẢO VỆ MÔI TRƯỜNG',
	   N'AR0294',AT94.VoucherID,0,1,N'ASOFTADMIN',GETDATE(),N'ASOFTADMIN',GETDATE()
FROM AT0294 AT94
WHERE AT94.LegalDocumentID = N'156/2013/TT-BTC'
INSERT INTO AT0305(DivisionID, VoucherID, TransactionID, ETaxID)
SELECT @DivisionID, @VoucherID, NEWID(),AT95.ETaxID
FROM AT0294 AT94
INNER JOIN AT0295 AT95 ON AT95.VoucherID = AT94.VoucherID
WHERE AT94.LegalDocumentID = N'156/2013/TT-BTC'
END
FETCH NEXT FROM @Cur INTO @DivisionID
END
CLOSE @Cur