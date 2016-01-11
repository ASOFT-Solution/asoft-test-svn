IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP0338]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP0338]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- <Summary>
---- Đổ nguồn danh mục khai bao thuế TNCN
---- Create on 17/12/2013 by Khanh Van
CREATE PROCEDURE [dbo].[HP0338]
( 
	@DivisionID as nvarchar(50),
	@TranMonth as int,
	@TranYear AS int
) 
AS 


Select HT0338.*, HV1400.DutyName, FullName, DepartmentName, Birthday, isMale, HV1400.IdentifyCardNo, FullAddress, HomePhone, PersonalTaxID, Income01,Income02,Income03,Income04,Income05,Income06,Income07,Income08,Income09,Income10,Income11,Income12,Income13,Income14,Income15,Income16,Income17,Income18,Income19,Income20,Income21,Income22,Income23,Income24,Income25,Income26,Income27,Income28,Income29,Income30,SubAmount01,SubAmount02,SubAmount03,SubAmount04,SubAmount05,SubAmount06,SubAmount07,SubAmount08,SubAmount09,SubAmount10,SubAmount11,SubAmount12,SubAmount13,SubAmount14,SubAmount15,SubAmount16,SubAmount17,SubAmount18,SubAmount19,SubAmount20

From HT0338  
inner join HV1400 on HV1400.DivisionID = HT0338.DivisionID and HV1400.EmployeeID = HT0338.EmployeeID
inner join HT0341 on HT0338.DivisionID = HT0341.DivisionID and HT0338.TransactionID = HT0341.TransactionID and HT0341.EmployeeID=HT0338.EmployeeID 

Where HT0338.TranMonth = @TranMonth 
		and HT0338.TranYear = @TranYear 
		and HT0338.DivisionID = @DivisionID 



GO
