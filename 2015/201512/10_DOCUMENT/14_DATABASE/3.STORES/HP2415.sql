/****** Object:  StoredProcedure [dbo].[HP2415]    Script Date: 08/02/2010 15:14:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---Created by : Vo Thanh Huong
---Created date: 09/06/2004
---purpose: Xoa luong san pham
/********************************************
'* Edited by: [GS] [Thành Nguyên] [02/08/2010]
'********************************************/
 
ALTER PROCEDURE [dbo].[HP2415] 	 @DivisionID as nvarchar(50),
		@DepartmentID as nvarchar(50),
		@TranMonth as int,
		@TranYear as int

AS

Delete HT3401 Where	DivisionID = @DivisionID and
			DepartmentID like @DepartmentID and
			TranMonth = @TranMonth and
			TranYear = @TranYear
GO
