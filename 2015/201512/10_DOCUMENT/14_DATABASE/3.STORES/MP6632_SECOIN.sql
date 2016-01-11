IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP6632_SECOIN]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[MP6632_SECOIN]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Báo cáo tổng hợp sản lượng sản xuất (Theo vật tư) (Customerindex: 43 => Secoin)
---- chỉ xử lý cho trường hợp công đoạn 1 (sản xuất 2 công đoạn)
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 04/03/2015 by Phan thanh thoang vu
---- Edit on 06/08/2015 by Phan thanh thoang vu: thêm người thợ mục đích thống kê thợ sản xuất được bao nhiêu
---- 
-- <Example>
/*
	Exec MP6632_SECOIN 'AS', '201401', '201603', '2015-01-01', '2016-03-30', 0,  '', '','', '', '', '', '', '', '', '', '', '', 'ASOFTADMIN'
*/
---- 
CREATE PROCEDURE MP6632_SECOIN
(
	@DivisionID AS NVARCHAR(50),
	@FromPeriod AS INT,
	@ToPeriod AS INT,
	@FromDate AS NVARCHAR(50),  
	@ToDate AS NVARCHAR(50),
	@TimeMode as INT, -- Period=0. day = 1
	@FromObjectID as nvarchar(50),
	@ToObjectID as nvarchar(50),
	@FromWareHouseID as nvarchar(50),
	@ToWareHouseID as nvarchar(50),				
	@FromInventoryID as nvarchar(50),
	@ToInventoryID as nvarchar(50),
	@FromDepartmentID as nvarchar(50),
	@ToDepartmentID as nvarchar(50),
	@FromLaborID as nvarchar(50),
	@ToLaborID as nvarchar(50),
	@FromTeamID as nvarchar(50),
	@ToTeamID as nvarchar(50),
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

	SET @sWhere = ' 1 = 1 '
	
	IF Isnull(@DivisionID, '') != ''
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
			Set @sWhere = @sWhere + N' AND M.TranYear*100 + M.TranMonth BETWEEN '
											+ CONVERT(NVARCHAR(10), @FromPeriod) 
											+ ' AND '+CONVERT(NVARCHAR(10), @ToPeriod)
											+ ' '
		End
	
	IF (isnull(@FromWareHouseID, '') != '' and isnull(@ToWareHouseID, '') != '')
		Set @sWhere = @sWhere + ' and (M.WareHouseID between ''' + @FromWareHouseID + ''' And ''' + @ToWareHouseID + ''')'

	IF (isnull(@FromObjectID, '') != '' and isnull(@ToObjectID, '') != '')
		Set @sWhere = @sWhere + ' and (M.ObjectID between ''' + @FromObjectID + ''' And ''' + @ToObjectID + ''')'

	IF (isnull(@FromDepartmentID, '') != '' and isnull(@ToDepartmentID, '') != '')
		Set @sWhere = @sWhere + ' and (M.DepartmentID between ''' + @FromDepartmentID + ''' And ''' + @ToDepartmentID + ''')'

	IF (isnull(@FromTeamID, '') != '' and isnull(@ToTeamID, '') != '')
	Set @sWhere = @sWhere + ' and (M.TeamID between ''' + @FromTeamID + ''' And ''' + @ToTeamID + ''')'

	IF (Isnull(@FromLaborID, '') != '' and isnull(@ToLaborID, '') !='')
		Set @sWhere = @sWhere + ' and (MT2007.LaborID between ''' + @FromLaborID + ''' And ''' + @ToLaborID + ''')'

	IF (Isnull(@FromInventoryID, '') != '' and isnull(@ToInventoryID, '') !='')
		Set @sWhere = @sWhere + ' and (D.InventoryID between ''' + @FromInventoryID + ''' And ''' + @ToInventoryID + ''')'

	Set @sSQL01 =' Select	x.*
							, AT1202.ObjectName
							, AT1102.DepartmentName
							, HT1101.TeamName
							, AT1103_1.FullName as LaborName
							, AT1303.WareHouseName
							, AT1302_1.InventoryName
							, AT1302_2.InventoryName as ProductName
							, AT1304_1.UnitName
							, AT1304_1.UnitName as ConvertedUnitName
							, AT1311.ExtraName
							, A01.AnaName as AnaName_Type, A02.AnaName as Ana02Name, A03.AnaName as Ana03Name, A04.AnaName as Ana04Name
							, A05.AnaName as Ana05Name, A06.AnaName as Ana06Name, A07.AnaName as Ana07Name, A08.AnaName as Ana08Name
							, A09.AnaName as Ana09Name, A10.AnaName as Ana10Name
							, AT1015_1.AnaName as Inventory_I01Name
							, AT1015_2.AnaName as Inventory_I02Name
							, AT1015_3.AnaName as Inventory_I03Name
							, AT1015_4.AnaName as Inventory_I04Name
							, AT1015_5.AnaName as Inventory_I05Name
							, AT1015_6.AnaName as Product_I01Name
							, AT1015_7.AnaName as AnaName_Size
							, AT1015_8.AnaName as Product_I03Name
							, AT1015_9.AnaName as Product_I04Name
							, AT1015_10.AnaName as Product_I05Name
					From (
							Select	M.DivisionID, M.TranMonth, M.TranYear, M.ObjectID, M.DepartmentID, M.TeamID, MT2007.LaborID
									, M.WareHouseID, D.InventoryID, D.ProductID, D.UnitID, D.ConvertedUnitID, D.ExtraID
									, Sum(D.Quantity) as Quantity, Sum(D.ConvertedQuantity) as ConvertedQuantity
									, D.Ana01ID, D.Ana02ID, D.Ana03ID, D.Ana04ID, D.Ana05ID
									, D.Ana06ID, D.Ana07ID, D.Ana08ID, D.Ana09ID, D.Ana10ID
							From   MT0810 M Inner join MT1001 D On M.DivisionID = D.DivisionID 
															and M.VoucherID = D.VoucherID and M.IsPhase = 1  and M.IsJob = 1 
											Left join MT2007 on D.InheritVoucherID = MT2007.VoucherID and D.DivisionID = MT2007.DivisionID '
											+ @sSQLPer +
							' Where ' + @sWhere + @sWHEREPer +
							' Group by	M.DivisionID, M.TranMonth, M.TranYear, M.ObjectID, M.WareHouseID, MT2007.LaborID
									, M.DepartmentID, M.TeamID, D.InventoryID, D.ProductID, D.UnitID, D.ExtraID, D.ConvertedUnitID
									, D.Ana01ID, D.Ana02ID, D.Ana03ID, D.Ana04ID, D.Ana05ID
									, D.Ana06ID, D.Ana07ID, D.Ana08ID, D.Ana09ID, D.Ana10ID
						) x '
						
Set @sSQL02 ='				Left join AT1202 on x.ObjectID = AT1202.ObjectID and x.DivisionID = AT1202.DivisionID
				Left join AT1102 on x.DepartmentID = AT1102.DepartmentID and x.DivisionID = AT1102.DivisionID
				Left join HT1101 on x.TeamID = HT1101.TeamID and x.DivisionID = HT1101.DivisionID
				Left join AT1103 AT1103_1 on x.LaborID = AT1103_1.EmployeeID and x.DivisionID = AT1103_1.DivisionID
				Left join AT1311 on x.DivisionID = AT1311.DivisionID and x.ExtraID = AT1311.ExtraID
				Left join AT1303 on x.WareHouseID = AT1303.WareHouseID and x.DivisionID = AT1303.DivisionID
				Left join AT1302 AT1302_1 on x.InventoryID = AT1302_1.InventoryID and x.DivisionID = AT1302_1.DivisionID
				Left join AT1015 AT1015_1 on AT1302_1.DivisionID = AT1015_1.DivisionID and AT1302_1.I01ID = AT1015_1.AnaID and AT1015_1.AnaTypeID = ''I01''
				Left join AT1015 AT1015_2 on AT1302_1.DivisionID = AT1015_2.DivisionID and AT1302_1.I02ID = AT1015_2.AnaID and AT1015_2.AnaTypeID = ''I02''
				Left join AT1015 AT1015_3 on AT1302_1.DivisionID = AT1015_3.DivisionID and AT1302_1.I03ID = AT1015_3.AnaID and AT1015_3.AnaTypeID = ''I03''
				Left join AT1015 AT1015_4 on AT1302_1.DivisionID = AT1015_4.DivisionID and AT1302_1.I04ID = AT1015_4.AnaID and AT1015_4.AnaTypeID = ''I04''
				Left join AT1015 AT1015_5 on AT1302_1.DivisionID = AT1015_5.DivisionID and AT1302_1.I05ID = AT1015_5.AnaID and AT1015_5.AnaTypeID = ''I05''

				Left join AT1302 AT1302_2 on x.ProductID = AT1302_2.InventoryID and x.DivisionID = AT1302_2.DivisionID
				Left join AT1015 AT1015_6 on AT1302_2.DivisionID = AT1015_6.DivisionID and AT1302_2.I01ID = AT1015_6.AnaID and AT1015_6.AnaTypeID = ''I01''
				Left join AT1015 AT1015_7 on AT1302_2.DivisionID = AT1015_7.DivisionID and AT1302_2.I02ID = AT1015_7.AnaID and AT1015_7.AnaTypeID = ''I02''
				Left join AT1015 AT1015_8 on AT1302_2.DivisionID = AT1015_8.DivisionID and AT1302_2.I03ID = AT1015_8.AnaID and AT1015_8.AnaTypeID = ''I03''
				Left join AT1015 AT1015_9 on AT1302_2.DivisionID = AT1015_9.DivisionID and AT1302_2.I04ID = AT1015_9.AnaID and AT1015_9.AnaTypeID = ''I04''
				Left join AT1015 AT1015_10 on AT1302_2.DivisionID = AT1015_10.DivisionID and AT1302_2.I05ID = AT1015_10.AnaID and AT1015_10.AnaTypeID = ''I05''

				Left join AT1304 AT1304_1 on x.UnitID = AT1304_1.UnitID and x.DivisionID = AT1304_1.DivisionID
				Left join AT1304 AT1304_2 on x.ConvertedUnitID = AT1304_2.UnitID and x.DivisionID = AT1304_2.DivisionID
				Left join AT1011 A01 on x.DivisionID = A01.DivisionID and x.Ana01ID = A01.AnaID and A01.AnaTypeID =''A01''
				Left join AT1011 A02 on x.DivisionID = A02.DivisionID and x.Ana02ID = A02.AnaID and A02.AnaTypeID =''A02''
				Left join AT1011 A03 on x.DivisionID = A03.DivisionID and x.Ana03ID = A03.AnaID and A03.AnaTypeID =''A03''
				Left join AT1011 A04 on x.DivisionID = A04.DivisionID and x.Ana04ID = A04.AnaID and A04.AnaTypeID =''A04''
				Left join AT1011 A05 on x.DivisionID = A05.DivisionID and x.Ana05ID = A05.AnaID and A05.AnaTypeID =''A05''
				Left join AT1011 A06 on x.DivisionID = A06.DivisionID and x.Ana06ID = A06.AnaID and A06.AnaTypeID =''A06''
				Left join AT1011 A07 on x.DivisionID = A07.DivisionID and x.Ana07ID = A07.AnaID and A07.AnaTypeID =''A07''
				Left join AT1011 A08 on x.DivisionID = A08.DivisionID and x.Ana08ID = A08.AnaID and A08.AnaTypeID =''A08''
				Left join AT1011 A09 on x.DivisionID = A09.DivisionID and x.Ana09ID = A09.AnaID and A09.AnaTypeID =''A09''
				Left join AT1011 A10 on x.DivisionID = A10.DivisionID and x.Ana10ID = A10.AnaID and A10.AnaTypeID =''A10'''
						
	EXEC (@sSQL01 +@sSQL02)
	Print (@sSQL01)
	Print (@sSQL02)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

