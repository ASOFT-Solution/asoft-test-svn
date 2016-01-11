IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7419]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP7419]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


------ Created by Nguyen Van Nhan, Date 29/08/2003
------ In bang ke dau vao, ra
------ Last Edit ThuyTuyen  Them VATTypeID4, VATGroupID4, Date 26/10/2007
------ Edeit theo thong tu 13/2009, Thuy tuyen
------ Edit by: Dang Le Bao Quynh; Date: 14/10/2009
------ Purpose: Bo sung truong ngay dao han, xu ly hoa don hang mua tra lai, but toan chiet khau
--------- Last edit by B.Anh, date 08/12/2009	Sua cho truong hop co' nhieu nhom thue
--------- Last edit by B.Anh, date 11/01/2010	Sua loi doanh so len sai khi hang mua tra lai
--- Edit by To Oanh, date 08/08/2013: Hieu chinh data null

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/
---- Modified on 30/07/2013 by Le Thi Thu Hien : Cai thien toc do Không sử dụng View AV4300
---- Modified on 20/09/2013 by Thien Huynh : 2  loại hóa đơn VHDSD  và VGTGT1 cùng 1 group
---- Modified on 11/02/2014 by Thanh Sơn: Lấy thêm 2 cột InvID và InvSign
	--Để bảng kê đầu vào (bao gồm Xuất Excel)thể hiện 2 loại hóa đơn VHDSD  và VGTGT1  trên nhóm 1
---- Modified on 21/09/2015 by Tiểu Mai: Bổ sung thông tin tài khoản Nợ, tài khoản Có

CREATE PROCEDURE [dbo].[AP7419]
			@DivisionID AS NVARCHAR(50),
			@TranMonthFrom AS INT,
			@TranYearFrom AS INT,
			@TranMonthTo AS INT,
			@TranYearTo AS INT,
			@ReportCode AS NVARCHAR(50)
AS

SET NOCOUNT ON

DECLARE @strSQL NVARCHAR(MAX),
		@PeriodFrom INT,
		@PeriodTo INT,
		@TableSQL NVARCHAR(MAX)


DECLARE @TaxAccountID1From AS NVARCHAR(50),
		@TaxAccountID1To AS NVARCHAR(50),
		@TaxAccountID2From AS NVARCHAR(50),
		@TaxAccountID2To AS NVARCHAR(50),
		@TaxAccountID3From AS NVARCHAR(50),
		@TaxAccountID3To AS NVARCHAR(50),
		@NetAccountID1From AS NVARCHAR(50),	
		@NetAccountID1To AS NVARCHAR(50),	
		@NetAccountID2From AS NVARCHAR(50),	
		@NetAccountID2To AS NVARCHAR(50),	
		@NetAccountID3From AS NVARCHAR(50),	
		@NetAccountID3To AS NVARCHAR(50),	
		@NetAccountID4From AS NVARCHAR(50),	
		@NetAccountID4To AS NVARCHAR(50),	
		@CreateUserIDFrom AS NVARCHAR(50),
		@NetAccountID5From AS NVARCHAR(50),	
		@NetAccountID5To AS NVARCHAR(50),			
		@CreateUserIDTo AS NVARCHAR(50),
		@VoucherTypeIDFrom AS NVARCHAR(50),
		@VoucherTypeIDTo AS NVARCHAR(50),
		@VATTypeID AS NVARCHAR(50),
		@VATGroupIDFrom AS NVARCHAR(50),
		@VATGroupIDTo AS NVARCHAR(50),
		@VATObjectIDFrom AS NVARCHAR(50),			
		@VATObjectIDTo AS NVARCHAR(50),
		@VATTypeID1  AS NVARCHAR(50),
		@VATTypeID2  AS NVARCHAR(50),
		@VATTypeID3  AS NVARCHAR(50),
		@VATTypeID4  AS NVARCHAR(50),
		@VATTypeID5  AS NVARCHAR(50),
		@IsVATIn AS tinyint,
		@IsTax AS tinyint,
		@IsVATType AS tinyint,
		@IsVATGroup AS tinyint,
		@VATGroupID1 AS NVARCHAR(50),
		@VATGroupID2 AS NVARCHAR(50),
		@VATGroupID3 AS NVARCHAR(50),
		@VATGroupID4 AS NVARCHAR(50),
		@VATGroupID5 AS NVARCHAR(50),
		@VoucherTypeID AS NVARCHAR(50),
		@DebitAccountID AS NVARCHAR(50),
		@CreditAccountID AS NVARCHAR(50)

	

