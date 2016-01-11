IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP03411]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP03411]
GO

----- Created by Khanh Van on 20/12/2013
----- Purpose: Tinh Thue thu nhap ca nhan
--- Modified on 22/05/2015 by Lê Thị Hạnh: Cập nhật @sSQL* dạng NVARCHAR(MAX) và str() = ltrim()
--- Modified on 24/11/2015 by Kim Vũ : Cập nhật lại điều kiện update HT0338( Bổ sung TransactionID vs bảng tạm), Move Phần update HT0338 ra vòng lặp,
---										chỉ thực hiện 1 lần duy nhất khi đã tính toán xong. Bo sung SumAll cung EmployeeID @SQL11
--Exec HP03411 'TH', 9, 2013,	'123'	
					
CREATE PROCEDURE 	[dbo].[HP03411] 	
					@DivisionID as nvarchar(50),   		
					@TranMonth as int, 			
					@TranYear as int,			
					@MethodID as nvarchar(50)	

AS
 Declare @sSQL1 NVARCHAR(MAX) = N'',  
 @sSQL2 NVARCHAR(MAX)= N'',  
 @sSQL3 NVARCHAR(MAX)= N'',  
 @sSQL4 NVARCHAR(MAX)= N'',  
 @sSQL5 NVARCHAR(MAX)= N'',  
 @sSQL6 NVARCHAR(MAX)= N'',  
 @sSQL7 NVARCHAR(MAX)= N'',  
 @sSQL8 NVARCHAR(MAX)= N'',
 @sSQL9 NVARCHAR(MAX)= N'',
 @sSQL10 NVARCHAR(MAX)= N'', 
 @sSQL11 NVARCHAR(MAX) =N''  
  
  
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HTT0337]') AND type in (N'U'))  
DROP TABLE [dbo].[HTT0337]  
  
Create table HTT0337  
(  
 IncomeID nvarchar(50) not null, 
 Coefficient decimal(28,8) NULL
     )
 ON [PRIMARY] 

insert into HTT0337 (IncomeID, Coefficient)   
Select InComeID,Coefficient
From HT0337  
where DivisionID = @DivisionID  
and MethodID = @MethodID  
and IsUsed = 1  
--Xoa tinh thue thu nhap ca nhan trong thang  
Delete HT0338 where DivisionID =@DivisionID and TranMonth =@TranMonth and TranYear = @TranYear  
Delete HT0341 where DivisionID =@DivisionID and TranMonth =@TranMonth and TranYear = @TranYear  
  
