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
----    EXEC CRMP30201 'AS','AS','','','','','', 'NV01'

CREATE PROCEDURE [dbo].[CRMP30201] ( 
        @DivisionID       VARCHAR(50),  --Biến môi trường
		@DivisionIDList    NVARCHAR(2000),  --Chọn trong DropdownChecklist DivisionID
		@FromDate         DATETIME,
		@ToDate           DATETIME,
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
	IF ((Isnull(@FromAccountID, '') !='')and (Isnull(@ToAccountID, '') !=''))
		SET @sWhere = @sWhere +' AND (M.ObjectID between N'''+@FromAccountID+''' and N'''+@ToAccountID+''')'
	IF ((Isnull(@FromAccountID, '') !='')and (Isnull(@ToAccountID, '') =''))
		SET @sWhere = @sWhere +'AND cast(M.ObjectID as Nvarchar(50)) >= N'''+cast(@FromAccountID as Nvarchar(50))+''''
	IF ((Isnull(@FromAccountID, '') ='')and (Isnull(@ToAccountID, '') !=''))
		SET @sWhere = @sWhere +'AND cast(M.ObjectID as Nvarchar(50)) <= N'''+cast(@ToAccountID as Nvarchar(50))+''''
	
	
	SET @sWhere = @sWhere + ' AND (CONVERT(VARCHAR(10),M.OrderDate,112) BETWEEN'''+ CONVERT(VARCHAR(20),@FromDate,112)+''' AND''' + CONVERT(VARCHAR(20),@ToDate,112) +''')'
	

Set @sSQL = N'
	Select b.DivisionID as Division,  b.DivisionName, Convert(Nvarchar(10),b.OrderDate,103) as OrderDate , b.AccountID, b.AccountName, b.Address ,b.Tel, c.InventoryID, c.InventoryName ,c.AvgQuantity
	From 
	(
		
			Select M.DivisionID, AT.DivisionName, CR.AccountID, CR.AccountName, 
			Max(M.OrderDate ) as OrderDate,CR.Address, CR.Tel
			from OT2001 M 
			Inner join CRMT10101 CR On CR.DivisionID= M.DivisionID and CR.AccountID=M.ObjectID
			Left join OT2002 D On M.DivisionID = D.DivisionID and M.SOrderID = D.SOrderID
			Inner Join AT1101 AT On AT.DivisionID = M.DivisionID
			where  '+@sWhere+'
			AND CR.IsUsing = 1
			---Tìm khách hàng ngung s? d?ng v?i don hàng cu?i cùng
		Group by AT.DivisionName, CR.AccountID, CR.AccountName, M.DivisionID, CR.Address, CR.Tel
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
					
						Select M.DivisionID, M.ObjectID,max(M.OrderDate) As OrderDate
						from OT2001 M
						where  '+@sWhere+'
					--Tìm th?i gian c?a don hàng cu?i cùng c?a d?i tu?ng
					Group by M.ObjectID, M.DivisionID
				)z  
				Inner join OT2001 H on H.DivisionID=z.DivisionID and H.ObjectID = z.ObjectID
				Left join OT2002 D On z.DivisionID = D.DivisionID and H.SOrderID = D.SOrderID
				Where  DATEDIFF(DD, H.OrderDate, z.OrderDate)<=90
				Group by z.DivisionID,H.ObjectID, D.InventoryID	
				--Tìm s? lu?ng s?n ph?m trung bình trong vòng 3 tháng g?n nh?t 
			)s
			Group By s.DivisionID, s.ObjectID
			--Tìm s? lu?ng max theo d?i tu?ng
		)A inner join 
		(
			Select z.DivisionID,H.ObjectID, D.InventoryID,T.InventoryName , AVG(D.OrderQuantity) as AVGOrderQuantity From 
			(
				
					Select M.DivisionID, M.ObjectID, Max(M.OrderDate)as OrderDate
					from OT2001 M
					Where  '+@sWhere+'
				
				Group by M.ObjectID, M.DivisionID
				--Tìm th?i gian c?a don hàng cu?i cùng c?a d?i tu?ng
			)z 
			Inner join OT2001 H on H.DivisionID=z.DivisionID and H.ObjectID = z.ObjectID
			Left join OT2002 D On z.DivisionID = D.DivisionID and H.SOrderID = D.SOrderID
			Left join AT1302 T On z.DivisionID = T.DivisionID and D.InventoryID = T.InventoryID
			where  DATEDIFF(DD, H.OrderDate, z.OrderDate)<=90
			Group by H.ObjectID, D.InventoryID, z.DivisionID, T.InventoryName
			--Tìm s? lu?ng s?n ph?m trung bình trong vòng 3 tháng g?n nh?t 
		) y on A.DivisionID = y.DivisionID and A.ObjectID = y.ObjectID
		Where A.AvgQuantity = y.AVGOrderQuantity
		---Tìm ra s? m?t hàng ch?a có s? lu?ng trung bình l?n nh?t
	) c ON b.AccountID = c.ObjectID And b.DivisionID = c.DivisionID
'

 EXEC (@sSQL)
GO