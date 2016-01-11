/****** Object:  StoredProcedure [dbo].[MP2012]    Script Date: 08/02/2010 09:53:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

-----  Created by Nguyen Quoc Huy, Date 24/01/2007
-----  Lay cac don hang len form MF2012(Ket qua san xuat)

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [02/08/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[MP2012] @DivisionID nvarchar(50), 
				 @TranMonth as int, 
				 @TranYear as int
 AS

Declare 	@sSQL as nvarchar(4000)

Set @sSQL =' Select SOrderID, VoucherNo, Notes, DivisionID  From OT2001 
Where Disabled=0 and DivisionID = '''+@DivisionID+''' 
and OrderType=1 and OrderStatus in (0,1) 
'


If Exists (Select 1 From sysObjects Where Name ='MV2022' and XType = 'V')
	DROP view MV2022
Exec( 'Create view MV2022  ---tao boi MP2012
		as '+@sSQL)
