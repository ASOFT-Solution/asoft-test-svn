IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP2016]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[MP2016]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Load Grid màn hình Kế thừa phiếu giao việc (Detail)
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
----Created by: Phan thanh hoang vu
----Create date: 02/03/2015
/*
	EXEC MP2016 'AS', 'fa7076e5-af53-4104-8bde-9bbd2f5d5e77', 1, ''
*/
 CREATE PROCEDURE MP2016
(
	@DivisionID VARCHAR(50),
	@VoucherID NVARCHAR(Max),
	@IsType tinyint, --0: Màn hình Kế quả sản sản xuất; 1: Màn hình Phiếu xuất kho
	@WareHouseID as varchar(50)
)
AS
BEGIN
		DECLARE @sSQL NVARCHAR (MAX),
				@sSQL1 NVARCHAR (MAX),
				@sSQL2 NVARCHAR (MAX),
				@sWhere NVARCHAR(MAX),
				@sSELECT NVARCHAR(MAX),
				@OrderBy NVARCHAR(500)
				
				SET @sWhere = ''
				
				SET @OrderBy = ' M.VoucherDate, M.VoucherNo, M.ObjectID'
	
				IF Isnull(@DivisionID, '') != ''
					SET @sWhere = @sWhere + 'And M.DivisionID = '''+ @DivisionID+''''

				IF @VoucherID is not null
					SET @sWhere = @sWhere + 'And M.VoucherID in ('''+ @VoucherID+''')'
				
				IF Isnull(@WareHouseID, '') != ''
					SET @sWhere = @sWhere + ' And D.WareHouseID = '''+ @WareHouseID+''''

				If @IsType = 0 
				Begin
					Set @sSQL1 = ' Left join ( 
											Select D.DivisionID, D.InventoryID, D.UnitID, sum(D.Quantity) as Quantity, Sum(D.ConvertedQuantity) as ConvertedQuantity, D.InheritVoucherID, 
											D.InheritTransactionID, D.InheritTableID
											From MT0810 M inner join MT1001 D on M.DivisionID =  D.DivisionID and M.VoucherID = D.VoucherID
																				and D.InheritVoucherID is not null
											Group by D.DivisionID, D.InventoryID, D.UnitID,D.InheritVoucherID, 
											D.InheritTransactionID, D.InheritTableID
							
										) A07 on D.DivisionID = A07.DivisionID and  D.VoucherID = A07.InheritVoucherID 
																				and D.TransactionID = A07.InheritTransactionID '
					
					Set @sSELECT = 'D.InventoryID, Isnull(D.InventoryCommonName,AT1302.InventoryName ) as InventoryCommonName, 
									D.UnitID, isnull(D.Quantity,0) - isnull(A07.Quantity,0) as Quantity, 
									isnull(D.ConvertedQuantity,0) - isnull(A07.ConvertedQuantity,0) as ConvertedQuantity, '
				End
				If @IsType = 1
				Begin
					Set @sSQL1 = ' Left join ( 
											Select D.DivisionID, D.InventoryID, D.UnitID, D.ActualQuantity as Quantity, D.ConvertedQuantity, D.InheritVoucherID, 
											D.InheritTransactionID, D.InheritTableID
											From AT2006 M inner join AT2007 D on M.DivisionID =  D.DivisionID and M.VoucherID = D.VoucherID
																				and D.InheritVoucherID is not null
										) A07 on D.DivisionID = A07.DivisionID and  D.VoucherID = A07.InheritVoucherID 
																				and D.TransactionID = A07.InheritTransactionID '
					

					Set @sSELECT = 'D.RInventoryID as InventoryID,  AT13021.InventoryName as InventoryCommonName, AT13021.UnitID, 1 as Quantity, 1 as ConvertedQuantity,'
				End

				SET @sSQL = '
				Select  convert(bit,0) as Choose, M.DivisionID, M.VoucherID, M.TranMonth, M.TranYear, M.VoucherTypeID, A17.VoucherTypeName, M.VoucherDate, 
				M.VoucherNo , O.PVoucherNo, O.SVoucherNo, M.RefNo01, M.RefNo02, M.RefNo03, M.RefNo04, M.RefNo05, M.ObjectID, A12.ObjectName, M.LaborID, 
				A131.FullName as LaborName, A131.DepartmentID, A131.DepartmentName, A131.TEAMID, A131.TeamName
				, M.EmployeeID, A132.FullName as EmployeeName, M.InventoryTypeID, M.Description, M.OrderStatus, 
				M.SOrderID, M.CreateDate, M.CreateUserID, M.LastModifyUserID, M.LastModifyDate, D.TransactionID, D.WareHouseID, 
				' +@sSELECT + 
				' 
				D.InventoryID as ProductID, 
				D.ExtraID, AT1311.ExtraName,
				
				D.Orders, 
				D.Description as Notes, D.Notes01, D.Notes02, D.Notes03, 
				D.Ana01ID, D.Ana02ID, D.Ana03ID, D.Ana04ID, D.Ana05ID, D.Ana06ID, D.Ana07ID, D.Ana08ID, D.Ana09ID, D.Ana10ID, D.nvarchar01, 
				D.nvarchar02, D.nvarchar03, D.nvarchar04, D.nvarchar05, D.nvarchar06, D.nvarchar07, D.nvarchar08, D.nvarchar09, D.nvarchar10, 
				M.VoucherID as InheritVoucherID, D.TransactionID as InheritTransactionID, ''MT2007'' as InheritTableID
				From MT2007 M Inner join MT2008 D on M.DivisionID = D.DivisionID and M.VoucherID = D.VoucherID' + 
								@sSQL1 + 
								'
								Left Join AT1311 on D.DivisionID = AT1311.DivisionID and D.ExtraID = AT1311.ExtraID
								Left Join AT1302 on D.DivisionID = AT1302.DivisionID and D.InventoryID = AT1302.InventoryID
								Left Join AT1302 AT13021 on D.DivisionID = AT13021.DivisionID and D.RInventoryID = AT13021.InventoryID
								Left join AT1202 A12 on M.ObjectID = A12.ObjectID and M.DivisionID = A12.DivisionID
								Left join HV1400 A131 on M.LaborID = A131.EmployeeID and M.DivisionID = A131.DivisionID
								Left join AT1103 A132 on M.EmployeeID = A132.EmployeeID and M.DivisionID = A132.DivisionID
								Left join AT1007 A17 on M.VoucherTypeID = A17.VoucherTypeID and M.DivisionID = A17.DivisionID
								Left join (
											Select D.DivisionID, M.VoucherNo as PVoucherNo, O.VoucherNo as SVoucherNo,M.SOrderID, D.TransactionID
			
											from OT2001 M inner join OT2002 D on M.SOrderID = D.SOrderID
															Left join (
																		Select M.VoucherNo, M.OrderDate, M.SOrderID, D.TransactionID, M.InheritSOrderID,
																		D.RefOrderID, D.RefSOrderID, D.RefSTransactionID
																		from OT2001 M inner join OT2002 D on M.SOrderID = D.SOrderID
																		Where M.OrderType = 0
																	) O on D.RefSOrderID = O.SOrderID and D.RefSTransactionID = O.TransactionID
											Where M.OrderType = 1
										  ) O on O.DivisionID = D.DivisionID and  O.SOrderID = D.InheritVoucherID 
																				and O.TransactionID = D.InheritTransactionID
							WHERE Isnull(D.Quantity,0) - Isnull(A07.Quantity,0) > 0 '+ @sWhere + 
							' Order By' + @OrderBy + ''

				EXEC (@sSQL)
				
				print @sSQL
			
END
