IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP1530_ST]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP1530_ST]
GO

---Created by: Khánh Vân: Customize cho Siêu Thanh on 13/01/2014    
  
    
CREATE PROCEDURE [dbo].[AP1530_ST]      
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
   @GroupID as nvarchar(250)    
    
    
If (@TypeTime = 0)     
  Begin    
 set @FromPeriod = @FromMonth + @FromYear * 100    
 set @ToPeriod = @ToMonth + @ToYear * 100    
  end    
else    
  IF (@TypeTime = 1)    
   begin    
    set @FromPeriod = (@FromQuarter * 3 - 2) + @FromYear * 100    
    set @ToPeriod = (@ToQuarter * 3) + @ToYear * 100    
   end    
  else    
   begin    
    set @FromPeriod = 1 + @Year * 100    
    set @ToPeriod = 12 + @Year * 100    
   end    
Set @GroupID = ''    
If @GroupType = 0     
 Set @GroupID = ''''' as GroupID,  ''''  as GroupName '    
If @GroupType = 1      
 Set @GroupID =' AT1603.CreditAccountID as GroupID, AT1005.AccountName as GroupName '    
If @GroupType = 2     
 Set @GroupID =' AT1603.DebitAccountID as GroupID, AT1005.AccountName as GroupName '    
If @GroupType = 3    
 Set @GroupID =' AT1603.Ana02ID as GroupID, AT2018.Ana02Name as GroupName'    
     
    
