IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0103]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0103]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Created by: Bao Anh
---- Date: 08/05/2013
---- Purpose: Tra ra du lieu lenh chuyen tien dung cho xuat file csv (Customize Fine Fruit Asia)
---- Modift on 26/07/2013  by Bao Anh: Chinh sua theo yeu cau phan mem ngan hang
---- EXEC AP0103 'as','AV201200000020'

CREATE PROCEDURE [dbo].[AP0103] 
	@DivisionID nvarchar(50),
	@VoucherID nvarchar(max)

AS

Declare @sSQL as nvarchar(max)

SET @VoucherID = REPLACE(@VoucherID,',',''',''')
SET @sSQL = N'
			SELECT	AT9000.Parameter01, AT9000.Parameter02, AT9000.Parameter03, AT9000.Parameter04, AT9000.Parameter05,
					(case when Parameter01 = ''TT'' then AT9000.Parameter06 else '''' end) as Parameter06,
					AT9000.Parameter07, AT9000.Parameter08, AT9000.Parameter09, AT9000.Parameter10,
					(AT1016.CurrencyID + AT1016.BankAccountNo) as CreditBankAccountID, AT9000.VoucherDate,
					Left(Isnull(AT9000.SenderReceiver,''''),35) as SenderReceiver1,
					(case when SUBSTRING(Isnull(AT9000.SenderReceiver,''''),36,35) = '''' then '''' else SUBSTRING(Isnull(AT9000.SenderReceiver,''''),36,35) end) as SenderReceiver2,
					AT9000.CurrencyID, AT9000.ExchangeRate, AT9000.OriginalAmount,
					left(Isnull(AT9000.VDescription,''''),70) as VDescription1,
					(case when SUBSTRING(Isnull(AT9000.VDescription,''''),71,70) = '''' then '''' else SUBSTRING(Isnull(AT9000.VDescription,''''),71,70) end) as VDescription2,
					AT1004.ExchangeRateDecimal,
					(case when Parameter08 = ''C'' then ''N'' else '''' end) as FxRateIndicator,
					AT9000.CurrencyID as TTCurrencyID,
					''SCBLVNVXXXX'' as SCBBankCode,
					AT1103.Email,
					
					(Select COUNT(*) as RowNums from AT9000 WHERE DivisionID = ''' + @DivisionID + '''
					AND VoucherID in (''' + @VoucherID + ''')) as RowNums,
					
					(Select SUM(OriginalAmount) From AT9000 WHERE DivisionID = ''' + @DivisionID + '''
					AND VoucherID in (''' + @VoucherID + ''')) as SumOAmount
			
			FROM	AT9000
			LEFT JOIN AT1004 On AT9000.DivisionID = AT1004.DivisionID and AT9000.CurrencyID = AT1004.CurrencyID
			LEFT JOIN AT1016 On AT9000.DivisionID = AT1016.DivisionID and AT9000.CreditBankAccountID = AT1016.BankAccountID
			LEFT JOIN AT1103 On AT9000.DivisionID = AT1103.DivisionID and AT9000.EmployeeID = AT1103.EmployeeID
			
			WHERE	AT9000.DivisionID = ''' + @DivisionID + '''
			AND		AT9000.VoucherID in (''' + @VoucherID + ''')
			AND		AT9000.TransactionTypeID = ''T22''
			
			ORDER BY Orders'
---	print 	@sSQL	
EXEC(@sSQL)

