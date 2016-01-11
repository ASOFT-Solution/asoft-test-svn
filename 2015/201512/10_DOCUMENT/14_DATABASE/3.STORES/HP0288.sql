
IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0288]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0288]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Load danh chấm công sản phẩm của nhân viên phương pháp chỉ định
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 27/08/2013 by Thanh Sơn
---- Modify by 03/12/2015 On Hoàng Vũ: CustomizeINdex = 43 (Secoin), Lưu trữ thểm 2 trường kế thừa lưu vết InheritVoucherID, InheritTransactionID và load lên trường số chứng từ tham chiếu để cho biết kế thừa từ phiếu kết quả sản xuất nào
-- <Example>
---- EXEC HP0288 'CTY', 'Admin', 3, 2013,'LAN01', 'VR.0000', 1,'2013-03-19 00:00:00',1,'CA1'

CREATE PROCEDURE HP0288
( 
		@DivisionID AS NVARCHAR(50),
		@UserID AS NVARCHAR(50),
		@TranMonth AS INT,
		@TranYear AS INT,
		@TimesID AS NVARCHAR(50),
        @EmployeeID AS NVARCHAR(50),
        @CheckDate AS TINYINT,
        @TrackingDate AS DATETIME,
        @CheckShift AS TINYINT,
        @ShiftID AS NVARCHAR(50)
)
AS
DECLARE @sWhere AS NVARCHAR (MAX),
        @sSQL AS NVARCHAR(MAX)

SET @sWhere = ''   
     
  IF @CheckDate = 1
   SET @sWhere=@sWhere +  N'   
   AND convert(nvarchar(10), HT87.TrackingDate, 101)='''+convert(nvarchar(10),@TrackingDate, 101)+''''
   
IF @CheckShift = 1
   SET @sWhere=@sWhere + N'
   AND HT87.ShiftID= '''+@ShiftID+'''  
   '
   
SET @sSQL=N'
SELECT HT87.*, HT15.ProductName, MT0810.VoucherNo as RefVoucherNo
FROM    HT0287 HT87
LEFT JOIN HT1015 HT15 ON HT87.DivisionID=HT15.DivisionID AND HT87.ProductID=HT15.ProductID
LEFT JOIN MT0810 On HT87.DivisionID = MT0810.DivisionID and HT87.InheritVoucherID = MT0810.VoucherID
WHERE HT87.DivisionID='''+@DivisionID+'''
AND HT87.TimesID='''+@TimesID+'''
AND HT87.EmployeeID='''+@EmployeeID+'''
'
--PRINT (@sSQL)
--PRINT(@sWhere)

EXEC (@sSQL+@sWhere)


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