Set @sSQL = '    
SELECT AT1604.DivisionID,    
 At1604.ToolID,    
 Sum(AT1604.DepAmount) as DepAmount,    
 TranMonth,    
 TranYear,    
 (Case when ' + str(@TypeTime) + ' = 0 then     
  ltrim (Rtrim(str(TranMonth))) + ''/'' + Ltrim(Rtrim(str(TranYear)))     
 else Case When ' + str(@TypeTime) + ' = 1 Then     
  (''0'' + ltrim(rtrim(Case when TranMonth %3 = 0 then TranMonth/3      
 Else TranMonth/3+1 End)) + ''/'' + ltrim(Rtrim(str(TranYear))))     
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
    
 --So dau ky      
 Isnull((Case when exists (select top 1 AT1606.ToolID     
      from AT1606     
      Where AT1606.ToolID = AT1603.ToolID     
       and AT1606.ReVoucherID = AT1603.VoucherID     
       and AT1606.DivisionID = AT1603.DivisionID    
       and AT1606.TranMonth + 100 * AT1606.TranYear < ' + str(@FromPeriod) + '    
       and (isnull(AT1602.VoucherDate,'''')='''' or AT1602.TranMonth+100*AT1602.TranYear>=' + str(@FromPeriod) + '))    
 Then (select top 1 AT1606.ConvertedNewAmount    
   From AT1606     
   Where AT1606.ToolID = AT1603.ToolID     
    and AT1606.ReVoucherID = AT1603.VoucherID     
    and AT1606.DivisionID = AT1603.DivisionID    
    and AT1606.TranMonth + 100 * AT1606.TranYear < ' + str(@FromPeriod) + '    
   Order by AT1606.TranYear Desc,AT1606.TranMonth Desc)    
 Else (Select TOP 1 AT03.ConvertedAmount     
   From AT1603 AT03 left join AT9000 on AT03.DivisionID = AT9000.DivisionID and AT03.RevoucherID = AT9000.VoucherID    
   Where AT03.ToolID = AT1603.ToolID and AT03.DivisionID = AT1603.DivisionID   and   AT03.VoucherID = AT1603.VoucherID 
   and (Case when (isnull(AT03.RevoucherID,'''')='''' or transactiontypeID = ''T00'' )then (Month(AT1603.CreateDate) + Year(AT1603.CreateDate)*100) else (AT9000.TranMonth+AT9000.TranYear*100) end) < ' + str(@FromPeriod) + '     
   and (isnull(AT1602.VoucherDate,'''')='''' or AT1602.TranMonth+100*AT1602.TranYear>=' + str(@FromPeriod) + ')) end),0) as BeConvertedAmount, '    
     
 print @sSQL1        
Set @sSQL2=N'     
    
    
 --Tang trong ky      
	Isnull((Case when exists (select top 1 AT1606.ToolID 
						from AT1606 
						Where AT1606.ToolID = AT1603.ToolID 
							and AT1606.ReVoucherID = AT1603.VoucherID 
							and AT1606.DivisionID = AT1603.DivisionID
							and AT1606.ConvertedOldAmount < AT1606.ConvertedNewAmount
							and AT1606.TranMonth + 100 * AT1606.TranYear between ' + str(@FromPeriod) + ' and  ' + str(@ToPeriod) + ' )
	Then (select sum(AT1690.ConvertedAmount)
			From AT1606 inner join AT1690 on AT1690.DivisionID = AT1606.DivisionID 
			and AT1690.VoucherID = AT1606.RevaluateID
			Where AT1606.ToolID = AT1603.ToolID 
				and AT1606.ReVoucherID = AT1603.VoucherID 
				and AT1606.DivisionID = AT1603.DivisionID
				and AT1606.TranMonth + 100 * AT1606.TranYear between ' + str(@FromPeriod) + ' and ' + str(@ToPeriod) + ')
 Else (Select AT03.ConvertedAmount     
   From AT1603 AT03 left join AT9000 on AT03.DivisionID = AT9000.DivisionID and AT03.RevoucherID = AT9000.VoucherID and AT03.CreditAccountID = AT9000.DebitAccountID    
   Where AT03.ToolID = AT1603.ToolID and AT03.DivisionID = AT1603.DivisionID   and AT03.voucherID = AT1603.voucherID 
   and (Case when( isnull(AT03.RevoucherID,'''')='''' or transactiontypeID = ''T00'') then (Month(AT1603.CreateDate) + Year(AT1603.CreateDate)*100) else (AT9000.TranMonth+AT9000.TranYear*100) end) between ' + str(@FromPeriod) + ' and ' + str(@ToPeriod) + 
')end),0) as DeConvertedAmount,    
    
    
    
    
--Giam trong ky      
		Isnull((Case when exists (select top 1 ToolID    from AT1602   
      Where AT1602.ToolID = AT1603.ToolID and at1602.DivisionID = AT1603.DivisionID  
      and AT1603.VoucherID =AT1602.ReVoucherID
			and AT1602.TranMonth + 100*AT1602.TranYear between ' + str(@FromPeriod) + ' and ' + str(@ToPeriod) + ') 
	Then AT1603.ConvertedAmount   
	When exists (select top 1 AT1606.ToolID 
						from AT1606 
						Where AT1606.ToolID = AT1603.ToolID 
							and AT1606.ReVoucherID = AT1603.VoucherID 
							and AT1606.DivisionID = AT1603.DivisionID
							and AT1606.ConvertedOldAmount > AT1606.ConvertedNewAmount
							and AT1606.TranMonth + 100 * AT1606.TranYear between ' + str(@FromPeriod) + ' and  ' + str(@ToPeriod) + ' )
	Then (select sum(AT1690.ConvertedAmount)
			From AT1606 inner join AT1690 on AT1690.DivisionID = AT1606.DivisionID 
			and AT1690.VoucherID = AT1606.RevaluateID
			Where AT1606.ToolID = AT1603.ToolID 
				and AT1606.ReVoucherID = AT1603.VoucherID 
				and AT1606.DivisionID = AT1603.DivisionID
				and AT1606.TranMonth + 100 * AT1606.TranYear between ' + str(@FromPeriod) + ' and ' + str(@ToPeriod) + ')					
    Else 0 end ),0) as CrConvertedAmount,    '
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
     
 AccuDepAmount = (Select isnull(sum (DepAmount),0)     
     from AT1604      
     Where AT1604.DivisionID like ''' + @DivisionID + '''     
      and AT1603.ToolID = AT1604.ToolID and AT1603.VoucherID = AT1604.ReVoucherID    
      and AT1604.TranMonth + AT1604.Tranyear * 100 <= ' + cast(@ToPeriod as nvarchar(10)) + '),    
 DepAmount =isnull((Select sum (DepAmount)     
    from AT1604    
    Where AT1604.DivisionID like ''' + @DivisionID+ '''     
     and AT1603.ToolID=AT1604.ToolID and AT1603.VoucherID = AT1604.ReVoucherID    
     and AT1604.TranMonth + AT1604.Tranyear * 100 between ' + cast(@FromPeriod as nvarchar(10)) + ' and ' + cast(@ToPeriod as nvarchar(10)) + '),0),    
 DepreciatedMonths = isnull(DepPeriod,0)+(select count(*)     
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
  left Join AT1202 on AT1202.DivisionID = AT1603.DivisionID  and AT1202.ObjectID = AT1603.ObjectID     
  left join AT2018 on AT2018.DivisionID=AT1603.DivisionID and AT2018.Ana02ID=AT1603.Ana02ID    
  left join AT1602 on AT1602.DivisionID = AT1603.DivisionID and AT1602.ToolID = AT1603.ToolID   and     AT1602.ReVoucherID = AT1603.VoucherID  
WHERE AT1603.DivisionID like ''' +  @DivisionID + '''      
 and AT1603.BeginMonth + AT1603.BeginYear * 100 <= ' + str(@ToPeriod) + ''    
    
    
if  @IsFail = 1 and  @Condition = 1    
 Set @SSQL = @sSQL     
if    @IsFail = 0  and  @Condition =1      
 Set @SSQL = @sSQL + ' and (AT1603.VoucherID  not in (Select ReVoucherID From AT1602 Where AT1602.DivisionID=''' +  @DivisionID + ''' AND AT1602.TranMonth + AT1602.TranYear*100 <=' + cast(@ToPeriod as nvarchar(10)) + ' ) ) '    
if    @IsFail =1 and  @Condition =0     
 Set @SSQL = @sSQL  + ' and (AT1603.VoucherID   in (Select ReVoucherID From AT1602 Where AT1602.DivisionID=''' +  @DivisionID + ''' AND AT1602.TranMonth + AT1602.TranYear*100 <=' + cast(@ToPeriod as nvarchar(10)) + ') ) '    
    
    
--Print @sSQL    
    
If  Exists (Select 1 From sysObjects Where Name ='AV1530')    
 DROP VIEW AV1530    
     
    
Exec ('Create view AV1530  --Tao boi AP1530    
   as ' + @sSQL1 + @sSQL2+@sSQL3+@sSQL) 