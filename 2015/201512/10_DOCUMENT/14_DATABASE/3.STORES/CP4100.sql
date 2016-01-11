/****** Object:  StoredProcedure [dbo].[CP4100]    Script Date: 07/29/2010 14:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



------ Created by Nguyen Quoc Huy, Date 16/07/2008
------ Purpose: In chi tiet ho so bao hanh bao tri
/********************************************
'* Edited by: [GS] [Tố Oanh] [29/07/2010]
'********************************************/


ALTER PROCEDURE [dbo].[CP4100] 	@DivisionID as nvarchar(50) ,
					@FromMonth as int,
					@FromYear  as int,
					@ToMonth  as int,
					@ToYear  as int,
					@FromDate as datetime,
					@ToDate as datetime,
					@isDate as tinyint,  --0: Theo thang, 1:theo ngay
					@FromObjectID  as nvarchar(50),
					@ToObjectID  as nvarchar(50),
					@FromServiceTypeID as nvarchar(50),
					@ToServiceTypeID as nvarchar(50),
					@isNotMaintenance as int

	
 ASDeclare @sSQL as nvarchar(4000),
	@SQLwhere as nvarchar(4000),
	@SQLObject as nvarchar(4000),
	@sqlGroup as nvarchar(4000),
	@FromPeriod as int,
	@ToPeriod as int



Set @FromPeriod = (@FromMonth + @FromYear*100)	
Set @ToPeriod = (@ToMonth + @ToYear*100)	

if @isDate=1 -- Theo ngay
	Set @SQLwhere ='  And ContractDate Between '''+
	convert(nvarchar(10),@FromDate,101)+''' and '''+convert(nvarchar(10),@ToDate,101)+''')  '
Else    ---Theo ky
	Set @SQLwhere ='  And (TranMonth + 100*TranYear  Between '+str(@FromPeriod)+' and '+ str(@ToPeriod)+')  '
	
Set @sSQL = 'Select 
		CT4001.DivisionID, 	
		CT4001.TranMonth, 
		CT4001.TranYear, 
		CT4001.WMFileID, 
		CT4001.TransactionID, 
		CT4001.Orders, 
		CT4001.InventoryID, 
		CT4001.UnitID, 
		CT4001.ActualQuantity, 
		CT4001.UnitPrice,
		CT4001.ConvertedAmount,
		CT4001.Serial, 
		CT4001.StartDate as StartDate02, 
		CT4001.EndDate as EndDate02,  
		CT4001.Notes, 
		
		CT4001.Ana01ID, 
		CT4001.Ana02ID, 
		CT4001.Ana03ID, 
		CT4001.Ana04ID, 
		CT4001.Ana05ID, 

		CT4000.S1, CT4000.S2, CT4000.S3, 
		CT4000.WMFileName, CT4000.WMFileDate, 
		CT4000.ObjectID, CT4000.ObjectName, 
		CT4000.Contact, CT4000.Site, CT4000.SupContractNo, 
		CT4000.SupContractDate, CT4000.SupStartDate, CT4000.SupEndDate, 
		CT4000.InvoiceNo, 
		CT4000.ContractNo, 
		CT4000.ContractDate, 
		CT4000.StartDate as StartDate01, 
		CT4000.EndDate as EndDate01,  
		CT4000.ServiceTypeID, CT1001.ServiceTypeName

		From CT4001 Inner join CT4000 on CT4000.WMFileID = CT4001.WMFileID and CT4000.DivisionID = CT4001.DivisionID 
				Left join CT1001 on CT1001.ServiceTypeID = CT4000.ServiceTypeID and CT1001.DivisionID = CT4000.DivisionID

		Where 	 CT4001.DivisionID ='''+ @DivisionID +'''
			and CT4000.ServiceTypeID between ''' + @FromServiceTypeID + ''' and ''' + @ToServiceTypeID + ''' 
			and CT4000.ObjectID between ''' + @FromObjectID + ''' and ''' + @ToObjectID + ''' and '
		+  case when @isDate = 1 then 
			'CT4000.ContractDate  between ' + ''''
			 + convert(nvarchar(10), @FromDate, 101) + ''' and ''' +  convert(nvarchar(10), @ToDate, 101)  + ''''
		else 	' CT4000.TranMonth + CT4000.TranYear*100 between ' +  cast(@FromMonth + @FromYear*100 as nvarchar(10)) +  ' and ' + 
		cast(@ToMonth + @ToYear*100 as nvarchar(10))  end  


--print @sSQL

If not exists (Select name from sysobjects Where id = Object_id(N'[dbo].[CV4100]') and OBJECTPROPERTY(id, N'IsView') = 1)
     Exec ('  Create View CV4100 as ' + @sSQL)
Else
     Exec ('  Alter View CV4100  As ' + @sSQL)

Set @sSQL = ' Select DivisionID, ObjectID, ObjectName, ContractNo, ServiceTypeID, ServiceTypeName, ContractDate,StartDate01,EndDate01,sum(isnull(ConvertedAmount,0)) as ConvertedAmount
		From CV4100
		Group by DivisionID, ObjectID, ObjectName, ContractNo, ServiceTypeID, ServiceTypeName, ContractDate,StartDate01,EndDate01'

if @isNotMaintenance = 1
Begin

	Set @sSQL = ' Select DivisionID, ObjectID, ObjectName, ContractNo, ServiceTypeID, ServiceTypeName, ContractDate,StartDate01,EndDate01,
				TranMonth, TranYear, sum(isnull(ConvertedAmount,0)) as ConvertedAmount
			From CV4100
			Group by DivisionID, ObjectID, ObjectName, ContractNo, ServiceTypeID, ServiceTypeName, ContractDate,StartDate01,EndDate01,TranMonth,TranYear'

	If not exists (Select name from sysobjects Where id = Object_id(N'[dbo].[CV4111]') and OBJECTPROPERTY(id, N'IsView') = 1)
	     Exec ('  Create View CV4111 as ' + @sSQL)
	Else
	     Exec ('  Alter View CV4111  As ' + @sSQL)

	Set @sSQL = '  Select DivisionID, ObjectID, ObjectName, ContractNo, ServiceTypeID, ServiceTypeName, ContractDate,StartDate01,EndDate01,sum(isnull(ConvertedAmount,0)) as ConvertedAmount
			From CV4111
			Where ObjectID not in (Select ObjectID From  CV4111 Where Year(EndDate01)> ''' + str(@ToYear) + ''' )
				and month(EndDate01) <  ''' + str(@ToMonth) + ''' and Year(EndDate01)=  ''' + str(@ToYear) + ''' 
			Group by DivisionID, ObjectID, ObjectName, ContractNo, ServiceTypeID, ServiceTypeName, ContractDate,StartDate01,EndDate01
			'
End

--Print @sSQL

If not exists (Select name from sysobjects Where id = Object_id(N'[dbo].[CV4101]') and OBJECTPROPERTY(id, N'IsView') = 1)
     Exec ('  Create View CV4101 as ' + @sSQL)
Else
     Exec ('  Alter View CV4101  As ' + @sSQL)