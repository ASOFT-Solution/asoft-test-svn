-- <Summary>
---- 
-- <History>
---- Create on 31/05/2013 on Lê Thị Thu Hiền
---- Modified on 15/11/2011 by Le Thi Thu Hien
---- Modified by Le Thi Thu Hien on 13/12/2011 : Tham so Chao ban
---- Modified on 31/05/2013 by Le Thi Thu Hien
---- Modified on 04/09/2015 by Tiểu Mai: Tham số chào bán, dự trù chi phí sx
---- <Example>
---- Add Data
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'PD01')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'PD01', N'Tham số 01', N'Tham số 01', 0, N'Parameter 01', N'Parameter 01', N'Purchase Detail')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'PD02')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'PD02', N'Tham số 02', N'Tham số 02', 0, N'Parameter 02', N'Parameter 02', N'Purchase Detail')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'PD03')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'PD03', N'Tham số 03', N'Tham số 03', 0, N'Parameter 03', N'Parameter 03', N'Purchase Detail')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'PD04')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'PD04', N'Tham số 04', N'Tham số 04', 0, N'Parameter 04', N'Parameter 04', N'Purchase Detail')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'PD05')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'PD05', N'Tham số 05', N'Tham số 05', 0, N'Parameter 05', N'Parameter 05', N'Purchase Detail')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'PD06')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'PD06', N'Tham số 06', N'Tham số 06', 0, N'Parameter 06', N'Parameter 06', N'Purchase Detail')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'PD07')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'PD07', N'Tham số 07', N'Tham số 07', 0, N'Parameter 07', N'Parameter 07', N'Purchase Detail')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'PD08')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'PD08', N'Tham số 08', N'Tham số 08', 0, N'Parameter 08', N'Parameter 08', N'Purchase Detail')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'PD09')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'PD09', N'Tham số 09', N'Tham số 09', 0, N'Parameter 09', N'Parameter 09', N'Purchase Detail')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'PD10')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'PD10', N'Tham số 10', N'Tham số 10', 0, N'Parameter 10', N'Parameter 10', N'Purchase Detail')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'PD11')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'PD11', N'Tham số 11', N'Tham số 11', 0, N'Parameter 11', N'Parameter 11', N'Purchase Detail')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'PD12')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'PD12', N'Tham số 12', N'Tham số 12', 0, N'Parameter 12', N'Parameter 12', N'Purchase Detail')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'PD13')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'PD13', N'Tham số 13', N'Tham số 13', 0, N'Parameter 13', N'Parameter 13', N'Purchase Detail')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'PD14')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'PD14', N'Tham số 14', N'Tham số 14', 0, N'Parameter 14', N'Parameter 14', N'Purchase Detail')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'PD15')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'PD15', N'Tham số 15', N'Tham số 15', 0, N'Parameter 15', N'Parameter 15', N'Purchase Detail')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'PD16')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'PD16', N'Tham số 16', N'Tham số 16', 0, N'Parameter 16', N'Parameter 16', N'Purchase Detail')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'PD17')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'PD17', N'Tham số 17', N'Tham số 17', 0, N'Parameter 17', N'Parameter 17', N'Purchase Detail')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'PD18')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'PD18', N'Tham số 18', N'Tham số 18', 0, N'Parameter 18', N'Parameter 18', N'Purchase Detail')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'PD19')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'PD19', N'Tham số 19', N'Tham số 19', 0, N'Parameter 19', N'Parameter 19', N'Purchase Detail')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'PD20')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'PD20', N'Tham số 20', N'Tham số 20', 0, N'Parameter 20', N'Parameter 20', N'Purchase Detail')
-------- Modified on 25/02/2014 on Lê Thị Thu Hiền
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'E01')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'E01', N'Tham số 01', N'Tham số 01', 0, N'Parameter 01', N'Parameter 01', N'Estimate Manufacture')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'E02')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'E02', N'Tham số 02', N'Tham số 02', 0, N'Parameter 02', N'Parameter 02', N'Estimate Manufacture')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'E03')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'E03', N'Tham số 03', N'Tham số 03', 0, N'Parameter 03', N'Parameter 03', N'Estimate Manufacture')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'E04')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'E04', N'Tham số 04', N'Tham số 04', 0, N'Parameter 04', N'Parameter 04', N'Estimate Manufacture')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'E05')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'E05', N'Tham số 05', N'Tham số 05', 0, N'Parameter 05', N'Parameter 05', N'Estimate Manufacture')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'E06')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'E06', N'Tham số 06', N'Tham số 06', 0, N'Parameter 06', N'Parameter 06', N'Estimate Manufacture')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'E07')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'E07', N'Tham số 07', N'Tham số 07', 0, N'Parameter 07', N'Parameter 07', N'Estimate Manufacture')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'E08')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'E08', N'Tham số 08', N'Tham số 08', 0, N'Parameter 08', N'Parameter 08', N'Estimate Manufacture')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'E09')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'E09', N'Tham số 09', N'Tham số 09', 0, N'Parameter 09', N'Parameter 09', N'Estimate Manufacture')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'E10')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'E10', N'Tham số 10', N'Tham số 10', 0, N'Parameter 10', N'Parameter 10', N'Estimate Manufacture')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'E11')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'E11', N'Tham số 11', N'Tham số 11', 0, N'Parameter 11', N'Parameter 11', N'Estimate Manufacture')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'E12')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'E12', N'Tham số 12', N'Tham số 12', 0, N'Parameter 12', N'Parameter 12', N'Estimate Manufacture')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'E13')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'E13', N'Tham số 13', N'Tham số 13', 0, N'Parameter 13', N'Parameter 13', N'Estimate Manufacture')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'E14')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'E14', N'Tham số 14', N'Tham số 14', 0, N'Parameter 14', N'Parameter 14', N'Estimate Manufacture')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'E15')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'E15', N'Tham số 15', N'Tham số 15', 0, N'Parameter 15', N'Parameter 15', N'Estimate Manufacture')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'E16')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'E16', N'Tham số 16', N'Tham số 16', 0, N'Parameter 16', N'Parameter 16', N'Estimate Manufacture')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'E17')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'E17', N'Tham số 17', N'Tham số 17', 0, N'Parameter 17', N'Parameter 17', N'Estimate Manufacture')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'E18')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'E18', N'Tham số 18', N'Tham số 18', 0, N'Parameter 18', N'Parameter 18', N'Estimate Manufacture')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'E19')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'E19', N'Tham số 19', N'Tham số 19', 0, N'Parameter 19', N'Parameter 19', N'Estimate Manufacture')
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'E20')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE, TransactionID)
	VALUES (N'E20', N'Tham số 20', N'Tham số 20', 0, N'Parameter 20', N'Parameter 20', N'Estimate Manufacture')