-- Calculate the periods 'from' and 'to'
	SET @PeriodFrom = @TranYearFrom*100+@TranMonthFrom
	SET @PeriodTo = @TranYearTo*100+@TranMonthTo

SELECT 
		@TaxAccountID1From = isnull(TaxAccountID1From,''),
		@TaxAccountID1To = isnull(TaxAccountID1To,''),
		@TaxAccountID2From = isnull(TaxAccountID2From,''),
		@TaxAccountID2To = isnull(TaxAccountID2To,''),
		@TaxAccountID3From = isnull(TaxAccountID3From,''),
		@TaxAccountID3To = isnull(TaxAccountID3To,''),
		@NetAccountID1From = isnull(NetAccountID1From,''),	
		@NetAccountID1To = isnull(NetAccountID1To,''),	
		@NetAccountID2From = isnull(NetAccountID2From,''),	
		@NetAccountID2To = isnull(NetAccountID2To,''),	
		@NetAccountID3From = isnull(NetAccountID3From,''),	
		@NetAccountID3To = isnull(NetAccountID3To,''),	
		@NetAccountID4From = isnull(NetAccountID4From,''),	
		@NetAccountID4To = isnull(NetAccountID4To,''),	
		@VoucherTypeID = isnull(VoucherTypeID,''), 
		@NetAccountID5From = isnull(NetAccountID5From,''),	
		@NetAccountID5To = isnull(NetAccountID5To,''),	
		@VoucherTypeIDTo = isnull(VoucherTypeIDTo,''),
		@VATTypeID = isnull(VATTypeID,''),
		@VATTypeID1 = isnull(VATTypeID1,''),
		@VATTypeID2 = isnull(VATTypeID2,''),
		@VATTypeID3 = isnull(VATTypeID3,''),
		@VATTypeID4 = isnull(VATTypeID4,''),
		@VATTypeID5 = isnull(VATTypeID5,''),
		@VATGroupIDFrom = isnull(VATGroupIDFrom,''),
		@VATGroupIDTo = isnull(VATGroupIDTo,''),
		@VATObjectIDFrom = isnull(ObjectIDFrom,''),			
		@VATObjectIDTo = isnull(ObjectIDTo,''),	
		@IsVATIn=IsVATIn,
		@IsVATGroup = IsVATGroup,
		@VATGroupID1 = isnull(VATGroupID1,''),
		@VATGroupID2 = isnull(VATGroupID2,''),
		@VATGroupID3 = isnull(VATGroupID3,''),
		@VATGroupID4 = isnull(VATGroupID4,''),
		@VATGroupID5 = isnull(VATGroupID5,''),
		@IsTax  = IsTax,
		@IsVATType = IsVATType

FROM	AT7410
WHERE	ReportCode = @ReportCode
		and DivisionID = @DivisionID



IF @TaxAccountID1To is NULL OR @TaxAccountID1To = ''
	SET @TaxAccountID1To = @TaxAccountID1From
IF @TaxAccountID2To is NULL OR @TaxAccountID2To = ''
	SET @TaxAccountID2To = @TaxAccountID2From
IF @TaxAccountID3To is NULL OR @TaxAccountID3To = ''
	SET @TaxAccountID3To = @TaxAccountID3From


IF @NetAccountID1To is NULL OR @NetAccountID1To = ''
	SET @NetAccountID1To = @NetAccountID1From
IF @NetAccountID2To is NULL OR @NetAccountID2To = ''
	SET @NetAccountID2To = @NetAccountID2From
