
/****** Object:  StoredProcedure [dbo].[OP1101]    Script Date: 08/03/2010 15:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


---Creater: Thuy Tuyen
---Date: 25/05/2009
---PP: loc cac tinh trang don hang do ra combo man hinh nhap lieu 
-- Last edit: Tuyen, 30/10/2009
-- Modified on 29/10/2014 by Quốc Tuấn bổ sung điều kiện IsConfirm khác 0 
-- Modified on 10/08/2015 by Quốc Tuấn bổ sung điều kiện cho đơn hàng sản xuất

/********************************************
'* Edited by: [GS] [Thanh Trẫm] [03/08/2010]
'********************************************/

ALTER Procedure  [dbo].[OP1101]  
@DivisionID nvarchar(50),
@OrderID  nvarchar(50), @TableID  nvarchar(50)
as
Declare @sSQL as nvarchar(4000)

If  exists (select top 1 1 from OT0000 Where  isnull(IsConfirm,0) <> 0 and DivisionID = @DivisionID)

Begin  
 	If  isnull(@OrderID,'') = '' 
		 Set  @sSQL = '
			select * from OT1101 
			Where (case when TypeID in( ''QO'',''SO'',''RO'',''PO'',''MO'') then OrderStatus else 0 end ) <> 1	'


	else
	begin
	 	
		 if  @TableID ='OT2101' 
			if exists  (select top 1 1 from OT2101 Where QuotationID  =''+@OrderID+''  and  IsConfirm  = 1  and DivisionID = @DivisionID  )
			Set  @sSQL = '
   			  Select * from OT1101	'
			else
			Set  @sSQL = '
			select * from OT1101 
			Where (case when TypeID in( ''QO'',''SO'',''RO'',''PO'',''MO'') then OrderStatus else 0 end ) <> 1	'
			
	
		if  @TableID ='OT2001' 
 			if exists  (select top 1 1 from OT2001 Where SOrderID  =''+@OrderID+''  and  IsConfirm  = 1   and DivisionID = @DivisionID )
			Set  @sSQL = '
   			  Select * from OT1101'
			else
			Set  @sSQL = '
			select * from OT1101 
			Where (case when TypeID in( ''QO'',''SO'',''RO'',''PO'',''MO'') then OrderStatus else 0 end ) <> 1	'
			
		if  @TableID ='OT3101'  
			 if exists (select top 1 1 from OT3101 Where ROrderID  =''+@OrderID+''  and  IsConfirm  = 1   and DivisionID = @DivisionID)  	 
			Set  @sSQL = '
   			 Select * from OT1101	'
			else
			Set  @sSQL = '
			select * from OT1101 
			Where (case when TypeID in( ''QO'',''SO'',''RO'',''PO'',''MO'') then OrderStatus else 0 end ) <> 1	'
			
		if  @TableID ='OT3001' 
 			if exists  (select top 1 1 from OT3001 Where POrderID  =''+@OrderID+''  and  IsConfirm  = 1   and DivisionID = @DivisionID )
			Set  @sSQL = '
   			  Select * from OT1101'
			else
			Set  @sSQL = '
			select * from OT1101 
			Where (case when TypeID in( ''QO'',''SO'',''RO'',''PO'',''MO'') then OrderStatus else 0 end ) <> 1	'
               end
End

If  exists (select top 1 1 from OT0000 Where  isnull(IsConfirm,0) = 0  and DivisionID = @DivisionID)
 
 Set  @sSQL = '
     Select * from OT1101'  


If  not exists ( select 1  from SysObjects Where Xtype ='V' and name = 'OV1101' )
	EXEC('Create view OV1101 as -- Tao boi OP1101 ' +@sSQL)

else
 	EXEC('Alter view OV1101 as --Tao boi OP1101 '+@sSQL)