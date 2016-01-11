IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP2014]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP2014]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- In báo cáo phiếu phiếu giao việc
---- Create by: Phan thanh hoàng Vũ, on 16/02/2015
---- Modify by: Phan thanh hoàng Vũ, on 17/06/2015-Bổ sung thêm phan quyền xem dữ liệu khi in
---- Modify by: Phan thanh hoàng Vũ, on 28/07/2015-Fixbug lấy sai trường Số đơn hàng bán thành số đơn hàng sản xuất
---- Example:    EXEC MP2014 'AS','5c6516f1-07d2-4d4b-99c7-a1b606a648ac', '((''''))', '((0 = 0))','((''''))', '((0 = 0))', 'ASOFTADMIN'


 CREATE PROCEDURE MP2014
(
    @DivisionID NVARCHAR(2000),
    @VoucherID VARCHAR(50),
	@ConditionVT nvarchar(max),
	@IsUsedConditionVT nvarchar(20),
	@ConditionOB nvarchar(max),
	@IsUsedConditionOB nvarchar(20),
	@UserID AS VARCHAR(50)
)
AS
Declare @sSQL1 AS varchar(max),
		@sSQL2 AS varchar(max),
		@DivisionWhere AS VARCHAR(MAX)
		Set @sSQL1 = ''	
		Set @sSQL2 = ''	
		Set @DivisionWhere = ' Where 1 = 1 '
		IF @DivisionID is not null and @DivisionID != ''
			Set @DivisionWhere = @DivisionWhere + ' and  M.DivisionID = '''+@DivisionID + '''' 
				
		IF @VoucherID is not null and @VoucherID != ''
			Set @DivisionWhere = @DivisionWhere + ' And  M.VoucherID = '''+@VoucherID + '''' 
	
		

		
		---------->>>>>> Phân quyền xem chứng từ của người dùng khác		
		DECLARE @sSQLPer AS NVARCHAR(MAX),
				@sWHEREPer AS NVARCHAR(MAX)
		SET @sSQLPer = ''
		SET @sWHEREPer = ''		

		IF EXISTS (
					SELECT TOP 1 1 FROM MT0000 WHERE DivisionID = @DivisionID AND IsPermissionView = 1 
				  )  -- Nếu check Phân quyền xem dữ liệu tại Thiết lập hệ thống thì mới thực hiện
		BEGIN
				SET @sSQLPer = ' LEFT JOIN AT0010 ON AT0010.DivisionID = M.DivisionID 
													AND AT0010.AdminUserID = '''+@UserID+''' 
													AND AT0010.UserID = M.CreateUserID '
				SET @sWHEREPer = ' AND (M.CreateUserID = AT0010.UserID
										OR  M.CreateUserID = '''+@UserID+''') '		
		END
		----------<<<<<< Phân quyền xem chứng từ của người dùng khác		


SET @sSQL1 = 'SELECT O.MVoucherNo, O.VoucherNo as SOrderID , M.VoucherID, D.TransactionID, M.DivisionID, M.TranMonth, M.TranYear, M.VoucherTypeID, M.VoucherDate, 
				 M.VoucherNo, M.RefNo01, M.RefNo02, M.RefNo03, M.RefNo04, M.RefNo05, M.ObjectID, AT1202.ObjectName, M.LaborID, 
				 A01.Fullname as LaborName, M.EmployeeID, A02.Fullname as EmployeeName, M.InventoryTypeID, M.Description MasterDescription, 
				 M.OrderStatus, MT0099.Description as OrderStatusName, M.CreateUserID, M.CreateDate, D.IsPicking,D.WareHouseID, AT1303.WareHouseName,
				 D.RInventoryID, A04.InventoryName as RInventoryName, D.InventoryID, Isnull(D.InventoryCommonName, A03.InventoryName) 
				 as InventoryName, D.UnitID, A05.UnitName, D.Quantity, D.ConvertedQuantity,D.Orders,D.Description,D.Notes01,D.Notes02,D.Notes03,
				 D.Ana01ID, MT2008_1.AnaName as AnaName01, D.Ana02ID, MT2008_2.AnaName as Ana02Name, D.Ana03ID, MT2008_3.AnaName as AnaName03,
				 D.Ana04ID, MT2008_4.AnaName as AnaName04,D.Ana05ID, MT2008_5.AnaName as AnaName05,D.Ana06ID, MT2008_6.AnaName as AnaName06,
				 D.Ana07ID, MT2008_7.AnaName as AnaName07,D.Ana08ID, MT2008_8.AnaName as AnaName08,
				 D.Ana09ID, MT2008_9.AnaName as AnaName09,D.Ana10ID, MT2008_10.AnaName as AnaName10,
				 D.nvarchar01,D.nvarchar02,D.nvarchar03,D.nvarchar04,D.nvarchar05,D.nvarchar06,D.nvarchar07,D.nvarchar08,D.nvarchar09,D.nvarchar10,
				 A00003.Image01ID, D.ExtraID, AT1311.ExtraName,
				 A03.I01ID, I01.AnaName as Ana01Name, A03.I02ID, I02.AnaName as AnaName01, A03.I03ID, I03.AnaName as Ana03Name,
				 A03.I04ID, I04.AnaName as Ana04Name,A03.I05ID, I05.AnaName as Ana05Name, O2.EndDate

				 

			 From MT2007 M  inner join MT2008 D on M.DivisionID = D.DivisionID and M.VoucherID = D.VoucherID
							Left join (Select O2.SOrderID as MOrderID, O2.VoucherNo as MVoucherNo, O1.VoucherNo, O1.DivisionID from OT2001 O1 inner join 
										(Select Distinct M.SOrderID, M.DivisionID, M.VoucherNo, D.InheritVoucherID 
										from OT2001 M inner join OT2002 D on M.DivisionID = D.DivisionID and M.SOrderID = D.SOrderID and M.OrderType = 1)
										 O2 on O1.DivisionID = O2.DivisionID and O1.SOrderID = O2.InheritVoucherID
										Where O1.OrderType=0
							) O on  M.DivisionID = O.DivisionID and M.SOrderID = O.MOrderID '
SET @sSQL2 = '
							left join AT1202 on M.DivisionID = AT1202.DivisionID and M.ObjectID = AT1202.ObjectID
							left join AT1103 A01 on M.DivisionID = A01.DivisionID and M.LaborID = A01.EmployeeID
							left join AT1103 A02 on M.DivisionID = A02.DivisionID and M.EmployeeID = A02.EmployeeID
							Left join AT1303 on D.DivisionID = AT1303.DivisionID and D.WareHouseID = AT1303.WareHouseID
							Left join AT1302 on D.DivisionID = AT1302.DivisionID and D.InventoryID = AT1302.InventoryID
							Left join AT1302 A03 on D.DivisionID = A03.DivisionID and D.InventoryID = A03.InventoryID
							Left join AT1015 I01 on A03.DivisionID = I01.DivisionID and A03.I01ID = I01.AnaID and I01.AnaTypeID = N''I01''
							Left join AT1015 I02 on A03.DivisionID = I02.DivisionID and A03.I01ID = I02.AnaID and I02.AnaTypeID = N''I02''
							Left join AT1015 I03 on A03.DivisionID = I03.DivisionID and A03.I01ID = I03.AnaID and I03.AnaTypeID = N''I03''
							Left join AT1015 I04 on A03.DivisionID = I04.DivisionID and A03.I01ID = I04.AnaID and I04.AnaTypeID = N''I04''
							Left join AT1015 I05 on A03.DivisionID = I05.DivisionID and A03.I01ID = I05.AnaID and I05.AnaTypeID = N''I05''
							Left join AT1302 A04 on D.DivisionID = A04.DivisionID and D.RInventoryID = A04.InventoryID
							Left join AT1304 A05 on D.DivisionID = A05.DivisionID and D.UnitID = A05.UnitID
							Left join MT0099 on M.OrderStatus = MT0099.ID and MT0099.CodeMaster =''OrderStatus''
							Left join AT1311 on D.DivisionID = AT1311.DivisionID and D.ExtraID = AT1311.ExtraID
							Left join OT2002 O2 on D.DivisionID = O2.DivisionID and D.InheritVoucherID = O2.SOrderID and D.InheritTransactionID = O2.TransactionID 
	LEFT JOIN AT1011 MT2008_1 ON MT2008_1.AnaID = D.Ana01ID AND  MT2008_1.AnaTypeID = ''A01''  AND MT2008_1.DivisionID = D.DivisionID
	LEFT JOIN AT1011 MT2008_2 ON MT2008_2.AnaID = D.Ana02ID AND  MT2008_2.AnaTypeID = ''A02''  AND MT2008_2.DivisionID = D.DivisionID
	LEFT JOIN AT1011 MT2008_3 ON MT2008_3.AnaID = D.Ana03ID AND  MT2008_3.AnaTypeID = ''A03''  AND MT2008_3.DivisionID = D.DivisionID
	LEFT JOIN AT1011 MT2008_4 ON MT2008_4.AnaID = D.Ana04ID AND  MT2008_4.AnaTypeID = ''A04''  AND MT2008_4.DivisionID = D.DivisionID
	LEFT JOIN AT1011 MT2008_5 ON MT2008_5.AnaID = D.Ana05ID AND  MT2008_5.AnaTypeID = ''A05''  AND MT2008_5.DivisionID = D.DivisionID
	LEFT JOIN AT1011 MT2008_6 ON MT2008_6.AnaID = D.Ana06ID AND  MT2008_6.AnaTypeID = ''A06''  AND MT2008_6.DivisionID = D.DivisionID
	LEFT JOIN AT1011 MT2008_7 ON MT2008_7.AnaID = D.Ana07ID AND  MT2008_7.AnaTypeID = ''A07''  AND MT2008_7.DivisionID = D.DivisionID
	LEFT JOIN AT1011 MT2008_8 ON MT2008_8.AnaID = D.Ana08ID AND  MT2008_8.AnaTypeID = ''A08''  AND MT2008_8.DivisionID = D.DivisionID
	LEFT JOIN AT1011 MT2008_9 ON MT2008_9.AnaID = D.Ana09ID AND  MT2008_9.AnaTypeID = ''A09''  AND MT2008_9.DivisionID = D.DivisionID
	LEFT JOIN AT1011 MT2008_10 ON MT2008_10.AnaID = D.Ana10ID AND  MT2008_10.AnaTypeID = ''A10''  AND MT2008_10.DivisionID = D.DivisionID
	LEFT JOIN A00003 on A00003.InventoryID = D.InventoryID and A00003.DivisionID = D.DivisionID
	'		+ @sSQLPer + ' ' 
			+ @DivisionWhere + ' ' 
			+ @sWHEREPer + 
			' AND (ISNULL(M.ObjectID, ''#'') IN (' + @ConditionOB + ') Or ' + @IsUsedConditionOB + ') 
				AND (ISNULL(M.VoucherTypeID, ''#'') IN (' + @ConditionVT + ') Or ' + @IsUsedConditionVT + ')'
EXEC(@sSQL1+@sSQL2)
print (@sSQL1)
print (@sSQL2)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
