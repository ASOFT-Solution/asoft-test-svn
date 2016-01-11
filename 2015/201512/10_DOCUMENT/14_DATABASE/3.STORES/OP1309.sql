
/****** Object:  StoredProcedure [dbo].[OP1309]    Script Date: 12/16/2010 11:07:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

--VAN HUNG
---Created by: Vo Thanh Huong, date: 30/12/2005
--Purpose: Lay du lieu cho man hinh danh muc hop dong 

/********************************************
'* Edited by: [GS] [Thanh Trẫm] [03/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[OP1309]  @DivisionID nvarchar(50)
 AS
DECLARE @sSQL nvarchar(4000)

Set @sSQL = '
Select Distinct OT2001.DivisionID, 
	OT2001.ContractNo, 
	OT2001.ContractDate, 
	OT2001.SOrderID,
	OT2001.ObjectID, 
	isnull(OT2001.ObjectName, AT1202.ObjectName) as ObjectName
From OT2001 inner join AT1202 on OT2001.ObjectID = AT1202.ObjectID
Where  OT2001.DivisionID = ''' + @DivisionID + ''' and Isnull(OT2001.ContractNo,'''') <> '''''



IF not exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV1309')
	EXEC('CREATE VIEW OV1309 --tao boi OP1309
		as ' + @sSQL)
ELSE 	 
	EXEC('ALTER  VIEW OV1309 --tao boi OP1309
		as ' + @sSQL)