IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP5000]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP5000]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----- Created by Nguyen Van Nhan, Date 26/04/2004.
----- Purpose: Tinh Luong thang

-----Edited by: Vo Thanh Huong
-----Edited date: 19/08/2004
-----purpose: Tính các kho?n gi?m tr? luong

-----Edited by: Dang Le Bao Quynh
-----Purpose: Thay doi sap xep theo truong MethodID tu bang HT5005,HT5006 phuc vu cho tinh khoan thu nhap tong hop
-----Edit by: Dang Le Bao Quynh; Date:17/07/2006
-----Purpose: Bo sung tinh luong san pham theo phuong phap phan bo
-----Dang Le Bao Quynh; Date: 08/12/2006
-----Purpose: Loc danh sach tinh luong theo chi dinh chi tiet cua phuong phap tinh luong.
--Edit by: Dang Le Bao Quynh; 27/03/2013: Toi uu lai cau lenh, sinh TransactionID bang NewID()	
--Edit by: Dang Le Bao Quynh; 28/03/2013: Xoa tinh luong cong trinh	
---- Modified on 13/11/2013 by Le Thi Thu Hien : Bo sung HP5014
----- Modified on 25/03/2015 by Lê Thị Hạnh: update Salary02: Doanh số bình quân tháng, tính ngày công nghỉ việc [CustomizeIndex: 36 - SGPT]
-- <Example>
---- 

CREATE PROCEDURE 	[dbo].[HP5000] 	
					@DivisionID as nvarchar(50),   		---- Don vi tinh luong
					@TranMonth as int, 			---- Ky tinh luong
					@TranYear as int,			---- Nam tinh luong
					@PayrollMethodID as nvarchar(50),	---- PP tinh luong	
					@VoucherDate as Datetime,		---- ngay tinh luong
					@UserID as nvarchar(50),			---- Nguoi tinh luong
					@DepartmentID1 as nvarchar(50),
					@TeamID1 as nvarchar(50),
					@SalaryAmount as decimal(28,8) = 0
						
AS
	Declare @sSQL as nvarchar(4000),
		@IncomeID as nvarchar(50), 
		@SubID as nvarchar(50), 
		@MethodID as nvarchar(50),  
		@BaseSalaryField as nvarchar(50),  
		@BaseSalary as decimal(28,8),
		@GeneralCoID as nvarchar(50),  
		@GeneralAbsentID as nvarchar(50),  
		@SalaryTotal as decimal(28,8),  
		@AbsentAmount decimal(28,8),
		@Orders as tinyint,
		@HT5005_cur as cursor,
		@HT5006_cur1 as cursor,
		@HT5006_cur2 as cursor,
		@TransactionID as nvarchar(50),
		@HT3400_cur as cursor,
		@EmployeeID as nvarchar(50), 
		@DepartmentID  as nvarchar(50),  
		@TeamID as nvarchar(50) ,
		@CYear as nvarchar(50),
		@IsIncome tinyint, ----1: thu nh?p, 0: các kho?n gi?m tr?
		@SourceFieldName nvarchar(100),
		@IsOtherDayPerMonth as tinyint,
		@SourceTableName nvarchar(50),
		@CurrencyID as nvarchar(50),
		@ExchangeRate decimal(28,8)

----------->>>> Kiem tra customize
Declare @AP4444 Table(CustomerName Int, Export Int)
Declare @CustomerName AS Int
Insert Into @AP4444(CustomerName,Export) EXEC('AP4444')
Select @CustomerName=CustomerName From @AP4444
-----------<<<< Kiem tra customize

Set Nocount on
Set  @CYear = LTRIM(str(@TranYear))

--Xoa tinh luong cong trinh
Delete HT340001 Where TransactionID In 
(Select APK From HT3400 
Where 	DivisionID = @DivisionID and
		TranMonth =@TranMonth and 
		TranYear = @TranYear and
		DepartmentID like @DepartmentID1 and
		IsNull(TeamID,'') like IsNull(@TeamID1,'') and
		PayrollMethodID =@PayrollMethodID)
		
Delete HT3400 Where DivisionID = @DivisionID and
		TranMonth =@TranMonth and 
		TranYear = @TranYear and
		DepartmentID like @DepartmentID1 and
		IsNull(TeamID,'') like IsNull(@TeamID1,'') and
		PayrollMethodID =@PayrollMethodID