-- Xac dinh cac khoan thu nhap giam tru  
Set  @sSQL1 = N'  
Select HT3400.DivisionID, HT3400.TransactionID, HT3400.EmployeeID, HT3400.TranMonth,  HT3400.TranYear,    
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''I01'') then Income01 *(Select Coefficient from HTT0337 where IncomeID = ''I01'') else 0 end) as Income01 ,      
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''I02'') then Income02 * (Select Coefficient from HTT0337 where IncomeID = ''I02'') else 0 end) as Income02,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''I03'') then Income03 *(Select Coefficient from HTT0337 where IncomeID = ''I03'') else 0 end) as Income03,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''I04'') then Income04 *(Select Coefficient from HTT0337 where IncomeID = ''I04'') else 0 end) as Income04,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''I05'') then Income05 *(Select Coefficient from HTT0337 where IncomeID = ''I05'')else 0 end) as Income05,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''I06'') then Income06 *(Select Coefficient from HTT0337 where IncomeID = ''I06'')else 0 end) as Income06,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''I07'') then Income07 *(Select Coefficient from HTT0337 where IncomeID = ''I07'')else 0 end) as Income07,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''I08'') then Income08 *(Select Coefficient from HTT0337 where IncomeID = ''I08'')else 0 end) as Income08,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''I09'') then Income09 *(Select Coefficient from HTT0337 where IncomeID = ''I09'')else 0 end) as Income09,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''I10'') then Income10 *(Select Coefficient from HTT0337 where IncomeID = ''I10'')else 0 end) as Income10,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''I11'') then Income11 *(Select Coefficient from HTT0337 where IncomeID = ''I11'')else 0 end) as Income11,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''I12'') then Income12 *(Select Coefficient from HTT0337 where IncomeID = ''I12'')else 0 end) as Income12,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''I13'') then Income13 *(Select Coefficient from HTT0337 where IncomeID = ''I13'')else 0 end) as Income13,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''I14'') then Income14 *(Select Coefficient from HTT0337 where IncomeID = ''I14'')else 0 end) as Income14,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''I15'') then Income15 *(Select Coefficient from HTT0337 where IncomeID = ''I15'')else 0 end) as Income15,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''I16'') then Income16 *(Select Coefficient from HTT0337 where IncomeID = ''I16'')else 0 end) as Income16,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''I17'') then Income17 *(Select Coefficient from HTT0337 where IncomeID = ''I17'')else 0 end) as Income17,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''I18'') then Income18 *(Select Coefficient from HTT0337 where IncomeID = ''I18'')else 0 end) as Income18,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''I19'') then Income19 *(Select Coefficient from HTT0337 where IncomeID = ''I19'')else 0 end) as Income19,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''I20'') then Income20 *(Select Coefficient from HTT0337 where IncomeID = ''I20'')else 0 end) as Income20,  '
Set  @sSQL2 = N' 
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''I21'') then Income21 *(Select Coefficient from HTT0337 where IncomeID = ''I21'')else 0 end) as Income21,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''I22'') then Income22 *(Select Coefficient from HTT0337 where IncomeID = ''I22'')else 0 end) as Income22,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''I23'') then Income23 *(Select Coefficient from HTT0337 where IncomeID = ''I23'')else 0 end) as Income23,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''I24'') then Income24 *(Select Coefficient from HTT0337 where IncomeID = ''I24'')else 0 end) as Income24,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''I25'') then Income25 *(Select Coefficient from HTT0337 where IncomeID = ''I25'')else 0 end) as Income25,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''I26'') then Income26 *(Select Coefficient from HTT0337 where IncomeID = ''I26'')else 0 end) as Income26,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''I27'') then Income27 *(Select Coefficient from HTT0337 where IncomeID = ''I27'')else 0 end) as Income27,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''I28'') then Income28 *(Select Coefficient from HTT0337 where IncomeID = ''I28'')else 0 end) as Income28,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''I29'') then Income29 *(Select Coefficient from HTT0337 where IncomeID = ''I29'')else 0 end) as Income29,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''I30'') then Income30 *(Select Coefficient from HTT0337 where IncomeID = ''I30'')else 0 end) as Income30,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''S01'') then SubAmount01 *(Select Coefficient from HTT0337 where IncomeID = ''S01'')else 0 end) as SubAmount01,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''S02'') then SubAmount02 *(Select Coefficient from HTT0337 where IncomeID = ''S02'')else 0 end) as SubAmount02,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''S03'') then SubAmount03 *(Select Coefficient from HTT0337 where IncomeID = ''S03'')else 0 end) as SubAmount03,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''S04'') then SubAmount04 *(Select Coefficient from HTT0337 where IncomeID = ''S04'')else 0 end) as SubAmount04,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''S05'') then SubAmount05 *(Select Coefficient from HTT0337 where IncomeID = ''S05'')else 0 end) as SubAmount05,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''S06'') then SubAmount06 *(Select Coefficient from HTT0337 where IncomeID = ''S06'')else 0 end) as SubAmount06,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''S07'') then SubAmount07 *(Select Coefficient from HTT0337 where IncomeID = ''S07'')else 0 end) as SubAmount07, '
Set  @sSQL3 = N'   
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''S08'') then SubAmount08 *(Select Coefficient from HTT0337 where IncomeID = ''S08'')else 0 end) as SubAmount08,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''S09'') then SubAmount09 *(Select Coefficient from HTT0337 where IncomeID = ''S09'')else 0 end) as SubAmount09,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''S10'') then SubAmount10 *(Select Coefficient from HTT0337 where IncomeID = ''S10'')else 0 end) as SubAmount10,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''S11'') then SubAmount11 *(Select Coefficient from HTT0337 where IncomeID = ''S11'')else 0 end) as SubAmount11,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''S12'') then SubAmount12 *(Select Coefficient from HTT0337 where IncomeID = ''S12'')else 0 end) as SubAmount12,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''S13'') then SubAmount13 *(Select Coefficient from HTT0337 where IncomeID = ''S13'')else 0 end) as SubAmount13,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''S14'') then SubAmount14 *(Select Coefficient from HTT0337 where IncomeID = ''S14'')else 0 end) as SubAmount14,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''S15'') then SubAmount15 *(Select Coefficient from HTT0337 where IncomeID = ''S15'')else 0 end) as SubAmount15,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''S16'') then SubAmount16 *(Select Coefficient from HTT0337 where IncomeID = ''S16'')else 0 end) as SubAmount16,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''S17'') then SubAmount17 *(Select Coefficient from HTT0337 where IncomeID = ''S17'')else 0 end) as SubAmount17,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''S18'') then SubAmount18 *(Select Coefficient from HTT0337 where IncomeID = ''S18'')else 0 end) as SubAmount18,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''S19'') then SubAmount19 *(Select Coefficient from HTT0337 where IncomeID = ''S19'')else 0 end) as SubAmount19,  
(Case when Exists(Select 1 from HTT0337 where IncomeID = ''S20'') then SubAmount20 *(Select Coefficient from HTT0337 where IncomeID = ''S20'')else 0 end) as SubAmount20  
 Into #HV3400  
 From HT3400  
 Where DivisionID ='''+@DivisionID+'''   
 and HT3400.TranMonth ='+LTRIM(@TranMonth)+'  
 and HT3400.TranYear ='+LTRIM(@TranYear)+'  
  