----- Du lieu ngam tham so man hinh don hang san xuat
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'M01')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE)
	VALUES (N'M01', N'M01 - Tham số 01', N'', 0, N'', N'M01 - Parameter 01')
ELSE
	UPDATE OT0005STD
	SET SystemName = N'M01 - Tham số 01', UserName = N'', IsUsed = 0, UserNameE = N'', SystemNameE = N'M01 - Parameter 01'
	WHERE TypeID = N'M01'
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'M02')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE)
	VALUES (N'M02', N'M02 - Tham số 02', N'', 0, N'', N'M02 - Parameter 02')
ELSE
	UPDATE OT0005STD
	SET SystemName = N'M02 - Tham số 02', UserName = N'', IsUsed = 0, UserNameE = N'', SystemNameE = N'M02 - Parameter 02'
	WHERE TypeID = N'M02'
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'M03')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE)
	VALUES (N'M03', N'M03 - Tham số 03', N'', 0, N'', N'M03 - Parameter 03')
ELSE
	UPDATE OT0005STD
	SET SystemName = N'M03 - Tham số 03', UserName = N'', IsUsed = 0, UserNameE = N'', SystemNameE = N'M03 - Parameter 03'
	WHERE TypeID = N'M03'
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'M04')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE)
	VALUES (N'M04', N'M04 - Tham số 04', N'', 0, N'', N'M04 - Parameter 04')
