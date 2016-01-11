/****** Object:  StoredProcedure [dbo].[HP1407]    Script Date: 07/29/2010 14:41:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

--Create by: Dang Le Bao Quynh; Date: 05/10/2007
--Purpose: kiem tra tinh hop le cua mot ma the quet
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [30/07/2010]
'**************************************************************/
ALTER PROCEDURE [dbo].[HP1407] 		@DivisionID nvarchar(50),
					@AbsentCardID nvarchar(50),
					@AbsentCardNo nvarchar(50),
					@BeginDate Datetime,
					@EndDate Datetime

AS

DECLARE 
		@Status tinyint,
		@EmployeeID nvarchar(50),
		@BDate datetime,
		@EDate datetime
Set @Status = 0
	--Neu ngay ket thuc la rong, dat nay ket thuc la max
	If @EndDate is null
		Begin
			Set @EndDate = '12/31/9999'		
		End

	Select Top 1 @EmployeeID = EmployeeID, @BDate = BeginDate, @EDate = isnull(EndDate,'12/31/9999') From HT1407 
	Where DivisionID = @DivisionID
		And AbsentCardID <> @AbsentCardID
		And AbsentCardNo = @AbsentCardNo 
		And EmployeeID In (Select EmployeeID From HT1400 Where DivisionID = @DivisionID)
		And @BeginDate<=isnull(EndDate,'12/31/9999') And @EndDate >= BeginDate
		
	If @EmployeeID is not null
		Begin
			Set @Status = 1
		End				
Select @Status As Status, @EmployeeID As EmployeeID, @BDate As BeginDate, @EDate As EndDate