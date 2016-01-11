if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AP3339]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[AP3339]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

--Creater by: Nguyen Quoc Huy
--Date: 24/06/2009
--Purpose: Ke thua phieu thu dich vu cho phieu thu tien

/**********************************************
** Edited by: [GS] [Thanh Trẫm] [04/10/2010]
***********************************************/

CREATE PROCEDURE AP3339 @Where nvarchar(4000), @Method tinyint = 0, @VoucherID nvarchar(20) = '' -- 0, do du lieu ke thua, 1 cap nhat tinh trang da ke thua, 2 Xoa

AS
Declare 
	@ServiceAmount as decimal, 
	@SumServiceAmount as decimal,
	@Cursor as Cursor	

--Kiem tra xem co phi dich vu ko? Neu co thi Union Them 1 hang la phi dich vu nua.
Set @SumServiceAmount =0
--Set @ServiceAmount = isnull((Select sum(isnull(ServiceAmount,0)) FROM  IT3336),0)

SET @Cursor = CURSOR SCROLL KEYSET FOR
Select isnull(ServiceAmount,0) From AV3338
OPEN @Cursor
		FETCH NEXT FROM @Cursor INTO @ServiceAmount
		WHILE @@FETCH_STATUS = 0
		BEGIN
				Set @SumServiceAmount = @SumServiceAmount + @ServiceAmount
			
		FETCH NEXT FROM @Cursor INTO @ServiceAmount
		END

CLOSE @Cursor

If @Method = 0
		---Tien hang
		Select  Ma,1 as Orders, 'VND' As CurrencyID, 
			A01.Serial, A01.InvoiceNo,
			null as SalesAccountID, 
			A01.OriginalAmount, 0 As ConvertedAmount, 0 As ExchangeRate,
			A01.ObjectID, 
			(Case when A.IsUpdateName = 0 then A.ObjectName else A01.ObjectName End) as  ObjectName,
			A.VATNo,
			A01.VATPercent, 
			case when A01.VATPercent = 5 then 'T05'
				when A01.VATPercent = 10 then 'T10'
			End as VATGroupID,

			Description as BDescription, Description as TDescription,
			A01.DepID as Ana02ID
			
			
		From 
			AV3338 A01 Left join AT1202 A on A.ObjectID = A01.ObjectID
		
		--Tien phí phuc vu (ServiceAmount)
		Union All 
		Select  Ma, 2 as Orders, 'VND' As CurrencyID, 
			A01.Serial, A01.InvoiceNo,
			null as SalesAccountID, 
			A01.ServiceAmount as OriginalAmount, A01.ServiceAmount as ConvertedAmount, 0 As ExchangeRate,
			A01.ObjectID, 
			(Case when A.IsUpdateName = 0 then A.ObjectName else A01.ObjectName End) as  ObjectName,
			A.VATNo,
			A01.VATPercent, 
			case when A01.VATPercent = 5 then 'T05'
				when A01.VATPercent = 10 then 'T10'
			End as VATGroupID,

			'Phí phuïc vuï' as BDescription, 'Phí phuïc vuï' as TDescription,
			A01.DepID as Ana02ID
			
			--A01.SpecialAmount
		From 
			AV3338 A01 Left join AT1202 A on A.ObjectID = A01.ObjectID
		Where isnull(A01.ServiceAmount,0) <> 0
		
		--Tien thue GTGT
		Union All 
		Select  Ma, 3 as Orders, 'VND' As CurrencyID, 
			A01.Serial, A01.InvoiceNo,
			null as SalesAccountID, 
			A01.VATAmount as OriginalAmount, A01.VATAmount as ConvertedAmount, 0 As ExchangeRate,
			A01.VATObjectID as ObjectID, 
			(Case when A.IsUpdateName = 0 then A.ObjectName else A01.VATObjectName End) as  ObjectName,
			A.VATNo,
			A01.VATPercent, 
			case when A01.VATPercent = 5 then 'T05'
				when A01.VATPercent = 10 then 'T10'
			End as VATGroupID,

			'Thueá GTGT ñaàu ra' as BDescription, 'Thueá GTGT ñaàu ra' as TDescription,
			A01.DepID as Ana02ID
			
			
		From 
			AV3338 A01 Left join AT1202 A on A.ObjectID = A01.VATObjectID
		Where isnull(A01.VATAmount,0) <> 0
		
		Order by MA,Orders	
Else
	If @Method = 1
		Begin
			Insert Into AT3333 Select @VoucherID, Ma From AV3338 Where Ma Not In (Select Ma From AT3333)
		End
	Else
		Begin
			Delete From AT3333 Where VoucherID = @VoucherID
		End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

