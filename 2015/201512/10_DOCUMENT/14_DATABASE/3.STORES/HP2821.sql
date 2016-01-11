IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2821]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2821]
GO
/****** Object:  StoredProcedure [dbo].[HP2821]    Script Date: 09/29/2011 17:23:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO
--Created by Nguyen Lam Hoa
--Xoa du lieu  muc luong  duoc tinh dua vao muc luong khac
--Date 1/8/2005

/**********************************************
** Edited by: [GS] [Cẩm Loan] [02/08/2010]
***********************************************/

CREATE PROCEDURE [dbo].[HP2821]  @DivisionID as nvarchar(50),
				@SalaryCondID as nvarchar(50),
				@TranMonth as tinyint,
				@TranYear as smallint,
				@Mode as tinyint-- 0 xoa tu ho so nhan su; 1 xoa tu  ho so luong thang	
As 
Declare 
			@sSQL as nvarchar(4000),
			@ParaBased as nvarchar(50),
			@ParaCal as nvarchar(50),
			@IsPercent as tinyint
			

Select  @ParaBased =  ParameterBased, @ParaCal= ParameterCal , @IsPercent =IsPercent From HT2820 Where SalaryCondID= @SalaryCondID

If @Mode=0 
	Begin
		Set @sSQL='Update HT1403 set ' +@ParaCal+'  = HV.ParameterCalOld
				From HT1403 HT left join HT2822 HV on HT.EmployeeID=HV.EmployeeID and HT.DivisionID=HV.DivisionID
				Where HT.DivisionID='''+ @DivisionID+''' and HV.TableID=''HT1403'' and SalaryCondID='''+ @SalaryCondID+ ''' '
		Exec (@sSQL)
		Delete HT2822 Where SalaryCondID=@SalaryCondID and TableID='HT1403' and DivisionID = @DivisionID
	End
Else 

	Begin	
		Set @sSQL='Update HT2400 set ' +@ParaCal+'  = HV.ParameterCalOld
			From HT2400 HT left join HT2822 HV on HT.EmployeeID=HV.EmployeeID and HT.DivisionID=HV.DivisionID
			Where HT.DivisionID='''+ @DivisionID+''' and HV.TableID=''HT2400'' and SalaryCondID='''+ @SalaryCondID+ ''' and 
			HT. TranMonth= ' + str(@TranMonth) + ' and HT. TranYear= ' + str(@TranYear) + ' '
		Exec (@sSQL)
		Delete HT2822 Where SalaryCondID=@SalaryCondID and TableID='HT2400' And DivisionID= @DivisionID
	End
	
GO


