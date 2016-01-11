IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0340]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0340]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Created by Nguyen Thi Ngoc Minh.
---- Created Date 15/09/2004
---- Bao cao doi chieu cong no phai thu va phai tra tren cung doi tuong
---- Bổ sung thêm biến @Orderby
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [29/07/2010]
'**************************************************************/
CREATE PROCEDURE [dbo].[AP0340]  @DivisionID as nvarchar(50),
				@FromObjectID as nvarchar(50),
				@ToObjectID as nvarchar(50),
				@FromRecAccountID  as nvarchar(50),  
				@ToRecAccountID  as nvarchar(50), 
				@FromPayAccountID  as nvarchar(50),  
				@ToPayAccountID  as nvarchar(50), 
				@CurrencyID as nvarchar(50),
				@FromInventoryID as nvarchar(50),
				@ToInventoryID as nvarchar(50),
				@IsDetail as tinyint,
				@IsDate as tinyint,
				@FromMonth as int,
				@FromYear as int,
				@ToMonth as int,
				@ToYear as int,				
				@FromDate as Datetime,
				@ToDate as Datetime,
				@IsPayable TINYINT
				--@Orderby NVARCHAR(4000)
AS


	If @IsDetail = 1 --- Chi tiet theo mat hang cua tung hoa don

		--Print ' P1'
		Exec AP0348 	@DivisionID, @FromObjectID, @ToObjectID, @FromRecAccountID, @ToRecAccountID, 
				@FromPayAccountID, @ToPayAccountID, @CurrencyID, @FromInventoryID, 
				@ToInventoryID, @IsDate, @FromMonth, @FromYear, @ToMonth, @ToYear, @FromDate, @ToDate, @IsPayable--, @Orderby

	Else

		Exec AP0349 	@DivisionID, @FromObjectID, @ToObjectID, @FromRecAccountID, @ToRecAccountID, 
				@FromPayAccountID, @ToPayAccountID, @CurrencyID, @FromInventoryID, 
				@ToInventoryID, @IsDate, @FromMonth, @FromYear, @ToMonth, @ToYear, @FromDate, @ToDate, @IsPayable--, @Orderby
		--Print ' P2'

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