'  
-- Sum cac cot neu cung EmployeeID
Set @sSQL11 = N'
select DivisionID,EmployeeID, TranMonth, TranYear, Sum(Income01) as Income01, Sum(Income02) as InCome02,
 Sum(Income03) as InCome03,Sum(Income04) as InCome04,Sum(Income05) as InCome05,Sum(Income06) as InCome06,
 Sum(Income07) as InCome07,Sum(Income08) as InCome08,Sum(Income09) as InCome09,Sum(Income10) as InCome10,
 Sum(Income11) as InCome11,Sum(Income12) as InCome12,Sum(Income13) as InCome13,Sum(Income14) as InCome14,
 Sum(Income15) as InCome15,Sum(Income16) as InCome16,Sum(Income17) as InCome17,Sum(Income18) as InCome18,
 Sum(Income19) as InCome19,Sum(Income20) as InCome20,Sum(Income21) as InCome21,Sum(Income22) as InCome22,
 Sum(Income23) as InCome23,Sum(Income24) as InCome24,Sum(Income25) as InCome25,Sum(Income26) as InCome26,
 Sum(Income27) as InCome27,Sum(Income28) as InCome28,Sum(Income29) as InCome29,Sum(Income30) as InCome30,
 SUM(SubAmount01) as SubAmount01,SUM(SubAmount02) as SubAmount02,SUM(SubAmount03) as SubAmount03,SUM(SubAmount04) as SubAmount04,
 SUM(SubAmount05) as SubAmount05,SUM(SubAmount06) as SubAmount06,SUM(SubAmount07) as SubAmount07,SUM(SubAmount08) as SubAmount08,
 SUM(SubAmount09) as SubAmount09,SUM(SubAmount10) as SubAmount10,SUM(SubAmount11) as SubAmount11,SUM(SubAmount12) as SubAmount12,
 SUM(SubAmount13) as SubAmount13,SUM(SubAmount14) as SubAmount14,SUM(SubAmount15) as SubAmount15,SUM(SubAmount16) as SubAmount16,
 SUM(SubAmount17) as SubAmount17,SUM(SubAmount18) as SubAmount18,SUM(SubAmount19) as SubAmount19,SUM(SubAmount20) as SubAmount20
 into #HV34001
	from #HV3400
	group by DivisionID,EmployeeID, TranMonth, TranYear'