ELSE
	UPDATE OT0005STD
	SET SystemName = N'M04 - Tham số 04', UserName = N'', IsUsed = 0, UserNameE = N'', SystemNameE = N'M04 - Parameter 04'
	WHERE TypeID = N'M04'
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'M05')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE)
	VALUES (N'M05', N'M05 - Tham số 05', N'', 0, N'', N'M05 - Parameter 05')
ELSE
	UPDATE OT0005STD
	SET SystemName = N'M05 - Tham số 05', UserName = N'', IsUsed = 0, UserNameE = N'', SystemNameE = N'M05 - Parameter 05'
	WHERE TypeID = N'M05'
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'M06')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE)
	VALUES (N'M06', N'M06 - Tham số 06', N'', 0, N'', N'M06 - Parameter 06')
ELSE
	UPDATE OT0005STD
	SET SystemName = N'M06 - Tham số 06', UserName = N'', IsUsed = 0, UserNameE = N'', SystemNameE = N'M06 - Parameter 06'
	WHERE TypeID = N'M06'
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'M07')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE)
	VALUES (N'M07', N'M07 - Tham số 07', N'', 0, N'', N'M07 - Parameter 07')
ELSE
	UPDATE OT0005STD
	SET SystemName = N'M07 - Tham số 07', UserName = N'', IsUsed = 0, UserNameE = N'', SystemNameE = N'M07 - Parameter 07'
	WHERE TypeID = N'M07'
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'M08')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE)
	VALUES (N'M08', N'M08 - Tham số 08', N'', 0, N'', N'M08 - Parameter 08')
ELSE
	UPDATE OT0005STD
	SET SystemName = N'M08 - Tham số 08', UserName = N'', IsUsed = 0, UserNameE = N'', SystemNameE = N'M08 - Parameter 08'
	WHERE TypeID = N'M08'
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'M09')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE)
	VALUES (N'M09', N'M09 - Tham số 09', N'', 0, N'', N'M09 - Parameter 09')
ELSE
	UPDATE OT0005STD
	SET SystemName = N'M09 - Tham số 09', UserName = N'', IsUsed = 0, UserNameE = N'', SystemNameE = N'M09 - Parameter 09'
	WHERE TypeID = N'M09'
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'M10')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE)
	VALUES (N'M10', N'M10 - Tham số 10', N'', 0, N'', N'M10 - Parameter 10')
ELSE
	UPDATE OT0005STD
	SET SystemName = N'M10 - Tham số 10', UserName = N'', IsUsed = 0, UserNameE = N'', SystemNameE = N'M10 - Parameter 10'
	WHERE TypeID = N'M10'
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'M11')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE)
	VALUES (N'M11', N'M11 - Tham số 11', N'', 0, N'', N'M11 - Parameter 11')
ELSE
	UPDATE OT0005STD
	SET SystemName = N'M11 - Tham số 11', UserName = N'', IsUsed = 0, UserNameE = N'', SystemNameE = N'M11 - Parameter 11'
	WHERE TypeID = N'M11'
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'M12')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE)
	VALUES (N'M12', N'M12 - Tham số 12', N'', 0, N'', N'M12 - Parameter 12')
ELSE
	UPDATE OT0005STD
	SET SystemName = N'M12 - Tham số 12', UserName = N'', IsUsed = 0, UserNameE = N'', SystemNameE = N'M12 - Parameter 12'
	WHERE TypeID = N'M12'
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'M13')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE)
	VALUES (N'M13', N'M13 - Tham số 13', N'', 0, N'', N'M13 - Parameter 13')
ELSE
	UPDATE OT0005STD
	SET SystemName = N'M13 - Tham số 13', UserName = N'', IsUsed = 0, UserNameE = N'', SystemNameE = N'M13 - Parameter 13'
	WHERE TypeID = N'M13'
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'M14')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE)
	VALUES (N'M14', N'M14 - Tham số 14', N'', 0, N'', N'M14 - Parameter 14')
