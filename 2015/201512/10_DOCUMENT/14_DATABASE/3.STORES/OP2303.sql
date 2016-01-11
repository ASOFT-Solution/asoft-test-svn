
/****** Object:  StoredProcedure [dbo].[OP2303]    Script Date: 12/16/2010 13:20:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



-- VAN HUNG
---Created by: Vo Thanh Huong, date: 12/12/2005
---purpose: Ke thua cac thanh pham tu don hang  ban cho PHIEU DIEU DO SAN XUAT BAO BI IN
/********************************************
'* Edited by: [GS] [Tố Oanh] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[OP2303]  @DivisionID nvarchar(50),
				@lstSOrderID nvarchar(50)
AS
Declare @sSQL  nvarchar(4000)

Set  @lstSOrderID = 	Replace(@lstSOrderID, ',', ''',''')

Set @sSQL ='
Select OT2001.DivisionID, 
		OT2001.SOrderID, 
		OT2001.OrderDate,  
		OT2001.ObjectID, 
		SourceNo = case when isnull(OT1305.FileID,'''') = ''''  then NULL else isnull(T00.MaxSourceNo,0) + 1 end,
		OT1305.FileID,
		OT2002.InventoryID,  
		AT1302.InventoryName, 
		OT2002.UnitID,   
		OT2002.OrderQuantity as SOrderQuantity, 
		isnull(OV2313.EndQuantity,0) as StockQuantity,  
		CASE WHEN OT2002.OrderQuantity - isnull(OV2313.EndQuantity,0)<=0 THEN NULL ELSE  
			OT2002.OrderQuantity - isnull(OV2313.EndQuantity,0) END  as OrderQuantity,
		OT2001.ShipDate as EndDate, 
		OT2002.Orders,
		OT2002.OrderQuantity/ case when isnull(OT1305.Num06,0) = 0 then 1 else OT1305.Num06 end as Cal01, 
		OT2002.OrderQuantity/ case when isnull(OT1305.Num06,0) = 0 then 1 else OT1305.Num06 end*isnull(Num05,1)*isnull(Num10,1)  as Cal02,
		 0 as Cal03, 0 as Cal04, 0 as Cal05, 0 as Cal06, 0 as Cal07, 0  as Cal08, 0 as Cal09, 0 as Cal10,
		OT1305.FileNo,
		OT1305.Var01, 
		OT1305.Var02, 
		OT1305.Var03, 
		OT1305.Var04, 
		OT1305.Var05, 
		OT1305.Var06, 
		OT1305.Var07, 
		OT1305.Var08, 
		OT1305.Var09, 
		OT1305.Var10, 
		OT1305.Date01, 
		OT1305.Num01, 
		OT1305.Num02, 
		OT1305.Num03, 
		OT1305.Num04, 
		OT1305.Num05, 
		OT1305.Num06, 
		OT1305.Num07, 
		OT1305.Num08, 
		OT1305.Num09, 
		OT1305.Num10, 
		OT1305.Num11, 
		OT1305.Num12, 
		OT1305.Num13, 
		OT1305.Num14, 
		OT1305.Num15				
From OT2002  inner join OT2001 on OT2001.SOrderID = OT2002.SOrderID 
		inner join AT1302 on AT1302.InventoryID = OT2002.InventoryID 
		inner  join OT1305 on OT2001.ObjectID = OT1305.ObjectID and OT2002.InventoryID = OT1305.ProductID and 
		OT2001.OrderDate <=
		case when OT1305.EndDate <= ''01/01/2000'' then   OT2001.OrderDate ELSE  
				isnull(OT1305.EndDate, ''12/31/9999'')  end  and OT1305.FileType = 1
		left join (Select InventoryID, Sum(DebitQuantity - CreditQuantity) as EndQuantity
			From OV2350	
			Group by InventoryID) OV2313 on OV2313.InventoryID = OT2002.InventoryID
		
		left join  (Select OT2001_Ref.ObjectID, OT2002.FileID, Max(isnull(OT2002.SourceNo,0)) as MaxSourceNo			   
			From OT2002 	inner join OT2001 on  OT2001.SOrderID = OT2002.SOrderID  and 
						OT2001.FileType = 2 and   OT2001.OrderType  = 1  and 
						OT2002.RefOrderID not in (''' + @lstSOrderID + ''')
				inner join OT2001 OT2001_Ref on  OT2001_Ref.SOrderID = OT2002.RefOrderID  
				
			Group by OT2001_Ref.ObjectID, OT2002.FileID) T00 on T00.FileID = OT1305.FileID and OT2001.ObjectID = T00.ObjectID 	 				
Where OT2001.DivisionID = ''' + @DivisionID + ''' and OT2001.SOrderID in (''' + @lstSOrderID + ''')'

--print @sSQL
If not exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV2303')
	EXEC('Create view OV2303 ----tao boi OP2303
			as ' + @sSQL)
Else	
	EXEC('Alter view OV2303 ----tao boi OP2303
			as ' + @sSQL)