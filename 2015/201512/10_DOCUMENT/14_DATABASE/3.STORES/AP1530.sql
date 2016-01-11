IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP1530]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP1530]
GO

---Created by: Nguyen Quoc Huy,    
--- purpose: In bao cao phan bo cong cu dung cu    
---Last edit by: Thuy Tuyen Date: 09/05/2007     
-- Last Edit by Thuy Tuyen  Date  03/02/2009    
--- Last edit B.Anh date 08/03/2010 Sua loi van hien CCDC hong khi khong check vao "Da bao hong"    
---Edit Thuy Tuyen, date 04/05/2010 ,lay them truong ObjectName.    
--- Edited by Bao Anh, date: 08/07/2012  Where them dieu kien VoucherID    
-- Edit by Khanh Van, date 28/06/2013 them dieu kien AnatypeID    
----Modified by Nguyễn Thanh Sơn on 03/10/2013: Thay AT1102.DepartmentName --> AT2018.Ana02Name    
--- Modified by Khanh Van on 13/10/2014: Customize cho Sieu Thanh
--- Modified by Mai Duyen on 22/04/2014: Thay AT2018.Ana02Name->AT1011.AnaName (sua loi double du lieu KH Nguyen Tat thanh)
--- Modified on 15/06/2015 by Bảo Anh: Lọc dữ liệu theo thời gian của niên độ tài chính do nguời dùng định nghĩa
--- Modified on 22/10/2015 by Tiểu Mai: fix dữ liệu: Hao mòn lũy kế không đúng.
/********************************************    
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]    
'********************************************/    
    
CREATE PROCEDURE [dbo].[AP1530]      
    @DivisionID nvarchar(50),    
    @FromMonth as int,    
    @FromYear as int,    
    @ToMonth as int,    
    @ToYear as int,    
    @FromQuarter as int,    
    @ToQuarter as int,    
    @Year as int,    
    @TypeTime as tinyint,  ---0:Thang ,1: Quy, 2:Nam    
    @GroupType as tinyint,  ---  0 la khong nhom    
        ----  1 theo tai khoan chi phi tra truoc    
        ---- 2 theo tai khoan chi phi phan bo    
        ----           3 theo bo phan su dung    
    @Condition  tinyint,    
    @IsFail tinyint     
        
 AS    
    
Declare     
   @FromPeriod as int,    
   @ToPeriod as int,    
   @sSQL as nvarchar(4000),    
   @sSQL1 as nvarchar(4000),    
   @sSQL2 as nvarchar(4000),    
   @sSQL3 as nvarchar(4000), 
   @GroupID as nvarchar(250) ,   
   @CustomerName INT
        
--Tao bang tam de kiem tra day co phai la khach hang Sieu Thanh khong (CustomerName = 16)
CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)
IF @CustomerName = 16 --- Customize Sieu Thanh
	Exec AP1530_ST @DivisionID, @FromMonth, @FromYear, @ToMonth, @ToYear, @FromQuarter, @ToQuarter, @Year, @TypeTime, @GroupType, @Condition, @IsFail
Else
Begin  
    

set @FromPeriod = @FromMonth + @FromYear * 100    
set @ToPeriod = @ToMonth + @ToYear * 100    

Set @GroupID = ''    
If @GroupType = 0     
 Set @GroupID = ''''' as GroupID,  ''''  as GroupName '    
If @GroupType = 1      
 Set @GroupID =' AT1603.CreditAccountID as GroupID, AT1005.AccountName as GroupName '    
If @GroupType = 2     
 Set @GroupID =' AT1603.DebitAccountID as GroupID, AT1005.AccountName as GroupName '    
If @GroupType = 3    
 --Set @GroupID =' AT1603.Ana02ID as GroupID, AT2018.Ana02Name as GroupName'    
 Set @GroupID =' AT1603.Ana02ID as GroupID, A02.AnaName as GroupName'    
     
    
Set @sSQL = '    
SELECT AT1604.DivisionID,    
 At1604.ToolID,    
 Sum(AT1604.DepAmount) as DepAmount,    
 TranMonth,    
 TranYear,    
 (Case when ' + str(@TypeTime) + ' = 0 then     
  ltrim (Rtrim(str(TranMonth))) + ''/'' + Ltrim(Rtrim(str(TranYear)))     
 else Case When ' + str(@TypeTime) + ' = 1 Then     
  (select Quarter from FV9999 Where DivisionID = AT1604.DivisionID and TranMonth = AT1604.TranMonth and TranYear = AT1604.TranYear)    
 else  Ltrim(Rtrim(str(TranYear))) end  end) as MonthYear   
FROM AT1604 Left Join AT1603 on at1603.ToolID = At1604.ToolID and at1603.DivisionID = At1604.DivisionID and AT1603.VoucherID = AT1604.ReVoucherID    
WHERE AT1604.DivisionID like ''' + @DivisionID + '''    
 and AT1603.ToolID = AT1604.ToolID and AT1603.VoucherID = AT1604.ReVoucherID    
 and AT1604.TranMonth + AT1604.Tranyear * 100 between ' + cast(@FromPeriod as nvarchar(10)) + ' and ' + cast(@ToPeriod as nvarchar(10)) + '    
