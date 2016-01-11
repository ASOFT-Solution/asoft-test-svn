
/****** Object:  StoredProcedure [dbo].[AP1518]    Script Date: 07/29/2010 11:17:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

--Creater :Nguyen Thi Thuy Tuyen.
---Creadate:08/08/2008
-- Puppose :Lay du lieu in  o man hinh ghi giam TSCD   !

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP1518] 
				@DivisionID nvarchar(50),
				@ReduceID nvarchar(50) 
				
				
AS
Declare @sSQL nVarchar(4000)
Set @sSQL = ' 
SELECT  
	ReduceID,
	AssetID, 
	AssetName, 
	DivisionID, 
	ReduceMonth, 
	ReduceYear, 
	ReduceNo, 
	ReduceVoucherNo,
	ReduceDate, 
	Notes, 
	AssetStatus, 
	CreateDate, 
	CreateUserID, 
	LastModifyUserID, 
	LastModifyDate, 
	ConvertedAmount, 
	AccuDepAmount, 
	RemainAmount, 
	DepPeriods, 
	DepreciatedMonths,
	DepartmentID, 
	EmployeeID
FROM AT1523
WHERE   AT1523.DivisionID = ''' + @DivisionID + ''' 
	and AT1523.ReduceID = ''' + @ReduceID + '''
'
--Print @sSQL
If not Exists (Select 1 From  sysObjects Where Xtype ='V' and Name ='AV1518')
	Exec(' Create view AV1518 as '+ @sSQL )
Else
	Exec(' Alter view AV1518 as '+@sSQL)