--Created by Hoµng ThÞ Lan
--Date 31/10/2003
--Purpose:In bao cao Ket qua san xuat
--Edit by: Dang Le Bao Quynh; Date 27/04/2007
--Purpose: Them truong he so chuyen doi va nhom theo ma phan tich
--Edit Tuyen. date 04/05/2010 xu ly chia cho 0
--- Modify on 11/06/2014 by Bảo Anh: Sửa cách tính ConvertedAmount (phân bổ đều giá thành vì có trường hợp nhiều phiếu KQSX có 1 mặt hàng cùng tỷ lệ hoàn thành)
---- Modified on 13/08/2014 by Le Thi Thu Hien : ConvertedAmount đã tính cho từng Quantity*Price
/********************************************
'* Edited by: [GS] [Tố Oanh] [30/07/2010]
'********************************************/
ALTER Procedure [dbo].[MP0812]       
(
				@DivisionID nvarchar(50),	
				@PeriodID as nvarchar(50),	
				@ResultTypeID as nvarchar(50),		 
				@FromMonth as int,
				@FromYear as int,
				@ToMonth as int,
				@ToYear as int,
				@AnaID as nvarchar(50)
)
as	
Declare @sSQL as nvarchar(max),
	@FromPeriod as int,
	@ToPeriod as int,
	@Where@ResultTypeID as nvarchar(2000)