DELETE HT3404 Where DivisionID = @DivisionID and
		TranMonth =@TranMonth and 
		TranYear = @TranYear and
		DepartmentID like @DepartmentID1 and
		IsNull(TeamID,'') like IsNull(@TeamID1,'') and
		PayrollMethodID =@PayrollMethodID	 
		
--------->>>>>Edit by: Dang Le Bao Quynh; 27/02/2013: Toi uu lai cau lenh, sinh TransactionID bang NewID()	
----------->>>>>> Customize Cảng sài gòn
IF @CustomerName = 19 AND (@PayrollMethodID LIKE 'PPLKH%' OR @PayrollMethodID LIKE 'PPLSP%')		--- Cảng sài gòn
	BEGIN
	IF @PayrollMethodID LIKE 'PPLKH%' --- Nếu là lương khoán chỉ hiển thị những người được check lương khoán
		BEGIN
			Insert Into HT3400 (TransactionID,EmployeeID, DivisionID, DepartmentID,TeamID, TranMonth ,  TranYear, PayrollMethodID,
				CreateUserID, CreateDate, LastModifyUserID, LastModifyDate, IsOtherDayPerMonth)
			Select NewID(), HT2400.EmployeeID, @DivisionID, HT2400.DepartmentID, HT2400.TeamID, @TranMonth, @TranYear, @PayrollMethodID, 
							@UserID, getdate(),@UserID, getdate(), HT2400.IsOtherDayPerMonth
			From HT2400
			Left Join HT3400 On
				HT2400.DivisionID = HT3400.DivisionID And
				HT2400.TranYear = HT3400.TranYear And
				HT2400.Tranmonth = HT3400.Tranmonth And
				HT2400.DepartmentID = HT3400.DepartmentID And
				Isnull(HT2400.TeamID,'') = isnull(HT3400.TeamID,'') And
				HT2400.EmployeeID = HT3400.EmployeeID And isnull(HT3400.PayrollMethodID,'') = @PayrollMethodID 
			Where 	HT2400.DivisionID =@DivisionID and  HT2400.TranMonth = @TranMonth and HT2400.TranYear =@TranYear and
					HT2400.DepartmentID like @DepartmentID1 and
					IsNull(HT2400.TeamID,'') like IsNull(@TeamID1,'') and
					(HT2400.DepartmentID In (Select DepartmentID From HT5004 Where PayrollMethodID = @PayrollMethodID And IsDetail = 0  And DivisionID = @DivisionID)
	 				Or HT2400.EmployeeID In (Select EmployeeID From HT5040 Where PayrollMethodID = @PayrollMethodID  And DivisionID = @DivisionID))
	 				And HT3400.DivisionID Is NULL
	 				AND HT2400.IsJobWage = 1
		END
	IF @PayrollMethodID LIKE 'PPLSP%' --- Nếu là lương sản phẩm chỉ hiển thị những người được check lương sản phẩm
		BEGIN
			Insert Into HT3400 (TransactionID,EmployeeID, DivisionID, DepartmentID,TeamID, TranMonth ,  TranYear, PayrollMethodID,
							CreateUserID, CreateDate, LastModifyUserID, LastModifyDate, IsOtherDayPerMonth)
			Select NewID(), HT2400.EmployeeID, @DivisionID, HT2400.DepartmentID, HT2400.TeamID, @TranMonth, @TranYear, @PayrollMethodID, 
							@UserID, getdate(),@UserID, getdate(), HT2400.IsOtherDayPerMonth
			From HT2400
			Left Join HT3400 On
				HT2400.DivisionID = HT3400.DivisionID And
				HT2400.TranYear = HT3400.TranYear And
				HT2400.Tranmonth = HT3400.Tranmonth And
				HT2400.DepartmentID = HT3400.DepartmentID And
				Isnull(HT2400.TeamID,'') = isnull(HT3400.TeamID,'') And
				HT2400.EmployeeID = HT3400.EmployeeID And isnull(HT3400.PayrollMethodID,'') = @PayrollMethodID 
			Where 	HT2400.DivisionID =@DivisionID and  HT2400.TranMonth = @TranMonth and HT2400.TranYear =@TranYear and
					HT2400.DepartmentID like @DepartmentID1 and
					IsNull(HT2400.TeamID,'') like IsNull(@TeamID1,'') and
					(HT2400.DepartmentID In (Select DepartmentID From HT5004 Where PayrollMethodID = @PayrollMethodID And IsDetail = 0  And DivisionID = @DivisionID)
	 				Or HT2400.EmployeeID In (Select EmployeeID From HT5040 Where PayrollMethodID = @PayrollMethodID  And DivisionID = @DivisionID))
	 				And HT3400.DivisionID Is NULL
	 				AND HT2400.IsPiecework = 1
		END
	END
