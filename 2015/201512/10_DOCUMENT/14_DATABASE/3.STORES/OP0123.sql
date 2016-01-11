IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0123]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0123]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Create by Bảo Anh	Date: 30/10/2013
---- Purpose : Tính hoa hồng đa cấp (Sinolife)
-----UPdate by Mai Duyen, Date 27/11/2013: Fix tach don hang va lay gia tri don hang
-----UPdate by Mai Duyen, Date 04/12/2013: Bo sung field ContractNo(ma phan tich hop dong)
-----Update by Bảo Anh, Date 09/12/2013: Bỏ phần Insert thông tin salesman chưa phát sinh đơn hàng vào bảng hoa hồng
-----Update by Bảo Anh, Date 11/12/2013: Không tính hoa hồng cho các đơn hàng đã tính (mantis 0021901)
-----Update by Bảo Anh, Date 11/02/2014: Không trừ chiết khấu khi tính hoa hồng
-----Update by Bảo Anh, Date 18/02/2014: Bổ sung Isnull khi select OT0123 tạo bảng tạm
-----Update by Bảo Anh, Date 02/07/2014: Không tính hoa hồng cho các đơn hàng không có số hợp đồng
---- Update by Bảo Anh, Date 14/08/2014 : Sửa cách tách đơn hàng
---- Update by Bảo Anh, Date 17/09/2014 : Sửa cách tính @CountEmployeeID (bỏ xét theo mã nhánh)
---- Update by Bảo Anh, Date 24/09/2014 : Trừ thêm tiền chiết khấu khi tính hoa hồng
---- OP0123 'SNL',7,2013,'07/01/2013','07/31/2013',0,'%','%','EO/07/2013/00003','EO/07/2013/00003'

CREATE PROCEDURE [dbo].[OP0123]
	@DivisionID nvarchar(50),
	@TranMonth int,
	@TranYear int,
	@FromDate datetime,
	@ToDate datetime,
	@IsDate tinyint,
	@ObjectID varchar(50),
	@SalesmanID varchar(50),
	@FromSOrderID nvarchar(50),
	@ToSOrderID nvarchar(50)
AS

DECLARE @SQL nvarchar(4000),
		@sWhere nvarchar(4000),
		@Cur AS cursor,
		@SOrderID nvarchar(50),
		@SalesmanID_TAM nvarchar(50),
		@OrderDate datetime,
		@OrderAmount_TAM decimal(28,8),
		@LevelNo int,
		@UpSale decimal(28,8),
		@OrderNo int,
		@AccAmount decimal(28,8),
		@OrderAmount decimal(28,8),
		@SalesContractAnaTypeID nvarchar(50),
		@ContractNo nvarchar(50),
		@Cur_Orders as cursor,
		@SalesmanID_Orders nvarchar(50),
		@LevelNo_Orders int,
		@RemainAmount decimal(28,8),
		@CountEmployeeID int
				
IF @IsDate = 0
	Set  @sWhere = 'And (OT2001.TranMonth + OT2001.TranYear*100 = ' + cast(@TranMonth + @TranYear*100 as nvarchar(50)) + ')'
