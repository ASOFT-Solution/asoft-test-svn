/****** Object:  StoredProcedure [dbo].[HP2407]    Script Date: 07/30/2010 16:22:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


---Created by: Dang Le Bao Quynh; Date 05/10/2007
---purpose: Xoa quet the 

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [30/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[HP2407] @DivisionID nvarchar(50),
				@DepartmentID nvarchar(50),
				@EmployeeID nvarchar(50),
				@TransactionID nvarchar(50),
				@TranMonth int,
				@TranYear int,
				@FromDate datetime,
				@ToDate datetime
 AS
Delete HT2407 
From HT2407 T00 inner join HT2400 T01 on T00.EmployeeID = T01.EmployeeID 
and T00.TranMonth = T01.Tranmonth  
and T00.TranYear = T01.TranYear
and T00.DivisionID = T01.DivisionID 
Where  T00.DivisionID = @DivisionID and 
	T01.DepartmentID like @DepartmentID and
	T00.EmployeeID like @EmployeeID and
	T00.TransactionID like @TransactionID and
	T00.TranMonth = @TranMonth and
	T00.TranYear = @TranYear and
	T00.AbsentDate between @FromDate and @ToDate