IF @NetAccountID3To is NULL OR @NetAccountID3To = ''
	SET @NetAccountID3To = @NetAccountID3From 
IF @NetAccountID4To is NULL OR @NetAccountID4To = ''
	SET @NetAccountID4To = @NetAccountID4From
IF @NetAccountID5To is NULL OR @NetAccountID5To = ''
	SET @NetAccountID5To = @NetAccountID5From
------------->>>


		
-----------<<<<

	


Delete  from AT7419


-------------------
 INSERT AT7419 (	DivisionID, VoucherID, BatchID, TransactionID, TransactionTypeID, AccountID, CorAccountID,
					D_C, DebitAccountID, CreditAccountID, VoucherDate, VoucherTypeID, VoucherNo,
					 InvoiceDate, InvoiceNo, Serial, ConvertedAmount, OriginalAmount,
					SignAmount, OSignAmount, TranMonth, TranYear,  VDescription ,BDescription, TDescription,
					 ObjectID ,VATObjectID, VATNo ,VATObjectName, 
					 ObjectAddress, VATTypeID, VATGroupID, ImTaxOriginalAmount, ImTaxConvertedAmount, DueDate, InvoiceCode, InvoiceSign)

SELECT 	DivisionID, VoucherID, BatchID, TransactionID, TransactionTypeID, 
		DebitAccountID AS AccountID, 
		ISNULL(CreditAccountID,'') AS CorAccountID, 
		CASE WHEN TransactionTypeID in ('T64','T65') Then 'C' Else 'D' End AS D_C,  
		DebitAccountID, ISNULL(CreditAccountID,'') AS CreditAccountID, 
		VoucherDate, VoucherTypeID, VoucherNo,
		InvoiceDate, ISNULL(InvoiceNo,'') AS InvoiceNo, ISNULL(Serial,'') AS Serial,  
		CASE WHEN TransactionTypeID in ('T64','T65')   Then -ROUND(ConvertedAmount,2) Else ROUND(ConvertedAmount,2) End + isnull(ROUND(ISNULL(ImTaxOriginalAmount,0),2),0),  
		CASE WHEN TransactionTypeID in ('T64','T65')   Then -ROUND(OriginalAmount,2) Else ROUND(OriginalAmount,2) End +isnull(ROUND(ISNULL(ImTaxConvertedAmount,0),2),0), 
		CASE WHEN TransactionTypeID in ('T64','T65')   Then -ROUND(ConvertedAmount,2) Else ROUND(ConvertedAmount,2) End + isnull(ROUND(ISNULL(ImTaxOriginalAmount,0),2),0),  
		CASE WHEN TransactionTypeID in ('T64','T65')   Then -ROUND(OriginalAmount,2) Else ROUND(OriginalAmount,2) End +isnull(ROUND(ISNULL(ImTaxConvertedAmount,0),2),0),  
		TranMonth, TranYear,  VDescription ,BDescription, TDescription,
		CASE WHEN ISNULL(ObjectID,'') = '' and TransactionTypeID ='T99' then CreditObjectID else ObjectID end AS ObjectID ,
		VATObjectID, VATNo ,VATObjectName, 
		'' AS ObjectAddress, VATTypeID, VATGroupID , 0,0, DueDate, InvoiceCode, InvoiceSign
FROM AT9000
WHERE	DivisionID = @DivisionID
		AND TranYear*100+TranMonth >= @TranYearFrom*100+@TranMonthFrom
		AND TranYear*100+TranMonth <= @TranYearTo*100+@TranMonthTo
		AND DebitAccountID IS NOT NULL AND DebitAccountID <> ''
		AND ISNULL(VATTypeID,'')<>''	


