------ Created by Nguyen Van Nhan, Date 23/12/2004    
----- Purpose: Tinh phan bo chi phi cong cu dung cu    
----- Edit by: Nguyen Quoc Huy, Date 14/07/2009 (Thay doi nguyen gia CCDC)    
---- Last  Edit : Tuyen. date 11/02/2009    
---- Edit by B.Anh  date 08/03/2010 Sua loi DepAmount lay khong dung khi phan bo deu    
---- Edit by Bao Anh Date: 08/07/2012 Purpose: Where them dieu kien VoucherID    
---- Edit by Khanh Van on 17/10/2013: Sua loi phan bo khong dung  
---- Edit by Khanh Van on 13/01/2014: Sua cach lay so ky da phan bo
---- Edit by Bao Anh Date on 23/04/2014: Khi phân bổ đều, nếu giá trị phân bổ là NULL thì tự tính dựa vào giá trị còn lại và số kỳ phân bổ còn lại
/**********************************************    
** Edited by: [GS] [Cẩm Loan] [29/07/2010]    
** Edited by: [GS] [Thanh Tùng] [25/11/2010]    
***********************************************/ 
---- Modified on 08/10/2015 by Tieu Mai: Sửa phần làm tròn số lẻ theo thiết lập đơn vị-chi nhánh
   
    
alter PROCEDURE [dbo].[AP1605] @DivisionID as nvarchar(50),     
    @TranMonth as int,     
    @TranYear as int,    
    @VoucherTypeID nvarchar(50),     
    @VoucherNo as nvarchar(50),     
    @VoucherDate as Datetime,    
    @BDescription as nvarchar(250),    
    @UserID nvarchar(50)    
AS    
    
    
Declare  @Tool_cur as Cursor,    
  @ToolID as nvarchar(50),    
  @ConvertedAmount as decimal(28,8), --- Nguyen gia    
  @TotalDepAmount as decimal(28,8),    
  @RemainAmount as decimal(28,8),    
  @Ana01ID as nvarchar(50),    
  @Ana02ID as nvarchar(50),    
  @Ana03ID as nvarchar(50),    
  @CreditAccountID As nvarchar(50),    
  @DebitAccountID as  nvarchar(50),    
  @MethodID as tinyint,    
  @ObjectID as nvarchar(50),    
  @ApportionRate as decimal(28,8),    
  @ApportionAmount as decimal(28,8),    
  @Periods as int,     
  @DepPeriod as int,    
  @BeginMonth as int,    
  @BeginYear as int,    
  @ConvertedDecimals as tinyint,    
  @DepAmount as decimal(28,8),    
  @DepType as tinyint,    
  @TempDepAmount as decimal(28,8),    
  @DepreciationID as nvarchar(50),     
  @VoucherID AS NVARCHAR(50)    
    
Set @ConvertedDecimals = (select top 1 ConvertedDecimals From AT1101 WHERE DivisionID = @DivisionID)    
    
