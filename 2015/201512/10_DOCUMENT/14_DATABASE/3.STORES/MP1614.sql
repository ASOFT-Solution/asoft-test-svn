IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP1614]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP1614]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--Created by Hoang Thi Lan
--Date 21/10/2003
--Purpose :Dïng hiÓn thÞ d÷ liÖu lªn Grid cña Form (MF1633-Danh môc phiÕu CPDDDKú)
--Edit by Phan thanh hoàng vũ, on 10/08/2015: Bổ sung thêm phần quyền xem dữ liệu của người khác (Danh mục chi phí dỡ dang đầu kỳ-MF0049)
--Test: EXEC MP1614 'AS', 'AAA', 1,2013,1,2016,'NV003'
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [02/08/2010]
'**************************************************************/

CREATE PROCEDURE [dbo].[MP1614] @DivisionID as nvarchar(50),@PeriodID as nvarchar(50),
			@FromMonth as int,
			@FromYear as int,
			@ToMonth as int,
			@ToYear as int,
			@UserID nvarchar(50)
as
Declare @FromPeriod as int,
	@ToPeriod as int,
	@sSQL as nvarchar(4000)
Set @FromPeriod=@FromMonth+@FromYear*100
Set @ToPeriod=@ToMonth+@ToYear*100
	

	----------------->>>>>> Phân quyền xem chứng từ của người dùng khác		
		DECLARE @sSQLPer AS NVARCHAR(MAX),
				@sWHEREPer AS NVARCHAR(MAX)
		SET @sSQLPer = ''
		SET @sWHEREPer = ''		

		IF EXISTS (SELECT TOP 1 1 FROM MT0000 WHERE DivisionID = @DivisionID AND IsPermissionView = 1) -- Nếu check Phân quyền xem dữ liệu tại Thiết lập hệ thống thì mới thực hiện
			BEGIN
				SET @sSQLPer = ' LEFT JOIN AT0010 ON AT0010.DivisionID = MT1612.DivisionID 
													AND AT0010.AdminUserID = '''+@UserID+''' 
													AND AT0010.UserID = MT1612.CreateUserID '
				SET @sWHEREPer = ' AND (MT1612.CreateUserID = AT0010.UserID
										OR  MT1612.CreateUserID = '''+@UserID+''') '		
			END

		-----------------<<<<<< Phân quyền xem chứng từ của người dùng khác		


Set @sSQL='
Select Distinct VoucherTypeID,
	--WipVoucherID,
	VoucherID,
	VoucherNo,
	EmployeeID,
	VoucherDate,
	PeriodID,
	ProductID,
	MT1612.Type,
	AT1302.InventoryName as ProductName,
	AT1302.UnitID,
	ProductQuantity,sum(ConvertedAmount) as ConvertedAmount,
	MT1612.DivisionID

From MT1612 left join AT1302 on MT1612.ProductID = AT1302.InventoryID and MT1612.DivisionID = AT1302.DivisionID
' + @sSQLPer+ '
Where MT1612.DivisionID='''+ @DivisionID +'''
	and TranMonth+TranYear*100 between '+str(@FromPeriod)+' and '+str(@ToPeriod)+'
	and MT1612.PeriodID like '''+@PeriodID+'''
	'+ @sWHEREPer+'
Group by  VoucherTypeID,
	VoucherID,
	VoucherNo,
	EmployeeID,
	VoucherDate,
	PeriodID,
	ProductID,
	MT1612.Type,	
	AT1302.InventoryName,
	AT1302.UnitID, ProductQuantity,
	MT1612.DivisionID'

If not Exists (Select top 1 1 From SysObjects Where Xtype ='V' and name ='MV1614')
	 Exec ('Create view MV1614 as '  +@sSQL)
Else
	Exec ('Alter view MV1614 as '+@sSQL)
Print @sSQL
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
