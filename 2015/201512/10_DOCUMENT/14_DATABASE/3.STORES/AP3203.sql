/****** Object:  StoredProcedure [dbo].[AP3203]    Script Date: 07/29/2010 11:15:11 ******/

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



---- Created by: Thuy Tuyen
---- Date: 30/09/2009
---- Purpose: Tra ra du lieu load( Addnew va edit)  Master  ke thua nhieu phieu  don hang mua (AF3216)

/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [29/07/2010]
'**************************************************************/
ALTER PROCEDURE [dbo].[AP3203]    @DivisionID nvarchar(50),
				    @FromMonth int,
	  			    @FromYear int,
				    @ToMonth int,
				    @ToYear int,  
				    @FromDate as datetime,
				    @ToDate as Datetime,
				    @IsDate as tinyint, ----0 theo k?, 1 theo ngày
				    @ObjectID nvarchar(50),
				    @VoucherID nvarchar(50) -- neu load 
				
 AS
Declare
 @sSQL as nvarchar(4000),
 @sWhere  as nvarchar(4000)

IF @IsDate = 0
Set  @sWhere = '
And  TranMonth+TranYear*100 between    ' + cast(@FromMonth + @FromYear*100 as nvarchar(50)) + ' and ' +  cast(@ToMonth + @ToYear*100 as nvarchar(50))  + ' '
else
Set  @sWhere = '
And OT3001.OrderDate  Between '''+Convert(nvarchar(10),@FromDate,21)+''' and '''+convert(nvarchar(10), @ToDate,21)+''''




if isnull(@VoucherID,'')<> ''

Set  @sSQL =' 
Select  top 100 percent AT9000.OrderID,OT3001.OrderDate, OT3001.ObjectID, AT1202.ObjectName,OT3001.Notes,IsCheck = 1, OT3001.VoucherTypeID, AT9000.DivisionID
From AT9000
Inner Join OT3001 On AT9000.OrderID = OT3001.POrderID and AT9000.DivisionID = OT3001.DivisionID 
Left Join AT1202 on AT1202.ObjectID = AT9000.ObjectID and AT1202.DivisionID = AT9000.DivisionID
Where AT9000.VoucherID = ''' + @VoucherID + ''' 
And  AT9000.DivisionID = ''' + @DivisionID + '''	
union
Select OT3001.POrderID as OrderID ,OT3001.OrderDate, OT3001.ObjectID, AT1202.ObjectName,OT3001.Notes, Ischeck = 0, OT3001.VoucherTypeID, OT3001.DivisionID
From OT3001
Left Join AT1202 on AT1202.ObjectID = OT3001.ObjectID and AT1202.DivisionID = OT3001.DivisionID
Where OT3001.DivisionID = ''' + @DivisionID + '''  
 	And OT3001.ObjectID like '''+@ObjectID+ ''' 
	And OT3001.Disabled=0  And OrderStatus Not In (0,3,4,5,9)
	And POrderID In (Select Distinct AQ1014.OrderID From AQ1014 Where EndQuantity>0 And DivisionID= ''' + @DivisionID + '''   ) 
	and POrderID not in ( Select OrderID from AT9000 Where  AT9000.VoucherID = ''' + @VoucherID + ''' and AT9000.DivisionID = ''' + @DivisionID + '''  )
	
	'+@sWhere+'
'

else 

Set @sSQL =' 
Select OT3001.POrderID as OrderID ,OT3001.OrderDate, OT3001.ObjectID, AT1202.ObjectName,OT3001.Notes, Ischeck = 0, OT3001.VoucherTypeID, OT3001.DivisionID
From OT3001
Left Join AT1202 on AT1202.ObjectID = OT3001.ObjectID and AT1202.DivisionID = OT3001.DivisionID
Where OT3001.DivisionID = ''' + @DivisionID + ''' 
 	And OT3001.ObjectID like '''+@ObjectID+ ''' 
	And OT3001.Disabled=0  And OrderStatus Not In (0,3,4,5,9)
	And POrderID In (Select Distinct AQ1014.OrderID From AQ1014 Where EndQuantity>0 And DivisionID= ''' + @DivisionID + '''   ) 
	
	'+@sWhere+'
'

---Print @sSQL

If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'AV3203')
	Exec('Create View AV3203  --tao boi AP3203
		as '+@sSQL)
Else
	Exec('Alter View AV3203  --- tao boi AP3203
		as '+@sSQL)