ELSE
	UPDATE OT0005STD
	SET SystemName = N'M14 - Tham số 14', UserName = N'', IsUsed = 0, UserNameE = N'', SystemNameE = N'M14 - Parameter 14'
	WHERE TypeID = N'M14'
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'M15')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE)
	VALUES (N'M15', N'M15 - Tham số 15', N'', 0, N'', N'M15 - Parameter 15')
ELSE
	UPDATE OT0005STD
	SET SystemName = N'M15 - Tham số 15', UserName = N'', IsUsed = 0, UserNameE = N'', SystemNameE = N'M15 - Parameter 15'
	WHERE TypeID = N'M15'
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'M16')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE)
	VALUES (N'M16', N'M16 - Tham số 16', N'', 0, N'', N'M16 - Parameter 16')
ELSE
	UPDATE OT0005STD
	SET SystemName = N'M16 - Tham số 16', UserName = N'', IsUsed = 0, UserNameE = N'', SystemNameE = N'M16 - Parameter 16'
	WHERE TypeID = N'M16'
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'M17')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE)
	VALUES (N'M17', N'M17 - Tham số 17', N'', 0, N'', N'M17 - Parameter 17')
ELSE
	UPDATE OT0005STD
	SET SystemName = N'M17 - Tham số 17', UserName = N'', IsUsed = 0, UserNameE = N'', SystemNameE = N'M17 - Parameter 17'
	WHERE TypeID = N'M17'
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'M18')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE)
	VALUES (N'M18', N'M18 - Tham số 18', N'', 0, N'', N'M18 - Parameter 18')
ELSE
	UPDATE OT0005STD
	SET SystemName = N'M18 - Tham số 18', UserName = N'', IsUsed = 0, UserNameE = N'', SystemNameE = N'M18 - Parameter 18'
	WHERE TypeID = N'M18'
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'M19')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE)
	VALUES (N'M19', N'M19 - Tham số 19', N'', 0, N'', N'M19 - Parameter 19')
ELSE
	UPDATE OT0005STD
	SET SystemName = N'M19 - Tham số 19', UserName = N'', IsUsed = 0, UserNameE = N'', SystemNameE = N'M19 - Parameter 19'
	WHERE TypeID = N'M19'
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'M20')
	INSERT INTO OT0005STD(TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE)
	VALUES (N'M20', N'M20 - Tham số 20', N'', 0, N'', N'M20 - Parameter 20')
ELSE
	UPDATE OT0005STD
	SET SystemName = N'M20 - Tham số 20', UserName = N'', IsUsed = 0, UserNameE = N'', SystemNameE = N'M20 - Parameter 20'
	WHERE TypeID = N'M20'
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'Q01')
	INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed)
	VALUES (N'Q01', N'Q01 - Tham số 01', N'Q01 - Parameter 01', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'Q02')
	INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed)
	VALUES (N'Q02', N'Q02 - Tham số 02', N'Q02 - Parameter 02', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'Q03')
	INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed)
	VALUES (N'Q03', N'Q03 - Tham số 03', N'Q03 - Parameter 03', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'Q04')
	INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed)
	VALUES (N'Q04', N'Q04 - Tham số 04', N'Q04 - Parameter 04', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'Q05')
	INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed)
	VALUES (N'Q05', N'Q05 - Tham số 05', N'Q05 - Parameter 05', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'Q06')
	INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed)
	VALUES (N'Q06', N'Q06 - Tham số 06', N'Q06 - Parameter 06', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'Q07')
	INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed)
	VALUES (N'Q07', N'Q07 - Tham số 07', N'Q07 - Parameter 07', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'Q08')
	INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed)
	VALUES (N'Q08', N'Q08 - Tham số 08', N'Q08 - Parameter 08', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'Q09')
	INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed)
	VALUES (N'Q09', N'Q09 - Tham số 09', N'Q09 - Parameter 09', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'Q10')
	INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed)
	VALUES (N'Q10', N'Q10 - Tham số 10', N'Q10 - Parameter 10', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'Q11')
	INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed)
	VALUES (N'Q11', N'Q11 - Tham số 11', N'Q11 - Parameter 11', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'Q12')
	INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed)
	VALUES (N'Q12', N'Q12 - Tham số 12', N'Q12 - Parameter 12', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'Q13')
	INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed)
	VALUES (N'Q13', N'Q13 - Tham số 13', N'Q13 - Parameter 13', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'Q14')
	INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed)
	VALUES (N'Q14', N'Q14 - Tham số 14', N'Q14 - Parameter 14', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'Q15')
	INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed)
	VALUES (N'Q15', N'Q15 - Tham số 15', N'Q15 - Parameter 15', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'Q16')
	INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed)
	VALUES (N'Q16', N'Q16 - Tham số 16', N'Q16 - Parameter 16', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'Q17')
	INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed)
	VALUES (N'Q17', N'Q17 - Tham số 17', N'Q17 - Parameter 17', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'Q18')
	INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed)
	VALUES (N'Q18', N'Q18 - Tham số 18', N'Q18 - Parameter 18', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'Q19')
	INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed)
	VALUES (N'Q19', N'Q19 - Tham số 19', N'Q19 - Parameter 19', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'Q20')
	INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed)
	VALUES (N'Q20', N'Q20 - Tham số 20', N'Q20 - Parameter 20', 0)
