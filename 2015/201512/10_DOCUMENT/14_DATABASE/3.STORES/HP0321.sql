IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP0321]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP0321]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
----Created by: Khanh Van
----Created date: 25/10/2013
----purpose: Khai bao tang giam BHXH, BHYT
--- Modify on 10/02/2014 by Bảo Anh: Bổ sung một số trường hợp tăng/giảm theo mẫu mới
--- Modify on 03/08/2014 by Bảo Anh: Sửa lỗi convert ngày tháng thành chuỗi
  
CREATE PROCEDURE [dbo].[HP0321]         
 @DivisionID nvarchar(50),       
 @Status int,        
 @TranMonth int,         
 @TranYear int,         
 @FromDepartmentID nvarchar(50),           
 @ToDepartmentID nvarchar(50),         
 @TeamID nvarchar(50),        
 @EmployeeID nvarchar(50),        
 @Description nvarchar(250)=N'',        
 @CreateUserID nvarchar(50)    
        
AS        
DECLARE @cur_01 cursor ,      
@cur_02 cursor ,      
@cur_03 cursor ,      
@cur_04 cursor ,      
@cur_05 cursor ,      
@cur_06 cursor ,
@cur_07 cursor ,
@cur_08 cursor ,
@OldBaseSalary decimal(28,8),      
@BaseSalary decimal(28,8),      
@Employee nvarchar(50),      
@PreMonthYear int      
      
if(@TranMonth=1)      
 set @PreMonthYear = 12 +(@TranYear-1)*100      
else      
 Set @PreMonthYear = (@TranMonth-1)+(@TranYear*100)       
      
If @Status = 1 or @Status=0    --- tăng lao động  
Begin      
SET @cur_01 = CURSOR SCROLL KEYSET FOR        
SELECT  EmployeeID, BaseSalary       
  FROM HT2461        
  Where (TranMonth +TranYear*100) = (@TranMonth+@TranYear*100) and      
 EmployeeID not in (Select EmployeeID from HT2461 A where A.DivisionID = HT2461.DivisionID and (A.TranMonth+A.TranYear*100) = @PreMonthYear)      
 and DepartmentID between @FromDepartmentID and @ToDepartmentID      
 and isnull(TeamID,'%') like @TeamID       
 And DivisionID = @DivisionID       
 and EmployeeID like @EmployeeID      
OPEN @cur_01        
FETCH NEXT FROM @cur_01 INTO  @Employee, @BaseSalary        
        
WHILE @@FETCH_STATUS = 0        
BEGIN        
 IF not exists (SELECT TOP 1 1 FROM HT0321 WHERE DivisionID = @DivisionID AND  EmployeeID = @Employee and TranMonth = @TranMonth and TranYear=@TranYear)         
	 If ISNULL(@BaseSalary,0) <>0      
	  BEGIN        
	   INSERT INTO HT0321(EmployeeID,  DivisionID,  InsuranceSalary,       
		 TranMonth,TranYear, Status, StatusName, Description,CreateUserID, CreateDate, MonthYearFrom, MonthYearTo)        
		VALUES(@Employee, @DivisionID,   @BaseSalary,  @TranMonth,@TranYear,       
		1,(Select TypeName from HV0321 Where DivisionID = @DivisionID And TypeID = 1),@Description, @CreateUserID, GETDATE(),
		(case when @TranMonth < 10 then '0' else '' end) + ltrim(@TranMonth) + '/' + ltrim(@TranYear), NULL)        
	  END         
         
 FETCH NEXT FROM @cur_01 INTO  @Employee, @BaseSalary        
            
END        
      
End    
      
