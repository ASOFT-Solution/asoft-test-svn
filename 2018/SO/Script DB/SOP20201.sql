IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'SOP20201') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE SOP20201
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
---- Load Grid Form SOP2020 Danh muc phiếu báo giá
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
----Created by: Thị Phượng, Date: 23/03/2017
--- Modify by Thị Phượng, Date 08/05/2017: Bổ sung phân quyền
--- Modify by Thị Phượng, Date 30/08/2017: Thay đổi cách sắp xếp order by theo CreateDate
--- Modify by Thị Phượng, Date 08/11/2017: Bổ sung thêm xử lý search nâng cao
-- <Example>
----    EXEC SOP20201 'AS','','','','','','','', 1, '2015-01-01', '2017-12-30', '05/2017'',''03/2017'',''04/2017' ,'NV01',N'ASOFTADMIN'', ''DANH'', ''HOANG'', ''HUYEN'', ''LIEN'', ''LUAN'', ''PHUONG'', ''QUI'', ''QUYNH'', ''VU' ,1,20,''
----
CREATE PROCEDURE SOP20201 ( 
  @DivisionID VARCHAR(50),
  @DivisionIDList NVARCHAR(2000),  
  @QuotationNo  NVARCHAR(250),
  @ObjectID  NVARCHAR(250),
  @VoucherTypeID  NVARCHAR(250),
  @EmployeeID  NVARCHAR(250),
  @Status  NVARCHAR(250),
  @IsConfirm  NVARCHAR(250),
  @IsDate TINYINT,--0: theo ngày, 1: Theo kỳ
  @FromDate Datetime,
  @ToDate Datetime,
  @Period NVARCHAR(4000),
  @UserID  VARCHAR(50),
  @ConditionQuotationID NVARCHAR (MAX),
  @PageNumber INT,
  @PageSize INT,
  @SearchWhere NVARCHAR(Max) = null
  ) 
AS 
DECLARE @sSQL NVARCHAR (MAX),
		@sSQL1 NVARCHAR (MAX),
		@sWhere NVARCHAR(MAX),
		@OrderBy NVARCHAR(500),
        @TotalRow NVARCHAR(50)
        
SET @sWhere = ' 1 = 1 '
SET @TotalRow = ''
SET @OrderBy = 'OT2101.DivisionID, OT2101.CreateDate DESC, OT2101.QuotationNo'