UNION ALL
SELECT 	DivisionID, VoucherID, BatchID, TransactionID, TransactionTypeID, 
		CreditAccountID AS AccountID, 
		ISNULL(DebitAccountID,'') AS CorAccountID, 
		CASE WHEN TransactionTypeID in ('T64','T65') THEN 'D' ELSE 'C' END AS D_C, 
		ISNULL(DebitAccountID,'') AS DebitAccountID, CreditAccountID,
		VoucherDate, VoucherTypeID, VoucherNo,
		InvoiceDate, ISNULL(InvoiceNo,'') AS InvoiceNo, ISNULL(Serial,'') AS Serial,  
		CASE WHEN TransactionTypeID in ('T64','T65')   Then -ROUND(ConvertedAmount,2) Else ROUND(ConvertedAmount,2) End + isnull(ROUND(ISNULL(ImTaxOriginalAmount,0),2),0),  
		CASE WHEN TransactionTypeID in ('T64','T65')   Then -ROUND(OriginalAmount,2) Else ROUND(OriginalAmount,2) End +isnull(ROUND(ISNULL(ImTaxConvertedAmount,0),2),0), 
		CASE WHEN TransactionTypeID in ('T64','T65')   Then -ROUND(ConvertedAmount,2) Else ROUND(ConvertedAmount,2) End + isnull(ROUND(ISNULL(ImTaxOriginalAmount,0),2),0),  
		CASE WHEN TransactionTypeID in ('T64','T65')   Then -ROUND(OriginalAmount,2) Else ROUND(OriginalAmount,2) End +isnull(ROUND(ISNULL(ImTaxConvertedAmount,0),2),0),  
		TranMonth, TranYear,  VDescription ,BDescription, TDescription,
		CASE WHEN ISNULL(CreditObjectID,'') <> '' and TransactionTypeID = 'T99'  then CreditObjectID else ObjectID end AS ObjectID ,
		VATObjectID, VATNo ,VATObjectName, 
		'' AS ObjectAddress, VATTypeID, VATGroupID , 0,0, DueDate, InvoiceCode, InvoiceSign
		 
FROM AT9000
WHERE DivisionID = @DivisionID
		AND TranYear*100+TranMonth >= @TranYearFrom*100+@TranMonthFrom
		AND TranYear*100+TranMonth <= @TranYearTo*100+@TranMonthTo
		AND CreditAccountID IS NOT NULL AND CreditAccountID <> ''
		AND ISNULL(VATTypeID,'')<>''

			       

--PRINT @strSQL

---EXEC(@strSQL)	----- Insert vao bang AT7419





--Print @strSQL


--IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE SYSOBJECTS.NAME = 'AV7411' AND SYSOBJECTS.XTYPE = 'V')
--	EXEC ('CREATE VIEW AV7411 AS -- Tạo bởi store AP7419
--	' + @strSQL)
--ELSE
--	EXEC ('ALTER VIEW AV7411 AS -- Tạo bởi store AP7419
--	' + @strSQL)

EXEC AP7411 @DivisionID,			
			@TaxAccountID1From,		@TaxAccountID1To,
			@TaxAccountID2From,		@TaxAccountID2To,
			@TaxAccountID3From,		@TaxAccountID3To,
			@NetAccountID1From,		@NetAccountID1To,	
			@NetAccountID2From,		@NetAccountID2To,	
			@NetAccountID3From,		@NetAccountID3To,	
			@NetAccountID4From,		@NetAccountID4To,
			@NetAccountID5From,		@NetAccountID5To,
			@IsVATIn, @IsTax, @IsVATType ,
			@IsVATGroup , @VATGroupID1 ,
			@VATGroupID2 ,	@VATGroupID3,
			@VATGroupID4 ,	@VATGroupID5, @PeriodFrom ,
			@PeriodTo , 		@VATTypeID ,
		@VATGroupIDFrom ,	@VATGroupIDTo ,
		@VATObjectIDFrom ,	@VATObjectIDTo ,
		@VATTypeID1  , @VATTypeID2  ,
		@VATTypeID3 ,@VATTypeID4 ,
		@VATTypeID5 ,	@VoucherTypeID , 		@VoucherTypeIDFrom ,
		@VoucherTypeIDTo , @ReportCode


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

