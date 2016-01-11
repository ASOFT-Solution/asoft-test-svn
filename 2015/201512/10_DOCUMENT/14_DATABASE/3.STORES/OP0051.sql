IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0051]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0051]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Created by : Thuy Tuyen
---- Date : 19/11/2009
---- Purpose: Loc ra cac don hang ban cho man hinh duyet don hang San Xuat.
---25/01/2010
--- Modify on 22/07/2015 by Bảo Anh: Sửa tên store từ OP0041 thành OP0051 và trả thẳng dữ liệu không tạo view
/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/

CREATE PROCEDURE [dbo].[OP0051]  @DivisionID NVARCHAR(50),
				@ObjectID NVARCHAR (50),
				 @FromMonth  int,
				 @FromYear int,
				 @ToMonth int,
				 @ToYear int ,
				 @IsCheck tinyint
AS
DECLARE 
    @sSQL1 AS NVARCHAR(4000),
	@sWhere AS NVARCHAR(4000)

IF @IsCheck  = 1
    SET @sWhere = ''
ELSE
    SET @sWhere = ' AND T00.IsConfirm = 0 '	
    
	----- Buoc  1 : Tra ra thong tin Master VIEW OV0033 ( De load truy van)
SET @sSQL1 = N' 
SELECT 
    T00.EstimateID, 
    T00.DivisionID, 
    T00.TranMonth, 
    T00.TranYear, 
    T00.VoucherTypeID, 
    T00.VoucherNo, 
    T00.VoucherDate, 
    T00.Status, 
    T00.SOrderID, 
    T00.ApportionType,
    T00.DepartmentID, 
    T00.EmployeeID, 
    T00.InventoryTypeID, 
    T00.Description, 
    T00.CreateUserID, 
    T00.CreateDate, 
    T00.LastModifyUserID, 
    T00.LastModifyDate, 
    T00.WareHouseID, 
    T00.OrderStatus, 
    T00.IsPicking,  
    T00.PeriodID, 
    T00.ObjectID, 
    T00.IsConfirm, 
    T00.DescriptionConfirm,
    AT1202.ObjectName,
    T11.Description AS OrderStatusName,
    T12.Description AS IsConfirmName, 
    T12.EDescription AS EIsConfirmName
FROM OT2201 T00
    LEFT JOIN AT1202     ON AT1202.DivisionID = T00.DivisionID AND AT1202.ObjectID = T00.ObjectID
    LEFT JOIN OT1101 T11 ON T11.DivisionID = T00.DivisionID    AND T11.OrderStatus = T00.OrderStatus AND T11.TypeID =''ES''
    LEFT JOIN OT1102 T12 ON T12.DivisionID = T00.DivisionID    AND T12.Code = T00.IsConfirm AND T12.TypeID =''SO''
WHERE T00.DivisionID = ''' + @DivisionID + ''' 
    AND T00.TranMonth + T00.TranYear * 100 BETWEEN '+str(@FromMonth)+' + '+str(@Fromyear)+' * 100 AND  '+str(@ToMonth)+' + '+str(@Toyear)+' * 100
    AND ISNULL(T00.ObjectID,'''')  like '''+ @ObjectID+'''
    AND Status = 1
    AND T00.EstimateID NOT IN (SELECT DISTINCT ISNULL (EstimateID,'''') FROM AT2007 LEFT JOIN OT2203 ON OT2203.TransactionID= AT2007.ETransactionID)--chi cac phieu chua ke thua sang ASOFT WM
'
SET @sSQL1 = @sSQL1 + @sWhere
EXEC(@sSQL1)
/*
IF exists (SELECT TOP 1 1 FROM SysObjects WHERE name = 'OV0041' AND Xtype ='V') 
    EXEC ('ALTER VIEW OV0041  --tao boi OP0051
		    AS '+@sSQL1)
ELSE    
    EXEC ('CREATE VIEW OV0041  --tao boi OP0051
		    AS '+@sSQL1)
*/