Select  @FromPeriod =    @FromMonth + @FromYear*100,  @ToPeriod = @ToMonth + @ToYear*100,
		@Where@ResultTypeID = case when isnull(@ResultTypeID, '') = '' then '' else ' and MT0810.ResultTypeID=''' + @ResultTypeID + '''' end

If (@AnaID Is Null or @AnaID='')
	Set @sSQL='
SELECT DISTINCT MT0810.VoucherID,
		MT0810.VoucherTypeID,
		MT0810.PeriodID,
		MT1601.Description as PeriodName,
		MT0810.DivisionID,
		MT0810.DepartmentID,
		AT1102.DepartmentName,
		MT0810.VoucherNo,
		MT0810.VoucherDate,
		MT0810.EmployeeID,	
		MT0810.KCSEmployeeID,	
		MT0810.Description,
		MT0810.CreateDate,
		MT0810.CreateUserID,
		MT0810.LastModifyUserID,
		MT0810.LastModifyDate,
		MT0810.ResultTypeID,
		MT0811.ResultTypeName,
		MT0810.InventoryTypeID,
		AT1301.InventoryTypeName,
		MT1001.PerfectRate,
		MT1001.ProductID,
		AT1302.InventoryName as ProductName,
		AT1302.Notes01 as Notes01,
		AT1302.Notes02 as Notes02,
		AT1302.Notes03 as Notes03,
		MT1001.UnitID,
		MT1001.TransactionID,
		MT1001.Price,
		MT1001.ConvertedAmount,
		--(case when MT0810.ResultTypeID = ''R01'' then MT1001.ConvertedAmount
		--else (MT1001.ConvertedAmount/(select count(T80.VoucherID) from MT0810 T80
		--						Where T80.ResultTypeID = MT0810.ResultTypeID and T80.TranMonth = MT0810.TranMonth and T80.TranYear = MT0810.TranYear and T80.PeriodID = MT0810.PeriodID
		--						And VoucherID in (Select T01.VoucherID From MT1001 T01 Where T01.ProductID = MT1001.ProductID and Isnull(T01.PerfectRate,100) = Isnull(MT1001.PerfectRate,100))								 
		--)) end) as ConvertedAmount,
		MT1001.Note,
		MT1001.Quantity,
		MT1001.MaterialRate,
		MT1001.HumanResourceRate,
		MT1001.OthersRate, Null as AnaIDGroup, Null as AnaNameGroup,
		(Select Top 1 
		(Case When Operator = 1 Then ConversionFactor Else 1/ case when isnull(ConversionFactor,1) = 0 then 1 end   End) As ConversionFactor 
		From AT1309 
		Where InventoryID  =  MT1001.ProductID And DivisionID = MT1001.DivisionID
		And DivisionID =''' + @DivisionID + '''
		Order by At1309.UnitID) As ConversionFactor, 
		(Select Top 1 
		(select UnitName From AT1304 Where UnitID = AT1309.UnitID And DivisionID = AT1309.DivisionID) As UnitName  
		From AT1309 
		Where InventoryID  =  MT1001.ProductID And DivisionID = MT1001.DivisionID
		And DivisionID =''' + @DivisionID + '''
		Order by At1309.UnitID) As UnitName 
		, MT1001.MOrderID
	FROM	MT0810   	      
	INNER JOIN MT1001 on MT0810.VoucherID=MT1001.VoucherID and MT0810.DivisionID=MT1001.DivisionID
	LEFT JOIN AT1302 on MT1001.ProductID=AT1302.InventoryID 	and MT1001.DivisionID=AT1302.DivisionID 	
	INNER JOIN MT1601 on MT0810.PeriodID=MT1601.PeriodID	and MT0810.DivisionID=MT1601.DivisionID
	LEFT JOIN AT1301 on AT1301.InventoryTypeID=MT0810.InventoryTypeID and AT1301.DivisionID=MT0810.DivisionID
	LEFT JOIN AT1102 on AT1102.DepartmentID=MT0810.DepartmentID and AT1102.DivisionID=MT0810.DivisionID
	LEFT JOIN MT0811 on MT0810.ResultTypeID=MT0811.ResultTypeID and MT0810.DivisionID=MT0811.DivisionID
	WHERE	MT0810.DivisionID = ''' + @DivisionID + ''' 
			AND MT0810.PeriodID like '''+@PeriodID+''' 
			AND MT0810.TranMonth+MT0810.TranYear*100 between ' + str(@FromPeriod)+' and ' + str(@ToPeriod) + @Where@ResultTypeID
Else
	Set @sSQL='
		Select Distinct MT0810.VoucherID,
		MT0810.VoucherTypeID,
		MT0810.PeriodID,
		MT1601.Description as PeriodName,
		MT0810.DivisionID,
		MT0810.DepartmentID,
		AT1102.DepartmentName,
		MT0810.VoucherNo,
		MT0810.VoucherDate,
		MT0810.EmployeeID,	
		MT0810.KCSEmployeeID,	
		MT0810.Description,
		MT0810.CreateDate,
		MT0810.CreateUserID,
		MT0810.LastModifyUserID,
		MT0810.LastModifyDate,
		MT0810.ResultTypeID,
		MT0811.ResultTypeName,
		MT0810.InventoryTypeID,
		AT1301.InventoryTypeName,
		MT1001.PerfectRate,
		MT1001.ProductID,
		AT1302.InventoryName as ProductName,
		AT1302.Notes01 as Notes01,
		AT1302.Notes02 as Notes02,
		AT1302.Notes03 as Notes03,
		MT1001.UnitID,
		MT1001.TransactionID,
		MT1001.Price,
		MT1001.ConvertedAmount,
		--(MT1001.ConvertedAmount/(Select count(*) From MT1001 T01 Where T01.DivisionID = MT1001.DivisionID And T01.ProductID = MT1001.ProductID
		--And T01.PerfectRate = MT1001.PerfectRate)) as ConvertedAmount,
		MT1001.Note,
		MT1001.Quantity,
		MT1001.MaterialRate,
		MT1001.HumanResourceRate,
		MT1001.OthersRate, (Select ' + @AnaID + 'ID From AT1302 Where InventoryID = MT1001.ProductID And DivisionID = MT1001.DivisionID) As AnaIDGroup,
		(Select AnaName From AT1015 Where AnaTypeID = ''' + @AnaID + ''' And AnaID In (Select ' + @AnaID + 'ID From AT1302 Where InventoryID = MT1001.ProductID And AT1302.DivisionID = MT1001.DivisionID) And DivisionID = MT1001.DivisionID) As AnaNameGroup,
		(Select Top 1 UserName From AT0005 Where TypeID = ''' + @AnaID  + ''' And DivisionID = MT1001.DivisionID) As AnaNameCommon, 
		(Select Top 1 
		(Case When Operator = 1 Then ConversionFactor Else 1/case when isnull(ConversionFactor,1) = 0 then 1 end  End) As ConversionFactor 
		From AT1309 
		Where InventoryID  =  MT1001.ProductID And DivisionID = MT1001.DivisionID 
		And DivisionID =''' + @DivisionID + '''
		Order by At1309.UnitID) As ConversionFactor, 
		(Select Top 1 
		(select UnitName From AT1304 Where UnitID = AT1309.UnitID And DivisionID = AT1309.DivisionID) As UnitName  
		From AT1309 
		Where InventoryID  =  MT1001.ProductID And DivisionID = MT1001.DivisionID 
		And DivisionID =''' + @DivisionID + ''' 
		Order by At1309.UnitID) As UnitName 
		, MT1001.MOrderID
	
	From MT0810   	      
	    	          inner join MT1001 on MT0810.VoucherID=MT1001.VoucherID 	and MT0810.DivisionID=MT1001.DivisionID
		          left join AT1302 on MT1001.ProductID=AT1302.InventoryID and	MT1001.DivisionID=AT1302.DivisionID
		          inner join MT1601 on MT0810.PeriodID=MT1601.PeriodID	and MT0810.DivisionID=MT1601.DivisionID
		          left join AT1301 on AT1301.InventoryTypeID=MT0810.InventoryTypeID and AT1301.DivisionID=MT0810.DivisionID
			left join AT1102 on AT1102.DepartmentID=MT0810.DepartmentID and AT1102.DivisionID=MT0810.DivisionID
			left join MT0811 on MT0810.ResultTypeID=MT0811.ResultTypeID and MT0810.DivisionID=MT0811.DivisionID
	Where MT0810.DivisionID = ''' + @DivisionID + ''' and MT0810.PeriodID like '''+@PeriodID+''' 
		and MT0810.TranMonth+MT0810.TranYear*100 between ' + str(@FromPeriod)+' and ' + str(@ToPeriod) + @Where@ResultTypeID
	
--Print @sSQL
If not exists (Select top 1 1 From SysObjects Where name = 'MV0812' and Xtype ='V')
	Exec ('Create view MV0812 as '+@sSQL)
Else
	Exec ('Alter view MV0812 as '+@sSQL)