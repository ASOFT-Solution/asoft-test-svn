IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[CRMP10104]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[CRMP10104]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
----In báo cáo Khách hàng mới theo nhân viên
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
----Created by: Thị Phượng on 27/01/2016
-- <Example>
----    EXEC CRMP10104 'AS','AS','','','','','','','', 'NV01',1,20

CREATE PROCEDURE [dbo].[CRMP10104] ( 
        @DivisionID       VARCHAR(50),  --Biến môi trường
		@DivisionIDList    NVARCHAR(2000),  --Chọn trong DropdownChecklist DivisionID
		@FromMonth        INT,
		@FromYear          INT,
		@ToMonth           INT,
		@ToYear           INT,
		@FromDate         DATETIME,
		@ToDate           DATETIME,
		@IsDate           TINYINT,
		@UserID  VARCHAR(50)
)
AS
DECLARE
        @sSQL   NVARCHAR (MAX),
		@sWhere NVARCHAR(MAX),
		@sWhere01 NVARCHAR(MAX),

		@FromMonthYearText NVARCHAR(20), 
		@ToMonthYearText NVARCHAR(20), 
		@FromDateText NVARCHAR(20), 
		@ToDateText NVARCHAR(20)

SET @sWhere = ''
SET @sWhere01 = ''
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101)

--Check Para DivisionIDList null then get DivisionID 
	IF @DivisionIDList IS NULL or @DivisionIDList = ''
		SET @sWhere01 = @sWhere01 + 'and CRMV10101.DivisionID = '''+ @DivisionID+''''
	Else 
		SET @sWhere01 = @sWhere01 + 'and CRMV10101.DivisionID IN ('''+@DivisionIDList+''')'
IF @IsDate = 1
    ---- xac dinh so lieu theo ngay
	SET @sSQL = 'SELECT C.DivisionID, C.OrderDate, C.AccountID, C.AccountName, 
	C.Address, C.Tel, C.CreateUserID, isnull(C.OrderQuantity,0) as OrderQuantity,
	C.InventoryID,C.InventoryName, C.Notes, C.SalesManID, C.FullName
	FROM CRMV10101 C
	INNER JOIN OT2001 B ON B.DivisionID = C.DivisionID and B.ObjectID = C.AccountID
	Where  C.DivisionID = '''+@DivisionID+''' AND (Month(C.OrderDate) = Month('+@ToDateText+')) AND 
	(SELECT  Count(B.VoucherNo)  from OT2001 B where B.DivisionID = C.DivisionID and B.ObjectID =C.AccountID) =1
	Group By C.SalesManID, C.DivisionID, C.OrderDate, C.AccountID, C.AccountName, 
	C.Address, C.Tel, C.CreateUserID, isnull(C.OrderQuantity,0), C.InventoryID,C.InventoryName, C.Notes, C.FullName
	'


IF @IsDate = 0
 
	SET  @sSQL = 'SELECT C.DivisionID, C.OrderDate, C.AccountID, C.AccountName, 
	C.Address, C.Tel, C.CreateUserID, isnull(C.OrderQuantity,0) as OrderQuantity,
	C.InventoryID,C.InventoryName, C.Notes, C.SalesManID, C.FullName
	FROM CRMV10101 C
	INNER JOIN OT2001 B ON B.DivisionID = C.DivisionID and B.ObjectID = C.AccountID
	Where  C.DivisionID = '''+@DivisionID+''' AND (Month(C.OrderDate) <Month('+@ToMonthYearText+')) AND 
	(SELECT  Count(B.VoucherNo)  from OT2001 B where B.DivisionID = C.DivisionID and B.ObjectID =C.AccountID) =1
	Group By C.SalesManID, C.DivisionID, C.OrderDate, C.AccountID, C.AccountName, 
	C.Address, C.Tel, C.CreateUserID, isnull(C.OrderQuantity,0), C.InventoryID,C.InventoryName, C.Notes, C.FullName
	'
EXEC (@sSQl)
GO
