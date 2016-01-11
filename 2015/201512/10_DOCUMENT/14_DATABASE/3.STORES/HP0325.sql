IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0325]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0325]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Create on 30/10/2013 by Thanh Sơn 
---- Nội dung: Insert dữ liệu vào bảng HT0325
---- EXEC HP0325 'SAS','166ACAF2-2E4B-4F6C-9C69-535B18DD8ED2',12345678901,2,9,2013

CREATE PROCEDURE HP0325
(
	@DivisionID VARCHAR (50),
	@APK VARCHAR (50),
	@Amount DECIMAL (28,8),
	@Mode TINYINT,
	@TranMonth INT,
	@TranYear INT
)    
AS 
DECLARE @sSQL NVARCHAR (MAX),
        @sSQL1 NVARCHAR (MAX)
SET @sSQL1=N'
DECLARE @RefAPK VARCHAR (50),
        @EmployeeID VARCHAR (50),
        @MainDriverID VARCHAR (50),
        @SecondDriverID VARCHAR (50), 
        @C25 DECIMAL (28,8),
        @C251 DECIMAL (28,8),
        @Cur CURSOR  '
        
 -----------------------Bốc xếp ----------------    

IF @Mode=2
SET @sSQL=N'
BEGIN	
	SET  @Cur= CURSOR SCROLL KEYSET FOR
    SELECT EmployeeID FROM PST2052 WHERE DivisionID='''+@DivisionID+''' AND RefAPK='''+@APK+'''     
    OPEN @Cur
    FETCH NEXT FROM @Cur INTO @EmployeeID
    WHILE @@FETCH_STATUS = 0
    BEGIN
    	SELECT @C25 = C25 FROM HT2400 WHERE DivisionID='''+@DivisionID+''' AND EmployeeID = @EmployeeID AND TranMonth='''+STR(@TranMonth)+''' AND TranYear='''+STR(@TranYear)+'''
    	IF NOT EXISTS (SELECT TOP 1 1 FROM HT0325 WHERE ResultAPK='''+@APK+''' AND EmployeeID = @EmployeeID)
    	BEGIN
    		INSERT INTO HT0325 (DivisionID,ResultAPK,EmployeeID,SalaryAmount,Coefficient,ProductAmount)
    	    SELECT '''+@DivisionID+''','''+@APK+''',@EmployeeID,CONVERT(DECIMAL(28,8),'''+CONVERT(VARCHAR(40),@Amount)+''')/CASE WHEN COUNT(EmployeeID)>0 THEN COUNT(EmployeeID) 
    	    ELSE 1 END,ISNULL(@C25,1),CONVERT(DECIMAL(28,8),'''+CONVERT(VARCHAR(40),@Amount)+''')/CASE WHEN COUNT(EmployeeID)>0 THEN COUNT(EmployeeID) ELSE 1 END * ISNULL(@C25,1)
    	    FROM PST2052
    	    WHERE DivisionID='''+@DivisionID+''' AND RefAPK='''+@APK+'''     		
    	END
    	FETCH NEXT FROM @Cur INTO @EmployeeID
    END
    CLOSE @Cur