-- Tham số đơn hàng bán
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'S01') INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed) VALUES (N'S01', N'S01 - Tham số 01', N'S01 - Parameter 01', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'S02') INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed) VALUES (N'S02', N'S02 - Tham số 02', N'S02 - Parameter 02', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'S03') INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed) VALUES (N'S03', N'S03 - Tham số 03', N'S03 - Parameter 03', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'S04') INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed) VALUES (N'S04', N'S04 - Tham số 04', N'S04 - Parameter 04', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'S05') INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed) VALUES (N'S05', N'S05 - Tham số 05', N'S05 - Parameter 05', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'S06') INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed) VALUES (N'S06', N'S06 - Tham số 06', N'S06 - Parameter 06', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'S07') INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed) VALUES (N'S07', N'S07 - Tham số 07', N'S07 - Parameter 07', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'S08') INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed) VALUES (N'S08', N'S08 - Tham số 08', N'S08 - Parameter 08', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'S09') INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed) VALUES (N'S09', N'S09 - Tham số 09', N'S09 - Parameter 09', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'S10') INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed) VALUES (N'S10', N'S10 - Tham số 10', N'S10 - Parameter 10', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'S11') INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed) VALUES (N'S11', N'S11 - Tham số 11', N'S11 - Parameter 11', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'S12') INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed) VALUES (N'S12', N'S12 - Tham số 12', N'S12 - Parameter 12', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'S13') INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed) VALUES (N'S13', N'S13 - Tham số 13', N'S13 - Parameter 13', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'S14') INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed) VALUES (N'S14', N'S14 - Tham số 14', N'S14 - Parameter 14', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'S15') INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed) VALUES (N'S15', N'S15 - Tham số 15', N'S15 - Parameter 15', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'S16') INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed) VALUES (N'S16', N'S16 - Tham số 16', N'S16 - Parameter 16', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'S17') INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed) VALUES (N'S17', N'S17 - Tham số 17', N'S17 - Parameter 17', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'S18') INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed) VALUES (N'S18', N'S18 - Tham số 18', N'S18 - Parameter 18', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'S19') INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed) VALUES (N'S19', N'S19 - Tham số 19', N'S19 - Parameter 19', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'S20') INSERT INTO OT0005STD(TypeID, SystemName, SystemNameE, IsUsed) VALUES (N'S20', N'S20 - Tham số 20', N'S20 - Parameter 20', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005 WHERE TypeID LIKE 'S__') 
INSERT INTO OT0005 (DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE)
SELECT AT.DivisionID, STD.TypeID, STD.SystemName, STD.UserName, STD.IsUsed, STD.UserNameE, STD.SystemNameE 
FROM OT0005STD STD, (SELECT DISTINCT DivisionID FROM AT1101) AT 
WHERE STD.TypeID LIKE 'S__'