-----------<<<<< Customize Cảng sài gòn	
ELSE 	
	BEGIN
	Insert Into HT3400 (TransactionID,EmployeeID, DivisionID, DepartmentID,TeamID, TranMonth ,  TranYear, PayrollMethodID,
				CreateUserID, CreateDate, LastModifyUserID, LastModifyDate, IsOtherDayPerMonth)
	Select NewID(), HT2400.EmployeeID, @DivisionID, HT2400.DepartmentID, HT2400.TeamID, @TranMonth, @TranYear, @PayrollMethodID, 
					@UserID, getdate(),@UserID, getdate(), HT2400.IsOtherDayPerMonth
	From HT2400
	Left Join HT3400 On
		HT2400.DivisionID = HT3400.DivisionID And
		HT2400.TranYear = HT3400.TranYear And
		HT2400.Tranmonth = HT3400.Tranmonth And
		HT2400.DepartmentID = HT3400.DepartmentID And
		Isnull(HT2400.TeamID,'') = isnull(HT3400.TeamID,'') And
		HT2400.EmployeeID = HT3400.EmployeeID And isnull(HT3400.PayrollMethodID,'') = @PayrollMethodID 
	Where 	HT2400.DivisionID =@DivisionID and  HT2400.TranMonth = @TranMonth and HT2400.TranYear =@TranYear and
			HT2400.DepartmentID like @DepartmentID1 and
			IsNull(HT2400.TeamID,'') like IsNull(@TeamID1,'') and
			(HT2400.DepartmentID In (Select DepartmentID From HT5004 Where DivisionID = @DivisionID And PayrollMethodID = @PayrollMethodID And IsDetail = 0)
 			Or HT2400.EmployeeID In (Select EmployeeID From HT5040 Where DivisionID = @DivisionID And PayrollMethodID = @PayrollMethodID))
 			And HT3400.DivisionID Is Null	
	END

			 	
---------------------- Xu ly tung khoan thu nhap 
IF @CustomerName = 19
	BEGIN
	SET @HT5005_cur = CURSOR SCROLL KEYSET FOR
		Select IncomeID, MethodID, BaseSalaryField, BaseSalary, GeneralCoID, GeneralAbsentID, 
			(Select Top 1 Isnull(TotalAmount,0) From HT9999 Where DivisionID = @DivisionID And TranMonth = @TranMonth And TranYear=@TranYear),
			AbsentAmount, right(IncomeID,2) as Orders, 1 as IsIncome,1			
		From HT5005
		Where HT5005.PayrollMethodID =@PayrollMethodID and HT5005.DivisionID = @DivisionID
		Order by MethodID

	

	END	 
