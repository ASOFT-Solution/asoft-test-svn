IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP8142]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP8142]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
-- <History>
---- Create on 17/08/2015 by Nguyễn Thanh Thịnh
---- Modified on 08/10/2015 by Tieu Mai: Sửa phần làm tròn số lẻ theo thiết lập đơn vị-chi nhánh
---- 
-- <Example>
/*
 AP8142 @DivisionID = 'VG', @UserID = 'ASOFTADMIN', @ImportTemplateID = '', @XML = ''
 */
 
CREATE PROCEDURE AP8142
( 
	@DivisionID AS NVARCHAR(50),
	@UserID AS NVARCHAR(50),	
	@ImportTemplateID AS NVARCHAR(50),
	@XML AS XML
) 
AS

DECLARE 
@SQL VARCHAR(MAX)



CREATE TABLE #Data
(
	APK UNIQUEIDENTIFIER DEFAULT(NEWID()),
	Row INT,
	Orders INT,
	DetailID NVARCHAR(50),
	ImportMessage NVARCHAR(MAX) DEFAULT ('')	
)

	SET @SQL =  STUFF((		SELECT'ALTER TABLE #Data ADD ' + TLD.ColID + ' ' +  BTL.ColSQLDataType + 
								CASE WHEN BTL.ColSQLDataType LIKE '%char%' 
										THEN ' COLLATE SQL_Latin1_General_CP1_CI_AS' 
										ELSE '' END + ' NULL '
							FROM A01065 TL
							INNER JOIN	A01066 TLD
								ON	TL.ImportTemplateID = TLD.ImportTemplateID
							INNER JOIN	A00065 BTL
								ON	BTL.ImportTransTypeID = TL.ImportTransTypeID AND BTL.ColID = TLD.ColID
							WHERE	TL.ImportTemplateID = 'ProduceAllocate'				
							FOR XML PATH('')),1,0,'')
EXEC(@SQL)


-- Thêm dữ liệu vào bảng tạm
INSERT INTO #Data ([Row],DivisionID,Period,TimesID,DepartmentID,TeamID,ProductID,Quantity,TrackingDate)
SELECT	X.Data.query('Row').value('.', 'INT') AS Row,
		X.Data.query('DivisionID').value('.', 'NVARCHAR(50)') AS DivisionID,
		X.Data.query('Period').value('.', 'NVARCHAR(50)') AS Period,
		X.Data.query('TimesID').value('.', 'NVARCHAR(50)') AS TimesID,		
		X.Data.query('DepartmentID').value('.', 'NVARCHAR(50)') AS DepartmentID,
		X.Data.query('TeamID').value('.', 'NVARCHAR(50)') AS TeamID,		
		X.Data.query('ProductID').value('.', 'NVARCHAR(50)') AS ProductID,
		X.Data.query('Quantity').value('.', 'DECIMAL(28,8)') AS Quantity,
		X.Data.query('TrackingDate').value('.', 'DATETIME') AS TrackingDate
FROM	@XML.nodes('//Data') AS X (Data)

-- Check
---- Kiểm tra check code mặc định

 
DECLARE 
@TranMonth VARCHAR(5) = NULL,
@TranYear VARCHAR(5) = NULL


 SELECT DISTINCT @TranMonth = SUBSTRING(DT.Period,0,PATINDEX('%/%',DT.Period))  ,
				@TranYear = SUBSTRING(DT.Period,PATINDEX('%/%',DT.Period) + 1,LEN(DT.Period)) 
				FROM #Data DT

EXEC AP8105 @ImportTemplateID = @ImportTemplateID, @UserID = @UserID


-- Nếu có lỗi thì không cần sinh khóa và không đẩy dữ liệu vào
IF EXISTS(SELECT TOP 1 1 FROM #Data WHERE ImportMessage != '')
	GOTO LB_RESULT

--- Xử lý làm tròn dữ liệu vì nhập trên Excel có thể sai
UPDATE DT 
SET 
	TrackingDate = CASE WHEN DT.TrackingDate IS NOT NULL OR DT.TrackingDate != '' THEN CONVERT(DATETIME,DT.TrackingDate,114) END,	
	Quantity	 = ROUND(DT.Quantity,A.UnitCostDecimals)	
FROM #Data DT
LEFT JOIN	AT1101 A 
	ON A.DivisionID = DT.DivisionID


 --Insert
DECLARE 
@SQL1 NVARCHAR(MAX)
SET @SQL1 = STUFF((	SELECT DISTINCT 
					'EXEC HP2474 @TimesID=N'''+DT.TimesID+''',@DivisionID=N'''+DT.DivisionID+''',@DepartmentID=N'''+DT.DepartmentID+''',@TeamID=N''' +CASE WHEN ISNULL(DT.TeamID,'''') = ''''THEN '%' ELSE  DT.TeamID END +''',@TranMonth='+ @TranMonth +', @TranYear='+@TranYear +',@CreateUserID='''+@UserID+''',@ProductID='''+DT.ProductID+''',@Quantity='+CAST(DT.Quantity AS VARCHAR)+',@TrackingDate='''+ CONVERT(VARCHAR(10),DT.TrackingDate,101)+'''  '								 
					FROM #Data DT 
					FOR XML PATH('')),1,0,'')
EXEC (@SQL1)
-----------------------------------------------------------------------------------------
LB_RESULT:
SELECT * FROM #Data DT
DROP TABLE #Data
 
