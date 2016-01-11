IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7501]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP7501]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



---- Created by Nguyen Van Nhan.
----- Date 28/07/2003
----- So quy tien mat 
---- Modified on 28/12/2012 by Lê Thị Thu Hiền : Bổ sung thêm strDivisionID
---- Modified by on 24/09/2014 by Trần Quốc Tuấn : Bổ sung điều kiện lộc
/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

CREATE PROCEDURE [dbo].[AP7501] 
				@DivisionID as nvarchar(50),
				@AccountID as nvarchar(50),
				@CurrencyID as nvarchar(50),
				@FromMonth as int,
				@FromYear as int,
				@ToMonth as int,
				@ToYear as int,	
				@FromDate as datetime,
				@ToDate as datetime,
				@IsDate as TINYINT,
				@StrDivisionID AS NVARCHAR(4000) = '',
				@strSqlFinder AS NVARCHAR(MAX)
AS

Declare @BegOrginalAmount as decimal (28, 8),
	@BegConvertedAmount as decimal (28, 8),
	@EndOrginalAmount as decimal (28, 8),
	@EndConvertedAmount as decimal (28, 8)

If @IsDate = 0 --- Xac dinh theo thang
	Exec AP7502 @DivisionID, @AccountID, @CurrencyID, @FromMonth, @FromYear , @ToMonth, @ToYear, @StrDivisionID,@strSqlFinder
Else
	Exec AP7503 @DivisionID, @AccountID, @CurrencyID, @FromDate, @ToDate, @StrDivisionID,@strSqlFinder

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

