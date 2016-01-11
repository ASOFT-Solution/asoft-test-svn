IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7511]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP7511]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Created by Nguyen Van Nhan.
----- Date 20/09/2004
----- So tien gui ngan hang
---- Modified on 03/10/2014 by Trần Quốc Tuấn : Bổ sung thêm điều kiện lọc tính số dư đầu kỳ

/**********************************************
** Edited by: [GS] [Cẩm Loan] [30/07/2010]
***********************************************/

CREATE PROCEDURE [dbo].[AP7511] @DivisionID as nvarchar(50),
				@BankAccountID as nvarchar(50),
				@FromMonth as int,
				@FromYear as int,
				@ToMonth as int,
				@ToYear as int,	
				@FromDate as datetime,
				@ToDate as datetime,
				@IsDate as TINYINT,
				@sqlWhere AS NVARCHAR(MAX)
AS

Declare @BegOrginalAmount as decimal(28,8),
	@BegConvertedAmount as decimal(28,8),
	@EndOrginalAmount as decimal(28,8),
	@EndConvertedAmount as decimal(28,8)

--Set @BankAccountID = replace(@BankAccountID,'''','''''')

If @IsDate = 0 		--- Xac dinh theo thang
	Exec AP7512 @DivisionID, @BankAccountID, @FromMonth, @FromYear , @ToMonth, @ToYear,@sqlWhere
Else
	Exec AP7513 @DivisionID, @BankAccountID, @FromDate, @ToDate,@sqlWhere

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
