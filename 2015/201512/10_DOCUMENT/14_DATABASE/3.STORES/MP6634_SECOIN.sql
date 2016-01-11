IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP6634_SECOIN]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[MP6634_SECOIN]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Báo cáo tổng hợp sản lượng thành phẩm A (Customerindex: 43 => Secoin)
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 04/03/2015 by Phan thanh thoang vu
---- 
-- <Example>
/*
	Exec MP6634_SECOIN 'AS', '201401', '201603', '2014-01-01', '2016-03-30', 0,  '', '', '', '', 'ASOFTADMIN'
*/
---- 
CREATE PROCEDURE MP6634_SECOIN
(
	@DivisionID AS NVARCHAR(50),
	@FromPeriod AS INT,
	@ToPeriod AS INT,
	@FromDate AS NVARCHAR(50),  
	@ToDate AS NVARCHAR(50),
	@TimeMode as INT, -- Period=0. day = 1
	@FromObjectID as nvarchar(50),
	@ToObjectID as nvarchar(50),				
	@FromInventoryID as nvarchar(50),
	@ToInventoryID as nvarchar(50),
	@UserID as nvarchar(50)
)	
AS
DECLARE @sSQL01           AS NVARCHAR(Max),
		@sSQL02           AS NVARCHAR(Max),
		@sWhere       AS NVARCHAR(4000)
	
	----------------->>>>>> Phân quyền xem chứng từ của người dùng khác		
			DECLARE @sSQLPer AS NVARCHAR(MAX),

					@sWHEREPer AS NVARCHAR(MAX)

			SET @sSQLPer = ''

			SET @sWHEREPer = ''		

			IF EXISTS (SELECT TOP 1 1 FROM MT0000 WHERE DivisionID = @DivisionID AND IsPermissionView = 1 ) 
			-- Nếu check Phân quyền xem dữ liệu tại Thiết lập hệ thống thì mới thực hiện
			BEGIN
					SET @sSQLPer = ' LEFT JOIN AT0010 ON AT0010.DivisionID = M.DivisionID 

														AND AT0010.AdminUserID = '''+@UserID+''' 

														AND AT0010.UserID = M.CreateUserID '

					SET @sWHEREPer = ' AND (M.CreateUserID = AT0010.UserID

											OR  M.CreateUserID = '''+@UserID+''') '		

				END
	-----------------<<<<<< Phân quyền xem chứng từ của người dùng khác	

	SET @sWhere = ' 1 = 1 and ((M.IsPhase = 1 and  M.IsResult = 1) or (M.IsPhase = 2 and M.IsJob = 1) or (M.IsPhase = 0) or (M.IsPhase is null))'
	
	IF isnull(@DivisionID, '') != ''
		Begin
			Set @sWhere = @sWhere +  ' And M.DivisionID Like N''' + @DivisionID + ''''
			
		End
	IF @TimeMode = 1
		Begin
			Set @sWhere = @sWhere + N' AND CONVERT(NVARCHAR(10), M.VoucherDate, 21) BETWEEN '''
												+ CONVERT(NVARCHAR(10),@FromDate,21)+ ''' AND '''
												+ CONVERT(NVARCHAR(10),@ToDate,21) + ''' '
		End
	Else
		Begin
			Set  @sWhere = @sWhere + N' AND M.TranYear*100 + M.TranMonth BETWEEN '
											+ CONVERT(NVARCHAR(10), @FromPeriod) 
											+ ' AND '+CONVERT(NVARCHAR(10), @ToPeriod)
											+ ' '
		End
	
	IF (isnull(@FromObjectID, '') != '' and isnull(@ToObjectID, '') != '')
		Set @sWhere = @sWhere + ' and (M.ObjectID between ''' + @FromObjectID + ''' And ''' + @ToObjectID + ''')'

	IF (isnull(@FromInventoryID, '') != '' and isnull(@ToInventoryID, '') != '')
		Set @sWhere = @sWhere + ' and (D.InventoryID between ''' + @FromInventoryID + ''' And ''' + @ToInventoryID + ''')'

	Set @sSQL01 =' Select 
								KQSX.DivisionID, KQSX.VoucherDate, KQSX.EmployeeID, KQSX.EmployeeName, KQSX.ObjectID, KQSX.ObjectName,
								KQSX.ProductID as InventoryID, 
								KQSX.InventoryName, KQSX.AnaID_Size, KQSX.AnaName_Size,
								KQSX.UnitID, KQSX.UnitName, KQSX.ConvertedUnitID, KQSX.ConvertedUnitName,
								KQSX.Ana01ID, 
								--KQSX.Ana02ID, KQSX.Ana03ID, KQSX.Ana04ID, KQSX.Ana05ID, 
								--KQSX.Ana06ID, KQSX.Ana07ID, KQSX.Ana08ID, KQSX.Ana09ID, KQSX.Ana10ID,
								KQSX.Ana01Name, 
								--KQSX.Ana02Name, KQSX.Ana03Name, KQSX.Ana04Name, KQSX.Ana05Name,
								--KQSX.Ana06Name, KQSX.Ana07Name, KQSX.Ana08Name, KQSX.Ana09Name, KQSX.Ana10Name,
								Sum(KQSX.Quantity) as Quantity, Sum(KQSX.ConvertedQuantity) as ConvertedQuantity
				 from (
						Select  M.IsPhase, M.IsJob, M.IsResult, AT1302.I02ID as AnaID_Size, AT1015.AnaName as AnaName_Size,
								M.DivisionID, M.VoucherID, M.TranMonth, M.TranYear, M.VoucherTypeID, M.VoucherNo, 
								M.VoucherDate, M.KCSEmployeeID, M.PeriodID, M.Description, M.IsWareHouse, M.WareHouseID, 
								M.IsTransfer, M.TransferPeriodID, M.EmployeeID, AT1103.FullName as EmployeeName,
								M.InventoryTypeID, M.DepartmentID, 
								M.TeamID, M.ObjectID, AT1202.ObjectName,
								M.CreateUserID, D.InventoryID, D.ProductID, 
								AT1302.InventoryName, D.UnitID, X01.UnitName , D.ConvertedUnitID, X02.UnitName as ConvertedUnitName, 
								D.Quantity, D.ConvertedQuantity, D.Price, D.ConvertedPrice, D.OriginalAmount, 
								D.ConvertedAmount, D.Note, D.DebitAccountID, D.CreditAccountID, D.SourceNo, 
								D.LimitDate, D.Orders, D.Ana01ID, D.Ana02ID, D.Ana03ID, D.Ana04ID, D.Ana05ID, 
								D.Ana06ID, D.Ana07ID, D.Ana08ID, D.Ana09ID, D.Ana10ID, D.Parameter01, D.Parameter02, 
								D.Parameter03, D.Parameter04, D.Parameter05, D.OTransactionID, D.MOrderID, 
								D.MTransactionID, D.SOrderID, D.STransactionID, D.InheritTableID, D.InheritVoucherID, 
								D.InheritTransactionID,
								A01.AnaName as Ana01Name, A02.AnaName as Ana02Name, A03.AnaName as Ana03Name, A04.AnaName as Ana04Name,
								A05.AnaName as Ana05Name, A06.AnaName as Ana06Name, A07.AnaName as Ana07Name, A08.AnaName as Ana08Name,
								A09.AnaName as Ana09Name, A10.AnaName as Ana10Name'
	Set @sSQL02 ='					From MT0810 M Inner join MT1001 D On M.DivisionID = D.DivisionID and M.VoucherID = D.VoucherID
									  Left join AT1302 on D.DivisionID = AT1302.DivisionID and D.ProductID = AT1302.InventoryID
									  Left join AT1015 AT1015 on AT1302.DivisionID = AT1015.DivisionID 
																	and AT1302.I02ID = AT1015.AnaID and AT1015.AnaTypeID = ''I02''
									  Left Join AT1202 on M.DivisionID = AT1202.DivisionID and M.ObjectID = AT1202.ObjectID		
									   Left join AT1304 X01 on D.DivisionID = X01.DivisionID and D.UnitID = X01.UnitID
									  Left join AT1304 X02 on D.DivisionID = X02.DivisionID and D.ConvertedUnitID = X02.UnitID
									  Left join AT1011 A00 on D.DivisionID = A00.DivisionID and D.ExtraID = A00.AnaID and A00.AnaTypeID = ''A03''
									Left join AT1011 A01 on D.DivisionID = A01.DivisionID and D.Ana01ID = A01.AnaID and A01.AnaTypeID =''A01''
									Left join AT1011 A02 on D.DivisionID = A02.DivisionID and D.Ana02ID = A02.AnaID and A02.AnaTypeID =''A02''
									Left join AT1011 A03 on D.DivisionID = A03.DivisionID and D.Ana03ID = A03.AnaID and A03.AnaTypeID =''A03''
									Left join AT1011 A04 on D.DivisionID = A04.DivisionID and D.Ana04ID = A04.AnaID and A04.AnaTypeID =''A04''
									Left join AT1011 A05 on D.DivisionID = A05.DivisionID and D.Ana05ID = A05.AnaID and A05.AnaTypeID =''A05''
									Left join AT1011 A06 on D.DivisionID = A06.DivisionID and D.Ana06ID = A06.AnaID and A06.AnaTypeID =''A06''
									Left join AT1011 A07 on D.DivisionID = A07.DivisionID and D.Ana07ID = A07.AnaID and A07.AnaTypeID =''A07''
									Left join AT1011 A08 on D.DivisionID = A08.DivisionID and D.Ana08ID = A08.AnaID and A08.AnaTypeID =''A08''
									Left join AT1011 A09 on D.DivisionID = A09.DivisionID and D.Ana09ID = A09.AnaID and A09.AnaTypeID =''A09''
									Left join AT1011 A10 on D.DivisionID = A10.DivisionID and D.Ana10ID = A10.AnaID and A10.AnaTypeID =''A10''
									Left join AT1103 on M.DivisionID = AT1103.DivisionID and M.EmployeeID = AT1103.EmployeeID
						'
						+ @sSQLPer +
						' Where ' + @sWhere + @sWHEREPer +

						' --and D.Ana01ID like N''LOAIA%''
							) KQSX
						Group by KQSX.DivisionID, KQSX.VoucherDate, KQSX.EmployeeID, KQSX.EmployeeName, KQSX.ObjectID, KQSX.ObjectName,
								KQSX.ProductID, KQSX.InventoryName, KQSX.AnaID_Size, KQSX.AnaName_Size,
								KQSX.UnitID, KQSX.UnitName, KQSX.ConvertedUnitID, KQSX.ConvertedUnitName,
								KQSX.Ana01ID, 
								--KQSX.Ana02ID, KQSX.Ana03ID, KQSX.Ana04ID, KQSX.Ana05ID, 
								--KQSX.Ana06ID, KQSX.Ana07ID, KQSX.Ana08ID, KQSX.Ana09ID, KQSX.Ana10ID,
								KQSX.Ana01Name--, 
								--KQSX.Ana02Name, KQSX.Ana03Name, KQSX.Ana04Name, KQSX.Ana05Name,
								--KQSX.Ana06Name, KQSX.Ana07Name, KQSX.Ana08Name, KQSX.Ana09Name, KQSX.Ana10Name
						Order by KQSX.ObjectID, KQSX.Ana01Name, KQSX.ProductID, KQSX.VoucherDate
				'
	EXEC (@sSQL01+@sSQL02)
	Print (@sSQL01)
	Print (@sSQL02)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

