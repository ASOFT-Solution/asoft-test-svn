IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP2015]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[MP2015]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Load Grid màn hình Kế thừa phiếu giao việc (Master)
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
	EXEC MP2015 'AS', 2,2014,3,2016 , 1, ''
*/
 CREATE PROCEDURE MP2015
(
	@DivisionID VARCHAR(50),
    @FromMonth as int,
	@FromYear as int,
	@ToMonth as int,
	@ToYear as int,
	@IsType tinyint, --0: Kế quả sản sản xuất; 1: Phiếu xuất kho
	@WareHouseID as varchar(50)
)
AS
BEGIN
		DECLARE @sSQL NVARCHAR (MAX),
				@sWhere NVARCHAR(MAX),
				@sSQL1 NVARCHAR (MAX),
				@sWhere1 NVARCHAR(MAX),
				@OrderBy NVARCHAR(500),
				@FromMonthYearText NVARCHAR(20), 
				@ToMonthYearText NVARCHAR(20)
				
				SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
				SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
				
				SET @sWhere = ''
				SET @OrderBy = ' M.VoucherDate, M.VoucherNo, M.ObjectID'
	
				IF Isnull(@DivisionID, '') != ''
					SET @sWhere = @sWhere + ' And M.DivisionID = '''+ @DivisionID+''''
				IF isnull(@WareHouseID, '') != '' 
					SET @sWhere = @sWhere + ' And D.WareHouseID = '''+ @WareHouseID+''' '
				
				
				If @IsType = 0
				Begin
					Set @sSQL1 = ' Left join ( 
											Select D.DivisionID, D.InventoryID, D.UnitID, Sum(D.Quantity) as Quantity, D.InheritVoucherID, 
											D.InheritTransactionID, D.InheritTableID
											From MT0810 M inner join MT1001 D on M.DivisionID =  D.DivisionID and M.VoucherID = D.VoucherID
																				and D.InheritVoucherID is not null
											Group by D.DivisionID, D.InventoryID, D.UnitID, D.InheritVoucherID, 
											D.InheritTransactionID, D.InheritTableID
										) A07 on D.DivisionID = A07.DivisionID and  D.VoucherID = A07.InheritVoucherID 
																				and D.TransactionID = A07.InheritTransactionID '
					Set @sWhere1 =  ' Having Sum(Isnull(D.Quantity,0)) - Sum(Isnull(A07.Quantity,0)) > 0 '
				End
				If @IsType = 1
				Begin
					Set @sSQL1 = ' Left join ( 
											Select D.DivisionID, D.InventoryID, D.UnitID, D.ActualQuantity, D.InheritVoucherID, 
											D.InheritTransactionID, D.InheritTableID
											From AT2006 M inner join AT2007 D on M.DivisionID =  D.DivisionID and M.VoucherID = D.VoucherID
																				and D.InheritVoucherID is not null
										) A07 on D.DivisionID = A07.DivisionID and  D.VoucherID = A07.InheritVoucherID 
																				and D.TransactionID = A07.InheritTransactionID '
					Set @sWhere1 =  ' Having Sum(Isnull(D.Quantity,0)) - Sum(Isnull(A07.ActualQuantity,0)) > 0 '
					
				End
				
				SET @sSQL = '
							Select  Distinct convert(bit,0) as Choose, M.DivisionID, M.VoucherID,M.TranMonth,M.TranYear,
									M.VoucherTypeID, A17.VoucherTypeName, M.VoucherDate,M.VoucherNo,
									M.RefNo01,M.RefNo02,M.RefNo03,M.RefNo04,M.RefNo05,
									M.ObjectID, A12.ObjectName,
									M.LaborID, A131.FullName as LaborName,
									M.EmployeeID, A132.FullName as EmployeeName,
									M.Description,M.OrderStatus

							From MT2007 M Inner join MT2008 D on M.DivisionID = D.DivisionID and M.VoucherID = D.VoucherID ' + 
											@sSQL1
										  + ' Left join AT1202 A12 on M.ObjectID = A12.ObjectID and M.DivisionID = A12.DivisionID
										  Left join AT1103 A131 on M.LaborID = A131.EmployeeID and M.DivisionID = A131.DivisionID
										  Left join AT1103 A132 on M.EmployeeID = A132.EmployeeID and M.DivisionID = A132.DivisionID
										  Left join AT1007 A17 on M.VoucherTypeID = A17.VoucherTypeID and M.DivisionID = A17.DivisionID
							WHERE M.OrderStatus = 0 and M.TranMonth + 100*M.TranYear between  '+ @FromMonthYearText  + ' and  ' + @ToMonthYearText
							+@sWhere + 
							' Group by M.DivisionID, M.VoucherID, M.TranMonth, M.TranYear, M.VoucherTypeID, A17.VoucherTypeName, M.VoucherDate, 
									   M.VoucherNo, M.RefNo01, M.RefNo02, M.RefNo03, M.RefNo04, M.RefNo05, M.ObjectID,A12.ObjectName, M.LaborID, 
									   A131.FullName, M.EmployeeID, A132.FullName, M.Description,M.OrderStatus '+ @sWhere1 + ' Order by ' +  @OrderBy + ''

				EXEC (@sSQL)
				--Print @sSQL
				
			
END
