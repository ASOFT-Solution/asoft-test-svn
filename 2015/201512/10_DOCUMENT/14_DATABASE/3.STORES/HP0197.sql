IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP0197]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP0197]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

SET NOCOUNT ON
GO
--- Created by: Bảo Anh, date: 04/09/2013
--- Purpose: Tìm kiếm mã lỗi khi quét thẻ
--- Modify on 24/11/2213 by Bảo Anh: Sửa lỗi tìm mã sai khi quét ca đêm
--- Modify on 26/11/2213 by Bảo Anh: Bổ sung load các dòng không lỗi (dùng store này đổ nguồn cho lưới)
--- Modify on 01/12/2213 by Bảo Anh: Bổ sung trường hợp khách hàng không quét ca đêm
--- Modify on 08/12/2213 by Bảo Anh: Sửa lỗi cho trường hợp có ngày không phân ca (TaTung)
--- Modify on 27/12/2213 by Bảo Anh: Bổ sung distinct ShiftCode khi không phải ca đêm
--- Modify on 30/12/2213 by Bảo Anh: Không báo lỗi ngày mà trước đó hoặc sau ngày đó nhân viên không có thông tin chấm công (Thuận Lợi)
--- Modify on 23/01/2015 by Mai Duyen: cai tien toc do
--- Modify on 01/07/2015 by Bảo Anh: cải tiến tốc độ
--- Modify on 30/12/2015 by Tan Phu: Thay doi cau lenh sql tu orderby thanh group --Order by HQ2406.AbsentDate,HQ2406.AbsentCardNo,HQ2406.AbsentTime ->	Group by HQ2406.AbsentDate,HQ2406.AbsentCardNo
--- exec HP0197 @DivisionID=N'CTY',@DepartmentID=N'%',@TranMonth=11,@TranYear=2014,@FromDate='2014-11-01 00:00:00',@ToDate='2014-11-30 00:00:00'

CREATE PROCEDURE [dbo].[HP0197]
				@DivisionID as nvarchar(50),
				@DepartmentID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@FromDate as datetime,
				@ToDate as datetime

AS

--- Tạo bảng @HQ2406 chứa các mã lỗi		
Declare @HQ2406 table
(
	APK uniqueidentifier,
	AbsentCardNo nvarchar(50),
	AbsentDate datetime,
	AbsentTime nvarchar (100)
)
Declare @SQL as varchar(8000)

Set @SQL ='
SELECT     H06.DivisionID, H06.TranMonth, H06.Tranyear, H06.AbsentCardNo, H06.AbsentDate, H06.AbsentTime, H06.MachineCode, H06.IOCode,     
                      H06.InputMethod, H07.EmployeeID, Null as Notes,  
                      Isnull(H06.ShiftCode,CASE Day(AbsentDate)     
                      WHEN 1 THEN H25.D01 WHEN 2 THEN H25.D02 WHEN 3 THEN H25.D03 WHEN 4 THEN H25.D04 WHEN 5 THEN H25.D05 WHEN 6 THEN H25.D06 WHEN    
                       7 THEN H25.D07 WHEN 8 THEN H25.D08 WHEN 9 THEN H25.D09 WHEN 10 THEN H25.D10 WHEN 11 THEN H25.D11 WHEN 12 THEN H25.D12 WHEN    
                       13 THEN H25.D13 WHEN 14 THEN H25.D14 WHEN 15 THEN H25.D15 WHEN 16 THEN H25.D16 WHEN 17 THEN H25.D17 WHEN 18 THEN H25.D18 WHEN    
                       19 THEN H25.D19 WHEN 20 THEN H25.D20 WHEN 21 THEN H25.D21 WHEN 22 THEN H25.D22 WHEN 23 THEN H25.D23 WHEN 24 THEN H25.D24 WHEN    
                       25 THEN H25.D25 WHEN 26 THEN H25.D26 WHEN 27 THEN H25.D27 WHEN 28 THEN H25.D28 WHEN 29 THEN H25.D29 WHEN 30 THEN H25.D30 WHEN    
                       31 THEN H25.D31 ELSE NULL END) as ShiftCode  