GROUP BY TranMonth, TranYear, At1604.ToolID, AT1604.DivisionID'    
    
--print @sSQL    
If Not Exists (Select 1 From sysObjects Where Name ='AV1531')    
 Exec ('Create view AV1531 as '+@sSQL)    
Else    
 Exec( 'Alter view AV1531 as '+@sSQL)    
     
Set @sSQL1='     
SELECT AT1603.DivisionID,    
 AT1603.ToolID,    
 AT1603.ToolName,     
 (Select top 1 AT9000.VoucherDate     
  From AT9000     
  Where AT9000.VoucherID = AT1603.ReVoucherID and AT9000.DivisionID = AT1603.DivisionID) as VoucherDate,    
 '''' as Unit,    
 AT1603.SerialNo,    
 AT1603.InventoryID,    
 AT1603.CreditAccountID,    
 AT1603.DebitAccountID,    
 AT1603.Ana01ID,    
 AT1011.AnaName as AnaName01ID,     AT1603.Ana02ID,    
 AT1603.Ana03ID,    
 AT1603.ObjectID,    
 AT1202.ObjectName,    
   AT1603.VoucherID,  
 (Case when exists (Select top 1 ToolID     
      From AT1606     
      Where AT1606.ToolID = AT1603.ToolID and AT1606.ReVoucherID = AT1603.VoucherID and AT1606.DivisionID = AT1603.DivisionID    
       and AT1606.TranMonth + 100 * AT1606.TranYear <= ' + str(@ToPeriod) + ')    
 Then (select top 1 AT1606.DepNewPercent      
   From AT1606     
   Where AT1606.ToolID = AT1603.ToolID and AT1606.ReVoucherID = AT1603.VoucherID and AT1606.DivisionID = AT1603.DivisionID    
     and AT1606.TranMonth + 100 * AT1606.TranYear <= ' + str(@ToPeriod) + '    
   Order by AT1606.TranYear Desc,AT1606.TranMonth Desc)    
 Else AT1603.ApportionRate end) as ApportionRate,        
     
 (Case when exists (Select top 1 ToolID     
      From AT1606     
      Where AT1606.ToolID = AT1603.ToolID and AT1606.ReVoucherID = AT1603.VoucherID and AT1606.DivisionID = AT1603.DivisionID    
       and AT1606.TranMonth + 100 * AT1606.TranYear <= ' + str(@ToPeriod)+ ')    
 Then (select top 1 AT1606.DepNewPeriods    
   From AT1606     
   Where AT1606.ToolID = AT1603.ToolID and AT1606.ReVoucherID = AT1603.VoucherID and AT1606.DivisionID = AT1603.DivisionID    
    and AT1606.TranMonth + 100 * AT1606.TranYear <= ' + str(@ToPeriod ) + '    
   Order by AT1606.TranYear Desc,AT1606.TranMonth Desc)    
 Else AT1603.Periods end) as Periods,     
     
 AT1603.MethodID,    
 ActualQuantity as Quantity,    
    
-- Nguyen gia    
 (Case when exists (select top 1 ToolID     
      from AT1606 Where ToolID = AT1603.ToolID and ReVoucherID = AT1603.VoucherID and DivisionID = AT1603.DivisionID    
       and AT1606.TranMonth + 100 * AT1606.TranYear <= ' + str(@ToPeriod) + ')    
 Then (select top 1 AT1606.ConvertedNewAmount    
   From AT1606     
   Where AT1606.ToolID = AT1603.ToolID and AT1606.ReVoucherID = AT1603.VoucherID and AT1606.DivisionID = AT1603.DivisionID    
    and AT1606.TranMonth + 100 * AT1606.TranYear <= ' + str(@ToPeriod) + '    
   Order by AT1606.TranYear Desc,AT1606.TranMonth Desc)    
 Else AT1603.ConvertedAmount end) as ConvertedAmount,     
    
 '    
      
Set @sSQL2=N' '
    set @sSQL3=N'
       
	(Case when exists (select top 1 ToolID from AT1602   
      Where AT1602.ToolID = AT1603.ToolID and at1602.DivisionID = AT1603.DivisionID  
      and AT1603.VoucherID =AT1602.ReVoucherID
			and AT1602.TranMonth + 100*AT1602.TranYear < ' + str(@FromPeriod) + ' ) then 0 else 1 end) as UseStatus,   
 AT1603.Description,     
 AT1603.ReTransactionID,    
 AT1603.ReVoucherID,    
 AT1603.BeginMonth,    
 AT1603.BeginYear,      
 AT1603.Parameter01,    
 AT1603.Parameter02,    
 AT1603.Parameter03,    
 AT1603.Parameter04,    
 AT1603.Parameter05,    
 AT1603.Parameter06,    
 AT1603.Parameter07,    
 AT1603.Parameter08,    
 AT1603.Parameter09,    
 AT1603.Parameter10,
  AT1603.Parameter11,    
 AT1603.Parameter12,    
 AT1603.Parameter13,    
 AT1603.Parameter14,    
 AT1603.Parameter15,    
 AT1603.Parameter16,    
 AT1603.Parameter17,    
 AT1603.Parameter18,    
 AT1603.Parameter19,    
 AT1603.Parameter20,
 --AT1603.VoucherID,    
 Case When IsNull(AT1603.Periods, 0) = 0 then 0     
  Else AT1603.ConvertedAmount/AT1603.Periods    
 End as DepreciatedPeriods,    
     
 AccuDepAmount = isnull(DepPeriod,0)+(Select isnull(sum (DepAmount),0)     
     from AT1604      
     Where AT1604.DivisionID like ''' + @DivisionID + '''     
      and AT1603.ToolID = AT1604.ToolID and AT1603.VoucherID = AT1604.ReVoucherID    
      and AT1604.TranMonth + AT1604.Tranyear * 100 <= ' + cast(@ToPeriod as nvarchar(10)) + ') + (Isnull(AT1603.ConvertedAmount,0)-Isnull(AT1603.ConvertedAmount, AT1603.ApportionAmount)),    
 DepAmount =isnull((Select sum (DepAmount)     
    from AT1604    
    Where AT1604.DivisionID like ''' + @DivisionID+ '''     
     and AT1603.ToolID=AT1604.ToolID and AT1603.VoucherID = AT1604.ReVoucherID    
     and AT1604.TranMonth + AT1604.Tranyear * 100 between ' + cast(@FromPeriod as nvarchar(10)) + ' and ' + cast(@ToPeriod as nvarchar(10)) + '),0),    
 DepreciatedMonths = (select count(*)     
      from (select distinct ToolID, TranMonth, TranYear, ReVoucherID     
        from AT1604    
        Where AT1604.TranMonth + AT1604.TranYear * 100 <= ' + cast(@ToPeriod as nvarchar(10)) + '     
         and isnull(AT1604.DepAmount, 0) > 1     
        ) A     
      where A.ToolID = AT1603.ToolID and A.ReVoucherID = AT1603.VoucherID),' +  @GroupID + ' '    
          
set @sSQL = ' FROM AT1603 Inner join AT1005 on AT1005.DivisionID = AT1603.DivisionID and AT1005.AccountID = ' + case when @GroupType = 1 then 'AT1603.CreditAccountID'     
       else 'AT1603.DebitAccountID' end + '    
  left join AT1102 on  AT1102.DepartmentID = AT1603.Ana02ID and AT1102.DivisionID = AT1603.DivisionID    
  left Join AT1011 on AT1011.DivisionID = AT1603.DivisionID and AT1011.AnaID = AT1603.Ana01ID and AnaTypeID =''A01''    
  left Join AT1011 A02 on A02.DivisionID = AT1603.DivisionID and A02.AnaID = AT1603.Ana02ID and A02.AnaTypeID =''A02''    
  left Join AT1202 on AT1202.DivisionID = AT1603.DivisionID  and AT1202.ObjectID = AT1603.ObjectID     
  --left join AT2018 on AT2018.DivisionID=AT1603.DivisionID and AT2018.Ana02ID=AT1603.Ana02ID    
  left join AT1602 on AT1602.DivisionID = AT1603.DivisionID and AT1602.ToolID = AT1603.ToolID   and     AT1602.ReVoucherID = AT1603.VoucherID  
WHERE AT1603.DivisionID like ''' +  @DivisionID + '''      
 and AT1603.BeginMonth + AT1603.BeginYear * 100 <= ' + str(@ToPeriod) + ''    
    
    
if  @IsFail = 1 and  @Condition = 1    
 Set @SSQL = @sSQL     
if    @IsFail = 0  and  @Condition =1      
 Set @SSQL = @sSQL + ' and (AT1603.VoucherID  not in (Select ReVoucherID From AT1602 Where AT1602.TranMonth + AT1602.TranYear*100 <=' + cast(@ToPeriod as nvarchar(10)) + ' ) ) '    
if    @IsFail =1 and  @Condition =0     
 Set @SSQL = @sSQL  + ' and (AT1603.VoucherID   in (Select ReVoucherID From AT1602 Where AT1602.TranMonth + AT1602.TranYear*100 <=' + cast(@ToPeriod as nvarchar(10)) + ') ) '    
    
    
--Print @sSQL1   
--Print @sSQL2   
--Print @sSQL3   
--print @sSQL
    
If  Exists (Select 1 From sysObjects Where Name ='AV1530')    
 DROP VIEW AV1530    
    
Exec ('Create view AV1530  --Tao boi AP1530    
   as ' + @sSQL1 + @sSQL2+@sSQL3+@sSQL) 
End