IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[CRMP30201]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[CRMP30201]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
----In báo cáo Danh sách Khách hàng ngưng sử dụng
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
----Created by: Thị Phượng By on 28/01/2016
-- <Example>
----    EXEC CRMP10105 'AS','AS','','','','','','','', 'NV01'

CREATE PROCEDURE [dbo].[CRMP30201] ( 
        @DivisionID       VARCHAR(50),  --Biến môi trường
		@DivisionIDList    NVARCHAR(2000),  --Chọn trong DropdownChecklist DivisionID
		@FromDate         DATETIME,
		@ToDate           DATETIME,
		@IsDate           TINYINT,--- =1 theo ngày , = 0 Theo kỳ
		@Period nvarchar(max),
		@FromAccountID       Varchar(50),
		@ToAccountID         Varchar(50),
		@UserID  VARCHAR(50)	
)
AS
DECLARE
        @sSQL NVARCHAR (MAX),
		@sWhere NVARCHAR(MAX)
       

SET @sWhere = ''

--Check Para DivisionIDList null then get DivisionID 
	IF @DivisionIDList IS NULL or @DivisionIDList = ''
		SET @sWhere = @sWhere + '  M.DivisionID = '''+ @DivisionID+''''
	Else 
		SET @sWhere = @sWhere + '  M.DivisionID IN ('''+@DivisionIDList+''')'
	IF (@FromAccountID is not null and @ToAccountID is not null)
		SET @sWhere = @sWhere +' AND (M.ObjectID between N'''+@FromAccountID+N''' and N'''+@ToAccountID+N''')'
	
	IF @IsDate = 1 ---xác định theo ngày
		SET @sWhere = @sWhere + ' AND (CONVERT(VARCHAR(10),M.CreateDate,112) BETWEEN'''+ CONVERT(VARCHAR(20),@FromDate,112)+''' AND''' + CONVERT(VARCHAR(20),@ToDate,112) +''')'
	Else
		SET @sWhere = @sWhere + ' AND (CASE WHEN M.TranMonth <10 THEN ''0''+rtrim(ltrim(str(M.TranMonth)))+''/''+ltrim(Rtrim(str(M.TranYear))) 
								ELSE rtrim(ltrim(str(M.TranMonth)))+''/''+ltrim(Rtrim(str(M.TranYear))) END) in ('''+@Period+''')'

Set @sSQL = N'
	Select b.DivisionID,  b.OrderDate, b.ObjectID, b.ObjectName, b.Address ,b.Tel, c.InventoryID, c.InventoryName ,c.AvgQuantity
	From 
	(
		Select x.DivisionID, Max(x.OrderDate) as OrderDate, x.ObjectID, x.ObjectName, x.Address, x.Tel
		From 
		(
			Select M.DivisionID, M.ObjectID, M.ObjectName, 
			case when M.OrderDate > M.CreateDate then M.OrderDate else M.CreateDate end as OrderDate,T.Address, T.Tel
			from OT2001 M 
			Left join OT2002 D On M.DivisionID = D.DivisionID and M.SOrderID = D.SOrderID
			Inner join AT1202 T On T.DivisionID =M.DivisionID AND T.ObjectID = M.ObjectID
			where '+@sWhere+' 
			AND T.IsUsing = 1 
			---Tìm khách hàng ngưng sử dụng với đơn hàng cuối cùng
		)x
		Group by x.ObjectID, x.DivisionID, x.ObjectName, x.Address, x.Tel
	)b Inner Join 
	(
		Select A.DivisionID, A.ObjectID, y.InventoryID, A.AvgQuantity, y.InventoryName
		From
		(
			Select s.DivisionID, s.ObjectID, Max(s.OrderQuantity) as AvgQuantity
			from
			(
				Select z.DivisionID,H.ObjectID, D.InventoryID , AVG(D.OrderQuantity) as OrderQuantity 
				From 
				(
					Select x.DivisionID, Max(x.OrderDate) as OrderDate, x.ObjectID
					From 
					(
						Select M.DivisionID, M.ObjectID, case when M.OrderDate > M.CreateDate then M.OrderDate else M.CreateDate end as OrderDate
						from OT2001 M
						where '+@sWhere+'
					)x --Tìm thời gian của đơn hàng cuối cùng của đối tượng
					Group by x.ObjectID, x.DivisionID
				)z  
				Inner join OT2001 H on H.DivisionID=z.DivisionID and H.ObjectID = z.ObjectID
				Left join OT2002 D On z.DivisionID = D.DivisionID and H.SOrderID = D.SOrderID
				Where  DATEDIFF(DD, H.OrderDate, z.OrderDate)<=90
				Group by z.DivisionID,H.ObjectID, D.InventoryID	
				--Tìm số lượng sản phẩm trung bình trong vòng 3 tháng gần nhất 
			)s
			Group By s.DivisionID, s.ObjectID
			--Tìm số lượng max theo đối tượng
		)A inner join 
		(
			Select z.DivisionID,H.ObjectID, D.InventoryID,T.InventoryName , AVG(D.OrderQuantity) as AVGOrderQuantity From 
			(
				Select x.DivisionID, Max(x.OrderDate) as OrderDate, x.ObjectID
				From 
				(
					Select M.DivisionID, M.ObjectID, case when M.OrderDate > M.CreateDate then M.OrderDate else M.CreateDate end as OrderDate
					from OT2001 M
					Where'+@sWhere+'
				)x
				Group by x.ObjectID, x.DivisionID
				--Tìm thời gian của đơn hàng cuối cùng của đối tượng
			)z 
			Inner join OT2001 H on H.DivisionID=z.DivisionID and H.ObjectID = z.ObjectID
			Left join OT2002 D On z.DivisionID = D.DivisionID and H.SOrderID = D.SOrderID
			Left join AT1302 T On z.DivisionID = T.DivisionID and D.InventoryID = T.InventoryID
			where  DATEDIFF(DD, H.OrderDate, z.OrderDate)<=90
			Group by H.ObjectID, D.InventoryID, z.DivisionID, T.InventoryName
			--Tìm số lượng sản phẩm trung bình trong vòng 3 tháng gần nhất 
		) y on A.DivisionID = y.DivisionID and A.ObjectID = y.ObjectID
		Where A.AvgQuantity = y.AVGOrderQuantity
		---Tìm ra số mặt hàng chứa có số lượng trung bình lớn nhất
	) c ON b.ObjectID = c.ObjectID And b.DivisionID = c.DivisionID
'
	Print @sSQL

 EXEC (@sSQL)
GO