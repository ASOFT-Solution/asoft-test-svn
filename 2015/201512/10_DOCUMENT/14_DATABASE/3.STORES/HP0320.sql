IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP0320]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP0320]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- <Summary>
---- Đổ nguồn danh mục khai báo tăng giảm BHXH, BHYT
---- Create on 23/10/2013 by Khanh Van
CREATE PROCEDURE [dbo].[HP0320]
( 
	@DivisionID as nvarchar(50),
	@TranMonth as int,
	@TranYear AS int
) 
AS 


Select HT0321.EmployeeID, FullName, DepartmentName, Birthday, FullAddress, HomePhone, HT0321.Status, HT0321.StatusName, HT0321.CreateDate 
From HV1400 inner join HT0321 on HV1400.DivisionID = HT0321.DivisionID and HV1400.EmployeeID = HT0321.EmployeeID
Where TranMonth = @TranMonth and TranYear = @TranYear and HT0321.DivisionID = @DivisionID

GO
--Exec HP0320 'TH',7,2013