Set  @sSQL4 = N'   
Select *, Isnull(Income01, 0) + Isnull(Income02, 0)  + Isnull(Income03, 0)  + Isnull(Income04, 0)  + Isnull(Income05, 0) +     
 Isnull(Income06, 0) + Isnull(Income07, 0)  + Isnull(Income08, 0)  + Isnull(Income09, 0)  + Isnull(Income10, 0) +    
 Isnull(Income11, 0) + Isnull(Income12, 0)  + Isnull(Income13, 0)  + Isnull(Income14, 0)  + Isnull(Income15, 0) +     
 Isnull(Income16, 0) + Isnull(Income17, 0)  + Isnull(Income18, 0)  + Isnull(Income19, 0)  + Isnull(Income20, 0) +    
 Isnull(Income21, 0) + Isnull(Income22, 0)  + Isnull(Income23, 0)  + Isnull(Income24, 0)  + Isnull(Income25, 0) +    
 Isnull(Income26, 0) + Isnull(Income27, 0)  + Isnull(Income28, 0)  + Isnull(Income29, 0)  + Isnull(Income30, 0) as TotalAmount,   
 Isnull(SubAmount01, 0) + Isnull(SubAmount02, 0)  + Isnull(SubAmount03, 0)  + Isnull(SubAmount04, 0)  + Isnull(SubAmount05, 0) +   Isnull(SubAmount06, 0) + Isnull(SubAmount07, 0)  + Isnull(SubAmount08, 0)  + Isnull(SubAmount09, 0)  + Isnull(SubAmount10, 0
) +    Isnull(SubAmount11, 0) + Isnull(SubAmount12, 0)  + Isnull(SubAmount13, 0)  + Isnull(SubAmount14, 0)  + Isnull(SubAmount15, 0) +   Isnull(SubAmount16, 0) + Isnull(SubAmount17, 0)  + Isnull(SubAmount18, 0)  + Isnull(SubAmount19, 0)  + Isnull(SubAmount20, 0)     
 as TotalSubAmount    
 Into #HV3401  
 From #HV34001 HV3400  
 Where DivisionID ='''+@DivisionID+'''   
'  
  
-- Tinh thue thu nhap ca nhan  
DECLARE @TaxStepID AS NVARCHAR(50),    
  @TaxCur CURSOR,    
  @Orders int,    
  @FromSalary decimal(28,8),    
  @ToSalary decimal(28,8),     
  @TempSalary decimal(28,8),  
  @Rate decimal(28,8)  ,  
  @ReduceUnit decimal(28,8)  
      
