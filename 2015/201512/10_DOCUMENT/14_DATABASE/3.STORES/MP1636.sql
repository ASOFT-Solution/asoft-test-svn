
/****** Object:  StoredProcedure [dbo].[MP1636]    Script Date: 07/29/2010 16:16:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

---Created by: Vo Thanh Huong, date: 30/06/2005
---purpose: Lay so lieu load len man hinh tien do san xuat
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [02/08/2010]
'**************************************************************/
ALTER PROCEDURE  [dbo].[MP1636] 	@DivisionID nvarchar(50),
					@FromMonth int,
					@FromYear int,
					@ToMonth int,
					@ToYear int

AS
DECLARE @sSQL nvarchar(4000),
	@FromPeriod nvarchar(50),
	@ToPeriod nvarchar(50)

Select @FromPeriod = cast((@FromMonth + @FromYear*100) as nvarchar(50)), @ToPeriod =  cast((@ToMonth + @ToYear*100) as nvarchar(50)) 

Set @sSQL = 
'Select MT2004.VoucherID, 
	MT2004.DivisionID, 
	MT2004.TranMonth, 
	MT2004.TranYear, 
	MT2004.VoucherTypeID, 
	MT2004.VoucherNo, 
	MT2004.VoucherDate, 
	MT2004.Description, 
	MT2004.Status, 
	MT2004.EmployeeID, 
	AT1103.FullName, 
	MT2004.KCSEmployeeID, 
	AT1103_KCS.FullName as KCSFullName, 
	MT2004.InventoryTypeID, 
	MT2004.CreateDate, 
	MT2004.CreateUserID, 
	MT2004.LastModifyDate, 
	MT2004.LastModifyUserID
From MT2004  left  join AT1103 on AT1103.EmployeeID = MT2004.EmployeeID and AT1103.DivisionID = MT2004.DivisionID
	left  join AT1103 AT1103_KCS on AT1103_KCS.EmployeeID = MT2004.KCSEmployeeID and AT1103_KCS.DivisionID = MT2004.DivisionID
Where MT2004.DivisionID = ''' + @DivisionID + ''' and 
	MT2004.TranMonth + MT2004.TranYear*100 between ' + @FromPeriod + ' and ' + @ToPeriod        


If exists (Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'MV1636')
	DROP VIEW MV1636
EXEC('Create view MV1636 ---tao boi MP1636
		as ' + @sSQL)

Set @sSQL = 
'Select   MT2004.VoucherID, 
	MT2004.DivisionID, 
	MT2004.TranMonth, 
	MT2004.TranYear, 
	MT2004.VoucherTypeID, 
	MT2004.VoucherNo, 
	MT2004.VoucherDate, 
	MT2004.Description, 
	MT2004.Status, 
	MT2004.EmployeeID, 
	AT1103.FullName, 
	MT2004.KCSEmployeeID, 
	AT1103_KCS.FullName as KCSFullName, 
	MT2004.InventoryTypeID, 
	MT2004.CreateDate, 
	MT2004.CreateUserID, 
	MT2004.LastModifyDate, 
	MT2004.LastModifyUserID,
	MT2005.TransactionID, 	
	MT2005.PLanID, 
	MT2005.InventoryID, 
	AT1302.InventoryName, 
	AT1302.UnitID,
	MT2005.LinkNo, 
	MT2005.ActualQuantity, 
	MT2005.Description as TDescription,  
	MT2005.DepartmentID,
	AT1102.DepartmentName,
	MT2005.WorkID,
	MT1701.WorkName,
	MT2005.LevelID, 
	MT1702.LevelName,
	MT2005.Finish,
	MT2005.Orders
From	MT2005 inner join MT2004 on MT2005.VoucherID = MT2004.VoucherID and MT2005.DivisionID = MT2004.DivisionID
	left join AT1302 on AT1302.InventoryID = MT2005.InventoryID and AT1302.DivisionID = MT2005.DivisionID
	left  join AT1103 on AT1103.EmployeeID = MT2004.EmployeeID and AT1103.DivisionID = MT2004.DivisionID
	left join AT1103 AT1103_KCS on AT1103_KCS.EmployeeID = MT2004.KCSEmployeeID and AT1103_KCS.DivisionID = MT2004.DivisionID
	left join MT1701 on MT1701.WorkID = MT2005.WorkID
	left join MT1702 on MT1702.WorkID = MT2005.WorkID and MT1702.LevelID = MT2005.LevelID
	left join AT1102 on AT1102.DepartmentID = MT2005.DepartmentID and AT1102.DivisionID = MT2005.DivisionID
Where MT2004.DivisionID = ''' + @DivisionID + ''' and  
	MT2004.TranMonth + MT2004.TranYear*100  between ' + @FromPeriod + ' and ' + @ToPeriod 

If exists (Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'MV1637')
	DROP VIEW MV1637
EXEC('Create view MV1637 ---tao boi MP1636
		as ' + @sSQL)