END'
------------------------Cơ giới--------------------
IF @Mode=3 
SET @sSQL=N'
BEGIN
	SELECT TOP 1 @MainDriverID = P10.MainDriverID FROM PST2110 P10 LEFT JOIN PST2111 P11 ON P11.DivisionID = P10.DivisionID AND P11.VoucherID = P10.VoucherID WHERE P11.DivisionID='''+@DivisionID+''' AND P11.APK='''+@APK+'''
	SELECT TOP 1 @SecondDriverID = P10.SecondDriverID FROM PST2110 P10 LEFT JOIN PST2111 P11 ON P11.DivisionID = P10.DivisionID AND P11.VoucherID = P10.VoucherID WHERE P11.DivisionID='''+@DivisionID+''' AND P11.APK='''+@APK+'''
	SELECT @C25 = C25 FROM HT2400 WHERE DivisionID='''+@DivisionID+''' AND EmployeeID = @MainDriverID AND TranMonth='''+STR(@TranMonth)+''' AND TranYear='''+STR(@TranYear)+'''
	SELECT @C251 = C25 FROM HT2400 WHERE DivisionID='''+@DivisionID+''' AND EmployeeID = @SecondDriverID AND TranMonth='''+STR(@TranMonth)+''' AND TranYear='''+STR(@TranYear)+'''
	IF (@MainDriverID IS NOT NULL AND @SecondDriverID IS NOT NULL)
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM HT0325 WHERE ResultAPK='''+@APK+''' AND EmployeeID = @MainDriverID)
		INSERT INTO HT0325 (DivisionID,ResultAPK,EmployeeID,SalaryAmount,Coefficient,ProductAmount)
		VALUES ('''+@DivisionID+''','''+@APK+''',@MainDriverID,CONVERT(DECIMAL(28,8),'''+CONVERT(VARCHAR(40),@Amount)+''')/2,ISNULL(@C25,1),'''+STR(@Amount)+'''/2 * ISNULL(@C25,1))
		IF NOT EXISTS (SELECT TOP 1 1 FROM HT0325 WHERE ResultAPK='''+@APK+''' AND EmployeeID = @SecondDriverID)
		INSERT INTO HT0325 (DivisionID,ResultAPK,EmployeeID,SalaryAmount,Coefficient,ProductAmount)
		VALUES ('''+@DivisionID+''','''+@APK+''',@SecondDriverID,CONVERT(DECIMAL(28,8),'''+CONVERT(VARCHAR(40),@Amount)+''')/2,ISNULL(@C251,1),'''+STR(@Amount)+'''/2 * ISNULL(@C251,1))
	END 
	IF (@MainDriverID IS NOT NULL AND @SecondDriverID IS NULL) 
	BEGIN 
		IF NOT EXISTS (SELECT TOP 1 1 FROM HT0325 WHERE ResultAPK='''+@APK+''' AND EmployeeID = @MainDriverID)
		INSERT INTO HT0325 (DivisionID,ResultAPK,EmployeeID,SalaryAmount,Coefficient,ProductAmount)
		VALUES ('''+@DivisionID+''','''+@APK+''',@MainDriverID,CONVERT(DECIMAL(28,8),'''+CONVERT(VARCHAR(40),@Amount)+'''),ISNULL(@C25,1),'''+STR(@Amount)+''' * ISNULL(@C25,1))
	END 
	IF (@MainDriverID IS NULL AND @SecondDriverID IS NOT NULL) 
	BEGIN 
		IF NOT EXISTS (SELECT TOP 1 1 FROM HT0325 WHERE ResultAPK='''+@APK+''' AND EmployeeID = @SecondDriverID)
		INSERT INTO HT0325 (DivisionID,ResultAPK,EmployeeID,SalaryAmount,Coefficient,ProductAmount)
		VALUES ('''+@DivisionID+''','''+@APK+''',@SecondDriverID,CONVERT(DECIMAL(28,8),'''+CONVERT(VARCHAR(40),@Amount)+'''),ISNULL(@C251,1),'''+STR(@Amount)+''' * ISNULL(@C251,1))
	END 
END'
------------------------Giao nhận------------------
IF @Mode=4
SET @sSQL=N'
BEGIN
SET @Cur = CURSOR SCROLL KEYSET FOR
    SELECT EmployeeID FROM PST2072 WHERE DivisionID='''+@DivisionID+''' AND RefAPK='''+@APK+'''
    OPEN @Cur
    FETCH NEXT FROM @Cur INTO @EmployeeID
    WHILE @@FETCH_STATUS=0
    BEGIN
    	SELECT @C25 = C25 FROM HT2400 WHERE DivisionID='''+@DivisionID+''' AND EmployeeID = @EmployeeID AND TranMonth='''+STR(@TranMonth)+''' AND TranYear='''+STR(@TranYear)+'''
    	IF NOT EXISTS (SELECT TOP 1 1 FROM HT0325 WHERE ResultAPK='''+@APK+''' AND EmployeeID = @EmployeeID)
    	BEGIN
    		INSERT INTO HT0325 (DivisionID,ResultAPK,EmployeeID,SalaryAmount,Coefficient,ProductAmount)
    	    SELECT '''+@DivisionID+''','''+@APK+''',@EmployeeID,CONVERT(DECIMAL(28,8),'''+CONVERT(VARCHAR(40),@Amount)+''')/CASE WHEN COUNT(EmployeeID)>0 THEN COUNT(EmployeeID) 
    	    ELSE 1 END, ISNULL(@C25,1),CONVERT(DECIMAL(28,8),'''+CONVERT(VARCHAR(40),@Amount)+''')/CASE WHEN COUNT(EmployeeID)>0 THEN COUNT(EmployeeID) ELSE 1 END * ISNULL(@C25,1)
    	    FROM PST2072
    	    WHERE DivisionID='''+@DivisionID+''' AND RefAPK='''+@APK+'''    		
    	END    	
    	FETCH NEXT FROM @Cur INTO @EmployeeID
    END
    CLOSE @Cur
END'
----------------------------------------------------

--PRINT (@sSQL1+@sSQL)
EXEC (@sSQL1+@sSQL)
SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