SET @ReduceUnit  = (SELECT UnitAmount FROM HT0336 WHERE MethodID = @MethodID AND DivisionID = @DivisionID)   
SET @TaxStepID  = (SELECT TaxStepID FROM HT0336 WHERE MethodID = @MethodID AND DivisionID = @DivisionID)   
Set  @sSQL5 = N'  
Insert into HT0338 (DivisionID, TransactionID, EmployeeID, TranMonth,  TranYear,TotalAmount, IncomeAmount, TaxReducedAmount, IncomeTax)  
Select HV3401.DivisionID,(select top 1 TransactionID from #HV3400 A where A.EmployeeID = HV3401.EmployeeID) as TransactionID, EmployeeID, TranMonth,  TranYear,TotalAmount, TotalAmount-TotalSubAmount,isnull(( Select Count(Ht0334.transactionID) From HT0334 where HV3401.DivisionID = HT0334.DivisionID and HV3401.EmployeeID = HT0334.EmployeeID and HT0334.Status = 0 ),0)*'+LTRIM(@ReduceUnit)+' ,0  
From #HV3401 HV3401 inner join HT0332 on HV3401.DivisionID = HT0332.DivisionID   
where TaxStepID ='''+@TaxStepID+'''  
and Orders =1  
and TotalAmount-TotalSubAmount >= FromSalary'   
  
SET @TaxCur = CURSOR SCROLL KEYSET FOR    
SELECT Orders,FromSalary,ToSalary , Rate     
FROM HT0332     
WHERE TaxStepID = @TaxStepID  AND DivisionID = @DivisionID ORDER BY Orders     
OPEN @TaxCur    
FETCH NEXT FROM @TaxCur INTO @Orders,@FromSalary,@ToSalary , @Rate    
  
SET @sSQL6 = N'    
 SELECT DivisionID, TransactionID, EmployeeID, TranMonth,  TranYear,TotalAmount, isnull(IncomeTax,0) as IncomeTax, IncomeAmount, IncomeAmount -TaxReducedAmount as Remain, 0 as status     
 INTO #Temp1    
 FROM HT0338   
 Where DivisionID ='''+@DivisionID+'''   
 and HT0338.TranMonth ='+LTRIM(@TranMonth)+'  
 and HT0338.TranYear ='+LTRIM(@TranYear)+'  
  
 '    
WHILE @@Fetch_Status = 0    
BEGIN    
 If (@ToSalary = -1)   
 Set  @ToSalary = 999999999   
  
 SET @sSQL7 = @sSQL7+N'    
 SELECT DivisionID, TransactionID, EmployeeID, TranMonth, TranYear, IncomeAmount, IncomeTax 
 INTO #Sum'+CONVERT(VARCHAR(1),@Orders)+'    
 FROM #Temp1       
 where Remain between '+LTRIM(@FromSalary)+' and '+LTRIM(@ToSalary)+'    
 '  
 SET @sSQL8=@sSQL8+ N'  
 UPDATE T  
 Set T.IncomeTax =T.IncomeTax + 0,  
 T.Status =1  
 FROM #SUM'+CONVERT(VARCHAR(1),@Orders)+' S inner join #Temp1 T    
 ON S.EmployeeID = T.EmployeeID   
 where T.Remain <= '+LTRIM(@FromSalary)+'  
   
 UPDATE T  
 Set T.IncomeTax = T.IncomeTax+(((T.Remain -'+LTRIM(@FromSalary)+')*'+LTRIM(@Rate)+')/100),  
 T.Status =1  
 FROM #SUM'+CONVERT(VARCHAR(1),@Orders)+' S inner join #Temp1 T    
 ON S.EmployeeID = T.EmployeeID   
 Where T.Remain between '+LTRIM(@FromSalary)+' and '+LTRIM(@ToSalary)+'   
   
UPDATE T  
 Set T.IncomeTax = T.IncomeTax+ ((('+LTRIM(@ToSalary)+'-'+LTRIM(@FromSalary)+')/100)*'+LTRIM(@Rate)+')  
 FROM #Temp1 T    
 Where T.Remain >='+LTRIM(@ToSalary)+'    '
 
FETCH NEXT FROM @TaxCur INTO @Orders,@FromSalary,@ToSalary , @Rate    
End 

SET @sSQL9=@sSQL9+ N'     
 Update HT0338  
 Set HT0338.IncomeTax = T.IncomeTax  
 From HT0338 inner join #Temp1 T on HT0338.DivisionID = T.DivisionID and HT0338.EmployeeID = T.EmployeeID  and HT0338.TransactionID = T.TransactionID
 Where HT0338.DivisionID ='''+@DivisionID+'''   
 and HT0338.TranMonth ='+LTRIM(@TranMonth)+'  
 and HT0338.TranYear ='+LTRIM(@TranYear)+'  
 and T.Status =1  
 '  
    
Set  @sSQL10 = 
N'Insert into HT0341 (DivisionID,TransactionID,EmployeeID,TranMonth,TranYear,Income01,Income02,Income03,Income04,Income05,Income06,Income07,Income08,Income09,Income10,Income11,Income12,Income13,Income14,Income15,Income16,Income17,Income18,Income19,Income20,Income21,Income22,Income23,Income24,Income25,Income26,Income27,Income28,Income29,Income30,SubAmount01,SubAmount02,SubAmount03,SubAmount04,SubAmount05,SubAmount06,SubAmount07,SubAmount08,SubAmount09,SubAmount10,SubAmount11,SubAmount12,SubAmount13,SubAmount14,SubAmount15,SubAmount16,SubAmount17,SubAmount18,SubAmount19,SubAmount20)
Select DivisionID,TransactionID,EmployeeID,TranMonth,TranYear,Income01,Income02,Income03,Income04,Income05,Income06,Income07,Income08,Income09,Income10,Income11,Income12,Income13,Income14,Income15,Income16,Income17,Income18,Income19,Income20,Income21,Income22,Income23,Income24,Income25,Income26,Income27,Income28,Income29,Income30,SubAmount01,SubAmount02,SubAmount03,SubAmount04,SubAmount05,SubAmount06,SubAmount07,SubAmount08,SubAmount09,SubAmount10,SubAmount11,SubAmount12,SubAmount13,SubAmount14,SubAmount15,SubAmount16,SubAmount17,SubAmount18,SubAmount19,SubAmount20 from #HV3400 where EmployeeID in (select EmployeeID from HT0338 where DivisionID ='''+@DivisionID+''' and TranMonth ='+LTRIM(@TranMonth)+' and TranYear = '+LTRIM(@TranYear)+')'

Exec (@sSql1+@sSql2+@sSql3+@sSQL11+@sSql4+@sSql5+@sSql6+@sSQl7+@sSQL8+@sSQL9+@sSQL10)  
