IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP2007]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP2007]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--- Created by Hoàng Vũ	Date: 11/02/2015
--- Purpose: Load master phiếu giao việc
--- EXEC MP2007 'AS','000000000'

CREATE PROCEDURE [dbo].[MP2007] 
(
	@DivisionID nvarchar(50),
	@VoucherID nvarchar(50)
)
AS

Declare @sSQL1 AS varchar(max),
		@sSQL2 AS varchar(max)
			
			
SET @sSQL1 =' 
SELECT	TOP 1
		MT2007.APK,
		MT2007.DivisionID,
		MT2007.VoucherID, 
		MT2007.TranMonth, 
		MT2007.TranYear,
		MT2007.VoucherTypeID, 
		MT2007.VoucherDate, 
		MT2007.VoucherNo,
		MT2007.RefNo01,
		MT2007.RefNo02,
		MT2007.RefNo03,
		MT2007.RefNo04,
		MT2007.RefNo05,
		MT2007.ObjectID,  
		AT1202.ObjectName,
		MT2007.LaborID,
		AT11031.FullName as LaborName,
		MT2007.EmployeeID,
		AT11032.FullName as EmployeeName, 
		MT2007.InventoryTypeID, 
		MT2007.Description,
		MT2007.OrderStatus,
		MT2007.SOrderID,
		MT2007.CreateUserID,
		MT2007.CreateDate,
		MT2007.LastModifyUserID,
		MT2007.LastModifyDate
'
SET @sSQL2 =' 
FROM	MT2007 
LEFT JOIN AT1202 AT1202 ON AT1202.ObjectID = MT2007.ObjectID And MT2007.DivisionID = AT1202.DivisionID
Left join AT1103 AT11031 on AT11031.EmployeeID = MT2007.LaborID and MT2007.DivisionID = AT11031.DivisionID
Left join AT1103 AT11032 on AT11032.EmployeeID = MT2007.EmployeeID and MT2007.DivisionID = AT11032.DivisionID

WHERE	MT2007.DivisionID = ''' + @DivisionID + ''' And MT2007.VoucherID = ''' + @VoucherID + ''''	

EXEC('SELECT * FROM (' + @sSQL1 + @sSQL2 + ') A')


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
