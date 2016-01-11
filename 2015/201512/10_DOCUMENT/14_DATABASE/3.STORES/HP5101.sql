IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP5101]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[HP5101]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----- 	Created by Nguyen Van Nhan, Date 29/04/2004
----  	Purpose: Tinh luong theo PP luong Nhan (Luong cong nhat
----	Cong thuc: L = LCB * HeSo*NgayCong/SoNgayQuyDinh

----	Edit by: Dang Le Bao Quynh; Date: 25/01/2007
----	Purpose: Tu thiet lap theo cong thuc tinh cua nguoi dung
/********************************************
'* Edited by: [GS] [Minh Lâm] [02/08/2010]
'********************************************/

-- Edited by: [GS] [Trong Khanh] [05/03/2012] -- If @MethodID = 'P04' : Thêm phần tính phương pháp tính lương sản phẩm chỉ định
-- Edited by: [GS] [Bao Quynh] [05/03/2013] -- If @MethodID = 'P05' : Thêm phần tính phương pháp tính lương sản phẩm theo ngay  Vietroll
--- Modify on 01/08/2013 by Bao Anh: Bo sung 10 khoan thu nhap Income21 -> Income30 (Hưng Vượng)
----- Modified on 06/09/2013 by Le Thi Thu Hien : Cham cong theo ca (Neu co du lieu cham cong ca thi cham cong ca nguoc lai cham cong ngay VietRoll
----- Modified on 08/11/2013 by Le Thi Thu Hien : Sửa tính lương sản phẩm của Cảng sài gòn
----- Modified on 03/12/2013 by Bảo Anh : Sửa lỗi không cập nhật các khoản IGAbsentAmount21 -> IGAbsentAmount30
----- Modified on 24/03/2014 by Le Thi Thu Hien : Bo sung tinh luong chi dinh theo loai cong khong sum het
----- Modified on 11/08/2015 by Bảo Anh : Sửa lỗi tính lương sản phẩm theo P04, P05 không lên dữ liệu

CREATE PROCEDURE [dbo].[HP5101]
       @DivisionID AS nvarchar(50) ,
       @TranMonth AS int ,
       @TranYear AS int ,
       @PayrollMethodID nvarchar(50) ,
       @MethodID AS nvarchar(50) ,
       @AbsentAmount AS decimal(28,8) ,
       @Orders AS tinyint ,
       @IsIncome AS tinyint ,
       @DepartmentID1 AS nvarchar(50) ,
       @TeamID1 AS nvarchar(50) ,
       @ExchangeRate decimal(28,8),
       @IncomeID        AS NVARCHAR(50),
       @GeneralAbsentID AS nvarchar(50)
AS --Print 'Luong congNhat'
DECLARE
        @Emp_cur AS cursor ,
        @DepartmentID AS nvarchar(50) ,
        @TeamID AS nvarchar(50) ,
        @EmployeeID AS nvarchar(50) ,
        @CoValues AS decimal(28,8) ,
        @AbsentValues AS decimal(28,8) ,
        @SalaryAmount AS decimal(28,8) ,
        @BaseSalary AS decimal(28,8) ,
        @TransactionID AS nvarchar(50) ,
        @IsOtherDayPerMonth AS tinyint ,
        @OtherDayPerMonth AS decimal(28,8) ,
        @IsCondition bit ,
        @ConditionCode nvarchar(4000)

--Kiem tra customize cho CSG
DECLARE @AP4444 TABLE(CustomerName INT, Export INT)
DECLARE	@SalaryTable TABLE (Salary DECIMAL(28,8))

Insert Into @AP4444(CustomerName,Export) EXEC('AP4444')

SELECT
    @OtherDayPerMonth = IsNull(OtherDayPerMonth , 0)
FROM
    HT0000
WHERE
    DivisionID = @DivisionID

SET @Emp_cur = CURSOR SCROLL KEYSET FOR
	SELECT HT34.TransactionID, HT34.EmployeeID, HT34.DepartmentID, HT34.TeamID, HV54.GeneralCo, HV54.AbsentAmount,
		HV54.BaseSalary, HT34.IsOtherDayPerMonth
	FROM HT3400 HT34
	LEFT JOIN HT3444 HV54 ON HT34.EmployeeID = HV54.EmployeeID AND HT34.DivisionID = HV54.DivisionID
		AND HT34.DepartmentID = HV54.DepartmentID AND isnull(HT34.TeamID , '') = isnull(HV54.TeamID , '') AND HT34.TranMonth = HV54.TranMonth AND HT34.TranYear = HV54.TranYear
	WHERE
	HT34.PayrollMethodID = @PayrollMethodID 
	AND HT34.TranMonth = @TranMonth 
	AND HT34.TranYear = @TranYear 
	AND HT34.DivisionID = @DivisionID 
	AND HT34.DepartmentID LIKE @DepartmentID1 
	AND ISNull(HT34.TeamID , '') LIKE ISNULL(@TeamID1 , '') 
	AND HT34.DepartmentID IN ( SELECT   DepartmentID
								FROM     HT5004
								WHERE    PayrollMethodID = @PayrollMethodID 
										AND DivisionID = @DivisionID )


OPEN @Emp_cur
FETCH NEXT FROM @Emp_cur INTO @TransactionID,@EmployeeID,@DepartmentID,@TeamID,@CoValues,@AbsentValues,@BaseSalary,@IsOtherDayPerMonth

WHILE @@FETCH_STATUS = 0
      BEGIN      	
            SET @SalaryAmount = 0                        
			If @MethodID = 'P04'------- Phương pháp chỉ định
			BEGIN
				IF (SELECT CustomerName From @AP4444) = 19 --- Cảng sài gòn
					BEGIN						
						SET @BaseSalary = ISNULL((	SELECT	SUM(ISNULL(D.ProductAmount,0)) AS ProductSalary 
													FROM	HT0324 M 
													INNER JOIN HT0325 D 
														ON M.DivisionID = D.DivisionID 
														AND M.ResultAPK = D.ResultAPK 
													WHERE M.TranMonth = @TranMonth 
															AND M.TranYear = @TranYear 
															AND M.DivisionID = @DivisionID 
															AND D.EmployeeID = @EmployeeID),0)	
					END										
												   
				ELSE
					BEGIN
						IF NOT EXISTS (SELECT TOP 1 1 FROM HT0287 WHERE DivisionID = @DivisionID 
               														AND TranMonth = @TranMonth 
               														AND TranYear = @TranYear
																	AND DepartmentID = @DepartmentID)
						SET @BaseSalary = ISNULL((SELECT SUM(ISNULL(HT2403.quantity,0)* ISNULL(HT1015.unitprice,0)) as ProductSalary 
								FROM HT2403 
								INNER JOIN HT1015 ON HT2403.ProductID=HT1015.ProductID and HT2403.DivisionID=HT1015.DivisionID 
								WHERE TranMonth=@TranMonth and TranYear=@TranYear and HT2403.DivisionID=@DivisionID and EmployeeID = @EmployeeID),0)
						ELSE
							---------- Theo ca
						SET @BaseSalary = ISNULL((SELECT SUM(ISNULL(HT2403.quantity,0)* ISNULL(HT1015.UnitPrice,0)) as ProductSalary 
								FROM HT0287 HT2403 
								INNER JOIN HT1015 ON HT2403.ProductID=HT1015.ProductID 
												and HT2403.DivisionID=HT1015.DivisionID 
								INNER JOIN HT0284 ON HT0284.DivisionID = HT1015.DivisionID
												AND HT0284.AbsentDate = HT2403.TrackingDate
												AND HT0284.ShiftID = HT2403.ShiftID
												AND HT0284.EmployeeID = HT2403.EmployeeID
												
								WHERE HT2403.TranMonth=@TranMonth 
										and HT2403.TranYear=@TranYear 
										and HT2403.DivisionID=@DivisionID 
										and HT2403.EmployeeID = @EmployeeID	
										AND HT0284.AbsentDate = HT2403.TrackingDate
										AND HT0284.ShiftID = HT2403.ShiftID
										AND HT0284.EmployeeID = HT2403.EmployeeID 
										AND AbsentTypeID In (SELECT AbsentTypeID ----- Check vao ngay cong tong hop
															 FROM	HT5003 
															 WHERE	DivisionID = @DivisionID 
																	AND GeneralAbsentID = @GeneralAbsentID)
										),0)
					END
					
			END	--- @MethodID = 'P04'------- Phương pháp chỉ định
			
			IF @MethodID = 'P05'------Phương pháp phân bổ
			BEGIN
			IF NOT EXISTS (SELECT TOP 1 1 FROM HT0289 WHERE DivisionID = @DivisionID 
               													AND TranMonth = @TranMonth 
               													AND TranYear = @TranYear
																AND DepartmentID = @DepartmentID)
			BEGIN
				Set @BaseSalary = ISNULL((	SELECT SUM(ISNULL((CASE WHEN Total = 0 THEN 0 ELSE AbsentHour*Coefficient*TeamAmount/Total END),0))
											FROM HT2414 
											INNER JOIN (SELECT TeamID,AbsentDate, Sum(AbsentHour*Coefficient) AS Total 
											            FROM HT2414
														WHERE DivisionID = @DivisionID 
														And TranMonth = @TranMonth 
														And TranYear = @TranYear 
														GROUP BY TeamID,AbsentDate
														) TeamTotal
												ON HT2414.TeamID = TeamTotal.TeamID 
												AND HT2414.AbsentDate = TeamTotal.AbsentDate
											WHERE DivisionID = @DivisionID 
											And TranMonth = @TranMonth 
											And TranYear = @TranYear 
											And EmployeeID = @EmployeeID
										),0)	
			END
			ELSE
			BEGIN
				SET @BaseSalary = ISNULL((SELECT SUM(PersonAmount) 
				                         FROM HT2415 
				                         WHERE DivisionID = @DivisionID 
											And TranMonth = @TranMonth 
											And TranYear = @TranYear 
											And EmployeeID = @EmployeeID),0)
			END
				
			
			END ----@MethodID = 'P05'------Phương pháp phân bổ
							
            IF @IsIncome = 1
				BEGIN
            		SELECT @IsCondition = IsCondition, @ConditionCode = ConditionCode
            		FROM HT5005
            		WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND CAST(RIGHT(IncomeID, 2) AS INT) = @Orders
                
					IF @IsCondition = 0
						BEGIN
                			SET @SalaryAmount = CASE WHEN ISNULL(@AbsentAmount, 0) = 0 THEN 0
													 ELSE ISNULL(@BaseSalary, 0) * ISNULL(@CoValues, 1) * ISNULL(@AbsentValues, 0) * ISNULL(@ExchangeRate, 1) / @AbsentAmount END
                                       
						END
					ELSE
						BEGIN
							IF @ConditionCode IS NULL OR @ConditionCode = ''
								BEGIN
									SET @SalaryAmount = 0
								END
							 ELSE
							 BEGIN
							 	---- Thay thế sinh view bằng cách sử dụng biến bảng
							 	DELETE @SalaryTable
							 	SET @ConditionCode = REPLACE(@ConditionCode, 'If', ' CASE WHEN ')
								SET @ConditionCode = REPLACE(@ConditionCode, '@NC', ISNULL(@AbsentValues, 0))
								SET @ConditionCode = REPLACE(@ConditionCode, '@HSC', ISNULL(@CoValues , 1))
								SET @ConditionCode = REPLACE(@ConditionCode, '@LCB', ISNULL(@BaseSalary , 0))
							 	INSERT INTO @SalaryTable (Salary) EXEC('SELECT '+@ConditionCode+'')
							 	SET @SalaryAmount = (SELECT TOP 1 Salary FROM @SalaryTable)
								---------- EXEC HP5555 @AbsentValues , @CoValues , @BaseSalary , @ConditionCode , @SalaryAmount OUTPUT
							END
						END
				   END
			ELSE
				BEGIN
                     SELECT @IsCondition = IsCondition, @ConditionCode = ConditionCode FROM HT5006
                     WHERE DivisionID = @DivisionID and PayrollMethodID = @PayrollMethodID AND CAST(RIGHT(SubID , 2) AS INT) = @Orders
                     
                     IF @IsCondition = 0
                     BEGIN                     			
						SET @SalaryAmount = CASE WHEN ISNULL(@AbsentAmount, 0) = 0 THEN 0
                                                 ELSE ISNULL(@BaseSalary, 0) * ISNULL(@CoValues, 1) * ISNULL(@AbsentValues, 0) * ISNULL(@ExchangeRate, 1) / @AbsentAmount END
                     END
                     ELSE
                        BEGIN
							IF (@ConditionCode IS NULL OR @ConditionCode = '') SET @SalaryAmount = 0
							ELSE
							BEGIN
								DELETE @SalaryTable
							 	SET @ConditionCode = REPLACE(@ConditionCode, 'If', ' CASE WHEN ')
								SET @ConditionCode = REPLACE(@ConditionCode, '@NC', ISNULL(@AbsentValues, 0))
								SET @ConditionCode = REPLACE(@ConditionCode, '@HSC', ISNULL(@CoValues , 1))
								SET @ConditionCode = REPLACE(@ConditionCode, '@LCB', ISNULL(@BaseSalary , 0))
							 	INSERT INTO @SalaryTable (Salary) EXEC('SELECT '+@ConditionCode+'')
							 	SET @SalaryAmount = (SELECT TOP 1 Salary FROM @SalaryTable)
							 	------- EXEC HP5555 @AbsentValues, @CoValues, @BaseSalary, @ConditionCode, @SalaryAmount OUTPUT
							END							
                       END
               END
               
			--Rem by Dang Le Bao Quynh
			--Purpose: Khong hieu muc dich cua viec kiem tra so ngay quy dinh @AbsentAmount > 20 and @AbsentAmount <32 ???????????
			--Set @SalaryAmount = case when isnull(@AbsentAmount, 0) = 0 then 0 else isnull(@BaseSalary,0)*isnull( @CoValues,1)*isnull(@AbsentValues,0)* isnull(@ExchangeRate,1)/ case  When  @AbsentAmount > 20 and @AbsentAmount <32 Then   Case When IsNull(@IsOtherDayPerMonth,0) =0 Then  @AbsentAmount    Else  @OtherDayPerMonth  End    Else  @AbsentAmount  End     End
			
			--Edit by Dang Le Bao Quynh; 28/03/2013: Viet lai cau lenh update tuong ung voi tung column, thay vi update hang loat nhu truoc.
			
			If @Orders = 01
				Begin
					IF @IsIncome = 1
						UPDATE HT3400 SET Income01 = @SalaryAmount, IGAbsentAmount01 = ISNULL(@AbsentValues , 0)
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID--- AND @IsIncome = 1
					ELSE
						UPDATE HT3400 SET SubAmount01 = @SalaryAmount                 
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID ---AND @IsIncome = 0                      
				End				
			Else If @Orders = 02
				Begin
					IF @IsIncome = 1
						UPDATE HT3400 SET Income02 = @SalaryAmount, IGAbsentAmount02 = ISNULL(@AbsentValues, 0)
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID ---AND @IsIncome = 1
					ELSE
						UPDATE HT3400 SET SubAmount02 = @SalaryAmount                 
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID ---AND @IsIncome = 0                      
				End
			Else If @Orders = 03
				Begin
					IF @IsIncome = 1
						UPDATE HT3400 SET Income03 = @SalaryAmount, IGAbsentAmount03 = ISNULL(@AbsentValues, 0)
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID--- AND @IsIncome = 1
					ELSE
						UPDATE HT3400 SET SubAmount03 = @SalaryAmount                 
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID--- AND @IsIncome = 0                      
				End
			Else If @Orders = 04
				Begin
					IF @IsIncome = 1
						UPDATE HT3400 SET Income04 = @SalaryAmount, IGAbsentAmount04 = ISNULL(@AbsentValues, 0)
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID ---AND @IsIncome = 1
					Else
						UPDATE HT3400 SET SubAmount04 = @SalaryAmount                 
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID ---AND @IsIncome = 0                      
				End
			Else If @Orders = 05
				Begin
					IF @IsIncome = 1
						UPDATE HT3400 SET Income05 = @SalaryAmount, IGAbsentAmount05 = ISNULL(@AbsentValues, 0)
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID--- AND @IsIncome = 1
					Else
						UPDATE HT3400 SET SubAmount05 = @SalaryAmount                 
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID--- AND @IsIncome = 0                      
				End
			Else If @Orders = 06
				Begin
					IF @IsIncome = 1
						UPDATE HT3400 SET Income06 = @SalaryAmount, IGAbsentAmount06 = ISNULL(@AbsentValues, 0)
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID--- AND @IsIncome = 1
					Else
						UPDATE HT3400 SET SubAmount06 = @SalaryAmount                 
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID--- AND @IsIncome = 0                      
				End
			Else If @Orders = 07
				Begin
					IF @IsIncome = 1
						UPDATE HT3400 SET Income07 = @SalaryAmount, IGAbsentAmount07 = ISNULL(@AbsentValues, 0)
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID ---AND @IsIncome = 1
					Else
						UPDATE HT3400 SET SubAmount07 = @SalaryAmount                 
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID--- AND @IsIncome = 0                      
				End
			Else If @Orders = 08
				Begin
					IF @IsIncome = 1
						UPDATE HT3400 SET Income08 = @SalaryAmount, IGAbsentAmount08 = ISNULL(@AbsentValues, 0)
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID--- AND @IsIncome = 1
					Else
						UPDATE HT3400 SET SubAmount08 = @SalaryAmount                 
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID ---AND @IsIncome = 0                      
				End
			Else If @Orders = 09
				Begin
					IF @IsIncome = 1
						UPDATE HT3400 SET Income09 = @SalaryAmount, IGAbsentAmount09 = ISNULL(@AbsentValues, 0)
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID--- AND @IsIncome = 1
					Else
						UPDATE HT3400 SET SubAmount09 = @SalaryAmount                 
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID ---AND @IsIncome = 0                      
				End
			Else If @Orders = 10
				Begin
					IF @IsIncome = 1
						UPDATE HT3400 SET Income10 = @SalaryAmount, IGAbsentAmount10 = ISNULL(@AbsentValues, 0)
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID--- AND @IsIncome = 1
					Else
						UPDATE HT3400 SET SubAmount10 = @SalaryAmount                 
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID--- AND @IsIncome = 0                      
				End
			Else If @Orders = 11
				Begin
					IF @IsIncome = 1
						UPDATE HT3400 SET Income11 = @SalaryAmount, IGAbsentAmount11 = ISNULL(@AbsentValues, 0)
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID--- AND @IsIncome = 1
					Else
						UPDATE HT3400 SET SubAmount11 = @SalaryAmount                 
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID--- AND @IsIncome = 0                      
				End
			Else If @Orders = 12
				Begin
					IF @IsIncome = 1
						UPDATE HT3400 SET Income12 = @SalaryAmount, IGAbsentAmount12 = ISNULL(@AbsentValues , 0)
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID ---AND @IsIncome = 1
					Else
						UPDATE HT3400 SET SubAmount12 = @SalaryAmount                 
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID--- AND @IsIncome = 0                      
				End
			Else If @Orders = 13
				Begin
					IF @IsIncome = 1
						UPDATE HT3400 SET Income13 = @SalaryAmount, IGAbsentAmount13 = ISNULL(@AbsentValues, 0)
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID ---AND @IsIncome = 1
					Else
						UPDATE HT3400 SET SubAmount13 = @SalaryAmount                 
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID ---AND @IsIncome = 0                      
				End
			Else If @Orders = 14
				Begin
					IF @IsIncome = 1
						UPDATE HT3400 SET Income14 = @SalaryAmount, IGAbsentAmount14 = ISNULL(@AbsentValues, 0)
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID ---AND @IsIncome = 1
					Else
						UPDATE HT3400 SET SubAmount14 = @SalaryAmount                 
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID ---AND @IsIncome = 0                      
				End
			Else If @Orders = 15
				Begin
					IF @IsIncome = 1
						UPDATE HT3400 SET Income15 = @SalaryAmount, IGAbsentAmount15 = ISNULL(@AbsentValues, 0)
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID--- AND @IsIncome = 1
					Else
						UPDATE HT3400 SET SubAmount15 = @SalaryAmount                 
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID--- AND @IsIncome = 0                      
				End
			Else If @Orders = 16
				Begin
					IF @IsIncome = 1
						UPDATE HT3400 SET Income16 = @SalaryAmount, IGAbsentAmount16 = ISNULL(@AbsentValues, 0)
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID ---AND @IsIncome = 1
					Else
						UPDATE HT3400 SET SubAmount16 = @SalaryAmount                 
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID ---AND @IsIncome = 0                      
				End
			Else If @Orders = 17
				Begin
					IF @IsIncome = 1
						UPDATE HT3400 SET Income17 = @SalaryAmount, IGAbsentAmount17 = ISNULL(@AbsentValues, 0)
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID--- AND @IsIncome = 1
					Else
						UPDATE HT3400 SET SubAmount17 = @SalaryAmount                 
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID--- AND @IsIncome = 0             
				End
			Else If @Orders = 18
				Begin
					IF @IsIncome = 1
						UPDATE HT3400 SET Income18 = @SalaryAmount, IGAbsentAmount18 = ISNULL(@AbsentValues, 0)
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID ---AND @IsIncome = 1
					Else
						UPDATE HT3400 SET SubAmount18 = @SalaryAmount                 
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID ---AND @IsIncome = 0                      
				End
			Else If @Orders = 19
				Begin
					IF @IsIncome = 1
						UPDATE HT3400 SET Income19 = @SalaryAmount, IGAbsentAmount19 = ISNULL(@AbsentValues, 0)
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID ---AND @IsIncome = 1
					Else
						UPDATE HT3400 SET SubAmount19 = @SalaryAmount                 
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID ---AND @IsIncome = 0                      
				End
			Else If @Orders = 20
				Begin
					IF @IsIncome = 1
						UPDATE HT3400 SET Income20 = @SalaryAmount, IGAbsentAmount20 = ISNULL(@AbsentValues, 0)
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID--- AND @IsIncome = 1
					Else
						UPDATE HT3400 SET SubAmount20 = @SalaryAmount                 
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID ---AND @IsIncome = 0                      
				End
			Else If @Orders = 21
				Begin
					IF @IsIncome = 1
					Begin
						UPDATE HT3400 SET Income21 = @SalaryAmount, IGAbsentAmount21 = ISNULL(@AbsentValues, 0)
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID--- AND @IsIncome = 1
					End
				End
			Else If @Orders = 22
				Begin
					IF @IsIncome = 1
						UPDATE HT3400 SET Income22 = @SalaryAmount, IGAbsentAmount22 = ISNULL(@AbsentValues, 0)
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID--- AND @IsIncome = 1                
				End
			Else If @Orders = 23
				Begin
					IF @IsIncome = 1
						UPDATE HT3400 SET Income23 = @SalaryAmount, IGAbsentAmount23 = ISNULL(@AbsentValues, 0)
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID--- AND @IsIncome = 1
				End
			Else If @Orders = 24
				Begin
					IF @IsIncome = 1
						UPDATE HT3400 SET Income24 = @SalaryAmount, IGAbsentAmount24 = ISNULL(@AbsentValues, 0)
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID--- AND @IsIncome = 1                   
				End
			Else If @Orders = 25
				Begin
					IF @IsIncome = 1
						UPDATE HT3400 SET Income25 = @SalaryAmount, IGAbsentAmount25 = ISNULL(@AbsentValues, 0)
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID--- AND @IsIncome = 1
				End
			Else If @Orders = 26
				Begin
					IF @IsIncome = 1
						UPDATE HT3400 SET Income26 = @SalaryAmount, IGAbsentAmount26 = ISNULL(@AbsentValues, 0)
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID ---AND @IsIncome = 1
				End
			Else If @Orders = 27
				Begin
					IF @IsIncome = 1
						UPDATE HT3400 SET Income27 = @SalaryAmount, IGAbsentAmount27 = ISNULL(@AbsentValues, 0)
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID--- AND @IsIncome = 1
				End
			Else If @Orders = 28
				Begin
					IF @IsIncome = 1
						UPDATE HT3400 SET Income28 = @SalaryAmount, IGAbsentAmount28 = ISNULL(@AbsentValues, 0)
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID ---AND @IsIncome = 1
				End
			Else If @Orders = 29
				Begin
					IF @IsIncome = 1
						UPDATE HT3400 SET Income29 = @SalaryAmount, IGAbsentAmount29 = ISNULL(@AbsentValues, 0)
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID ---AND @IsIncome = 1
				End
			Else If @Orders = 30
				Begin
					IF @IsIncome = 1
						UPDATE HT3400 SET Income30 = @SalaryAmount, IGAbsentAmount30 = ISNULL(@AbsentValues, 0)
						WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID--- AND @IsIncome = 1
				End
            FETCH NEXT FROM @Emp_cur INTO @TransactionID,@EmployeeID,@DepartmentID,@TeamID,@CoValues,@AbsentValues,@BaseSalary,@IsOtherDayPerMonth
      END

CLOSE @Emp_cur
--------------------------------------------------------------------------------
--Xu ly luong cong trinh
--Xu ly luong cong trinh
--------------------------------------------------------------------------------

DECLARE @ProjectID as nvarchar(50)

IF @MethodID = 'P06'
BEGIN

SET @Emp_cur = CURSOR SCROLL KEYSET FOR
	SELECT HT34.TransactionID, HT34.EmployeeID, HT34.DepartmentID, HT34.TeamID, HV54.GeneralCo, 
		HV54.AbsentAmount, HV54.BaseSalary, HT34.IsOtherDayPerMonth, HV54.ProjectID
	FROM HT3400 HT34
		LEFT JOIN HT344401 HV54 ON HT34.EmployeeID = HV54.EmployeeID AND HT34.DivisionID = HV54.DivisionID
			AND HT34.DepartmentID = HV54.DepartmentID AND isnull(HT34.TeamID , '') = isnull(HV54.TeamID , '')
			AND HT34.TranMonth = HV54.TranMonth AND HT34.TranYear = HV54.TranYear
	WHERE HT34.PayrollMethodID = @PayrollMethodID AND HT34.TranMonth = @TranMonth AND HT34.TranYear = @TranYear
		AND HT34.DivisionID = @DivisionID AND HT34.DepartmentID LIKE @DepartmentID1 AND ISNull(HT34.TeamID , '') LIKE ISNULL(@TeamID1 , '')
		AND HT34.DepartmentID IN ( SELECT DepartmentID FROM HT5004 WHERE PayrollMethodID = @PayrollMethodID And DivisionID = @DivisionID )
		AND HV54.ProjectID IS NOT NULL
                                                                                                                                                                                                                                                                                         
OPEN @Emp_cur
FETCH NEXT FROM @Emp_cur INTO @TransactionID,@EmployeeID,@DepartmentID,@TeamID,@CoValues,@AbsentValues,@BaseSalary,@IsOtherDayPerMonth, @ProjectID

WHILE @@FETCH_STATUS = 0
      BEGIN
            SET @SalaryAmount = 0
            If not exists (Select Top 1 1 From HT340001 Where DivisionID = @DivisionID And TransactionID = @TransactionID And ProjectID = @ProjectID)
			INSERT INTO HT340001 (DivisionID, TransactionID, ProjectID) Values (@DivisionID,@TransactionID,@ProjectID)
			            
			IF @IsIncome = 1
               BEGIN
                     SELECT @IsCondition = IsCondition, @ConditionCode = ConditionCode FROM HT5005
                     WHERE DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND CAST(RIGHT(IncomeID , 2) AS INT) = @Orders
                     
                     IF @IsCondition = 0
						SET @SalaryAmount = CASE WHEN isnull(@AbsentAmount , 0) = 0 THEN 0
												 ELSE isnull(@BaseSalary , 0) * isnull(@CoValues , 1) * isnull(@AbsentValues , 0) * isnull(@ExchangeRate , 1) / @AbsentAmount END
                        
                     ELSE
                     BEGIN
						IF (@ConditionCode IS NULL OR @ConditionCode = '') SET @SalaryAmount = 0         
                        ELSE 
                            BEGIN
                            	DELETE @SalaryTable
							 	SET @ConditionCode = REPLACE(@ConditionCode, 'If', ' CASE WHEN ')
								SET @ConditionCode = REPLACE(@ConditionCode, '@NC', ISNULL(@AbsentValues, 0))
								SET @ConditionCode = REPLACE(@ConditionCode, '@HSC', ISNULL(@CoValues , 1))
								SET @ConditionCode = REPLACE(@ConditionCode, '@LCB', ISNULL(@BaseSalary , 0))
							 	INSERT INTO @SalaryTable (Salary) EXEC('SELECT '+@ConditionCode+'')
							 	SET @SalaryAmount = (SELECT TOP 1 Salary FROM @SalaryTable)
                                ----------- EXEC HP5555 @AbsentValues , @CoValues , @BaseSalary , @ConditionCode , @SalaryAmount OUTPUT
                            END
                        END
               END
            ELSE
               BEGIN
                     SELECT
                         @IsCondition = IsCondition ,
                         @ConditionCode = ConditionCode
                     FROM
                         HT5006
                     WHERE
                         DivisionID = @DivisionID and PayrollMethodID = @PayrollMethodID AND CAST(RIGHT(SubID , 2) AS int) = @Orders
                     IF @IsCondition = 0
                        BEGIN
                     
						
                              SET @SalaryAmount = CASE
                                                       WHEN isnull(@AbsentAmount , 0) = 0 THEN 0
                                                       ELSE isnull(@BaseSalary , 0) * isnull(@CoValues , 1) * isnull(@AbsentValues , 0) * isnull(@ExchangeRate , 1) / @AbsentAmount
                                                  END
                        END
                     ELSE
                        BEGIN
                              IF @ConditionCode IS NULL OR @ConditionCode = ''
                                 BEGIN
                                       SET @SalaryAmount = 0
                                 END
                              ELSE
                                 BEGIN
                                 	DELETE @SalaryTable
							 		SET @ConditionCode = REPLACE(@ConditionCode, 'If', ' CASE WHEN ')
									SET @ConditionCode = REPLACE(@ConditionCode, '@NC', ISNULL(@AbsentValues, 0))
									SET @ConditionCode = REPLACE(@ConditionCode, '@HSC', ISNULL(@CoValues , 1))
									SET @ConditionCode = REPLACE(@ConditionCode, '@LCB', ISNULL(@BaseSalary , 0))
							 		INSERT INTO @SalaryTable (Salary) EXEC('SELECT '+@ConditionCode+'')
							 		SET @SalaryAmount = (SELECT TOP 1 Salary FROM @SalaryTable)
                                    ---------	EXEC HP5555 @AbsentValues , @CoValues , @BaseSalary , @ConditionCode , @SalaryAmount OUTPUT
                                 END
                        END
               END
               
			--Edit by Dang Le Bao Quynh; 28/03/2013: Viet lai cau lenh update tuong ung voi tung column, thay vi update hang loat nhu truoc.
			If @Orders = 01
				BEGIN					
					UPDATE HT340001 SET Income01 = @SalaryAmount, IGAbsentAmount01 = ISNULL(@AbsentValues, 0)
					WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					--UPDATE HT340001 SET IGAbsentAmount01 = isnull(@AbsentValues , 0)
					--WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					UPDATE HT340001 SET SubAmount01 = @SalaryAmount                 
                    WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 0                      
				End
				
			Else If @Orders = 02
				Begin
					UPDATE HT340001 SET Income02 = @SalaryAmount, IGAbsentAmount02 = ISNULL(@AbsentValues, 0)
					WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					--UPDATE HT340001 SET IGAbsentAmount02 = isnull(@AbsentValues , 0)
					--WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					UPDATE HT340001 SET SubAmount02 = @SalaryAmount                 
                    WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 0                      
				End
			Else If @Orders = 03
				Begin
					UPDATE HT340001 SET Income03 = @SalaryAmount, IGAbsentAmount03 = ISNULL(@AbsentValues, 0)
					WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					--UPDATE HT340001 SET IGAbsentAmount03 = isnull(@AbsentValues , 0)
					--WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					UPDATE HT340001 SET SubAmount03 = @SalaryAmount                 
                    WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 0                      
				End
			Else If @Orders = 04
				Begin
					UPDATE HT340001 SET Income04 = @SalaryAmount, IGAbsentAmount04 = ISNULL(@AbsentValues, 0)
					WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					--UPDATE HT340001 SET IGAbsentAmount04 = isnull(@AbsentValues , 0)
					--WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					UPDATE HT340001 SET SubAmount04 = @SalaryAmount                 
                    WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 0                      
				End
			Else If @Orders = 05
				Begin
					UPDATE HT340001 SET Income05 = @SalaryAmount, IGAbsentAmount05 = ISNULL(@AbsentValues, 0)
					WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					--UPDATE HT340001 SET IGAbsentAmount05 = isnull(@AbsentValues , 0)
					--WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					UPDATE HT340001 SET SubAmount05 = @SalaryAmount                 
                    WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 0                      
				End
			Else If @Orders = 06
				Begin
					UPDATE HT340001 SET Income06 = @SalaryAmount, IGAbsentAmount06 = ISNULL(@AbsentValues, 0)
					WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					--UPDATE HT340001 SET IGAbsentAmount06 = isnull(@AbsentValues , 0)
					--WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					UPDATE HT340001 SET SubAmount06 = @SalaryAmount                 
                    WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 0                      
				End
			Else If @Orders = 07
				Begin
					UPDATE HT340001 SET Income07 = @SalaryAmount, IGAbsentAmount07 = ISNULL(@AbsentValues, 0)
					WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					--UPDATE HT340001 SET IGAbsentAmount07 = isnull(@AbsentValues , 0)
					--WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					UPDATE HT340001 SET SubAmount07 = @SalaryAmount                 
                    WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 0                      
				End
			Else If @Orders = 08
				Begin
					UPDATE HT340001 SET Income08 = @SalaryAmount, IGAbsentAmount08 = ISNULL(@AbsentValues, 0)
					WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					--UPDATE HT340001 SET IGAbsentAmount08 = isnull(@AbsentValues , 0)
					--WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					UPDATE HT340001 SET SubAmount08 = @SalaryAmount                 
                    WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 0                      
				End
			Else If @Orders = 09
				Begin
					UPDATE HT340001 SET Income09 = @SalaryAmount, IGAbsentAmount09 = ISNULL(@AbsentValues, 0)
					WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					--UPDATE HT340001 SET IGAbsentAmount09 = isnull(@AbsentValues , 0)
					--WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					UPDATE HT340001 SET SubAmount09 = @SalaryAmount                 
                    WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 0                      
				End
			Else If @Orders = 10
				Begin
					UPDATE HT340001 SET Income10 = @SalaryAmount, IGAbsentAmount10 = ISNULL(@AbsentValues, 0)
					WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					--UPDATE HT340001 SET IGAbsentAmount10 = isnull(@AbsentValues , 0)
					--WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					UPDATE HT340001 SET SubAmount10 = @SalaryAmount                 
                    WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 0                      
				End
			Else If @Orders = 11
				Begin
					UPDATE HT340001 SET Income11 = @SalaryAmount, IGAbsentAmount11 = ISNULL(@AbsentValues, 0)
					WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					--UPDATE HT340001 SET IGAbsentAmount11 = isnull(@AbsentValues , 0)
					--WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					UPDATE HT340001 SET SubAmount11 = @SalaryAmount                 
                    WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 0                      
				End
			Else If @Orders = 12
				Begin
					UPDATE HT340001 SET Income12 = @SalaryAmount, IGAbsentAmount12 = ISNULL(@AbsentValues, 0)
					WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					--UPDATE HT340001 SET IGAbsentAmount12 = isnull(@AbsentValues , 0)
					--WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					UPDATE HT340001 SET SubAmount12 = @SalaryAmount                 
					WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 0                      
				End
			Else If @Orders = 13
				Begin
					UPDATE HT340001 SET Income13 = @SalaryAmount, IGAbsentAmount13 = ISNULL(@AbsentValues, 0)
					WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					--UPDATE HT340001 SET IGAbsentAmount13 = isnull(@AbsentValues , 0)
					--WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					UPDATE HT340001 SET SubAmount13 = @SalaryAmount                 
                    WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 0                      
				End
			Else If @Orders = 14
				Begin
					UPDATE HT340001 SET Income14 = @SalaryAmount, IGAbsentAmount14 = ISNULL(@AbsentValues, 0)
					WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					--UPDATE HT340001 SET IGAbsentAmount14 = isnull(@AbsentValues , 0)
					--WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					UPDATE HT340001 SET SubAmount14 = @SalaryAmount                 
                    WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 0                      
				End
			Else If @Orders = 15
				Begin
					UPDATE HT340001 SET Income15 = @SalaryAmount, IGAbsentAmount15 = ISNULL(@AbsentValues, 0)
					WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					--UPDATE HT340001 SET IGAbsentAmount15 = isnull(@AbsentValues , 0)
					--WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					UPDATE HT340001 SET SubAmount15 = @SalaryAmount                 
                    WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 0                      
				End
			Else If @Orders = 16
				Begin
					UPDATE HT340001 SET Income16 = @SalaryAmount, IGAbsentAmount16 = ISNULL(@AbsentValues, 0)
					WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					--UPDATE HT340001 SET IGAbsentAmount16 = isnull(@AbsentValues , 0)
					--WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					UPDATE HT340001 SET SubAmount16 = @SalaryAmount           
                    WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 0                      
				End
			Else If @Orders = 17
				Begin
					UPDATE HT340001 SET Income17 = @SalaryAmount, IGAbsentAmount17 = ISNULL(@AbsentValues, 0)
					WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					--UPDATE HT340001 SET IGAbsentAmount17 = isnull(@AbsentValues , 0)
					--WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					UPDATE HT340001 SET SubAmount17 = @SalaryAmount                 
                    WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 0                      
				End
			Else If @Orders = 18
				Begin
					UPDATE HT340001 SET Income18 = @SalaryAmount, IGAbsentAmount18 = ISNULL(@AbsentValues, 0)
					WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					--UPDATE HT340001 SET IGAbsentAmount18 = isnull(@AbsentValues , 0)
					--WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					UPDATE HT340001 SET SubAmount18 = @SalaryAmount                 
                    WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 0                      
				End
			Else If @Orders = 19
				Begin
					UPDATE HT340001 SET Income19 = @SalaryAmount, IGAbsentAmount19 = ISNULL(@AbsentValues, 0)
					WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					--UPDATE HT340001 SET IGAbsentAmount19 = isnull(@AbsentValues , 0)
					--WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					UPDATE HT340001 SET SubAmount19 = @SalaryAmount                 
                    WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 0                      
				End
			Else If @Orders = 20
				Begin
					UPDATE HT340001 SET Income20 = @SalaryAmount, IGAbsentAmount20 = ISNULL(@AbsentValues, 0)
					WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					--UPDATE HT340001 SET IGAbsentAmount20 = isnull(@AbsentValues , 0)
					--WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					UPDATE HT340001 SET SubAmount20 = @SalaryAmount                 
                    WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 0                      
				End
			Else If @Orders = 21
				Begin
					UPDATE HT340001 SET Income21 = @SalaryAmount, IGAbsentAmount21 = ISNULL(@AbsentValues, 0)
					WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					--UPDATE HT340001 SET IGAbsentAmount21 = isnull(@AbsentValues , 0)
					--WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1                      
				End
			Else If @Orders = 22
				Begin
					UPDATE HT340001 SET Income22 = @SalaryAmount, IGAbsentAmount22 = ISNULL(@AbsentValues, 0)
					WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					--UPDATE HT340001 SET IGAbsentAmount22 = isnull(@AbsentValues , 0)
					--WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1                      
				End
			Else If @Orders = 23
				Begin
					UPDATE HT340001 SET Income23 = @SalaryAmount, IGAbsentAmount23 = ISNULL(@AbsentValues, 0)
					WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					--UPDATE HT340001 SET IGAbsentAmount23 = isnull(@AbsentValues , 0)
					--WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1                      
				End
			Else If @Orders = 24
				Begin
					UPDATE HT340001 SET Income24 = @SalaryAmount, IGAbsentAmount24 = ISNULL(@AbsentValues, 0)
					WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					--UPDATE HT340001 SET IGAbsentAmount24 = isnull(@AbsentValues , 0)
					--WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1                      
				End
			Else If @Orders = 25
				Begin
					UPDATE HT340001 SET Income25 = @SalaryAmount, IGAbsentAmount25 = ISNULL(@AbsentValues, 0)
					WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					UPDATE HT340001 SET IGAbsentAmount25 = isnull(@AbsentValues , 0)
					WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1                      
				End
			Else If @Orders = 26
				Begin
					UPDATE HT340001 SET Income26 = @SalaryAmount, IGAbsentAmount26 = ISNULL(@AbsentValues, 0)
					WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					--UPDATE HT340001 SET IGAbsentAmount26 = isnull(@AbsentValues , 0)
					--WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1                      
				End
			Else If @Orders = 27
				Begin
					UPDATE HT340001 SET Income27 = @SalaryAmount, IGAbsentAmount27 = ISNULL(@AbsentValues, 0)
					WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					--UPDATE HT340001 SET IGAbsentAmount27 = isnull(@AbsentValues , 0)
					--WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1                      
				End
			Else If @Orders = 28
				Begin
					UPDATE HT340001 SET Income28 = @SalaryAmount, IGAbsentAmount28 = ISNULL(@AbsentValues, 0)
					WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					--UPDATE HT340001 SET IGAbsentAmount28 = isnull(@AbsentValues , 0)
					--WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1                      
				End
			Else If @Orders = 29
				Begin
					UPDATE HT340001 SET Income29 = @SalaryAmount, IGAbsentAmount29 = ISNULL(@AbsentValues, 0)
					WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					--UPDATE HT340001 SET IGAbsentAmount29 = isnull(@AbsentValues , 0)
					--WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1                      
				End
			Else If @Orders = 30
				Begin
					UPDATE HT340001 SET Income30 = @SalaryAmount, IGAbsentAmount30 = ISNULL(@AbsentValues, 0)
					WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1
					--UPDATE HT340001 SET IGAbsentAmount30 = isnull(@AbsentValues, 0)
					--WHERE DivisionID = @DivisionID AND ProjectID = @ProjectID AND TransactionID = @TransactionID AND @IsIncome = 1                      
				End
			
            FETCH NEXT FROM @Emp_cur INTO @TransactionID,@EmployeeID,@DepartmentID,@TeamID,@CoValues,@AbsentValues,@BaseSalary,@IsOtherDayPerMonth, @ProjectID
      END

CLOSE @Emp_cur



--Cap nhat thu nhap tong

If @Orders = 01
		Begin
			UPDATE M SET M.Income01 = (Select Isnull(Sum(Isnull(D.Income01,0)),0) From HT340001 D Where D.TransactionID = M.TransactionID)
			FROM HT3400 M 
			WHERE	M.DivisionID = @DivisionID AND M.PayrollMethodID = @PayrollMethodID AND @IsIncome = 1 AND
					M.TranMonth = @TranMonth AND M.TranYear = @TranYear AND 
					M.DepartmentID LIKE @DepartmentID1 AND ISNull(M.TeamID , '') LIKE ISNULL(@TeamID1 , '')
		End
		
	Else If @Orders = 02
		Begin
			UPDATE M SET M.Income02 = (Select Isnull(Sum(Isnull(D.Income02,0)),0) From HT340001 D Where D.TransactionID = M.TransactionID)
			FROM HT3400 M 
			WHERE	M.DivisionID = @DivisionID AND M.PayrollMethodID = @PayrollMethodID AND @IsIncome = 1 AND
					M.TranMonth = @TranMonth AND M.TranYear = @TranYear AND 
					M.DepartmentID LIKE @DepartmentID1 AND ISNull(M.TeamID , '') LIKE ISNULL(@TeamID1 , '')
		End
	Else If @Orders = 03
		Begin
			UPDATE M SET M.Income03 = (Select Isnull(Sum(Isnull(D.Income03,0)),0) From HT340001 D Where D.TransactionID = M.TransactionID)
			FROM HT3400 M 
			WHERE	M.DivisionID = @DivisionID AND M.PayrollMethodID = @PayrollMethodID AND @IsIncome = 1 AND
					M.TranMonth = @TranMonth AND M.TranYear = @TranYear AND 
					M.DepartmentID LIKE @DepartmentID1 AND ISNull(M.TeamID , '') LIKE ISNULL(@TeamID1 , '')
		End
	Else If @Orders = 04
		Begin
			UPDATE M SET M.Income04 = (Select Isnull(Sum(Isnull(D.Income04,0)),0) From HT340001 D Where D.TransactionID = M.TransactionID)
			FROM HT3400 M 
			WHERE	M.DivisionID = @DivisionID AND M.PayrollMethodID = @PayrollMethodID AND @IsIncome = 1 AND
					M.TranMonth = @TranMonth AND M.TranYear = @TranYear AND 
					M.DepartmentID LIKE @DepartmentID1 AND ISNull(M.TeamID , '') LIKE ISNULL(@TeamID1 , '')
		End
	Else If @Orders = 05
		Begin
			UPDATE M SET M.Income05 = (Select Isnull(Sum(Isnull(D.Income05,0)),0) From HT340001 D Where D.TransactionID = M.TransactionID)
			FROM HT3400 M 
			WHERE	M.DivisionID = @DivisionID AND M.PayrollMethodID = @PayrollMethodID AND @IsIncome = 1 AND
					M.TranMonth = @TranMonth AND M.TranYear = @TranYear AND 
					M.DepartmentID LIKE @DepartmentID1 AND ISNull(M.TeamID , '') LIKE ISNULL(@TeamID1 , '')
		End
	Else If @Orders = 06
		Begin
			UPDATE M SET M.Income06 = (Select Isnull(Sum(Isnull(D.Income06,0)),0) From HT340001 D Where D.TransactionID = M.TransactionID)
			FROM HT3400 M 
			WHERE	M.DivisionID = @DivisionID AND M.PayrollMethodID = @PayrollMethodID AND @IsIncome = 1 AND
					M.TranMonth = @TranMonth AND M.TranYear = @TranYear AND 
					M.DepartmentID LIKE @DepartmentID1 AND ISNull(M.TeamID , '') LIKE ISNULL(@TeamID1 , '')
		End
	Else If @Orders = 07
		Begin
			UPDATE M SET M.Income07 = (Select Isnull(Sum(Isnull(D.Income07,0)),0) From HT340001 D Where D.TransactionID = M.TransactionID)
			FROM HT3400 M 
			WHERE	M.DivisionID = @DivisionID AND M.PayrollMethodID = @PayrollMethodID AND @IsIncome = 1 AND
					M.TranMonth = @TranMonth AND M.TranYear = @TranYear AND 
					M.DepartmentID LIKE @DepartmentID1 AND ISNull(M.TeamID , '') LIKE ISNULL(@TeamID1 , '')
		End
	Else If @Orders = 08
		Begin
			UPDATE M SET M.Income08 = (Select Isnull(Sum(Isnull(D.Income08,0)),0) From HT340001 D Where D.TransactionID = M.TransactionID)
			FROM HT3400 M 
			WHERE	M.DivisionID = @DivisionID AND M.PayrollMethodID = @PayrollMethodID AND @IsIncome = 1 AND
					M.TranMonth = @TranMonth AND M.TranYear = @TranYear AND 
					M.DepartmentID LIKE @DepartmentID1 AND ISNull(M.TeamID , '') LIKE ISNULL(@TeamID1 , '')                      
		End
	Else If @Orders = 09
		Begin
			UPDATE M SET M.Income09 = (Select Isnull(Sum(Isnull(D.Income09,0)),0) From HT340001 D Where D.TransactionID = M.TransactionID)
			FROM HT3400 M 
			WHERE	M.DivisionID = @DivisionID AND M.PayrollMethodID = @PayrollMethodID AND @IsIncome = 1 AND
					M.TranMonth = @TranMonth AND M.TranYear = @TranYear AND 
					M.DepartmentID LIKE @DepartmentID1 AND ISNull(M.TeamID , '') LIKE ISNULL(@TeamID1 , '')
		End
	Else If @Orders = 10
		Begin
			UPDATE M SET M.Income10 = (Select Isnull(Sum(Isnull(D.Income10,0)),0) From HT340001 D Where D.TransactionID = M.TransactionID)
			FROM HT3400 M 
			WHERE	M.DivisionID = @DivisionID AND M.PayrollMethodID = @PayrollMethodID AND @IsIncome = 1 AND
					M.TranMonth = @TranMonth AND M.TranYear = @TranYear AND 
					M.DepartmentID LIKE @DepartmentID1 AND ISNull(M.TeamID , '') LIKE ISNULL(@TeamID1 , '')
		End
	Else If @Orders = 11
		Begin
			UPDATE M SET M.Income11 = (Select Isnull(Sum(Isnull(D.Income11,0)),0) From HT340001 D Where D.TransactionID = M.TransactionID)
			FROM HT3400 M 
			WHERE	M.DivisionID = @DivisionID AND M.PayrollMethodID = @PayrollMethodID AND @IsIncome = 1 AND
					M.TranMonth = @TranMonth AND M.TranYear = @TranYear AND 
					M.DepartmentID LIKE @DepartmentID1 AND ISNull(M.TeamID , '') LIKE ISNULL(@TeamID1 , '')
		End
	Else If @Orders = 12
		Begin
			UPDATE M SET M.Income12 = (Select Isnull(Sum(Isnull(D.Income12,0)),0) From HT340001 D Where D.TransactionID = M.TransactionID)
			FROM HT3400 M 
			WHERE	M.DivisionID = @DivisionID AND M.PayrollMethodID = @PayrollMethodID AND @IsIncome = 1 AND
					M.TranMonth = @TranMonth AND M.TranYear = @TranYear AND 
					M.DepartmentID LIKE @DepartmentID1 AND ISNull(M.TeamID , '') LIKE ISNULL(@TeamID1 , '')                      
		End
	Else If @Orders = 13
		Begin
			UPDATE M SET M.Income13 = (Select Isnull(Sum(Isnull(D.Income13,0)),0) From HT340001 D Where D.TransactionID = M.TransactionID)
			FROM HT3400 M 
			WHERE	M.DivisionID = @DivisionID AND M.PayrollMethodID = @PayrollMethodID AND @IsIncome = 1 AND
					M.TranMonth = @TranMonth AND M.TranYear = @TranYear AND 
					M.DepartmentID LIKE @DepartmentID1 AND ISNull(M.TeamID , '') LIKE ISNULL(@TeamID1 , '')                      
		End
	Else If @Orders = 14
		Begin
			UPDATE M SET M.Income14 = (Select Isnull(Sum(Isnull(D.Income14,0)),0) From HT340001 D Where D.TransactionID = M.TransactionID)
			FROM HT3400 M 
			WHERE	M.DivisionID = @DivisionID AND M.PayrollMethodID = @PayrollMethodID AND @IsIncome = 1 AND
					M.TranMonth = @TranMonth AND M.TranYear = @TranYear AND 
					M.DepartmentID LIKE @DepartmentID1 AND ISNull(M.TeamID , '') LIKE ISNULL(@TeamID1 , '')                      
		End
	Else If @Orders = 15
		Begin
			UPDATE M SET M.Income15 = (Select Isnull(Sum(Isnull(D.Income15,0)),0) From HT340001 D Where D.TransactionID = M.TransactionID)
			FROM HT3400 M 
			WHERE	M.DivisionID = @DivisionID AND M.PayrollMethodID = @PayrollMethodID AND @IsIncome = 1 AND
					M.TranMonth = @TranMonth AND M.TranYear = @TranYear AND 
					M.DepartmentID LIKE @DepartmentID1 AND ISNull(M.TeamID , '') LIKE ISNULL(@TeamID1 , '')                     
		End
	Else If @Orders = 16
		Begin
			UPDATE M SET M.Income16 = (Select Isnull(Sum(Isnull(D.Income16,0)),0) From HT340001 D Where D.TransactionID = M.TransactionID)
			FROM HT3400 M 
			WHERE	M.DivisionID = @DivisionID AND M.PayrollMethodID = @PayrollMethodID AND @IsIncome = 1 AND
					M.TranMonth = @TranMonth AND M.TranYear = @TranYear AND 
					M.DepartmentID LIKE @DepartmentID1 AND ISNull(M.TeamID , '') LIKE ISNULL(@TeamID1 , '')                      
		End
	Else If @Orders = 17
		Begin
			UPDATE M SET M.Income17 = (Select Isnull(Sum(Isnull(D.Income17,0)),0) From HT340001 D Where D.TransactionID = M.TransactionID)
			FROM HT3400 M 
			WHERE	M.DivisionID = @DivisionID AND M.PayrollMethodID = @PayrollMethodID AND @IsIncome = 1 AND
					M.TranMonth = @TranMonth AND M.TranYear = @TranYear AND 
					M.DepartmentID LIKE @DepartmentID1 AND ISNull(M.TeamID , '') LIKE ISNULL(@TeamID1 , '')                     
		End
	Else If @Orders = 18
		Begin
			UPDATE M SET M.Income18 = (Select Isnull(Sum(Isnull(D.Income18,0)),0) From HT340001 D Where D.TransactionID = M.TransactionID)
			FROM HT3400 M 
			WHERE	M.DivisionID = @DivisionID AND M.PayrollMethodID = @PayrollMethodID AND @IsIncome = 1 AND
					M.TranMonth = @TranMonth AND M.TranYear = @TranYear AND 
					M.DepartmentID LIKE @DepartmentID1 AND ISNull(M.TeamID , '') LIKE ISNULL(@TeamID1 , '')                      
		End
	Else If @Orders = 19
		Begin
			UPDATE M SET M.Income19 = (Select Isnull(Sum(Isnull(D.Income19,0)),0) From HT340001 D Where D.TransactionID = M.TransactionID)
			FROM HT3400 M 
			WHERE	M.DivisionID = @DivisionID AND M.PayrollMethodID = @PayrollMethodID AND @IsIncome = 1 AND
					M.TranMonth = @TranMonth AND M.TranYear = @TranYear AND 
					M.DepartmentID LIKE @DepartmentID1 AND ISNull(M.TeamID , '') LIKE ISNULL(@TeamID1 , '')
		End
	Else If @Orders = 20
		Begin
			UPDATE M SET M.Income20 = (Select Isnull(Sum(Isnull(D.Income20,0)),0) From HT340001 D Where D.TransactionID = M.TransactionID)
			FROM HT3400 M 
			WHERE	M.DivisionID = @DivisionID AND M.PayrollMethodID = @PayrollMethodID AND @IsIncome = 1 AND
					M.TranMonth = @TranMonth AND M.TranYear = @TranYear AND 
					M.DepartmentID LIKE @DepartmentID1 AND ISNull(M.TeamID , '') LIKE ISNULL(@TeamID1 , '')
		End
	Else If @Orders = 21
		Begin
			UPDATE M SET M.Income21 = (Select Isnull(Sum(Isnull(D.Income21,0)),0) From HT340001 D Where D.TransactionID = M.TransactionID)
			FROM HT3400 M 
			WHERE	M.DivisionID = @DivisionID AND M.PayrollMethodID = @PayrollMethodID AND @IsIncome = 1 AND
					M.TranMonth = @TranMonth AND M.TranYear = @TranYear AND 
					M.DepartmentID LIKE @DepartmentID1 AND ISNull(M.TeamID , '') LIKE ISNULL(@TeamID1 , '')
		End
	Else If @Orders = 22
		Begin
			UPDATE M SET M.Income22 = (Select Isnull(Sum(Isnull(D.Income22,0)),0) From HT340001 D Where D.TransactionID = M.TransactionID)
			FROM HT3400 M 
			WHERE	M.DivisionID = @DivisionID AND M.PayrollMethodID = @PayrollMethodID AND @IsIncome = 1 AND
					M.TranMonth = @TranMonth AND M.TranYear = @TranYear AND 
					M.DepartmentID LIKE @DepartmentID1 AND ISNull(M.TeamID , '') LIKE ISNULL(@TeamID1 , '')
		End
	Else If @Orders = 23
		Begin
			UPDATE M SET M.Income23 = (Select Isnull(Sum(Isnull(D.Income23,0)),0) From HT340001 D Where D.TransactionID = M.TransactionID)
			FROM HT3400 M 
			WHERE	M.DivisionID = @DivisionID AND M.PayrollMethodID = @PayrollMethodID AND @IsIncome = 1 AND
					M.TranMonth = @TranMonth AND M.TranYear = @TranYear AND 
					M.DepartmentID LIKE @DepartmentID1 AND ISNull(M.TeamID , '') LIKE ISNULL(@TeamID1 , '')
		End
	Else If @Orders = 24
		Begin
			UPDATE M SET M.Income24 = (Select Isnull(Sum(Isnull(D.Income24,0)),0) From HT340001 D Where D.TransactionID = M.TransactionID)
			FROM HT3400 M 
			WHERE	M.DivisionID = @DivisionID AND M.PayrollMethodID = @PayrollMethodID AND @IsIncome = 1 AND
					M.TranMonth = @TranMonth AND M.TranYear = @TranYear AND 
					M.DepartmentID LIKE @DepartmentID1 AND ISNull(M.TeamID , '') LIKE ISNULL(@TeamID1 , '')
		End
	Else If @Orders = 25
		Begin
			UPDATE M SET M.Income25 = (Select Isnull(Sum(Isnull(D.Income25,0)),0) From HT340001 D Where D.TransactionID = M.TransactionID)
			FROM HT3400 M 
			WHERE	M.DivisionID = @DivisionID AND M.PayrollMethodID = @PayrollMethodID AND @IsIncome = 1 AND
					M.TranMonth = @TranMonth AND M.TranYear = @TranYear AND 
					M.DepartmentID LIKE @DepartmentID1 AND ISNull(M.TeamID , '') LIKE ISNULL(@TeamID1 , '')
		End
	Else If @Orders = 26
		Begin
			UPDATE M SET M.Income26 = (Select Isnull(Sum(Isnull(D.Income26,0)),0) From HT340001 D Where D.TransactionID = M.TransactionID)
			FROM HT3400 M 
			WHERE	M.DivisionID = @DivisionID AND M.PayrollMethodID = @PayrollMethodID AND @IsIncome = 1 AND
					M.TranMonth = @TranMonth AND M.TranYear = @TranYear AND 
					M.DepartmentID LIKE @DepartmentID1 AND ISNull(M.TeamID , '') LIKE ISNULL(@TeamID1 , '')
		End
	Else If @Orders = 27
		Begin
			UPDATE M SET M.Income27 = (Select Isnull(Sum(Isnull(D.Income27,0)),0) From HT340001 D Where D.TransactionID = M.TransactionID)
			FROM HT3400 M 
			WHERE	M.DivisionID = @DivisionID AND M.PayrollMethodID = @PayrollMethodID AND @IsIncome = 1 AND
					M.TranMonth = @TranMonth AND M.TranYear = @TranYear AND 
					M.DepartmentID LIKE @DepartmentID1 AND ISNull(M.TeamID , '') LIKE ISNULL(@TeamID1 , '')
		End
	Else If @Orders = 28
		Begin
			UPDATE M SET M.Income28 = (Select Isnull(Sum(Isnull(D.Income28,0)),0) From HT340001 D Where D.TransactionID = M.TransactionID)
			FROM HT3400 M 
			WHERE	M.DivisionID = @DivisionID AND M.PayrollMethodID = @PayrollMethodID AND @IsIncome = 1 AND
					M.TranMonth = @TranMonth AND M.TranYear = @TranYear AND 
					M.DepartmentID LIKE @DepartmentID1 AND ISNull(M.TeamID , '') LIKE ISNULL(@TeamID1 , '')
		End
	Else If @Orders = 29
		Begin
			UPDATE M SET M.Income29 = (Select Isnull(Sum(Isnull(D.Income29,0)),0) From HT340001 D Where D.TransactionID = M.TransactionID)
			FROM HT3400 M 
			WHERE	M.DivisionID = @DivisionID AND M.PayrollMethodID = @PayrollMethodID AND @IsIncome = 1 AND
					M.TranMonth = @TranMonth AND M.TranYear = @TranYear AND 
					M.DepartmentID LIKE @DepartmentID1 AND ISNull(M.TeamID , '') LIKE ISNULL(@TeamID1 , '')
		End
	Else If @Orders = 30
		Begin
			UPDATE M SET M.Income30 = (Select Isnull(Sum(Isnull(D.Income30,0)),0) From HT340001 D Where D.TransactionID = M.TransactionID)
			FROM HT3400 M 
			WHERE	M.DivisionID = @DivisionID AND M.PayrollMethodID = @PayrollMethodID AND @IsIncome = 1 AND
					M.TranMonth = @TranMonth AND M.TranYear = @TranYear AND 
					M.DepartmentID LIKE @DepartmentID1 AND ISNull(M.TeamID , '') LIKE ISNULL(@TeamID1 , '')
		End
END


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
