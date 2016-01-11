IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV7427]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV7427]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

  CREATE View [dbo].[AV7427]  As  
		SELECT 	AV4203.ObjectID, AV4203.Ana01ID, AV4203.AccountID , 
			--AV4203.CurrencyID,
			 AV4203.CurrencyIDCN  as CurrencyIDCN,
			AT1202.ObjectName,
			AT1005.AccountName,
			(SELECT Sum(ConvertedAmount) 
				FROM AV4203 V03
				WHERE DivisionID = 'ASNHT' and
				( (02/02/2009<'02/02/2009'  )  
				or ( 02/02/2009 <='02/02/2009' and TransactionTypeID ='T00' ) )  and
				(V03.ObjectID = AV4203.ObjectID) and
				(V03.AccountID between  'a' and  'b' ) and
				V03.CurrencyIDCN like 'VND' 
			) as OpeningConvertedAmount,
			(SELECT Sum(OriginalAmount) 
				FROM AV4203 V03 
				WHERE DivisionID = 'ASNHT' and
				( (02/02/2009<'02/02/2009'  )  
				or ( 02/02/2009 <='02/02/2009' and TransactionTypeID ='T00' ) )  and
				(V03.ObjectID = AV4203.ObjectID) and
				(V03.AccountID between  'a' and  'b' ) and
				V03.CurrencyIDCN like 'VND' 
			) As OpeningOriginalAmount,
			Sum(ConvertedAmount) as OpeningConvertedAmountAna01ID,
			Sum(OriginalAmount) AS OpeningOriginalAmountAna01ID
		FROM AV4203  	inner join AT1202 on AT1202.ObjectID = AV4203.ObjectID
				inner join AT1005 on AT1005.AccountID = AV4203.AccountID
		WHERE 	AV4203.DivisionID = 'ASNHT' and
			( (02/02/2009<'02/02/2009'  )  
			or ( 02/02/2009 <='02/02/2009' and TransactionTypeID ='T00' ) )  and
			(AV4203.ObjectID between 'a' and 'b') and
			(AV4203.AccountID between  'a' and  'b' ) and
			AV4203.CurrencyIDCN like 'VND'	
		GROUP BY AV4203.ObjectID ,  AV4203.Ana01ID, AV4203.AccountID,    AT1202.ObjectName, AT1005.AccountName ,  AV4203.CurrencyIDCN 
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
