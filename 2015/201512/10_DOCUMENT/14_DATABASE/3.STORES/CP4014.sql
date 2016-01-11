/****** Object:  StoredProcedure [dbo].[CP4014]    Script Date: 07/30/2010 09:11:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



--- Created by: Nguyen Thi Thuy Tuyen
-- Created date: 16/11/2006
-- Purpose: Load detail thong ke
--Edit by Quoc Huy, Date 18/07/2008
/********************************************
'* Edited by: [GS] [Tố Oanh] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[CP4014]  @DivisionID nvarchar(50),
				 @TablesName nvarchar(250),
				 @FieldID nvarchar(50),
				 @Type tinyint,
				
				 @FromMonth int,
				 @FromYear int,
				 @ToMonth int,
				 @ToYear int,
				@FromDate datetime,
				@ToDate datetime,
				@Isdate tinyint

 AS

Declare  @strSQL as nvarchar(4000),
	@TypeID as nvarchar(50),
	@sPeriod as nvarchar (500)
Set @TablesName = Ltrim(Rtrim(@TablesName))
Set @FieldID = Ltrim(Rtrim(@FieldID))


If @Type = 0
	Begin
		If @TablesName <> 'AT1302'	
			Set @sPeriod = case when @IsDate = 1 then ' and  CT4000.WMFileDate  between''' + convert(nvarchar(20), @FromDate,101) + '''  and  ''' + 
				convert(nvarchar(20),  @ToDate, 101) + ''''   else 
				' and CT4000.TranMonth + CT4000.TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as nvarchar(20)) + ' and ' +
				cast(@ToMonth + @ToYear*100 as nvarchar(20))  end
		Else
			Set @sPeriod = ' and CT4000.TranMonth + CT4000.TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as nvarchar(20)) + ' and ' +
				cast(@ToMonth + @ToYear*100 as nvarchar(20)) 

	End
Else
	Begin
	Set @sPeriod = case when @IsDate = 1 then ' and  CT4002.FixDate  between''' + convert(nvarchar(20), @FromDate,101) + '''  and  ''' + 
		convert(nvarchar(20),  @ToDate, 101) + ''''   else 
		' and CT4002.TranMonth + CT4002.TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as nvarchar(20)) + ' and ' +
		cast(@ToMonth + @ToYear*100 as nvarchar(20))  end
	End	

If @Type = 0
   Begin
	If @TablesName <> 'AT1302'	and @FieldID <> 'Serial'
		Set @strSQL ='
			Select 
			CT4000. '+@FieldID +' as GroupID,
			CV2222.'+left(@FieldID, len(@FieldID) - 2) +'name as GruopName,
			WMfileID,
			WMfileName,
			CT4000.ObjectID,
			isnull (CT4000.ObjectName,AT1202.ObjectName) as ObjectName,
			ContractNo,
			Topay,
			StartDate,
			EndDate,
			SupContractNo,
			SupStartDate,
			SupEndDate,
			CT4000.Tranmonth,
			CT4000.TranYear,
			CT4000.DivisionID
	
		From CT4000

			    Left Join  AT1202 on AT1202.ObjectID = CT4000.ObjectID and AT1202.DivisionID = CT4000.DivisionID
			    Left Join  CV2222 on CV2222. '+@FieldID +' = Ct4000. '+@FieldID +' and CV2222.DivisionID = CT4000.DivisionID
		Where CT4000. Disabled  = 0   '+@sPeriod +' AND CT4000.DivisionID = '''+@DivisionID+''''
	Else If  @FieldID <> 'Serial'
		Set @strSQL ='
			Select 
			CT4001. '+@FieldID +' as GroupID,
			CV2222.'+left(@FieldID, len(@FieldID) - 2) +'name as GruopName,
			CT4000.WMfileID,
			CT4000.WMfileName,
			CT4000.ObjectID,
			isnull (CT4000.ObjectName,AT1202.ObjectName) as ObjectName,
			ContractNo,
			Topay,
			CT4001.StartDate,
			CT4001.EndDate,
			SupContractNo,
			SupStartDate,
			SupEndDate,
			CT4000.Tranmonth,
			CT4000.TranYear,
			CT4000.DivisionID
	
		From CT4000
			    Inner join 	CT4001 on CT4001.WMfileID =CT4000.WMfileID and CT4001.DivisionID =CT4000.DivisionID
			    Left Join  AT1202 on AT1202.ObjectID = CT4000.ObjectID and AT1202.DivisionID = CT4000.DivisionID
			    Left Join  CV2222 on CV2222. '+@FieldID +' = CT4001. '+@FieldID +' and CV2222.DivisionID = CT4000.DivisionID
		Where CT4000. Disabled  = 0   '+@sPeriod +' AND CT4000.DivisionID = '''+@DivisionID+''''
	Else If  @FieldID = 'Serial'
		Set @strSQL ='
			Select distinct
			CT4001.Serial as GroupID,
			CV2222.SerialName as GruopName,
			CT4000.WMfileID,
			CT4000.WMfileName,
			CT4000.ObjectID,
			isnull (CT4000.ObjectName,AT1202.ObjectName) as ObjectName,
			CT4000.ContractNo,
			CT4000.Topay,
			CT4000.StartDate,
			CT4000.EndDate,
			CT4000.SupContractNo,
			CT4000.SupStartDate,
			CT4000.SupEndDate,
			CT4000.Tranmonth,
			CT4000.TranYear,
			CT4000.DivisionID
	
		From CT4000
			    Inner  Join  CT4001 on CT4001.WMfileID = CT4000.WMfileID and CT4001.DivisionID = CT4000.DivisionID	
			    Left Join  AT1202 on AT1202.ObjectID = CT4000.ObjectID and AT1202.DivisionID = CT4000.DivisionID
			    Left Join  CV2222 on CV2222.Serial = CT4001.Serial and CV2222.DivisionID = CT4001.DivisionID		
		Where CT4000. Disabled  = 0   '+@sPeriod +' AND CT4000.DivisionID = '''+@DivisionID+''''

  End
Else
  Begin

    Set @strSQL =' Select 
	CT4002.'+@FieldID +' as GroupID,
	CV2222.'+left(@FieldID, len(@FieldID) - 2) +'name as GruopName,
	CT4000.WMfileID,
	WMfileName,
	CT4000.ObjectID,
	isnull (CT4000.ObjectName,AT1202.ObjectName) as ObjectName,
	ContractNo,
	Topay,
	StartDate,
	CT4000.EndDate,
	SupContractNo,
	SupStartDate,
	SupEndDate  ,
	RequestNo, 
	CaseID,
	TaskID,
	VoucherNo,
	FixDate,
	CT4002.InventoryID,
	InventoryName,
	Serial,
	Repair,
	Finish,
	CV1001.DesCription as FinishName,
	CT4002.EmployeeID,
	AT1103.FullName,
	CT4002.Tranmonth,
	CT4002.TranYear,
	CT4002.DivisionID
From CT4002

    Left Join CT4000 on CT4000.WMFileID = CT4002.WMFileID and CT4000.DivisionID = CT4002.DivisionID
     Left Join  AT1202 on AT1202.ObjectID = CT4000.ObjectID and AT1202.DivisionID = CT4000.DivisionID		
  inner  Join  CV2222 on CV2222.'+@FieldID +' = Ct4002.'+@FieldID +' and CV2222.DivisionID = CT4000.DivisionID
Left join AT1302 on AT1302.InventoryID = CT4002.InventoryID	and AT1302.DivisionID = CT4002.DivisionID	
    Left join CV1001 on CV1001.Status = CT4002.Finish and CV1001.DivisionID = CT4002.DivisionID
			and TypeID =''SD''
    Left join AT1103 on AT1103.EmployeeID = CT4002.EmployeeID
			and AT1103.DIvisionID =	CT4002.DivisionID
Where Ct4002.DivisionID = '''+@DivisionID +'''  '+@sPeriod +' AND CT4000.DivisionID = '''+@DivisionID+''''
 End

--Print @strSQL

If not exists (Select name from sysObjects Where id = Object_ID(N'[dbo].[CV4014]') and OBJECTPROPERTY(id,N'IsView')=1)
	Exec (' Create View CV4014 as ' + @strSQL)
Else
	Exec (' Alter  View CV4014 as ' + @strSQL)