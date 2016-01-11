IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0355]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[HP0355]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--- Created by Hoàng Vũ	Date: 03/12/2015
--- Purpose: Load master kế thừa kết quả sản xuất từ cập nhật chấm công sản phẩm theo phương pháp chỉ định (HF0288)
--- Edit by ..
--- EXEC HP0355 'AS', 1,2015,12,2015,'2015-01-01', '2015-12-31', 1, '', '', '' ,'', ''

CREATE PROCEDURE [dbo].[HP0355] 
(
	@DivisionID nvarchar(50),
	@FromMonth int,
    @FromYear int,
    @ToMonth int,
    @ToYear int,  
    @FromDate as datetime,
    @ToDate as Datetime,
    @IsDate as tinyint, ----0 theo ky, 1 theo ngày
	@DepartmentID nvarchar(50),
	@TeamID nvarchar(50),
	@KCSEmployeeID nvarchar(50),
	@HRMEmployeeID nvarchar(50),
	@UserID nvarchar(50)
)
AS
Begin
		Declare @sSQL AS varchar(max),
				@sWHERE01 AS VARCHAR(MAX),
				@sWHERE02 AS VARCHAR(MAX)
		SET @sWHERE01 = ''
		SET @sWHERE02 = ''

		IF @DivisionID is not null
			Set @sWHERE01 = @sWHERE01 + ' and ISNULL(x.DivisionID,'''') LIKE N''%'+@DivisionID+'%'' ' 

		IF isnull(@IsDate, 0) = 0
			Set  @sWHERE01 = @sWHERE01 + ' and (x.TranMonth + x.TranYear*100 between ' + cast(@FromMonth + @FromYear*100 as nvarchar(50)) 
								   + ' and ' +  cast(@ToMonth + @ToYear*100 as nvarchar(50))  + ')'
		else
			Set  @sWHERE01 = @sWHERE01 + ' and (x.VoucherDate  Between '''+Convert(nvarchar(10),@FromDate,21)
								   + ''' and '''+convert(nvarchar(10), @ToDate,21)+''')'
		IF @DepartmentID is not null
			Set @sWHERE01 = @sWHERE01 + ' and ISNULL(x.DepartmentID,'''') LIKE N''%'+@DepartmentID+'%'' ' 

		IF @TeamID is not null
			Set @sWHERE01 = @sWHERE01 + ' and ISNULL(x.TeamID,'''') LIKE N''%'+@TeamID+'%'' ' 

		IF @KCSEmployeeID is not null
			Set @sWHERE01 = @sWHERE01 + ' and ISNULL(x.KCSEmployeeID,'''') LIKE N''%'+@KCSEmployeeID+'%'' ' 
		
		IF @HRMEmployeeID is not null
			Set @sWHERE02 = @sWHERE02 + ' Where ISNULL(D.HRMEmployeeID,'''') LIKE N''%'+@HRMEmployeeID+'%'' ' 

		SET @sSQL ='Select Distinct convert(bit,0) as Choose, x.DivisionID, x.VoucherID
					, x.TranMonth, x.TranYear, x.VoucherTypeID, x.VoucherNo, x.VoucherDate
					, x.ObjectID, AT1202.ObjectName
					, x.DepartmentID, AT1102.DepartmentName
					, x.TeamID, HT1101.TeamName
					, x.EmployeeID, AT1103.FullName as EmployeeName
					, x.KCSEmployeeID, AT1103_01.FullName as KSCEmployeeName
					, x.WareHouseID, AT1303.WareHouseName, x.Description
					
					From 
							(Select M.DivisionID, M.VoucherID, M.TranMonth, M.TranYear
									, M.VoucherNo, M.VoucherDate, M.DepartmentID, M.TeamID
									, M.EmployeeID, M.KCSEmployeeID, D.HRMEmployeeID
									, M.Description, M.VoucherTypeID
									, M.WareHouseID, M.ObjectID
									, D.TransactionID, D.InventoryID, D.ProductID, D.UnitID
									, D.Quantity
									, isnull((Select Sum(isnull(Quantity,0)) From HT0287 Where HT0287.InheritTransactionID = D.TransactionID),0) 
									As InheritedQuantity
									, D.Quantity - isnull((Select Sum(isnull(Quantity,0)) From HT0287 
															Where HT0287.InheritTransactionID = D.TransactionID),0) As RemainQuantity
									, D.Note, D.Orders, D.Ana01ID, D.Ana02ID, D.Ana03ID, D.Ana04ID, D.Ana05ID
									, D.Ana06ID, D.Ana07ID, D.Ana08ID, D.Ana09ID, D.Ana10ID
							From MT0810 M inner join MT1001 D on M.DivisionID = D.DivisionID and M.VoucherID = D.VoucherID
							' + @sWHERE02 + '
							) x left join AT1103 on x.DivisionID = AT1103.DivisionID and x.EmployeeID = AT1103.EmployeeID
								left join AT1103 AT1103_01 on x.DivisionID = AT1103_01.DivisionID and x.KCSEmployeeID = AT1103_01.EmployeeID
								Left join AT1303 on x.DivisionID = AT1303.DivisionID and x.WareHouseID = AT1303.WareHouseID
								Left join AT1102 on x.DivisionID = AT1102.DivisionID and x.DepartmentID = AT1102.DepartmentID
								Left join AT1202 on x.DivisionID = AT1202.DivisionID and x.ObjectID = AT1202.ObjectID
								Left join HT1101 on x.DivisionID = HT1101.DivisionID and x.TeamID = HT1101.TeamID
								
					Where x.RemainQuantity>0 
					'+ @sWHERE01+
					' Order by x.VoucherDate, x.VoucherNo'	

		EXEC(@sSQL)
		print @sSQL
		
end
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