----- Tham số chi tiết Phiếu dự trù chi phí sản xuất

IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'ED01') INSERT INTO OT0005STD (TypeID, SystemName, SystemNameE, IsUsed) values ('ED01'	,N'E01 - Tham số 01',N'Parameter 01',0)

IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'ED02') INSERT INTO OT0005STD (TypeID, SystemName, SystemNameE, IsUsed) values ('ED02',	N'E02 - Tham số 02',N'Parameter 02',0)

IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'ED03') INSERT INTO OT0005STD (TypeID, SystemName, SystemNameE, IsUsed) values ('ED03',	N'E03 - Tham số 03',N'Parameter 03',0)

IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'ED04') INSERT INTO OT0005STD (TypeID, SystemName, SystemNameE, IsUsed) values ('ED04',	N'E04 - Tham số 04',N'Parameter 04',0)

IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'ED05') INSERT INTO OT0005STD (TypeID, SystemName, SystemNameE, IsUsed) values ('ED05',	N'E05 - Tham số 05',N'Parameter 05',0)

IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'ED06') INSERT INTO OT0005STD (TypeID, SystemName, SystemNameE, IsUsed) values ('ED06',	N'E06 - Tham số 06',N'Parameter 06',0)

IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'ED07') INSERT INTO OT0005STD (TypeID, SystemName, SystemNameE, IsUsed) values ('ED07',	N'E07 - Tham số 07',N'Parameter 07',0)

IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'ED08') INSERT INTO OT0005STD (TypeID, SystemName, SystemNameE, IsUsed) values ('ED08',	N'E08 - Tham số 08',N'Parameter 08',0)

IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'ED09') INSERT INTO OT0005STD (TypeID, SystemName, SystemNameE, IsUsed) values ('ED09',	N'E09 - Tham số 09',N'Parameter 09',0)

IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'ED10') INSERT INTO OT0005STD (TypeID, SystemName, SystemNameE, IsUsed) values ('ED10',	N'E10 - Tham số 10',N'Parameter 10',0)

---- Tham số chi tiết Phiếu chào giá
IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'QD01') INSERT INTO OT0005STD (TypeID, SystemName, SystemNameE, IsUsed) values ('QD01'	,N'Q01 - Tham số 01',N'Q01 - Parameter 01',0)

IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'QD02') INSERT INTO OT0005STD (TypeID, SystemName, SystemNameE, IsUsed) values ('QD02',	N'Q02 - Tham số 02',N'Q02 - Parameter 02',0)

IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'QD03') INSERT INTO OT0005STD (TypeID, SystemName, SystemNameE, IsUsed) values ('QD03',	N'Q03 - Tham số 03',N'Q03 - Parameter 03',0)

IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'QD04') INSERT INTO OT0005STD (TypeID, SystemName, SystemNameE, IsUsed) values ('QD04',	N'Q04 - Tham số 04',N'Q04 - Parameter 04',0)

IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'QD05') INSERT INTO OT0005STD (TypeID, SystemName, SystemNameE, IsUsed) values ('QD05',	N'Q05 - Tham số 05',N'Q05 - Parameter 05',0)

IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'QD06') INSERT INTO OT0005STD (TypeID, SystemName, SystemNameE, IsUsed) values ('QD06',	N'Q06 - Tham số 06',N'Q06 - Parameter 06',0)

IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'QD07') INSERT INTO OT0005STD (TypeID, SystemName, SystemNameE, IsUsed) values ('QD07',	N'Q07 - Tham số 07',N'Q07 - Parameter 07',0)

IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'QD08') INSERT INTO OT0005STD (TypeID, SystemName, SystemNameE, IsUsed) values ('QD08',	N'Q08 - Tham số 08',N'Q08 - Parameter 08',0)

IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'QD09') INSERT INTO OT0005STD (TypeID, SystemName, SystemNameE, IsUsed) values ('QD09',	N'Q09 - Tham số 09',N'Q09 - Parameter 09',0)

IF NOT EXISTS(SELECT TOP 1 1 FROM OT0005STD WHERE TypeID = N'QD10') INSERT INTO OT0005STD (TypeID, SystemName, SystemNameE, IsUsed) values ('QD10',	N'Q10 - Tham số 10',N'Q10 - Parameter 10',0)