If @Status = 2 or @Status=0      --- tăng mức đóng
Begin      
SET @cur_02 = CURSOR SCROLL KEYSET FOR        
SELECT  HT2461.EmployeeID, A.BaseSalary, HT2461.BaseSalary       
  FROM HT2461  inner join (Select  DivisionID, EmployeeID, BaseSalary from HT2461 A where A.DivisionID =@DivisionID and (A.TranMonth+A.TranYear*100)=@PreMonthYear)A on HT2461.DivisionID = A.DivisionID and HT2461.EmployeeID=A.EmployeeID      
  Where (HT2461.TranMonth +HT2461.TranYear*100) = (@TranMonth+@TranYear*100)       
  and HT2461.BaseSalary > A.BaseSalary      
 and DepartmentID between @FromDepartmentID and @ToDepartmentID      
 and isnull(TeamID,'%') like @TeamID       
 And HT2461.DivisionID = @DivisionID       
 and HT2461.EmployeeID like @EmployeeID      
OPEN @cur_02        
FETCH NEXT FROM @cur_02 INTO  @Employee, @OldBaseSalary, @BaseSalary        
        
WHILE @@FETCH_STATUS = 0        
BEGIN        
 IF not exists (SELECT TOP 1 1 FROM HT0321 WHERE DivisionID = @DivisionID AND  EmployeeID = @Employee and TranMonth = @TranMonth and TranYear=@TranYear)         
 If ISNULL(@BaseSalary,0) <>0      
  BEGIN        
   INSERT INTO HT0321(EmployeeID,  DivisionID,  OldInsuranceSalary, InsuranceSalary,       
     TranMonth,TranYear, Status, StatusName, Description,CreateUserID, CreateDate, MonthYearFrom, MonthYearTo)        
    VALUES(@Employee, @DivisionID, @OldBaseSalary,  @BaseSalary,  @TranMonth,@TranYear,       
    2,(Select TypeName from HV0321 Where DivisionID = @DivisionID And TypeID = 2),@Description, @CreateUserID, GETDATE(),
    (case when @TranMonth < 10 then '0' else '' end) + ltrim(@TranMonth) + '/' + ltrim(@TranYear), NULL)        
  END         
         
 FETCH NEXT FROM @cur_02 INTO  @Employee, @OldBaseSalary, @BaseSalary        
            
END      
End      
     
If @Status = 3 or @Status=0      --- tăng bảo hiểm y tế
Begin      
SET @cur_03 = CURSOR SCROLL KEYSET FOR        
SELECT  HT2461.EmployeeID, HT2461.BaseSalary       
  FROM HT2461  inner join (Select  DivisionID, EmployeeID, HAmount from HT2461 A where A.DivisionID =@DivisionID and (A.TranMonth+A.TranYear*100)=@PreMonthYear)A on HT2461.DivisionID = A.DivisionID and HT2461.EmployeeID=A.EmployeeID      
  Where (HT2461.TranMonth +HT2461.TranYear*100) = (@TranMonth+@TranYear*100)       
  and HT2461.HAmount > A.HAmount      
 and DepartmentID between @FromDepartmentID and @ToDepartmentID      
 and isnull(TeamID,'%') like @TeamID       
 And HT2461.DivisionID = @DivisionID       
 and HT2461.EmployeeID like @EmployeeID      
OPEN @cur_03        
FETCH NEXT FROM @cur_03 INTO  @Employee, @BaseSalary        
        
WHILE @@FETCH_STATUS = 0        
BEGIN        
 IF not exists (SELECT TOP 1 1 FROM HT0321 WHERE DivisionID = @DivisionID AND  EmployeeID = @Employee and TranMonth = @TranMonth and TranYear=@TranYear)         
 If ISNULL(@BaseSalary,0) <>0      
  BEGIN
	Declare @CFromDate datetime,
			@CToDate datetime
			
	SELECT 	@CFromDate = CFromDate, @CToDate = CToDate
	FROM HT2460 WHERE DivisionID = @DivisionID AND TranMonth = @TranMonth AND TranYear=@TranYear AND EmployeeID = @Employee
   
	INSERT INTO HT0321(EmployeeID,  DivisionID,  InsuranceSalary, TranMonth,TranYear, Status, StatusName,      
						Description,CreateUserID, CreateDate, MonthYearFrom, MonthYearTo)        
	VALUES(@Employee, @DivisionID, @BaseSalary,  @TranMonth,@TranYear,       
	3,(Select TypeName from HV0321 Where DivisionID = @DivisionID And TypeID = 3),@Description, @CreateUserID, GETDATE(),
    case when @CFromDate is null then '' else (case when month(@CFromDate) < 10 then '0' else '' end) + ltrim(month(@CFromDate)) + '/' + ltrim(year(@CFromDate)) end,
    case when @CToDate is null then '' else (case when month(@CToDate) < 10 then '0' else '' end) + ltrim(month(@CToDate)) + '/' + ltrim(year(@CToDate)) end
	)        
  END         
         
 FETCH NEXT FROM @cur_03 INTO  @Employee, @BaseSalary        
            
