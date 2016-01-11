IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1500]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP1500]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Luu gia tri khau hao cho tung Nguon hinh thanh va tai khoan phan bo
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Created by Hoang Thi Lan
---- Edited by: [GS] [Việt Khánh] [29/07/2010]
---- Modified on 06/02/2012 by Nguyễn Bình Minh: Bổ sung phân bổ theo bộ hệ số và thêm các mã phân tích còn thiếu (04, 05)
-- <Example>
---- 
CREATE PROCEDURE [dbo].[AP1500]
( 
    @DivisionID NVARCHAR(50), 
    @AssetID NVARCHAR(50), 
    @VoucherNo NVARCHAR(50), 
    @VoucherTypeID NVARCHAR(50), 
    @VoucherDate DATETIME, 
    @TranMonth INT, 
    @TranYear INT, 
    @SourceID NVARCHAR(50), 
    @BDescription NVARCHAR(250), 
    @CreditAccountID NVARCHAR(50), 
    @DebitAccountID NVARCHAR(50), 
    @DepAmount DECIMAL, 
    @DepPercent DECIMAL, 
    @UserID NVARCHAR(50), 
    @Ana01ID NVARCHAR(50), 
    @Ana02ID NVARCHAR(50), 
    @Ana03ID NVARCHAR(50), 
    @PeriodID NVARCHAR(50),
    @Ana04ID NVARCHAR(50) = NULL,
    @Ana05ID NVARCHAR(50) = NULL,
    @CoefficientID NVARCHAR(50) = NULL,
    @Ana06ID NVARCHAR(50) = NULL
)    
AS

DECLARE @DepreciationID NVARCHAR(50)

EXEC AP0000 @DivisionID, @DepreciationID OUTPUT, 'AT1504', 'AD', @TranYear, '', 15, 3, 0, '-'

INSERT AT1504 (	DepreciationID, DivisionID, AssetID, VoucherNo, VoucherTypeID, VoucherDate, TranMonth, TranYear, SourceID, BDescription, CreditAccountID, DebitAccountID, DepAmount, DepPercent, CreateDate, CreateUserID, LastModifyDate, LastModifyUserID, DepType, Ana01ID, Ana02ID, Ana03ID, Status, ObjectID, PeriodID, 
				Ana04ID, Ana05ID, CoefficientID, Ana06ID)
VALUES (		@DepreciationID, @DivisionID, @AssetID, @VoucherNo, @VoucherTypeID, @VoucherDate, @TranMonth, @TranYear, @SourceID, @BDescription, @CreditAccountID, @DebitAccountID, @DepAmount, @DepPercent, GETDATE(), @UserID, GETDATE(), @UserID, 0, @Ana01ID, @Ana02ID, @Ana03ID, 0, NULL, @PeriodID,
				@Ana04ID, @Ana05ID, @CoefficientID, @Ana06ID)
				
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

