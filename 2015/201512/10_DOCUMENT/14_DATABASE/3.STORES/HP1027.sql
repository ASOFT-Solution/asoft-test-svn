/****** Object:  StoredProcedure [dbo].[HP1027]    Script Date: 07/29/2010 13:50:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

-- Create by: Dang Le Bao Quynh; Date: 15/10/2007
-- Purpose: Ke thua bang phan ca
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [30/07/2010]
'**************************************************************/
ALTER PROCEDURE [dbo].[HP1027]	@STranMonth int, 
				@STranYear int, 
				@DTranMonth int, 
				@DTranYear int, 
				@DivisionID nvarchar(50), 
				@DepartmentID nvarchar(50), 
				@TeamID nvarchar(50), 
				@EmployeeID nvarchar(50),
				@UserID nvarchar(50)

AS

DECLARE	@TransactionID nvarchar(50),
		@sEmployeeID nvarchar(50),
		@D01 nvarchar(50),
		@D02 nvarchar(50),
		@D03 nvarchar(50),
		@D04 nvarchar(50),
		@D05 nvarchar(50),
		@D06 nvarchar(50),
		@D07 nvarchar(50),
		@D08 nvarchar(50),
		@D09 nvarchar(50),
		@D10 nvarchar(50),
		@D11 nvarchar(50),
		@D12 nvarchar(50),
		@D13 nvarchar(50),
		@D14 nvarchar(50),
		@D15 nvarchar(50),
		@D16 nvarchar(50),
		@D17 nvarchar(50),
		@D18 nvarchar(50),
		@D19 nvarchar(50),
		@D20 nvarchar(50),
		@D21 nvarchar(50),
		@D22 nvarchar(50),
		@D23 nvarchar(50),
		@D24 nvarchar(50),
		@D25 nvarchar(50),
		@D26 nvarchar(50),
		@D27 nvarchar(50),
		@D28 nvarchar(50),
		@D29 nvarchar(50),
		@D30 nvarchar(50),
		@D31 nvarchar(50),
		@Notes nvarchar(254),
		@curHT1025 cursor

Set @curHT1025 = Cursor Static For

Select EmployeeID, D01, D02, D03, D04, D05, D06, D07, D08, D09, D10, D11, D12, D13, D14, D15, D16, D17, D18, D19, D20, D21, D22, D23, D24, D25, D26, D27, D28, D29, D30, D31, Notes
From HT1025 HT10
Where 	DivisionID = @DivisionID And
	HT10.EmployeeID Like @EmployeeID And 
	HT10.EmployeeID In 
		(Select EmployeeID From HT2400 
		Where 	DivisionID  = @DivisionID And DepartmentID Like @DepartmentID And 
			isnull(TeamID,'') Like @TeamID And TranMonth = @DTranMonth And TranYear = @DTranYear) And
	HT10.TranMonth = @STranMonth And 
	HT10.TranYear = @STranYear

Open @curHT1025

Fetch Next From @curHT1025 Into @sEmployeeID, @D01, @D02, @D03, @D04, @D05, @D06, @D07, @D08, @D09, @D10, @D11, @D12, @D13, @D14, @D15, @D16, @D17, @D18, @D19, @D20, @D21, @D22, @D23, @D24, @D25, @D26, @D27, @D28, @D29, @D30, @D31, @Notes
While @@Fetch_Status = 0
Begin
	Exec AP0000  @DivisionID, @TransactionID  OUTPUT, 'HT1025', 'SD', @DTranYear, '', 15, 3, 0, ''
	INSERT INTO HT1025(TransactionID, DivisionID, EmployeeID, TranMonth, TranYear, D01, D02, D03, D04, D05, D06, D07, D08, D09, D10, D11, D12, D13, D14, D15, D16, D17, D18, D19, D20, D21, D22, D23, D24, D25, D26, D27, D28, D29, D30, D31, Notes, CreateUserID, CreateDate, LastModifyUserID, LastModifyDate)
	VALUES (@TransactionID, @DivisionID, @sEmployeeID, @DTranMonth, @DTranYear, @D01, @D02, @D03, @D04, @D05, @D06, @D07, @D08, @D09, @D10, @D11, @D12, @D13, @D14, @D15, @D16, @D17, @D18, @D19, @D20, @D21, @D22, @D23, @D24, @D25, @D26, @D27, @D28, @D29, @D30, @D31, @Notes, @UserID, getDate(), @UserID, getDate())
	Fetch Next From @curHT1025 Into @sEmployeeID, @D01, @D02, @D03, @D04, @D05, @D06, @D07, @D08, @D09, @D10, @D11, @D12, @D13, @D14, @D15, @D16, @D17, @D18, @D19, @D20, @D21, @D22, @D23, @D24, @D25, @D26, @D27, @D28, @D29, @D30, @D31, @Notes
End
Close @curHT1025
Deallocate @curHT1025