IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP2521]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP2521]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






--- date 7/5/2005
--- purpose : In bao cao tam ung
--- Edit by: Dang Le Bao Quynh; Date: 30/01/2007
--- Purpose: Sua lai chuoi @sSQL
--- Updated by Van Nhan, them dieu kien and H5.DepartmentID = HT1101.DepartmentID  va chi ro tuong minh: HT1101.TeamName, '
--- Edit by : Dang Le Bao Quynh; Date: 30/01/2008
--- Purpose: Bo sung cac truong BankId, BankName, BankAccountNo
CREATE PROCEDURE HP2521 @DivisionID varchar(20),
				@FromDepartmentID varchar(20),
				@ToDepartmentID varchar(20),
				@TeamID varchar(20),
				@FromEmployeeID varchar(20), 
				@ToEmployeeID varchar(20), 
				@FromYear int,
				@FromMonth int,				
				@ToYear int,
				@ToMonth int			
							
AS
declare	@sSQL  varchar(8000)


set @sSQL='Select H5.AdvanceID, H5.DivisionID, H5.DepartmentID, AT1102.DepartmentName, H5.TeamID, HT1101.TeamName, H5.EmployeeID, HV4.FullName,
		H5.TranMonth, H5.TranYear, H5.AdvanceDate, H5.AdvanceAmount, H5.Description, HV4.BankID, HT1008.BankName, HV4.BankAccountNo,
		isnull((Select sum(OriginalAmount) 
		from AT9000 where DivisionID = '''+@DivisionID+''' And TransactionTypeID in(''T02'',''T22'') And ReVoucherID = H5.AdvanceID),0) as PaidAmount,
		(H5.AdvanceAmount - isnull((Select sum(OriginalAmount) from AT9000 where DivisionID = '''+@DivisionID+''' And TransactionTypeID in(''T02'',''T22'') And ReVoucherID = H5.AdvanceID),0)) as RemainAmount
		,HV4.DutyID, HV4.BaseSalary, HV4.IdentifyCardNo
		From HT2500 H5 left join HV1400 HV4 on H5.DivisionID=HV4.DivisionID and H5.EmployeeID=HV4.EmployeeID
		left join HT1008 on HV4.BankID = HT1008.BankID and HV4.DivisionID = HT1008.DivisionID 
		left join AT1102 on H5.DepartmentID=AT1102.DepartmentID and H5.DivisionID=AT1102.DivisionID 
		left join HT1101 on H5.DivisionID=HT1101.DivisionID and H5.TeamID=HT1101.TeamID and
					H5.DepartmentID = HT1101.DepartmentID '
Set @sSQL=@sSQL+ '  Where H5.DivisionID = ''' + @DivisionID + ''' and
		H5.DepartmentID between ''' + @FromDepartmentID + ''' and ''' + @ToDepartmentID + ''' and
		isnull(H5.TeamID,'''') like ''' + ISNULL(@TeamID, '')  + ''' and
		H5.EmployeeID between ''' + @FromEmployeeID + ''' and ''' + @ToEmployeeID + ''' and
		H5.TranMonth + 100*H5.TranYear between '+str(@FromMonth)+'+100*'+str(@FromYear)+' and '+str(@ToMonth)+'+100*'+str(@ToYear)+ ' 		
		Group by  H5.AdvanceID, H5.DivisionID, H5.DepartmentID, AT1102.DepartmentName,H5.TeamID, HT1101.TeamName,H5.EmployeeID, HV4.FullName,
		H5.TranMonth, H5.TranYear, H5.AdvanceDate, H5. AdvanceAmount,H5.Description, HV4.BankID, HT1008.BankName, HV4.BankAccountNo,HV4.DutyID, HV4.BaseSalary, HV4.IdentifyCardNo '

---print @sSQL
 If  exists (Select 1 From sysObjects Where XType = 'V' and Name = 'HV2521')
	Drop view HV2521
exec('Create view HV2521 -----created by HP2521
	as  ' + @sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