END      
End     
     
If @Status = 4 or @Status=0      --- tăng bảo hiểm thất nghiệp
Begin      
SET @cur_04 = CURSOR SCROLL KEYSET FOR        
SELECT  HT2461.EmployeeID, HT2461.BaseSalary       
  FROM HT2461  inner join (Select  DivisionID, EmployeeID, TAmount from HT2461 A where A.DivisionID =@DivisionID and (A.TranMonth+A.TranYear*100)=@PreMonthYear)A on HT2461.DivisionID = A.DivisionID and HT2461.EmployeeID=A.EmployeeID      
  Where (HT2461.TranMonth +HT2461.TranYear*100) = (@TranMonth+@TranYear*100)       
  and HT2461.TAmount > A.TAmount      
 and DepartmentID between @FromDepartmentID and @ToDepartmentID      
 and isnull(TeamID,'%') like @TeamID       
 And HT2461.DivisionID = @DivisionID       
 and HT2461.EmployeeID like @EmployeeID      
OPEN @cur_04        
FETCH NEXT FROM @cur_04 INTO  @Employee, @BaseSalary        
        
WHILE @@FETCH_STATUS = 0        
BEGIN        
 IF not exists (SELECT TOP 1 1 FROM HT0321 WHERE DivisionID = @DivisionID AND  EmployeeID = @Employee and TranMonth = @TranMonth and TranYear=@TranYear)         
 If ISNULL(@BaseSalary,0) <>0      
  BEGIN        
   INSERT INTO HT0321(EmployeeID,  DivisionID,  InsuranceSalary,       
     TranMonth,TranYear, Status, StatusName, Description,CreateUserID, CreateDate, MonthYearFrom, MonthYearTo)        
    VALUES(@Employee, @DivisionID, @BaseSalary,  @TranMonth,@TranYear,       
    4,(Select TypeName from HV0321 Where DivisionID = @DivisionID And TypeID = 4),@Description, @CreateUserID, GETDATE(),
    (case when @TranMonth < 10 then '0' else '' end) + ltrim(@TranMonth) + '/' + ltrim(@TranYear), NULL)        
  END         
         
 FETCH NEXT FROM @cur_04 INTO  @Employee, @BaseSalary        
            
END      
End     
        
If @Status = 5 or @Status=0    --- giảm lao động  
Begin      
SET @cur_05 = CURSOR SCROLL KEYSET FOR        
SELECT  HT2461.EmployeeID, HT2461.BaseSalary       
FROM HT2461  inner join HT1400 on HT2461.DivisionID = HT1400.DivisionID and HT2461.EmployeeID = HT1400.EmployeeID       
Where       
  (HT2461.TranMonth +HT2461.TranYear*100) = @PreMonthYear       
  and HT2461.EmployeeID not in (Select A.EmployeeID  from HT2461 A       
         where A.DivisionID = HT2461.DivisionID       
         and (A.TranMonth+A.TranYear*100)=(@TranMonth+@TranYear*100))      
 and HT2461.DepartmentID between @FromDepartmentID and @ToDepartmentID      
 and isnull(HT2461.TeamID,'%') like @TeamID       
 And HT2461.DivisionID = @DivisionID       
 and HT2461.EmployeeID like @EmployeeID      
 and HT1400.EmployeeStatus in (3,9)
