/****** Object:  StoredProcedure [dbo].[CP3003]    Script Date: 07/30/2010 10:25:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

---Created by:Nguyen  Thi Thuy Tuyen  , date:  29/01/2006
---Purpose: In bao cao Tong hop 

/********************************************
'* Edited by: [GS] [Thanh Trẫm] [30/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[CP3003] @DivisionID nvarchar(50),
				@IsDate tinyint,
				@FromMonth int,
				@FromYear int,
				@ToMonth int,
				@ToYear int,	
				@FromDate datetime,
				@ToDate datetime,
				@FromObject nvarchar(50),
				@ToObject nvarchar(50),
				@Status int				
AS
DECLARE 
	@sSQL nvarchar(4000),
	@sPeriod nvarchar(4000)

Set @sPeriod = case when @IsDate = 1 then ' and  CT4002.FixDate  between''' + convert(nvarchar(50), @FromDate,101) + '''  and  ''' + 
		convert(nvarchar(50),  @ToDate, 101) + ''''   else 
		' and CT4002.TranMonth + CT4002.TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as nvarchar(50)) + ' and ' +
		cast(@ToMonth + @ToYear*100 as nvarchar(50))  end

Set @sSQL = '
Select
	CT4002.TransactionID, 
	CT4002.VoucherNo, 
	CT4002.TranMonth,CT4002.TranYear, 
	CT4002.DivisionID, 
	CT4002.ReVoucherID,CT4002.RequestNo, 
	CT4002.Finish,CV1001.Description as FinishName,
	CT4002.WMFileID, 
	CT4000.WMFileName,
	CT4002.CaseID,CT4002.TaskID, 
	CT4002.InventoryID, 
	AT1302.InventoryName,
	CT4002.Serial, CT4002.UnitID, 
	CT4002.EmployeeID, 
	CT4002.ErrorStatusID, 
	CT4002.ErrorLevelID, CT2002.ErrorLevelName,
	CT4002.ErrorTypeID, 
	CT4002.FileLog, 
	CT4002.ErrorIssueID, 
	CT4002.Repair, 
	CT4002.Signature01, 
	CT4002.IsTest, 
	CT4002.StartTime, 
	CT4002.EndTime, 
	CT4002.MonitorTime, 
	CT4002.FixNextDate, 
	CT4002.Signature02, 
	CT4002.Notes01,CT4002.Notes02, CT4002.Notes03, CT4002.Notes04, CT4002.Notes05, 
	CT4002.IsReplace,CT4002.TimelinessID, 
	CT4002.MannerID, 
	CT4002.QualityID,
	 CT4002.FixDate ,
	CT4000.CObjectID,
	AT1202.ObjectName as CObjectName,
	isnull (CT4000.Contact,AT1202.Contactor) as Contact,
	CT4000.ContractNo,
	CT1002.ServiceLevelName

	
From CT4002 inner join CV3004 on CV3004.CaseID = CT4002.CaseID and CV3004.DivisionID = CT4002.DivisionID
			and CT4002.Fixdate = CV3004.FixDate
	left join CT4000 on CT4000.WMFileID = CT4002.WMFileID and CT4000.DivisionID = CT4002.DivisionID
	left join CT2002 on CT2002.ErrorLevelID = CT4002.ErrorLevelID and CT2002.DivisionID = CT4002.DivisionID
	Inner join AT1202 on AT1202.ObjectID = CT4000.CObjectID and AT1202.DivisionID = CT4000.DivisionID
	left join CT1002 on CT1002.ServiceLevelID = CT4000.ServiceLevelID and CT1002.DivisionID = CT4000.DivisionID
	inner join CV1001 on CV1001.Status = CT4002.Finish and CV1001.DivisionID = CT4002.DivisionID
				and CV1001.TypeID =''SD''
	Inner join AT1302 on AT1302.InventoryID = CT4002.InventoryID and AT1302.DivisionID = CT4002.DivisionID
Where CT4002.DivisionID like ''' + @DivisionID + ''' and 
	CT4000.ObjectID between ''' + @FromObject + ''' and ''' + @ToObject + ''' and 
	CT4002.Finish  like '  + case when @Status = - 1 then '''%''' else cast(@Status as nvarchar(1))  end + @sPeriod 


IF exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'CV3003')
	DROP VIEW CV3003

EXEC('Create view CV3003 --tao boi CP3003
		as ' + @sSQL)