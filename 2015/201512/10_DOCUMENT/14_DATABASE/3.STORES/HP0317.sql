IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP0317]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP0317]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- <Summary>
---- Đổ nguồn tờ khai BHXH, BHYT
---- Create on 10/09/2013 by Khanh Van
CREATE PROCEDURE [dbo].[HP0317]
( 
	@DivisionID as nvarchar(50),
	@TranMonth as int,
	@TranYear AS int
) 
AS 


Select HT0305.EmployeeID, FullName, DepartmentName, Birthday, FullAddress, HomePhone, HT0305.CreateDate 
From HV1400 inner join HT0305 on HV1400.DivisionID = HT0305.DivisionID and HV1400.EmployeeID = HT0305.EmployeeID
Where TranMonth = @TranMonth and TranYear = @TranYear and HT0305.DivisionID = @DivisionID

GO
--Exec HP0304 'TH',7,2013