OPEN @cur_05        
FETCH NEXT FROM @cur_05 INTO  @Employee, @BaseSalary        
        
WHILE @@FETCH_STATUS = 0        
BEGIN        
 IF not exists (SELECT TOP 1 1 FROM HT0321 WHERE DivisionID = @DivisionID AND  EmployeeID = @Employee and TranMonth = @TranMonth and TranYear=@TranYear)         
 If ISNULL(@BaseSalary,0) <>0      
  BEGIN        
   INSERT INTO HT0321(EmployeeID,  DivisionID,  OldInsuranceSalary,       
     TranMonth,TranYear, Status, StatusName, Description,CreateUserID, CreateDate, MonthYearFrom, MonthYearTo)        
    VALUES(@Employee, @DivisionID,   @BaseSalary,  @TranMonth,@TranYear,       
    5,(Select TypeName from HV0321 Where DivisionID = @DivisionID And TypeID = 5),@Description, @CreateUserID, GETDATE(),
    (case when @TranMonth < 10 then '0' else '' end) + ltrim(@TranMonth) + '/' + ltrim(@TranYear), NULL)          
  END         
         
 FETCH NEXT FROM @cur_05 INTO  @Employee, @BaseSalary        
            
END        
End      
      
If @Status = 6 or @Status=0      --- giảm mức đóng
Begin      
SET @cur_06 = CURSOR SCROLL KEYSET FOR        
SELECT  HT2461.EmployeeID, A.BaseSalary, HT2461.BaseSalary       
  FROM HT2461  inner join (Select  DivisionID, EmployeeID, BaseSalary from HT2461 A where A.DivisionID =@DivisionID and (A.TranMonth+A.TranYear*100)=@PreMonthYear)A on HT2461.DivisionID = A.DivisionID and HT2461.EmployeeID=A.EmployeeID      
  Where (HT2461.TranMonth +HT2461.TranYear*100) = (@TranMonth+@TranYear*100)       
  and HT2461.BaseSalary < A.BaseSalary      
 and DepartmentID between @FromDepartmentID and @ToDepartmentID      
 and isnull(TeamID,'%') like @TeamID       
 And HT2461.DivisionID = @DivisionID       
 and HT2461.EmployeeID like @EmployeeID      
OPEN @cur_06        
FETCH NEXT FROM @cur_06 INTO  @Employee, @OldBaseSalary, @BaseSalary        
        
WHILE @@FETCH_STATUS = 0        
BEGIN        
 IF not exists (SELECT TOP 1 1 FROM HT0321 WHERE DivisionID = @DivisionID AND  EmployeeID = @Employee and TranMonth = @TranMonth and TranYear=@TranYear)         
 If ISNULL(@BaseSalary,0) <>0      
  BEGIN        
   INSERT INTO HT0321(EmployeeID,  DivisionID,  OldInsuranceSalary, InsuranceSalary,       
     TranMonth,TranYear, Status, StatusName, Description,CreateUserID, CreateDate, MonthYearFrom, MonthYearTo)        
    VALUES(@Employee, @DivisionID, @OldBaseSalary,  @BaseSalary,  @TranMonth,@TranYear,       
    6,(Select TypeName from HV0321 Where DivisionID = @DivisionID And TypeID = 6),@Description, @CreateUserID, GETDATE(),
    (case when @TranMonth < 10 then '0' else '' end) + ltrim(@TranMonth) + '/' + ltrim(@TranYear), NULL)         
  END         
         
 FETCH NEXT FROM @cur_06 INTO  @Employee, @OldBaseSalary, @BaseSalary        
            
END      
End      
   
