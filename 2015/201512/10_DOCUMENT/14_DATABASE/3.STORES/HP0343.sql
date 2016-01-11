IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0343]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0343]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- Created by Bảo Anh	Date: 09/10/2013
--- Purpose: In danh sách đề nghị cấp sổ BHXH, thẻ BHYT (mẫu A01a-TS)
--- EXEC HP0343 'AS',4,2012

CREATE PROCEDURE [dbo].[HP0343]
				@DivisionID nvarchar(50),
				@TranMonth as int,
				@TranYear AS int		
AS
	
Declare @SQL nvarchar(max)

SET @SQL = N'SELECT * FROM (
			Select V00.EmployeeID, V00.FullName, V00.SoInsuranceNo, V00.Birthday, V00.IsMale, V00.EthnicID, V00.EthnicName,
			V00.IdentifyCardNo, V00.IdentifyDate, V00.IdentifyCityID, V00.FullAddress, V00.HospitalID,
			(Select top 1 Notes From HT2460 Where DivisionID = V00.DivisionID And EmployeeID = V00.EmployeeID
							And Isnull(SNo,'''') = Isnull(V00.SoInsuranceNo,'''')) as InBenefit
			From HV1400 V00
			Where V00.DivisionID = ''' + @DivisionID + '''
			And V00.EmployeeID in (Select EmployeeID From HT0321 Where DivisionID = ''' + @DivisionID + '''
									And TranMonth = ' + ltrim(@TranMonth) + ' And TranYear = ' + ltrim(@TranYear) + ' And Status = 1)
			And Isnull(V00.SoInsuranceNo,'''') <> ''''

			UNION
			Select V00.EmployeeID, V00.FullName, V00.SoInsuranceNo, V00.Birthday, V00.IsMale, V00.EthnicID, V00.EthnicName,
					V00.IdentifyCardNo, V00.IdentifyDate, V00.IdentifyCityID, V00.FullAddress, V00.HospitalID,
					(Select top 1 Notes From HT2460 Where DivisionID = V00.DivisionID And EmployeeID = V00.EmployeeID
								And SNo = V00.SoInsuranceNo) as InBenefit
			From HV1400 V00			
			Where V00.DivisionID = ''' + @DivisionID + '''
			And V00.EmployeeID in (Select EmployeeID From HT0321 Where DivisionID = ''' + @DivisionID + '''
									And TranMonth = ' + ltrim(@TranMonth) + ' And TranYear = ' + ltrim(@TranYear) + ' And Status = 1)
			And Isnull(V00.SoInsuranceNo,'''') = ''''
			
			) A Order by Isnull(SoInsuranceNo,''99999999999999'')'	

EXEC(@SQL)