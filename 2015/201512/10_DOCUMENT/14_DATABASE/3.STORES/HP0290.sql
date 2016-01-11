
IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0290]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0290]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Load danh chấm công sản phẩm của nhân viên phương pháp phân bổ
-- <Param>
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 27/08/2013 by Thanh Sơn
-- <Example>
---- EXEC HP0290 'CTY', 'Admin', 3, 2013,'LAN01', '01', 1,'2013-03-19 00:00:00',1,'CA2'

CREATE PROCEDURE HP0290
( 
		@DivisionID AS NVARCHAR(50),
		@UserID AS NVARCHAR(50),
		@TranMonth AS INT,
		@TranYear AS INT,
		@TimesID AS NVARCHAR(50),
		@AllocationID AS NVARCHAR(50),       
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
   AND convert(nvarchar(10), HT89.TrackingDate, 101)='''+convert(nvarchar(10),@TrackingDate, 101)+''''
   
IF @CheckShift = 1
   SET @sWhere=@sWhere + N'
   AND HT89.ShiftID= '''+@ShiftID+'''  
   '
   
SET @sSQL=N'
SELECT HT89.*, HT15.ProductName
FROM    HT0289 HT89
LEFT JOIN HT1015 HT15 ON HT89.DivisionID=HT15.DivisionID AND HT89.ProductID=HT15.ProductID
WHERE HT89.DivisionID='''+@DivisionID+'''
AND HT89.TimesID='''+@TimesID+'''
AND HT89.AllocationID='''+@AllocationID+'''
'
PRINT (@sSQL)
PRINT(@sWhere)

EXEC (@sSQL+@sWhere)


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