If @Status = 7 or @Status=0      --- giảm bảo hiểm y tế
Begin      
SET @cur_07 = CURSOR SCROLL KEYSET FOR        
SELECT  HT2461.EmployeeID, HT2461.BaseSalary       
  FROM HT2461  inner join (Select  DivisionID, EmployeeID, HAmount from HT2461 A where A.DivisionID =@DivisionID and (A.TranMonth+A.TranYear*100)=@PreMonthYear)A on HT2461.DivisionID = A.DivisionID and HT2461.EmployeeID=A.EmployeeID      
  Where (HT2461.TranMonth +HT2461.TranYear*100) = (@TranMonth+@TranYear*100)       
  and HT2461.HAmount < A.HAmount      
 and DepartmentID between @FromDepartmentID and @ToDepartmentID      
 and isnull(TeamID,'%') like @TeamID       
 And HT2461.DivisionID = @DivisionID       
 and HT2461.EmployeeID like @EmployeeID      
OPEN @cur_07        
FETCH NEXT FROM @cur_07 INTO  @Employee, @BaseSalary        
        
WHILE @@FETCH_STATUS = 0        
BEGIN        
 IF not exists (SELECT TOP 1 1 FROM HT0321 WHERE DivisionID = @DivisionID AND  EmployeeID = @Employee and TranMonth = @TranMonth and TranYear=@TranYear)         
 If ISNULL(@BaseSalary,0) <>0      
  BEGIN        
   INSERT INTO HT0321(EmployeeID,  DivisionID,  InsuranceSalary,       
     TranMonth,TranYear, Status, StatusName, Description,CreateUserID, CreateDate, MonthYearFrom, MonthYearTo)        
    VALUES(@Employee, @DivisionID, @BaseSalary,  @TranMonth,@TranYear,       
    7,(Select TypeName from HV0321 Where DivisionID = @DivisionID And TypeID = 7),@Description, @CreateUserID, GETDATE(),
    (case when @TranMonth < 10 then '0' else '' end) + ltrim(@TranMonth) + '/' + ltrim(@TranYear), NULL)        
  END         
         
 FETCH NEXT FROM @cur_07 INTO  @Employee, @BaseSalary        
            
END      
End   

If @Status = 8 or @Status=0      --- giảm bảo hiểm thất nghiệp
Begin      
SET @cur_08 = CURSOR SCROLL KEYSET FOR        
SELECT  HT2461.EmployeeID, HT2461.BaseSalary       
  FROM HT2461  inner join (Select  DivisionID, EmployeeID, TAmount from HT2461 A where A.DivisionID =@DivisionID and (A.TranMonth+A.TranYear*100)=@PreMonthYear)A on HT2461.DivisionID = A.DivisionID and HT2461.EmployeeID=A.EmployeeID      
  Where (HT2461.TranMonth +HT2461.TranYear*100) = (@TranMonth+@TranYear*100)       
  and HT2461.TAmount < A.TAmount      
 and DepartmentID between @FromDepartmentID and @ToDepartmentID      
 and isnull(TeamID,'%') like @TeamID       
 And HT2461.DivisionID = @DivisionID       
 and HT2461.EmployeeID like @EmployeeID      
OPEN @cur_08        
FETCH NEXT FROM @cur_08 INTO  @Employee, @BaseSalary        
        
WHILE @@FETCH_STATUS = 0        
BEGIN        
 IF not exists (SELECT TOP 1 1 FROM HT0321 WHERE DivisionID = @DivisionID AND  EmployeeID = @Employee and TranMonth = @TranMonth and TranYear=@TranYear)         
 If ISNULL(@BaseSalary,0) <>0      
  BEGIN        
   INSERT INTO HT0321(EmployeeID,  DivisionID,  InsuranceSalary,       
     TranMonth,TranYear, Status, StatusName, Description,CreateUserID, CreateDate, MonthYearFrom, MonthYearTo)        
    VALUES(@Employee, @DivisionID, @BaseSalary,  @TranMonth,@TranYear,       
    8,(Select TypeName from HV0321 Where DivisionID = @DivisionID And TypeID = 8),@Description, @CreateUserID, GETDATE(),
    (case when @TranMonth < 10 then '0' else '' end) + ltrim(@TranMonth) + '/' + ltrim(@TranYear), NULL)        
  END         
         
 FETCH NEXT FROM @cur_08 INTO  @Employee, @BaseSalary        
            
END      
End   