ELSE
	SET @HT5005_cur = CURSOR SCROLL KEYSET FOR
		Select IncomeID, MethodID, BaseSalaryField, BaseSalary, GeneralCoID, GeneralAbsentID, 
			SalaryTotal, AbsentAmount, right(IncomeID,2) as Orders, 1 as IsIncome,1			
		From HT5005
		Where HT5005.DivisionID = @DivisionID and HT5005.PayrollMethodID =@PayrollMethodID
		Order by MethodID 
	
	Open @HT5005_cur
	FETCH NEXT FROM @HT5005_cur INTO  @IncomeID, @MethodID, @BaseSalaryField, @BaseSalary, @GeneralCoID,
		 @GeneralAbsentID, @SalaryTotal, @AbsentAmount, @Orders, @IsIncome,  @ExchangeRate

	WHILE @@FETCH_STATUS = 0
	  BEGIN
		If @AbsentAmount IS NULL
			Set @AbsentAmount = (Select DayPerMonth  From HT0000 where DivisionID = @DivisionID )
			Set 	@SalaryTotal = isnull(@SalaryTotal,0)* @ExchangeRate
			

						
			Exec HP5001 	@DivisionID, @TranMonth, @TranYear,  
							@PayrollMethodID, 
							@IncomeID,   	--- Ma thu nhap
							@MethodID, 	--- PP tinh luong
							@BaseSalaryField,  ----- Muc luong co ban lay tu dau
							@BaseSalary, 		---- Muc luong co ban cu the (Chi su dung khi @BaseSalaryField ='Others'), 
							@GeneralCoID, 		---PP Xac dinh he so chung
							@GeneralAbsentID, 	--- PP xac dinh ngay cong tong hop
							@SalaryTotal, 		---- Quy luong chi ap dung trong truong hop la luong khoan
							@AbsentAmount , 	---- So ngay quy dinh (he so chi				

							@Orders,	--- Thu tu
							@IsIncome ,
							@DepartmentID1,
							@TeamID1,
							@ExchangeRate
					
			IF 	@CustomerName = 19	AND @IncomeID = 'I04'
				BEGIN
							----- 	Xac dinh he so chung:	--- Toàn công ty
						EXEC HP5009	@DivisionID, @TranMonth, @TranYear, @PayrollMethodID, @GeneralCoID, @MethodID,
								@BaseSalaryField, @BaseSalary

							---	Xac dinh ngay cong tong hop: --- Toàn công ty
						EXEC HP5008	@DivisionID, @TranMonth, @TranYear, @PayrollMethodID, @GeneralAbsentID	
				END

		FETCH NEXT FROM @HT5005_cur INTO  @IncomeID, @MethodID, @BaseSalaryField, @BaseSalary, @GeneralCoID,
		 @GeneralAbsentID, @SalaryTotal, @AbsentAmount, @Orders, @IsIncome,  @ExchangeRate

	  END
	Close @HT5005_cur
	
	IF @CustomerName = 19 --- Tinh tổng quỹ lương phân bổ xuống Customize riêng cho Cảng sài gòn
	EXEC HP5014
		@DivisionID,
		@TranMonth,
		@TranYear,
		@PayrollMethodID,
		@SalaryTotal		
-------------------------------------------------------------------------------------------------------

EXEC HP5106 @PayrollMethodID, @TranMonth, @TranYear, @DivisionID,@DepartmentID1,@TeamID1

-----------------------Xu ly tung khoan giam tru ( khong phai tu ket chuyen)
SET @HT5006_cur1 = CURSOR SCROLL KEYSET FOR
	Select HT5006.SubID, IsNull(MethodID,'P01') as MethodID, BaseSalaryField, BaseSalary, GeneralCoID, GeneralAbsentID, 
		IsNull(SalaryTotal,0) as SalaryTotal, AbsentAmount, right(HT5006.SubID,2) as Orders, 0 as IsIncome,
		1
	From HT5006  inner join HT0005  on HT5006.DivisionID = HT0005.DivisionID And HT5006.SubID = HT0005.SubID
	Where HT5006.DivisionID = @DivisionID and HT5006.PayrollMethodID =@PayrollMethodID and IsTranfer = 0
	Order by MethodID

	Open @HT5006_cur1
	FETCH NEXT FROM @HT5006_cur1 INTO  @SubID, @MethodID, @BaseSalaryField, @BaseSalary, @GeneralCoID,
				 @GeneralAbsentID, @SalaryTotal, @AbsentAmount, @Orders, @IsIncome, @ExchangeRate

	WHILE @@FETCH_STATUS = 0
	  BEGIN					
		If @AbsentAmount IS NULL
			Set @AbsentAmount = (Select DayPerMonth  From HT0000 WHERE DivisionID = @DivisionID)
			Exec HP5001 	@DivisionID, @TranMonth, @TranYear,  
					@PayrollMethodID, 
					@SubID,   	--- Ma thu nhap
					@MethodID, 	--- PP tinh luong
					@BaseSalaryField,  ----- Muc luong co ban lay tu dau
					@BaseSalary, 		---- Muc luong co ban cu the (Chi su dung khi @BaseSalaryField ='Others'), 
					@GeneralCoID, 		---PP Xac dinh he so chung
					@GeneralAbsentID, 	--- PP xac dinh ngay cong tong hop
					@SalaryTotal, 		---- Quy luong chi ap dung trong truong hop la luong khoan
					@AbsentAmount , 	---- So ngay quy (he so chi				
					@Orders,	--- Thu thu
					@IsIncome,
					@DepartmentID1,
					@TeamID1,
					@ExchangeRate

		FETCH NEXT FROM @HT5006_cur1 INTO  @SubID, @MethodID, @BaseSalaryField, @BaseSalary, @GeneralCoID,
				 @GeneralAbsentID, @SalaryTotal, @AbsentAmount, @Orders, @IsIncome, @ExchangeRate
	  END

	Close @HT5006_cur1


----------------------------Xu ly tung khoan giam tru tu ket chuyen	

SET @HT5006_cur2 = CURSOR SCROLL KEYSET FOR
	Select HT00.SubID, right(HT00.SubID,2) as Orders,  
		SourceFieldName, SourceTableName
	From HT5006 HT00 inner join HT0005 HT01 on HT00.SubID = HT01.SubID and HT00.DivisionID = HT01.DivisionID
			
	Where HT00.PayrollMethodID =@PayrollMethodID and IsTranfer = 1 and HT00.DivisionID = @DivisionID
	Order by Orders
	
	Open @HT5006_cur2 
	FETCH NEXT FROM @HT5006_cur2 INTO  @SubID,  @Orders, @SourceFieldName, @SourceTableName
	
	While @@FETCH_STATUS = 0
	Begin	
		EXEC HP5005   @PayrollMethodID,	@DivisionID,	@TranMonth,	@TranYear,
			@SubID,  	@Orders, 	@SourceFieldName,	@SourceTableName, @DepartmentID1, @TeamID1 --, @CurrencyID

		FETCH NEXT FROM @HT5006_cur2 INTO  @SubID,  @Orders, @SourceFieldName, @SourceTableName
	End

Set Nocount off

----------------------------------Tinh thue thu nhap 
IF exists (Select Top 1 1 From HT2400 
	Where DivisionID = @DivisionID and TranMonth = @TranMonth and 	TranYear = @TranYear and 	Isnull(TaxObjectID, '') <> '') 	

	If @PayrollMethodID='PPY' OR @PayrollMethodID='PPZ'
		EXEC HP5007 @DivisionID,	@TranMonth,	@TranYear ,	@PayrollMethodID, @DepartmentID1, @TeamID1
	Else
		EXEC HP5006 @DivisionID,	@TranMonth,	@TranYear ,	@PayrollMethodID , @DepartmentID1, @TeamID1

-- Nếu KH là SGPT thì update Salary02: Doanh số bình quân tháng, tính ngày công nghỉ việc
IF @CustomerName = 36 
BEGIN
DECLARE @Cur CURSOR,
	    @Salary02 DECIMAL(28,8) = 0
SET @Cur = CURSOR SCROLL KEYSET FOR
SELECT HT34.DivisionID, HT34.EmployeeID, HT34.DepartmentID, HT34.TeamID, HT34.PayRollMethodID,
	   ISNULL(AVG(ISNULL(HT24.Salary01,0)*ISNULL(HT24.C06,0)),0) AS Salary02
FROM HT3400 HT34
LEFT JOIN HT2400 HT24 ON HT24.DivisionID = HT34.DivisionID AND HT24.EmployeeID = HT34.EmployeeID 
AND HT24.DepartmentID = HT34.DepartmentID AND ISNULL(HT24.TeamID,'') = ISNULL(HT34.TeamID,'')
AND HT24.TranMonth = HT34.TranMonth AND HT24.TranYear = HT34.TranYear
LEFT JOIN HT1400 HT14 ON HT14.DivisionID = HT24.DivisionID AND HT14.EmployeeID = HT24.EmployeeID 
AND HT14.DepartmentID = HT24.DepartmentID AND ISNULL(HT14.TeamID,'') = ISNULL(HT24.TeamID,'')
WHERE HT34.DivisionID = @DivisionID AND HT34.PayRollMethodID = @PayrollMethodID AND 
      (HT34.TranYear*12 + HT34.TranMonth) <= (@TranYear*12 + @TranMonth)
      AND ISNULL(HT14.EmployeeStatus,0) = 9
GROUP BY HT34.DivisionID, HT34.EmployeeID, HT34.DepartmentID, HT34.TeamID, HT34.PayRollMethodID
OPEN @Cur
FETCH NEXT FROM @Cur INTO @DivisionID,@EmployeeID,@DepartmentID,@TeamID,@PayrollMethodID,@Salary02
WHILE @@FETCH_STATUS = 0
BEGIN
	UPDATE HT2400 SET 
		Salary02 = ISNULL(@Salary02,0)
	WHERE DivisionID = @DivisionID AND EmployeeID = @EmployeeID AND TranYear = @TranYear AND TranMonth = @TranMonth AND DepartmentID = @DepartmentID AND ISNULL(TeamID,'') = ISNULL(@TeamID,'')
FETCH NEXT FROM @Cur INTO @DivisionID,@EmployeeID,@DepartmentID,@TeamID,@PayrollMethodID,@Salary02
END
CLOSE @Cur
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

