IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP5410CSG]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP5410CSG]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- <Summary>
---- Load dữ liệu màn hình Cảnh báo nhân viên được nâng bậc lương
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 19/12/2013 by Thanh Sơn
---- 
-- <Example>
---- EXEC HP5410CSG 'SAS', 9,2013

CREATE PROCEDURE HP5410CSG
(
	@DivisionID VARCHAR(50),
	@FromMonth INT,
	@FromYear INT,
	@ToMonth INT,
	@ToYear INT
)

AS 
DECLARE @Cur CURSOR,
        @Cur1 CURSOR,
        @APK VARCHAR(50),
        @EmployeeID VARCHAR(50),
        @SumTon DECIMAL(28,8),
        @SalaryTon DECIMAL(28,8),
        @SumCont DECIMAL(28,8),
        @SalaryCont DECIMAL(28,8),
        @SumKien DECIMAL(28,8),
        @SalaryKien DECIMAL(28,8),
        @SumXe DECIMAL(28,8),
        @SalaryXe DECIMAL(28,8),
        @JobWage DECIMAL(28,8)
        
DELETE FROM HT5401CSG       
SET @Cur = CURSOR SCROLL KEYSET FOR
    SELECT P52.EmployeeID, 
SUM(B.SumTon) AS SumTon, SUM(B.SalaryTon) AS SalaryTon, SUM(B.SumCont) AS SumCont,
SUM(B.SalaryCont) AS SalaryCont, SUM(B.SumKien) AS SumKien, SUM(B.SalaryKien) AS SalaryKien,
SUM(B.SumXe) AS SumXe, SUM(B.SalaryXe) AS SalaryXe, SUM(B.JobWage) AS JobWage
 FROM 
(SELECT A.APK, P51.UnitID, P50.VoucherNo,
(CASE WHEN P50.VoucherNo NOT LIKE 'KK_____________' THEN 
     (CASE WHEN P51.UnitID = 'TA' THEN (CASE WHEN COUNT(A.EmployeeID) <> 0 THEN P51.[Weight]/COUNT(A.EmployeeID) ELSE 0 END) ELSE 0 END)
ELSE 0 END) AS SumTon,
(CASE WHEN P50.VoucherNo NOT LIKE 'KK_____________' THEN 
     (CASE WHEN P51.UnitID = 'TA' THEN (CASE WHEN COUNT(A.EmployeeID) <> 0 THEN P51.[Weight]/COUNT(A.EmployeeID) ELSE 0 END) ELSE 0 END)* H72.Price 
ELSE 0 END) AS SalaryTon,
(CASE WHEN P50.VoucherNo NOT LIKE 'KK_____________' THEN 
     (CASE WHEN P51.UnitID = 'CT' THEN (CASE WHEN COUNT(A.EmployeeID) <> 0 THEN P51.Quantity/COUNT(A.EmployeeID) ELSE 0 END) ELSE 0 END) 
ELSE 0 END) AS SumCont,
(CASE WHEN P50.VoucherNo NOT LIKE 'KK_____________' THEN 
     (CASE WHEN P51.UnitID = 'CT' THEN (CASE WHEN COUNT(A.EmployeeID) <> 0 THEN P51.Quantity/COUNT(A.EmployeeID) ELSE 0 END) ELSE 0 END)*  H72.Price 
ELSE 0 END) AS SalaryCont,
(CASE WHEN P50.VoucherNo NOT LIKE 'KK_____________' THEN 
     (CASE WHEN P51.UnitID = 'K' THEN (CASE WHEN COUNT(A.EmployeeID) <> 0 THEN P51.Quantity/COUNT(A.EmployeeID) ELSE 0 END) ELSE 0 END) 
ELSE 0 END) AS SumKien,
(CASE WHEN P50.VoucherNo NOT LIKE 'KK_____________' THEN 
     (CASE WHEN P51.UnitID = 'K' THEN (CASE WHEN COUNT(A.EmployeeID) <> 0 THEN P51.Quantity/COUNT(A.EmployeeID) ELSE 0 END) ELSE 0 END) *  H72.Price 
ELSE 0 END) AS SalaryKien,
(CASE WHEN P50.VoucherNo NOT LIKE 'KK_____________' THEN 
     (CASE WHEN P51.UnitID = 'XE' THEN (CASE WHEN COUNT(A.EmployeeID) <> 0 THEN P51.Quantity/COUNT(A.EmployeeID) ELSE 0 END) ELSE 0 END)
ELSE 0 END) AS SumXe,
(CASE WHEN P50.VoucherNo NOT LIKE 'KK_____________' THEN 
     (CASE WHEN P51.UnitID = 'XE' THEN (CASE WHEN COUNT(A.EmployeeID) <> 0 THEN P51.Quantity/COUNT(A.EmployeeID) ELSE 0 END) ELSE 0 END) * H72.Price 
ELSE 0 END) AS SalaryXe,
(CASE WHEN P50.VoucherNo LIKE 'KK_____________' THEN 
	(CASE WHEN P51.UnitID = 'TA' THEN 
		(CASE WHEN COUNT(A.EmployeeID) <> 0 THEN P51.[Weight]/COUNT(A.EmployeeID) ELSE 0 END) 
	ELSE (CASE WHEN COUNT(A.EmployeeID) <> 0 THEN P51.Quantity/COUNT(A.EmployeeID) ELSE 0 END) END)
ELSE 0 END) AS JobWage
FROM 
(
SELECT P51.APK,P52.EmployeeID
FROM PST2051 P51
LEFT JOIN PST2052 P52 ON P52.DivisionID = P51.DivisionID AND P52.VoucherID = P51.VoucherID
)A
LEFT JOIN PST2051 P51 ON P51.APK = A.APK
LEFT JOIN PST2050 P50 ON P50.DivisionID = P51.DivisionID AND P50.VoucherID = P51.VoucherID
LEFT JOIN HT0272 H72 ON H72.SalaryPlanID = P51.TurnRoundPlanID
GROUP BY A.APK, P51.UnitID, P51.[Weight], P51.Quantity, H72.Price,P50.VoucherNo
)B
LEFT JOIN PST2052 P52 ON P52.RefAPK = B.APK
GROUP BY P52.EmployeeID

OPEN @Cur
FETCH NEXT FROM @Cur INTO @EmployeeID, @SumTon, @SalaryTon, @SumCont, @SalaryCont, @SumKien, @SalaryKien, @SumXe, @SalaryXe, @JobWage
WHILE @@FETCH_STATUS = 0
BEGIN
	IF @EmployeeID IS NOT NULL
	BEGIN
		INSERT INTO HT5401CSG
	   (EmployeeID, SumTon, SalaryTon, SumKien, SalaryKien, SumCont, SalaryCont, SumXe, SalaryXe, JobWage)
	    VALUES
	   (@EmployeeID, @SumTon, @SalaryTon, @SumKien, @SalaryKien, @SumCont, @SalaryCont, @SumXe, @SalaryXe, @JobWage)	    
	END
	FETCH NEXT FROM @Cur INTO @EmployeeID, @SumTon, @SalaryTon, @SumCont, @SalaryCont, @SumKien, @SalaryKien, @SumXe, @SalaryXe, @JobWage
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