else
	Set  @sWhere = 'And (OT2001.OrderDate Between '''+Convert(nvarchar(10),@FromDate,21)+''' and '''+convert(nvarchar(10), @ToDate,21)+''')'

--Lay ma phan tich HD ban tu thiet lap 
Set @SalesContractAnaTypeID = ISNULL((Select SalesContractAnaTypeID from AT0000  Where DefDivisionID = @DivisionID),'A02' )

--- Tạo bảng tạm chứa các đơn hàng cần tính hoa hồng
IF EXISTS (SELECT *	FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb.dbo.#TAM')) 
	DROP TABLE #TAM

CREATE TABLE #TAM (	SOrderID varchar(50),
					SalesManID varchar(50),
					OrderDate datetime,
					LevelNo int,
					OrderAmount decimal(28,8),
					ContractNo varchar(50),
					OrderNo int
)
	
		SET @SQL = 'INSERT INTO #TAM (SOrderID, SalesManID, OrderDate, LevelNo, OrderAmount,ContractNo)
			SELECT * FROM (
			SELECT OT2001.SOrderID,OT2001.SalesManID,OT2001.OrderDate,AT1202.LevelNo,
						(Isnull(ConvertedAmount,0) + Isnull(VATConvertedAmount,0) - ISNULL(CommissionCAmount,0) - Isnull(DiscountConvertedAmount,0))
						 as OrderAmount,
						 Case When ''' +  @SalesContractAnaTypeID + '''= ''A01'' THEN OT2002.Ana01ID
							  When ''' +  @SalesContractAnaTypeID + '''= ''A02'' THEN OT2002.Ana02ID
							  When ''' +  @SalesContractAnaTypeID + '''= ''A03'' THEN OT2002.Ana03ID
							  When ''' +  @SalesContractAnaTypeID + '''= ''A04'' THEN OT2002.Ana04ID
							  When ''' +  @SalesContractAnaTypeID + '''= ''A05'' THEN OT2002.Ana05ID
							  When ''' +  @SalesContractAnaTypeID + '''= ''A06'' THEN OT2002.Ana06ID
							  When ''' +  @SalesContractAnaTypeID + '''= ''A07'' THEN OT2002.Ana07ID
							  When ''' +  @SalesContractAnaTypeID + '''= ''A08'' THEN OT2002.Ana08ID
							  When ''' +  @SalesContractAnaTypeID + '''= ''A09'' THEN OT2002.Ana09ID
							  When ''' +  @SalesContractAnaTypeID + '''= ''A10'' THEN OT2002.Ana10ID
						End as ContractNo	  
						
			FROM OT2001
			LEFT JOIN OT2002 On OT2001.DivisionID = OT2002.DivisionID  AND OT2001.SOrderID = OT2002.SOrderID	
			LEFT JOIN AT1202 On OT2001.DivisionID = AT1202.DivisionID And OT2001.SalesManID = AT1202.ObjectID And AT1202.ObjectTypeID = ''NV''
		
			WHERE OT2001.DivisionID = ''' + @DivisionID + '''
			AND OT2001.ObjectID like ''' + @ObjectID + ''' AND OT2001.SalesManID like ''' + @SalesmanID + '''' + @sWhere + '
			AND AT1202.Disabled = 0
			AND (OT2001.SOrderID between ''' + @FromSOrderID + ''' And ''' + @ToSOrderID + ''')
			AND OT2001.SOrderID not in (Select Isnull(OrderID,'''') From OT0123 Where DivisionID = ''' + @DivisionID + ''')
			) A
			Order by  OrderDate,SOrderID ,ContractNo, SalesmanID'
---print 	@SQL
EXEC(@SQL)

------------------------------------
SET @Cur = CURSOR SCROLL KEYSET FOR
SELECT SOrderID, OrderDate, SalesmanID, LevelNo, OrderAmount,ContractNo FROM #TAM 
Order by OrderDate,SOrderID,ContractNo,SalesmanID
  
OPEN @Cur
FETCH NEXT FROM @Cur INTO @SOrderID, @OrderDate, @SalesmanID_TAM, @LevelNo, @OrderAmount_TAM,@ContractNo
WHILE @@FETCH_STATUS = 0
BEGIN
	DELETE OT0143 WHERE DivisionID = @DivisionID
	
	IF Isnull(@ContractNo,'') <> ''
	Begin
		----- 1. Insert nhân viên bán đơn hàng vào bảng cần xét tách đơn hàng
		INSERT INTO OT0143 (DivisionID, SalesmanID, LevelNo, SalesAmount, Orders)
		VALUES (@DivisionID, @SalesmanID_TAM, @LevelNo, 1, 0)
	    
		--- 2. Insert người quản lý
		EXEC OP0122 @DivisionID, @SOrderID,	@OrderDate,	@OrderAmount_TAM, @SalesmanID_TAM,@ContractNo,NULL, 1
		
		---- 3. Insert người giới thiệu
		EXEC OP0121 @DivisionID, @SOrderID,	@OrderDate,	@OrderAmount_TAM,@ContractNo,NULL, 1
		
		SET @OrderNo = 0
		SET @RemainAmount = @OrderAmount_TAM
		SET @OrderAmount = 0
		
		SET @Cur_Orders = CURSOR SCROLL KEYSET FOR
		SELECT SalesmanID, LevelNo FROM (
			SELECT SalesmanID, LevelNo, 1 as Num, Orders FROM OT0143 Where DivisionID = @DivisionID And SalesAmount = 1 And LevelNo < 2
			UNION SELECT SalesmanID, LevelNo, 2 as Num, Orders FROM OT0143 Where DivisionID = @DivisionID And SameAmount = 1 And LevelNo < 2
			UNION SELECT SalesmanID, LevelNo, 3 as Num, Orders FROM OT0143 Where DivisionID = @DivisionID And ExtendAmount = 1 And LevelNo < 2
		) A
		Order by Num, Orders
		
		OPEN @Cur_Orders
		FETCH NEXT FROM @Cur_Orders INTO @SalesmanID_Orders, @LevelNo_Orders
		WHILE @@FETCH_STATUS = 0
		BEGIN
			Set @UpSale = 0
			Set @AccAmount = 0
			Set @CountEmployeeID = 0
			
			---Lay gia tri UpSales va AccAmount de tinh lai  @OrderAmount. 
			SELECT @UpSale = Isnull(UpSales,0), @AccAmount = Isnull(AccAmount,0)
			FROM AT1202
			LEFT JOIN AT0101 T01 On AT1202.DivisionID = T01.DivisionID And AT1202.LevelNo + 1 = T01.LevelNo
			Where ObjectID = @SalesmanID_Orders AND ObjectTypeID ='NV' AND AT1202.DivisionID = @DivisionID
				
			--- Lấy số nhân viên cấp dưới được lên GD
			IF @LevelNo_Orders = 1
				SELECT @CountEmployeeID =	COUNT(ObjectID)
											From AT1202
											Where DivisionID = @DivisionID AND MiddleID = @SalesmanID_Orders
											AND ObjectID in (Select ObjectID From AT1213 Where DivisionID = @DivisionID AND ManagerID = @SalesmanID_Orders)
											AND AccAmount >= (Select UpSales from AT0101 Where DivisionID = @DivisionID AND LevelNo =1)
			ELSE
				SET @CountEmployeeID = 2
							
			IF NOT EXISTS (SELECT TOP 1 1 FROM OT0143 Where DivisionID = @DivisionID And SalesmanID = @SalesmanID_Orders And Isnull(IsReview,0) <> 0)
			AND (@RemainAmount + @AccAmount - @UpSale > 0) AND (@CountEmployeeID > 1) --tach don hang theo nhân viên này
			Begin
					SET @OrderAmount = @UpSale  - @AccAmount
					SET @RemainAmount = @RemainAmount - @OrderAmount
					SET @OrderNo = @OrderNo + 1
					
					--- Tính hoa hồng
					----- 1. Insert nhân viên bán đơn hàng
					INSERT INTO OT0123 (DivisionID, OrderID, OrderDate, OrderAmount, SalesmanID, PreLevelNo, SalesAmount,ContractNo,OrderNo)
					VALUES (@DivisionID, @SOrderID, @OrderDate, @OrderAmount, @SalesmanID_TAM, @LevelNo, 1,@ContractNo,  @OrderNo)
				    
					--- 2. Insert người quản lý
					EXEC OP0122 @DivisionID, @SOrderID,	@OrderDate,	@OrderAmount, @SalesmanID_TAM,@ContractNo,@OrderNo, NULL
					
					---- 3. Insert người giới thiệu
					EXEC OP0121 @DivisionID, @SOrderID,	@OrderDate,	@OrderAmount,@ContractNo,@OrderNo, NULL
					
					---- 4. Tính hoa hồng cho từng nhân viên được hưởng
					EXEC OP0120 @DivisionID, @SalesmanID_TAM, @SOrderID, @OrderDate, @OrderAmount , @ContractNo,@OrderNo
			
					UPDATE OT0143 SET IsReview = 1 Where DivisionID = @DivisionID And SalesmanID = @SalesmanID_Orders
			End
			FETCH NEXT FROM @Cur_Orders INTO @SalesmanID_Orders, @LevelNo_Orders
		END
		Close @Cur_Orders
		
		IF @RemainAmount > 0
		BEGIN
			--- Tính hoa hồng cho phần còn lại chưa tách đơn hàng
			SET @OrderNo = @OrderNo + 1
			----- 1. Insert nhân viên bán đơn hàng
			INSERT INTO OT0123 (DivisionID, OrderID, OrderDate, OrderAmount, SalesmanID, PreLevelNo, SalesAmount,ContractNo,OrderNo)
			VALUES (@DivisionID, @SOrderID, @OrderDate, @RemainAmount, @SalesmanID_TAM, @LevelNo, 1,@ContractNo,  @OrderNo)
		    
			--- 2. Insert người quản lý
			EXEC OP0122 @DivisionID, @SOrderID,	@OrderDate,	@RemainAmount, @SalesmanID_TAM,@ContractNo,@OrderNo, NULL
			
			---- 3. Insert người giới thiệu
			EXEC OP0121 @DivisionID, @SOrderID,	@OrderDate,	@RemainAmount,@ContractNo,@OrderNo, NULL
			
			---- 4. Tính hoa hồng cho từng nhân viên được hưởng
			EXEC OP0120 @DivisionID, @SalesmanID_TAM, @SOrderID, @OrderDate, @RemainAmount , @ContractNo,@OrderNo
		END
		
	End
		
	FETCH NEXT FROM @Cur INTO @SOrderID, @OrderDate, @SalesmanID_TAM, @LevelNo, @OrderAmount_TAM,@ContractNo
END
CLOSE @Cur

DELETE OT0143 WHERE DivisionID = @DivisionID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