FROM         dbo.HT2408 AS H06     
 LEFT OUTER JOIN HT1407 AS H07 ON H07.AbsentCardNo = H06.AbsentCardNo and H07.DivisionID = H06.DivisionID    
 LEFT OUTER JOIN HT1025 AS H25 ON H07.EmployeeID = H25.EmployeeID and H07.DivisionID = H25.DivisionID    
 WHERE  H06.DivisionID = ''' + @DivisionID + ''' AND H25.TranMonth =  H06.TranMonth  AND H25.TranYear = H06.TranYear 
 AND   H06.TranMonth ='+ str(@TranMonth) + ' AND H06.TranYear = ' +  str(@TranYear) + '
 AND (AbsentDate Between '''	+convert(nvarchar(10),@FromDate,101)+ ''' and  '''+convert(nvarchar(10),@ToDate,101)+ ''') '
--print @SQL
IF NOT EXISTS(SELECT name FROM sysobjects WHERE id = Object_id(N'[dbo].[HQ2406A]') AND OBJECTPROPERTY(id, N'IsView') = 1)
    EXEC(' CREATE VIEW HQ2406A AS ' + @SQL)
ELSE
    EXEC(' ALTER VIEW HQ2406A AS ' + @SQL)    
    
--- Nếu là khách hàng cũ, không có quét ca đêm
IF NOT EXISTS (Select top 1 1 From HT1021 Where DivisionID = @DivisionID And Isnull(IsNextDay,0) = 1)
	BEGIN
		INSERT INTO @HQ2406 (AbsentCardNo,AbsentDate,AbsentTime)
		Select HQ2406.AbsentCardNo,HQ2406.AbsentDate,NULL
		From HQ2406A HQ2406
		left join HT1400 on HT1400.DivisionID=HQ2406.DivisionID and HT1400.EmployeeID=HQ2406.EmployeeID
		right join
				(select AbsentCardNo,AbsentDate
				from HQ2406A HQ2406
				where DivisionID = @DivisionID
				And HQ2406.TranMonth=@TranMonth And HQ2406.TranYear = @TranYear
				And CONVERT(DATETIME,CONVERT(varchar(20), LTRIM(RTRIM(AbsentDate)),101),101) BETWEEN CONVERT(datetime,CONVERT(VARCHAR(20), @FromDate, 101)) AND CONVERT(datetime,CONVERT(VARCHAR(20), @ToDate, 101))	  
				Group by AbsentCardNo,EmployeeID,AbsentDate having count(AbsentCardNo)%2<>0 ) as X
		On HQ2406.AbsentCardNo=X.AbsentCardNo and HQ2406.AbsentDate=X.AbsentDate
		where HQ2406.DivisionID = @DivisionID
		And HQ2406.TranMonth=@TranMonth	
		And HQ2406.TranYear=@TranYear	 
		And HT1400.DepartmentID like @DepartmentID
		--Order by HQ2406.AbsentDate,HQ2406.AbsentCardNo,HQ2406.AbsentTime
		Group by HQ2406.AbsentDate,HQ2406.AbsentCardNo
	END