SET @Tool_cur = Cursor Scroll KeySet FOR     
 Select   ToolID,     
   (Case when exists (Select top 1 ToolID From AT1606 Where AT1606.ToolID = AT1603.ToolID AND AT1606.ReVoucherID = AT1603.VoucherID and AT1606.DivisionID = AT1603.DivisionID    
      and AT1606.TranMonth + 100*AT1606.TranYear <= @TranMonth +  100*@TranYear)    
     Then  (select top 1 AT1606.ConvertedNewAmount  From AT1606     
      Where AT1606.ToolID = AT1603.ToolID AND AT1606.ReVoucherID = AT1603.VoucherID and AT1606.DivisionID = AT1603.DivisionID    
      and AT1606.TranMonth + 100*AT1606.TranYear <=  @TranMonth +  100*@TranYear  Order by AT1606.TranYear Desc,AT1606.TranMonth Desc )    
    Else AT1603.ConvertedAmount end) as ConvertedAmount,    
     CreditAccountID, DebitAccountID,MethodID,     
     (Case when exists (Select top 1 ToolID From AT1606 Where AT1606.ToolID = AT1603.ToolID AND AT1606.ReVoucherID = AT1603.VoucherID and AT1606.DivisionID = AT1603.DivisionID    
      and AT1606.TranMonth + 100*AT1606.TranYear <= @TranMonth +  100*@TranYear)    
     Then      
      (select top 1 AT1606.DepNewPercent  From AT1606     
      Where AT1606.ToolID = AT1603.ToolID AND AT1606.ReVoucherID = AT1603.VoucherID and AT1606.DivisionID = AT1603.DivisionID    
      and AT1606.TranMonth + 100*AT1606.TranYear <=  @TranMonth +  100*@TranYear  Order by AT1606.TranYear Desc,AT1606.TranMonth Desc )    
     Else AT1603.ApportionRate end) as ApportionRate,     
       
      (Case when exists (Select top 1 ToolID From AT1606 Where AT1606.ToolID = AT1603.ToolID AND AT1606.ReVoucherID = AT1603.VoucherID and AT1606.DivisionID = AT1603.DivisionID    
      and AT1606.TranMonth + 100*AT1606.TranYear <= @TranMonth +  100*@TranYear)    
     Then      
      (select top 1 AT1606.DepNewAmount  From AT1606     
      Where AT1606.ToolID = AT1603.ToolID AND AT1606.ReVoucherID = AT1603.VoucherID and AT1606.DivisionID = AT1603.DivisionID    
      and AT1606.TranMonth + 100*AT1606.TranYear <=  @TranMonth +  100*@TranYear  Order by AT1606.TranYear Desc,AT1606.TranMonth Desc )    
     Else AT1603.ApportionAmount end) as ApportionAmount,     
       
   (Case when exists (Select top 1 ToolID From AT1606 Where AT1606.ToolID = AT1603.ToolID AND AT1606.ReVoucherID = AT1603.VoucherID and AT1606.DivisionID = AT1603.DivisionID    
      and AT1606.TranMonth + 100*AT1606.TranYear <= @TranMonth +  100*@TranYear)    
     Then      
      (select top 1 AT1606.DepNewPeriods  From AT1606     
      Where AT1606.ToolID = AT1603.ToolID AND AT1606.ReVoucherID = AT1603.VoucherID and AT1606.DivisionID = AT1603.DivisionID    
      and AT1606.TranMonth + 100*AT1606.TranYear <=  @TranMonth +  100*@TranYear  Order by AT1606.TranYear Desc,AT1606.TranMonth Desc )    
     Else AT1603.Periods end) as Periods,     
    
   BeginMonth, BeginYear, Ana01ID, Ana02ID, Ana03ID, ObjectID, VoucherID, isnull(DepPeriod,0) as DepPeriod  
 From  AT1603    
 Where  DivisionID = @DivisionID and    
  (BeginMonth + BeginYear*100)<= (@TranMonth + @TranYear*100) and     
  IsUsed =0 and    
  VoucherID not in (select ReVoucherID From AT1604 Where DivisionID = @DivisionID and TranMonth= @TranMonth and TranYear = @TranYear)    
   and VoucherID not in (select ReVoucherID From AT1602 Where DivisionID = @DivisionID and TranMonth + TranYear*100 < =  @TranMonth + @TranYear*100)    
      
OPEN @Tool_cur    
FETCH NEXT FROM @Tool_cur INTO  @ToolID, @ConvertedAmount, @CreditAccountID, @DebitAccountID, @MethodID, @ApportionRate, @ApportionAmount, @Periods,    
     @BeginMonth, @BeginYear, @Ana01ID, @Ana02ID, @Ana03ID, @ObjectID, @VoucherID, @DepPeriod  
    
