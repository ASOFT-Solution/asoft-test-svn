
/****** Object:  StoredProcedure [dbo].[AP1524]    Script Date: 07/29/2010 11:33:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

--Creater :Nguyen Thi Thuy Tuyen.
---Creadate:08/08/2006
-- Puppose :Lay du lieu in bao cao danh muc giam TSCD   !
--Last Edit Thuy Tuyen 15/06/2006  

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP1524] 
				@DivisionID nvarchar(50) ,
				@FromMonth int,
				@FromYear int,
				@ToMonth int,
				@ToYear int
				
				
AS
Declare @sSQL nvarchar(800)
Set @sSQL = ' 
SELECT  
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
	DepartmentID, 
	EmployeeID
FROM AT1523
WHERE  DivisionID = ''' + @DivisionID + '''
	and	(ReduceMonth + 100 * ReduceYear between ' + str(@FromMonth) + ' + 100 * ' + str(@FromYear) + ' and ' + str(@ToMonth) + ' + 100 * ' + str(@ToYear) + ') 
'
--Print @sSQL
If not Exists (Select 1 From  sysObjects Where Xtype ='V' and Name ='AV1524')
	Exec(' Create view AV1524 as '+ @sSQL )
Else
	Exec(' Alter view AV1524 as '+@sSQL)