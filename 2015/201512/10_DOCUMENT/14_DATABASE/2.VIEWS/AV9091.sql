IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV9091]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV9091]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

  CREATE View AV9091  AS  Select Ana01ID, Ana02ID, Ana03ID, ObjectID, PeriodID, TranMonth, TranYear, 
			DivisionID, AccountID, CorAccountID, D_C, SignAmount, 
			SignQuantity, BudgetID, TransactionTypeID,
			DivisionID AS FilterMaster,
			'' AS FilterDetail
			From AV9090
			 

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