WHILE @@Fetch_Status = 0    
 Begin     
  Set @DepAmount =0    
  ----- Bao CCDC bi hong    
  IF Exists (Select top 1 1 From AT1602 Where ToolID= @ToolID AND ReVoucherID = @VoucherID and TranMonth = @TranMonth and TranYear = @TranYear and  DivisionID =@DivisionID )    
  BEGIN    
     Set @DepType = 2      
     Set @DepAmount = @ConvertedAmount -  isnull((Select Round(Sum(DepAmount),@ConvertedDecimals) From AT1604 Where DivisionID =@DivisionID and ToolID =@ToolID AND ReVoucherID = @VoucherID),0)    
  END    
  ELSE    
    
  IF (@MethodID =0 and @DepPeriod<>1)---- Phan bo 02 lan    
  BEGIN    
  
    If exists ( select top 1 1 from AT1604  Where DivisionID =@DivisionID and ToolID =@ToolID AND ReVoucherID = @VoucherID)    
     Begin    
      Set @DepType = 0 -- Phan bo lan hai       
      Set @DepAmount =  @ConvertedAmount -  isnull((Select Round(Sum(DepAmount),@ConvertedDecimals) From AT1604 Where DivisionID =@DivisionID and ToolID =@ToolID AND ReVoucherID = @VoucherID),0)    
     End    
    Else    
         
     Begin    
      Set @DepType = 0                 
      Set @DepAmount = Round(@ApportionAmount,@ConvertedDecimals)    
     End    
  END    
  ELSE    
  IF (@MethodID =0 and @DepPeriod=1)---- Phan bo 02 lan    
  BEGIN    
  
      Set @DepType = 0 -- Phan bo lan hai       
      Set @DepAmount =  @ConvertedAmount    
   
  END    
  ELSE    
  IF @MethodID =1 ---- Phan bo deu    
  BEGIN    
       
   Set @DepType = 1    
  
   If @Periods - isnull((Select Count(ToolID) From At1604 Where ToolID =@ToolID AND ReVoucherID = @VoucherID and DivisionID =@DivisionID),0) - @DepPeriod> 1     
   Begin
		If Isnull(@ApportionAmount,0) = 0
			Set @TempDepAmount = Round ((@ConvertedAmount -  isnull((Select Sum(DepAmount) From AT1604 Where DivisionID =@DivisionID and ToolID = @ToolID AND ReVoucherID = @VoucherID),0))/(@Periods - isnull((Select Count(*) From At1604 Where ToolID =@ToolID AND ReVoucherID = @VoucherID and DivisionID =@DivisionID),0)),@ConvertedDecimals)
		Else
			Set @TempDepAmount = Round (@ApportionAmount,@ConvertedDecimals)
   End
   Else
   Begin   
		Set @TempDepAmount  =@ConvertedAmount -  isnull((Select Round(Sum(DepAmount),@ConvertedDecimals) From AT1604 Where DivisionID =@DivisionID and ToolID =@ToolID AND ReVoucherID = @VoucherID),0)    
   End
   
   If @ConvertedAmount -  isnull((Select Sum(DepAmount) From AT1604 Where DivisionID =@DivisionID and ToolID = @ToolID AND ReVoucherID = @VoucherID),0) >=@TempDepAmount    
    Begin    
    
     If   @Periods - 1 = isnull((Select Count(*) From At1604 Where ToolID =@ToolID AND ReVoucherID = @VoucherID and DivisionID =@DivisionID),0)  +@DepPeriod  
       Set @DepAmount = @ConvertedAmount -  isnull((Select Sum(DepAmount) From AT1604 Where DivisionID =@DivisionID and ToolID = @ToolID AND ReVoucherID = @VoucherID),0)    
     Else     
     Set @DepAmount = @TempDepAmount    
    End    
   Else        
    Set @DepAmount = @ConvertedAmount -  isnull((Select Sum(DepAmount) From AT1604 Where DivisionID =@DivisionID and ToolID =@ToolID AND ReVoucherID = @VoucherID),0)     
       
  END    
      
  ---Print 'HELLO'+str(@DepAmount)    
  IF @DepAmount >0     
    Begin     
   Exec AP0000  @DivisionID, @DepreciationID   OUTPUT, 'AT1605', 'AD', @TranYear ,'',15, 3, 0, '-'      
   Insert AT1604 (    
   DepreciationID, VoucherNo, VoucherDate, TranMonth, TranYear,    
    DivisionID, Status, CreditAccountID, DebitAccountID, DepAmount,    
    DepType, Ana01ID, Ana02ID, Ana03ID, PeriodID, ObjectID, VoucherTypeID, Description,    
   ToolID , CreateDate, CreateUserID, LastModifyDate, LastModifyUserID, ReVoucherID)    
   Values (    
   @DepreciationID, @VoucherNo, @VoucherDate, @TranMonth, @TranYear,    
    @DivisionID, 0, @CreditAccountID, @DebitAccountID, @DepAmount,    
    @DepType, @Ana01ID, @Ana02ID, @Ana03ID, NULL, @ObjectID, @VoucherTypeID, @BDescription,    
   @ToolID, getdate(), @UserID, getdate(), @UserID, @VoucherID)    
   IF Exists (Select  1 from AT1603 where ToolID =@ToolID AND VoucherID = @VoucherID and DivisionID =@DivisionID and UseStatus =0 )    
    Update AT1603  Set UseStatus =1 Where ToolID =@ToolID AND VoucherID = @VoucherID and DivisionID = @DivisionID    
    End    
  FETCH NEXT FROM @Tool_cur INTO  @ToolID,  @ConvertedAmount, @CreditAccountID, @DebitAccountID, @MethodID, @ApportionRate, @ApportionAmount,@Periods,    
       @BeginMonth, @BeginYear, @Ana01ID, @Ana02ID, @Ana03ID, @ObjectID, @VoucherID, @DepPeriod      
      
    
      
 End    
     
     
CLose @Tool_cur