IF isnull(@SearchWhere,'') =''
Begin
	IF @IsDate = 0 
	SET @sWhere = @sWhere + ' AND CONVERT(VARCHAR(10),OT2101.QuotationDate,21) BETWEEN '''+ CONVERT(VARCHAR(10),@FromDate,21)+''' AND '''+CONVERT(VARCHAR(10),@ToDate,21)+''''
	IF @IsDate = 1 
	SET @sWhere = @sWhere + ' AND (CASE WHEN OT2101.TranMonth <10 THEN ''0''+rtrim(ltrim(str(OT2101.TranMonth)))+''/''+ltrim(Rtrim(str(OT2101.TranYear))) 
				ELSE rtrim(ltrim(str(OT2101.TranMonth)))+''/''+ltrim(Rtrim(str(OT2101.TranYear))) END) in ('''+@Period +''')'
	--Check Para DivisionIDList null then get DivisionID 
	IF @DivisionIDList IS NULL or @DivisionIDList = ''
		SET @sWhere = @sWhere + 'and OT2101.DivisionID = '''+ @DivisionID+''''
	Else 
		SET @sWhere = @sWhere + 'and OT2101.DivisionID IN ('''+@DivisionIDList+''')'
	IF isnull(@QuotationNo,'') !=''
		SET @sWhere = @sWhere + ' AND ISNULL(OT2101.QuotationNo, '''') LIKE N''%'+@QuotationNo+'%'' '
	IF Isnull(@ObjectID,'') !='' 
		SET @sWhere = @sWhere + ' AND (ISNULL(OT2101.ObjectID, '''') LIKE N''%'+@ObjectID+'%''  or ISNULL(OT2101.ObjectName, '''') LIKE N''%'+@ObjectID+'%'')'
	IF Isnull(@VoucherTypeID,'') !='' 
		SET @sWhere = @sWhere + ' AND ISNULL(OT2101.VoucherTypeID, '''') LIKE N''%'+@VoucherTypeID+'%'' '
	IF Isnull(@EmployeeID, '') !=''
		SET @sWhere = @sWhere + ' AND (ISNULL(OT2101.EmployeeID, '''') LIKE N''%'+@EmployeeID+'%''  or ISNULL(A03.FullName, '''') LIKE N''%'+@EmployeeID+'%'')' 
	IF Isnull(@IsConfirm,'') !=''
		SET @sWhere = @sWhere + ' AND ISNULL(OT2101.IsConfirm, '''') LIKE N''%'+@IsConfirm+'%'' '
	IF Isnull(@Status,'') !=''
		SET @sWhere = @sWhere + ' AND ISNULL(OT2101.OrderStatus, '''') LIKE N''%'+@Status+'%'' '
	IF Isnull(@ConditionQuotationID,'') !=''
		SET @sWhere = @sWhere + ' AND ISNULL(OT2101.EmployeeID, OT2101.CreateUserID) IN ('''+@ConditionQuotationID+''') '
END
IF isnull(@SearchWhere,'') !=''
Begin
	SET  @sWhere='1 = 1'
End
SET @sSQL = 'SELECT  OT2101.APK, OT2101.DivisionID
, OT2101.QuotationID, OT2101.VoucherTypeID, OT2101.QuotationNo
, OT2101.QuotationDate, OT2101.ObjectID, OT2101.Transport, OT2101.Attention1, OT2101.Attention2, OT2101.Dear
, Case When OT2101.ObjectName is null then A01.ObjectName else OT2101.ObjectName end as ObjectName
, OT2101.DeliveryAddress, OT2101.Disabled, AT0099.Description as OrderStatus, B.Description as QuotationStatusName
, OT2101.CreateDate, OT2101.CreateUserID, OT2101.LastModifyUserID, OT2101.LastModifyDate, OT2101.Ana01ID
, OT2101.Ana02ID, OT2101.Ana03ID, OT2101.Ana04ID, OT2101.Ana05ID, OT2101.CurrencyID, OT2101.ExchangeRate
, OT2101.InventoryTypeID, OT2101.TranMonth, OT2101.TranYear, OT2101.EmployeeID
, OT2101.PaymentID, OT2101.Address, OT2101.OpportunityID, OT2101.EndDate, Isnull(OT2101.IsSO, 0) as IsSO
, OT2101.SalesManID,  OT2101.PaymentTermID, OT2101.IsConfirm, A.Description as IsConfirmName, OT2101.DescriptionConfirm, OT2101.Varchar01
	, OT2101.Varchar02, OT2101.Varchar03, OT2101.Varchar04, OT2101.Varchar05, OT2101.Varchar06, OT2101.Varchar07, OT2101.Varchar08
	, OT2101.Varchar09, OT2101.Varchar10, OT2101.Varchar11, OT2101.Varchar12, OT2101.Varchar13, OT2101.Varchar14, OT2101.Varchar15
	, OT2101.Varchar16, OT2101.Varchar17, OT2101.Varchar18, OT2101.Varchar19, OT2101.Varchar20,  OT2101.PriceListID
, OT2101.Ana06ID, OT2101.Ana07ID, OT2101.Ana08ID, OT2101.Ana09ID, OT2101.Ana10ID, OT2101.DeleteFlg
, A03.FullName as EmployeeName, OT2101.Description
Into #TemOT2101
FROM OT2101 With (NOLOCK) 
			Left join AT1202 A01 With (NOLOCK) on OT2101.ObjectID = A01.ObjectID
			Left join AT1103 A03 With (NOLOCK) on  OT2101.EmployeeID = A03.EmployeeID
			Left join AT0099 With (NOLOCK) on Convert(varchar, OT2101.OrderStatus) = AT0099.ID and AT0099.CodeMaster = ''AT00000003''
			Left join CRMT0099 B With (NOLOCK) on Convert(varchar, OT2101.QuotationStatus) = B.ID and B.CodeMaster = ''CRMT00000015''
			Left join AT0099  A With (NOLOCK) on isnull(OT2101.IsConfirm,0) = A.ID and A.CodeMaster = ''AT00000039''
	WHERE '+@sWhere+' and isnull(OT2101.DeleteFlg, 0) =0

	Declare @Count int
	Select @Count = Count(OrderStatus) From  #TemOT2101
	'+Isnull(@SearchWhere,'')+''

SET	@sSQL1 =N'Select ROW_NUMBER() OVER (Order BY '+@OrderBy+') AS RowNum, @Count AS TotalRow	
	,  OT2101.APK, OT2101.DivisionID, OT2101.QuotationID, OT2101.VoucherTypeID, OT2101.QuotationNo
	, convert(varchar(20), OT2101.QuotationDate, 103) as QuotationDate
	, OT2101.ObjectID, OT2101.Transport, OT2101.Attention1, OT2101.Attention2, OT2101.Dear, ObjectName
	, OT2101.DeliveryAddress, OT2101.Disabled, OrderStatus, QuotationStatusName
	, OT2101.CreateDate, OT2101.CreateUserID, OT2101.LastModifyUserID, OT2101.LastModifyDate, OT2101.Ana01ID
	, OT2101.Ana02ID, OT2101.Ana03ID, OT2101.Ana04ID, OT2101.Ana05ID, OT2101.CurrencyID, OT2101.ExchangeRate
	, OT2101.InventoryTypeID, OT2101.TranMonth, OT2101.TranYear, OT2101.EmployeeID
	, OT2101.PaymentID, OT2101.Address, OT2101.OpportunityID, OT2101.EndDate, IsSO
	, OT2101.SalesManID,  OT2101.PaymentTermID, OT2101.IsConfirm, IsConfirmName, OT2101.DescriptionConfirm, OT2101.Varchar01
	, OT2101.Varchar02, OT2101.Varchar03, OT2101.Varchar04, OT2101.Varchar05, OT2101.Varchar06, OT2101.Varchar07, OT2101.Varchar08
	, OT2101.Varchar09, OT2101.Varchar10, OT2101.Varchar11, OT2101.Varchar12, OT2101.Varchar13, OT2101.Varchar14, OT2101.Varchar15
	, OT2101.Varchar16, OT2101.Varchar17, OT2101.Varchar18, OT2101.Varchar19, OT2101.Varchar20, OT2101.PriceListID
	, OT2101.Ana06ID, OT2101.Ana07ID, OT2101.Ana08ID, OT2101.Ana09ID, OT2101.Ana10ID, OT2101.DeleteFlg
	, EmployeeName, OT2101.Description
	From  #TemOT2101 OT2101
	'+Isnull(@SearchWhere,'')+'
	Order BY '+@OrderBy+'
	OFFSET '+STR((@PageNumber-1) * @PageSize)+' ROWS
	FETCH NEXT '+STR(@PageSize)+' ROWS ONLY '
EXEC (@sSQL + @sSQL1)
--print (@sSQL)
--print (@sSQL1)