ELSE --- có quét ca đêm
	BEGIN
		--- Insert các mã quét không đầy đủ hoặc quét dư In/Out và không phải ca đêm	 
		INSERT INTO @HQ2406 (AbsentCardNo,AbsentDate,AbsentTime)
		Select AbsentCardNo,AbsentDate,NULL
		From HQ2406A HQ2406
		Where DivisionID = @DivisionID
		And HQ2406.TranMonth=@TranMonth And HQ2406.TranYear = @TranYear
		And CONVERT(DATETIME,CONVERT(varchar(20), LTRIM(RTRIM(AbsentDate)),101),101) BETWEEN CONVERT(datetime,CONVERT(VARCHAR(20), @FromDate, 101)) AND CONVERT(datetime,CONVERT(VARCHAR(20), @ToDate, 101))	  
		Group by DivisionID,AbsentCardNo,EmployeeID,AbsentDate,ShiftCode
		having (count(AbsentCardNo)%2<>0
				and (Isnull((select top 1 1 from HT1021 Where DivisionID = @DivisionID and ShiftID= (case when Isnull(HQ2406.ShiftCode,'') = '' then (Select distinct HQ.ShiftCode from HQ2406A  HQ Where HQ.DivisionID = HQ2406.DivisionID and HQ.AbsentDate = dateadd(day,-1,HQ2406.AbsentDate) and HQ.AbsentCardNo = HQ2406.AbsentCardNo and Isnull(HQ.ShiftCode,'') <> '' and IOCode = 0) else HQ2406.ShiftCode end)
				and DateTypeID = Left(datename(dw,HQ2406.AbsentDate),3) and Isnull(IsNextDay,0)=1),0)=0))
				
		--- Insert các mã là ca đêm	nhưng quét không đầy đủ In/Out
		Union
		Select AbsentCardNo,AbsentDate,AbsentTime
		From HQ2406A HQ2406
		Where DivisionID = @DivisionID
		And HQ2406.TranMonth=@TranMonth And HQ2406.TranYear = @TranYear
		And CONVERT(DATETIME,CONVERT(varchar(20), LTRIM(RTRIM(AbsentDate)),101),101) BETWEEN CONVERT(datetime,CONVERT(VARCHAR(20), @FromDate, 101)) AND CONVERT(datetime,CONVERT(VARCHAR(20), @ToDate, 101))	  
		Group by AbsentCardNo,EmployeeID,AbsentDate,AbsentTime,ShiftCode,IOCOde
		having (---count(AbsentCardNo)%2<>0
		---and 
		(Isnull((select top 1 1 from HT1021 Where DivisionID = @DivisionID and ShiftID=HQ2406.ShiftCode
		and DateTypeID = Left(datename(dw,HQ2406.AbsentDate),3) and Isnull(IsNextDay,0)=1),0)=1))
		and ((sum(IOCode) = 0 and Isnull((select top 1 IOCode From HQ2406A H1 Where H1.AbsentCardNo = HQ2406.AbsentCardNo And H1.AbsentDate = dateadd(day,1,HQ2406.AbsentDate) Order by AbsentTime),1)<>1)
		or (Sum(IOCode) = 1 and Isnull((select top 1 IOCode From HQ2406A H1 Where H1.AbsentCardNo = HQ2406.AbsentCardNo And dateadd(day,1,H1.AbsentDate) = HQ2406.AbsentDate Order by AbsentTime DESC),0)<>0)
		or Isnull((select top 1 1 From HQ2406A H1 Where H1.AbsentCardNo = HQ2406.AbsentCardNo And H1.AbsentDate = HQ2406.AbsentDate And H1.AbsentTime <> HQ2406.AbsentTime And IOCode = HQ2406.IOCode),0) = 1)
	END
	
--- Trả ra các dòng lỗi
SELECT * FROM (
Select HQ2406.AbsentCardNo, HQ2406.AbsentDate, HQ2406.AbsentTime, HQ2406.EmployeeID, HQ2406.MachineCode, HQ2406.ShiftCode, HQ2406.IOCode, HQ2406.Notes,
HV1400.FullName,HV1400.DepartmentName, 1 as IsError
From HQ2406A HQ2406
left join HV1400 on HV1400.DivisionID=HQ2406.DivisionID and HV1400.EmployeeID=HQ2406.EmployeeID and HV1400.DepartmentID like @DepartmentID
right join @HQ2406 X On HQ2406.AbsentCardNo=X.AbsentCardNo and HQ2406.AbsentDate=X.AbsentDate and HQ2406.AbsentTime = Isnull(X.AbsentTime,HQ2406.AbsentTime) 

--- Bổ sung các dòng không lỗi
UNION ALL
Select HQ2406.AbsentCardNo, HQ2406.AbsentDate, HQ2406.AbsentTime, HQ2406.EmployeeID, HQ2406.MachineCode, HQ2406.ShiftCode, HQ2406.IOCode, HQ2406.Notes,
HV1400.FullName,HV1400.DepartmentName, 0 as IsError
From HQ2406A HQ2406
left join HV1400 on HV1400.DivisionID=HQ2406.DivisionID and HV1400.EmployeeID=HQ2406.EmployeeID and HV1400.DepartmentID like @DepartmentID
Where
	NOT EXISTS (Select top 1 1 From @HQ2406 Where AbsentCardNo = HQ2406.AbsentCardNo And convert(varchar(20),AbsentDate,101) = convert(varchar(20),HQ2406.AbsentDate,101)
				and Isnull(AbsentTime,HQ2406.AbsentTime) = HQ2406.AbsentTime)
) A
Order by AbsentDate,AbsentCardNo,AbsentTime

SET NOCOUNT OFF