---- Update Data
-- TypeID P
UPDATE OT0005STD SET SystemName = N'P01 - Tham số 01', UserName = N'TS01', SystemNameE = N'P01 - Parameter 01', UserNameE = N'Para01' WHERE TypeID = 'P01'
UPDATE OT0005STD SET SystemName = N'P02 - Tham số 02', UserName = N'TS02', SystemNameE = N'P02 - Parameter 02', UserNameE = N'Para02' WHERE TypeID = 'P02'
UPDATE OT0005STD SET SystemName = N'P03 - Tham số 03', UserName = NULL, SystemNameE = N'P03 - Parameter 03', UserNameE = NULL WHERE TypeID = 'P03'
UPDATE OT0005STD SET SystemName = N'P04 - Tham số 04', UserName = NULL, SystemNameE = N'P04 - Parameter 04', UserNameE = NULL WHERE TypeID = 'P04'
UPDATE OT0005STD SET SystemName = N'P05 - Tham sô 05', UserName = NULL, SystemNameE = N'P05 - Parameter 05', UserNameE = NULL WHERE TypeID = 'P05'
UPDATE OT0005STD SET SystemName = N'P06 - Tham số 06', UserName = NULL, SystemNameE = N'P06 - Parameter 06', UserNameE = NULL WHERE TypeID = 'P06'
UPDATE OT0005STD SET SystemName = N'P07 - Tham số 07', UserName = NULL, SystemNameE = N'P07 - Parameter 07', UserNameE = NULL WHERE TypeID = 'P07'
UPDATE OT0005STD SET SystemName = N'P08 - Tham sô 08', UserName = NULL, SystemNameE = N'P08 - Parameter 08', UserNameE = NULL WHERE TypeID = 'P08'
UPDATE OT0005STD SET SystemName = N'P09 - Tham số 09', UserName = NULL, SystemNameE = N'P09 - Parameter 09', UserNameE = NULL WHERE TypeID = 'P09'
UPDATE OT0005STD SET SystemName = N'P10 - Tham số 10', UserName = NULL, SystemNameE = N'P10 - Parameter 10', UserNameE = NULL WHERE TypeID = 'P10'
UPDATE OT0005STD SET SystemName = N'P11 - Tham số 11', UserName = NULL, SystemNameE = N'P11 - Parameter 11', UserNameE = NULL WHERE TypeID = 'P11'
UPDATE OT0005STD SET SystemName = N'P12 - Tham số 12', UserName = NULL, SystemNameE = N'P12 - Parameter 12', UserNameE = NULL WHERE TypeID = 'P12'
UPDATE OT0005STD SET SystemName = N'P13 - Tham số 13', UserName = NULL, SystemNameE = N'P13 - Parameter 13', UserNameE = NULL WHERE TypeID = 'P13'
UPDATE OT0005STD SET SystemName = N'P14 - Tham số 14', UserName = NULL, SystemNameE = N'P14 - Parameter 14', UserNameE = NULL WHERE TypeID = 'P14'
UPDATE OT0005STD SET SystemName = N'P15 - Tham số 15', UserName = NULL, SystemNameE = N'P15 - Parameter 15', UserNameE = NULL WHERE TypeID = 'P15'
UPDATE OT0005STD SET SystemName = N'P16 - Tham số 16', UserName = NULL, SystemNameE = N'P16 - Parameter 16', UserNameE = NULL WHERE TypeID = 'P16'
UPDATE OT0005STD SET SystemName = N'P17 - Tham số 17', UserName = NULL, SystemNameE = N'P17 - Parameter 17', UserNameE = NULL WHERE TypeID = 'P17'
UPDATE OT0005STD SET SystemName = N'P18 - Tham số 18', UserName = NULL, SystemNameE = N'P18 - Parameter 18', UserNameE = NULL WHERE TypeID = 'P18'
UPDATE OT0005STD SET SystemName = N'P19 - Tham số 19', UserName = NULL, SystemNameE = N'P19 - Parameter 19', UserNameE = NULL WHERE TypeID = 'P19'
UPDATE OT0005STD SET SystemName = N'P20 - Tham số 20', UserName = NULL, SystemNameE = N'P20 - Parameter 20', UserNameE = NULL WHERE TypeID = 'P20'
-- TypeID SD
UPDATE OT0005STD SET SystemName = N'SD01 - Tham số 01', UserName = NULL, SystemNameE = N'SD01 - Parameter 01', UserNameE = NULL WHERE TypeID = 'SD01'
UPDATE OT0005STD SET SystemName = N'SD02 - Tham sô 02', UserName = NULL, SystemNameE = N'SD02 - Parameter 02', UserNameE = NULL WHERE TypeID = 'SD02'
UPDATE OT0005STD SET SystemName = N'SD03 - Tham số 03', UserName = NULL, SystemNameE = N'SD03 - Parameter 03', UserNameE = NULL WHERE TypeID = 'SD03'
UPDATE OT0005STD SET SystemName = N'SD04 - Tham số 04', UserName = NULL, SystemNameE = N'SD04 - Parameter 04', UserNameE = NULL WHERE TypeID = 'SD04'
UPDATE OT0005STD SET SystemName = N'SD05 - Tham sô 05', UserName = NULL, SystemNameE = N'SD05 - Parameter 05', UserNameE = NULL WHERE TypeID = 'SD05'
UPDATE OT0005STD SET SystemName = N'SD06 - Tham số 06', UserName = NULL, SystemNameE = N'SD06 - Parameter 06', UserNameE = NULL WHERE TypeID = 'SD06'
UPDATE OT0005STD SET SystemName = N'SD07 - Tham số 07', UserName = NULL, SystemNameE = N'SD07 - Parameter 07', UserNameE = NULL WHERE TypeID = 'SD07'
UPDATE OT0005STD SET SystemName = N'SD08 - Tham sô 08', UserName = NULL, SystemNameE = N'SD08 - Parameter 08', UserNameE = NULL WHERE TypeID = 'SD08'
UPDATE OT0005STD SET SystemName = N'SD09 - Tham số 09', UserName = NULL, SystemNameE = N'SD09 - Parameter 09', UserNameE = NULL WHERE TypeID = 'SD09'
UPDATE OT0005STD SET SystemName = N'SD10 - Tham số 10', UserName = NULL, SystemNameE = N'SD10 - Parameter 10', UserNameE = NULL WHERE TypeID = 'SD10'
-- Cập nhật OT0005
UPDATE OT0005 SET OT0005.SystemName = OT0005STD.SystemName, OT0005.SystemNameE = OT0005STD.SystemNameE FROM OT0005STD WHERE OT0005.TypeID = OT0005STD.TypeID
UPDATE OT0005 SET OT0005.UserName = OT0005STD.UserName FROM OT0005STD WHERE OT0005.TypeID = OT0005STD.TypeID AND ISNULL(OT0005.UserName, '') = ''
UPDATE OT0005 SET OT0005.UserNameE = OT0005STD.UserNameE FROM OT0005STD WHERE OT0005.TypeID = OT0005STD.TypeID AND ISNULL(OT0005.UserNameE, '') = ''
UPDATE OT0005STD SET TransactionID = 'Purchase' WHERE TypeID LIKE 'P__'
UPDATE OT0005 SET TransactionID = 'Purchase' WHERE TypeID LIKE 'P__'

UPDATE OT0005STD SET TransactionID = 'Sales' WHERE TypeID LIKE 'S__'
UPDATE OT0005 SET TransactionID = 'Sales' WHERE TypeID LIKE 'S__'

UPDATE OT0005STD SET TransactionID = 'Sales Detail' WHERE TypeID LIKE 'SD__'
UPDATE OT0005 SET TransactionID = 'Sales Detail' WHERE TypeID LIKE 'SD__'

UPDATE OT0005STD SET TransactionID = 'Quotation' WHERE TypeID LIKE 'Q__'
UPDATE OT0005 SET TransactionID = 'Quotation' WHERE TypeID LIKE 'Q__'
