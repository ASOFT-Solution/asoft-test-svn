/****** Object:  StoredProcedure [dbo].[AP3207]    Script Date: 07/29/2010 11:35:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

---- Created by: Bao Anh
---- Date: 24/12/2009
---- Purpose: Tra ra du lieu load edit Master ke thua nhieu phieu don hang mua o MH nhap kho (AF2116)

/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [29/07/2010]
---- Modified on 28/10/2015 by Tiểu Mai: thêm biến môi trường, không sinh view.
'**************************************************************/
ALTER PROCEDURE [dbo].[AP3207]      @DivisionID nvarchar(50),
				    @FromMonth int,
	  			    @FromYear int,
				    @ToMonth int,
				    @ToYear int,  
				    @FromDate as datetime,
				    @ToDate as Datetime,
				    @IsDate as tinyint, ----0 theo k?, 1 theo ngày
				    @ObjectID nvarchar(50),
				    @VoucherID nvarchar(50),	--- add new: truyen ''	
					@ConditionIV NVARCHAR(100),
					@IsUsedConditionIV NVARCHAR(100)		
				
 AS
Declare @sSQL as nvarchar(4000)

Set  @sSQL =' 
Select  top 100 percent AT2007.OrderID, AV1023.OrderDate, AV1023.ObjectID, AV1023.ObjectName, AV1023.Notes, IsCheck = 1, AV1023.VoucherTypeID,  AT2006.RDAddress as Address, AT2007.DivisionID
From AT2007
Inner join AT2006 on AT2007.VoucherID = AT2006. VoucherID and  AT2007.DivisionID = AT2006.DivisionID
Inner Join AV1023 On AT2007.OrderID = AV1023.OrderID and AT2007.DivisionID = AV1023.DivisionID
and AV1023.Type = ''PO''
Where AT2007.VoucherID = ''' + @VoucherID + ''' 
And  AT2007.DivisionID = ''' + @DivisionID + '''	
Order by AT2007.OrderID
'

If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'AV3217')
	Exec('Create View AV3217  --tao boi AP3207
		as '+@sSQL)

Else
	Exec('Alter View AV3217  --- tao boi AP3207
		as '+@sSQL)

If @IsDate =0
Begin
	Set @sSQL =
	'Select AV1023.OrderID, AV1023.OrderDate, AV1023.ObjectID, AV1023.ObjectName, AV1023.Notes, Ischeck = 0, AV1023.VoucherTypeID, AV1023.Address, DivisionID
	From AV1023
	Where DivisionID = ''' + @DivisionID + ''' 
	 	And ObjectID like '''+@ObjectID+ ''' 
		And Disabled=0  And Type=''PO'' And OrderStatus Not In (0,3,4,9)
		And OrderID In (Select Distinct AQ1024.OrderID From AQ1024 Where EndQuantity>0 And DivisionID= ''' + @DivisionID + '''   )
		AND (ISNULL(VoucherTypeID, ''#'') IN ('''+@ConditionIV+''') OR '+@IsUsedConditionIV+')
		AND (ISNULL(ObjectID, ''#'') IN ('''+@ConditionIV+''') OR '+@IsUsedConditionIV+') 
		And  TranMonth+TranYear*100 between    ' + cast(@FromMonth + @FromYear*100 as nvarchar(50)) + ' and ' +  cast(@ToMonth + @ToYear*100 as nvarchar(50))  
	    If isnull (@VoucherID,'') <> ''
	    Begin	
		Set @sSQL = @sSQL + '  And OrderID not in ( Select OrderID from AV3217 )
					Union 
					Select AV3217.OrderID, AV3217.OrderDate, AV3217.ObjectID, AV3217.ObjectName, AV3217.Notes, IsCheck = 1, AV3217.VoucherTypeID, AV3217.Address,DivisionID
					From AV3217
					Where (ISNULL(VoucherTypeID, ''#'') IN ('''+@ConditionIV+''') OR '+@IsUsedConditionIV+')
							AND (ISNULL(ObjectID, ''#'') IN ('''+@ConditionIV+''') OR '+@IsUsedConditionIV+')'
	    End
End

Else
Begin
	Set @sSQL =' 
	Select AV1023.OrderID, AV1023.OrderDate, AV1023.ObjectID, AV1023.ObjectName, AV1023.Notes, Ischeck = 0, AV1023.VoucherTypeID, AV1023.Address, DivisionID
	From AV1023
	Where DivisionID = ''' + @DivisionID + ''' 
	 	And ObjectID like '''+@ObjectID+ ''' 
		And Disabled=0  And Type=''PO'' And OrderStatus Not In (0,3,4,9)
		And OrderID In (Select Distinct  AQ1024.OrderID From AQ1024 Where EndQuantity>0 And DivisionID= ''' + @DivisionID + '''   ) 
		AND (ISNULL(VoucherTypeID, ''#'') IN ('''+@ConditionIV+''') OR '+@IsUsedConditionIV+')
		AND (ISNULL(ObjectID, ''#'') IN ('''+@ConditionIV+''') OR '+@IsUsedConditionIV+')
		And AV1023.OrderDate  Between '''+Convert(nvarchar(10),@FromDate,21)+''' and '''+convert(nvarchar(10), @ToDate,21)+''''
	    If isnull (@VoucherID,'') <> ''
	    Begin
		Set @sSQL = @sSQL + ' And OrderID not in ( Select OrderID from AV3217 )
					Union 
					Select AV3217.OrderID, AV3217.OrderDate, AV3217.ObjectID, AV3217.ObjectName, AV3217.Notes, IsCheck = 1, AV3217.VoucherTypeID, AV3217.Address,DivisionID
					From AV3217
					Where (ISNULL(VoucherTypeID, ''#'') IN ('''+@ConditionIV+''') OR '+@IsUsedConditionIV+')
							AND (ISNULL(ObjectID, ''#'') IN ('''+@ConditionIV+''') OR '+@IsUsedConditionIV+')'
	    End
End
--print @sSQL
EXEC (@sSQL)
