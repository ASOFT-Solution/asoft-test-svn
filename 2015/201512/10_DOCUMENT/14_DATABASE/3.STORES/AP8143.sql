IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP8143]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP8143]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


---- Xử lý Import chấm công theo Ngay
---- Created on 16/09/2015 Thanh Thinh

CREATE PROCEDURE [DBO].[AP8143]
( 
	@DivisionID AS NVARCHAR(50),
	@UserID AS NVARCHAR(50),	
	@ImportTemplateID AS NVARCHAR(50),
	@XML AS XML
) 
AS

		
DECLARE @TranMonth INT,
		@TranYear INT
		
CREATE TABLE #Data
(
	APK UNIQUEIDENTIFIER DEFAULT(NEWID()),
	Row INT,
	Orders INT,
	ImportMessage NVARCHAR(500) DEFAULT (''),
	CONSTRAINT [PK_#Data] PRIMARY KEY CLUSTERED 
	(
		Row ASC
	) ON [PRIMARY]	
)
declare 
@SQL nvarchar(MAX)

 SELECT	 @SQL =	STUFF((		SELECT'ALTER TABLE #Data ADD ' + TLD.ColID + ' ' +  BTL.ColSQLDataType + 
							CASE WHEN BTL.ColSQLDataType LIKE '%char%' 
									THEN ' COLLATE SQL_Latin1_General_CP1_CI_AS' 
									ELSE '' END + ' NULL '
						FROM A01065 TL
						INNER JOIN	A01066 TLD
							ON	TL.ImportTemplateID = TLD.ImportTemplateID
						INNER JOIN	A00065 BTL
							ON	BTL.ImportTransTypeID = TL.ImportTransTypeID AND BTL.ColID = TLD.ColID
						WHERE	TL.ImportTemplateID = @ImportTemplateID		
						FOR XML PATH('')),1,0,'')  
EXEC(@SQL)

INSERT INTO #Data ([Row],DivisionID,Period,EmployeeID,FromAbsentDate,ToAbsentDate,AbsentTypeID,AbsentAmount)
SELECT	X.Data.query('Row').value('.', 'INT') AS Row,
		X.Data.query('DivisionID').value('.', 'NVARCHAR(50)') AS DivisionID,
		X.Data.query('Period').value('.', 'VARCHAR(10)') AS Period,
		X.Data.query('EmployeeID').value('.', 'NVARCHAR(50)') AS EmployeeID,
		X.Data.query('FromAbsentDate').value('.', 'DATETIME') AS FromAbsentDate,
		X.Data.query('ToAbsentDate').value('.', 'DATETIME') AS ToAbsentDate,
		X.Data.query('AbsentTypeID').value('.', 'VARCHAR(50)') AS AbsentTypeID,
		X.Data.query('AbsentAmount').value('.', 'DECIMAL(28,3)') AS AbsentAmount	
FROM	@XML.nodes('//Data') AS X (Data)

---- Kiểm tra check code mặc định
EXEC AP8105 @ImportTemplateID = @ImportTemplateID, @UserID = @UserID
		
SET @TranMonth = CAST ((SELECT TOP 1 LEFT(Period, 2) FROM #Data) AS INT)
SET @TranYear = CAST ((SELECT TOP 1 RIGHT(Period, 4) FROM #Data) AS INT)

-- Kiểm Tra Lỗi Nhân viên không lập hò sơ lương
UPDATE		DT
SET			DT.ImportMessage = ImportMessage + CASE WHEN ImportMessage <> '' THEN '\n' ELSE '' END + 'ASML000099 {0}=''A'''
FROM		#Data DT
LEFT JOIN HT2400 HT24 
	ON HT24.DivisionID = DT.DivisionID AND HT24.EmployeeID = DT.EmployeeID 
		AND HT24.TranMonth = @TranMonth
		AND HT24.TranYear = @TranYear
WHERE 	HT24.DivisionID IS NULL

-- Kiểm Tra hệ số công
UPDATE		DT
SET			DT.ImportMessage = ImportMessage + CASE WHEN ImportMessage <> '' THEN '\n' ELSE '' END + 'ASML000100 {0}=''E'''
FROM		#Data DT
INNER JOIN HT1013 HT13 
	ON HT13.DivisionID = DT.DivisionID 
		AND HT13.AbsentTypeID = DT.AbsentTypeID 
		AND HT13.ConvertUnit < DT.AbsentAmount


			
-- Nếu có lỗi thì không đẩy dữ liệu vào
IF EXISTS(SELECT TOP 1 1 FROM #Data WHERE ImportMessage <> '')
	GOTO LB_RESULT

--- Xử lý làm tròn dữ liệu vì nhập trên Excel có thể sai
UPDATE		DT
SET			AbsentAmount = ROUND(AbsentAmount, 2)
FROM		#Data DT


CREATE TABLE #TMP_PreINSERT([ROW] INT, DivisionID NVARCHAR(50),EmployeeID NVARCHAR(50),AbsentDate DATETIME ,AbsentTypeID NVARCHAR(50),AbsentAmount DECIMAL(28,3))
CREATE CLUSTERED INDEX IDX_C_#TMP_INSERT_UserID ON #TMP_PreINSERT(DivisionID,EmployeeID,AbsentDate)    
CREATE INDEX IDX_#TMP_INSERT_UserName ON #TMP_PreINSERT(DivisionID,EmployeeID,AbsentDate)

DECLARE @dif INT = 0
DECLARE @FromDate smalldatetime = (SELECT TOP 1 CONVERT(datetime,'1/'+ Period,103) FROM #Data)
DECLARE @Todate smalldatetime = DATEADD(d,-1, DATEADD(mm, DATEDIFF(mm, 0 ,@FromDate)+1, 0)) 
SET @dif = DATEDIFF(DAY,@FromDate,@Todate)	


;with #Temp as 
	(
		SELECT 0 Prio
		UNION ALL 
		SELECT Prio + 1
		FROM #Temp
		WHERE Prio < @dif 
	)	
	INSERT INTO #TMP_PreINSERT ([ROW],DivisionID,EmployeeID,AbsentDate,AbsentTypeID,AbsentAmount)
	SELECT DT.ROW,DT.DivisionID,DT.EmployeeID,TP.[DATE],DT.AbsentTypeID,DT.AbsentAmount
	FROM (	SELECT Prio, DATEADD(DD,Prio,@FromDate) [DATE]
			FROM #Temp	) TP
		INNER JOIN #Data DT 
			ON TP.DATE BETWEEN DT.FromAbsentDate AND  DT.ToAbsentDate   
	ORDER BY [ROW]

	CREATE TABLE #TMP_INSERT(DivisionID NVARCHAR(50),EmployeeID NVARCHAR(50),AbsentDate DATETIME ,AbsentTypeID NVARCHAR(50),AbsentAmount DECIMAL(28,3))
	INSERT INTO #TMP_INSERT(DivisionID, EmployeeID, AbsentDate, AbsentTypeID, AbsentAmount)
	SELECT T1.DivisionID, T1.EmployeeID, T1.AbsentDate, T1.AbsentTypeID, T1.AbsentAmount
	FROM #TMP_PreINSERT T1
		INNER JOIN (	SELECT MAX(T2.[ROW]) [ROW], DivisionID,EmployeeID,AbsentDate,AbsentTypeID
						FROM #TMP_PreINSERT T2
						GROUP BY DivisionID,EmployeeID,AbsentDate,AbsentTypeID
					) T2 ON T2.ROW = T1.ROW AND T2.DivisionID = T1.DivisionID AND T2.EmployeeID = T1.EmployeeID 
							AND T2.AbsentDate = T1.AbsentDate AND T2.AbsentTypeID = T1.AbsentTypeID
						
--- UPDATE DU LIEU 
	UPDATE HT24
	SET HT24.AbsentAmount = TNS.AbsentAmount,
		HT24.LastModifyUserID = @UserID,
		HT24.LastModifyDate = GETDATE()
	FROM HT2401 HT24
	INNER JOIN #TMP_INSERT TNS
		ON HT24.DIVISIONID = TNS.DIVISIONID AND HT24.EmployeeID = TNS.EmployeeID
				AND HT24.AbsentDate = TNS.AbsentDate AND HT24.AbsentTypeID = TNS.AbsentTypeID
				AND HT24.TranMonth = @TranMonth AND HT24.TranYear= @TranYear
	

--- INSERT DU LIEU
	INSERT INTO HT2401(DivisionID, EmployeeID, TranMonth, TranYear, DepartmentID,TeamID, AbsentDate, AbsentTypeID, AbsentAmount, CreateUserID, CreateDate, LastModifyUserID, LastModifyDate)
	SELECT	TNS.DivisionID, TNS.EmployeeID, @TranMonth, @TranYear, HT14.DepartmentID, HT14.TeamID, TNS.AbsentDate, TNS.AbsentTypeID,
			TNS.AbsentAmount, @UserID,GETDATE(),@UserID,GETDATE()
		FROM #TMP_INSERT TNS
		LEFT JOIN HT2401 HT24
			ON HT24.DIVISIONID = TNS.DIVISIONID AND HT24.EmployeeID = TNS.EmployeeID AND HT24.TranMonth = @TranMonth AND HT24.TranYear= @TranYear
				AND HT24.AbsentDate = TNS.AbsentDate AND HT24.AbsentTypeID = TNS.AbsentTypeID
		LEFT JOIN HT1400 HT14
			ON HT14.DivisionID = TNS.DIVISIONID AND HT14.EmployeeID = TNS.EmployeeID  
	WHERE HT24.DivisionID IS NULL
	
LB_RESULT:
SELECT * FROM #Data


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

