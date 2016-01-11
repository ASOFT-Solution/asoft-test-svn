IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1505]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP1505]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Tính khấu hao tự động
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Created by Nguyen Van Nhan, Date 30/09/2003.
---- Editer by: Nguyen Quoc Huy, Date: 10/04/2007
---- Edited by: [GS] [Việt Khánh] [29/07/2010]
---- Modified on 06/02/2012 by Nguyễn Bình Minh: Bổ sung phần phân bổ khấu hao theo bộ định mức
---- Modified on 08/10/2015 by Tieu Mai: Sửa phần làm tròn số lẻ theo thiết lập đơn vị-chi nhánh
-- <Example>
CREATE PROCEDURE [dbo].[AP1505]
( 
    @DivisionID NVARCHAR(50), 
    @TranMonth INT, 
    @TranYear INT, 
    @VoucherTypeID NVARCHAR(50), 
    @VoucherNo NVARCHAR(50), 
    @VoucherDate DATETIME, 
    @BDescription NVARCHAR(250), 
    @UserID NVARCHAR(50)
)    
AS

DECLARE	@Asset_cur CURSOR, 
		@AssetID NVARCHAR(50), 
		@MethodID TINYINT, 
		@ConvertedAmount DECIMAL(28,8), --- Nguyen gia
		@TotalDepAmount DECIMAL(28,8), 
		@DepPercent DECIMAL(28,8), 
		@DepAccountID NVARCHAR(50), 
		@RemainAmount DECIMAL(28,8), 

		@DebitDepAccountID1 NVARCHAR(50), 
		@DepPercent1 DECIMAL(28,8), --- z1
		@DebitDepAccountID2 NVARCHAR(50), 
		@DepPercent2 DECIMAL(28,8), ---z2
		@DebitDepAccountID3 NVARCHAR(50), 
		@DepPercent3 DECIMAL(28,8), ---z3

		@DebitDepAccountID4 NVARCHAR(50), 
		@DepPercent4 DECIMAL(28,8), --- z1
		@DebitDepAccountID5 NVARCHAR(50), 
		@DepPercent5 DECIMAL(28,8), ---z2
		@DebitDepAccountID6 NVARCHAR(50), 
		@DepPercent6 DECIMAL(28,8), ---z3

		@ResidualValue DECIMAL(28,8), --- Giá trị còn lại tại thời điểm ban đầu
		@SourcePercent1 DECIMAL(28,8), --- y1
		@SourcePercent2 DECIMAL(28,8), ---y2
		@SourcePercent3 DECIMAL(28,8), ---- y3

		@SourceID1 NVARCHAR(50), 
		@SourceID2 NVARCHAR(50), 
		@SourceID3 NVARCHAR(50), 
		@Ana01ID1 NVARCHAR(50), @Ana02ID1 NVARCHAR(50), @Ana03ID1 NVARCHAR(50), @Ana04ID1 NVARCHAR(50), @Ana05ID1 NVARCHAR(50), @Ana06ID1 NVARCHAR(50), 
		@Ana01ID2 NVARCHAR(50), @Ana02ID2 NVARCHAR(50), @Ana03ID2 NVARCHAR(50), @Ana04ID2 NVARCHAR(50), @Ana05ID2 NVARCHAR(50), @Ana06ID2 NVARCHAR(50), 
		@Ana01ID3 NVARCHAR(50), @Ana02ID3 NVARCHAR(50), @Ana03ID3 NVARCHAR(50), @Ana04ID3 NVARCHAR(50), @Ana05ID3 NVARCHAR(50), @Ana06ID3 NVARCHAR(50), 
		@Ana01ID4 NVARCHAR(50), @Ana02ID4 NVARCHAR(50), @Ana03ID4 NVARCHAR(50), @Ana04ID4 NVARCHAR(50), @Ana05ID4 NVARCHAR(50), @Ana06ID4 NVARCHAR(50), 
		@Ana01ID5 NVARCHAR(50), @Ana02ID5 NVARCHAR(50), @Ana03ID5 NVARCHAR(50), @Ana04ID5 NVARCHAR(50), @Ana05ID5 NVARCHAR(50), @Ana06ID5 NVARCHAR(50), 
		@Ana01ID6 NVARCHAR(50), @Ana02ID6 NVARCHAR(50), @Ana03ID6 NVARCHAR(50), @Ana04ID6 NVARCHAR(50), @Ana05ID6 NVARCHAR(50), @Ana06ID6 NVARCHAR(50), 
		@PeriodID01 NVARCHAR(50), 
		@PeriodID02 NVARCHAR(50), 
		@PeriodID03 NVARCHAR(50), 
		@PeriodID04 NVARCHAR(50), 
		@PeriodID05 NVARCHAR(50), 
		@PeriodID06 NVARCHAR(50), 
		@ConvertedDecimals INT,
		@CoefficientID NVARCHAR(50),
		@UseCofficientID TINYINT


SET @ConvertedDecimals = ISNULL((SELECT TOP 1 ConvertedDecimals FROM AT1101 WHERE DivisionID = @DivisionID), 0)

SET @Asset_cur =  CURSOR SCROLL KEYSET FOR 
	SELECT AT1503.AssetID,
		   CASE	WHEN EXISTS (	SELECT	TOP 1 AssetID
								FROM	AT1506
								WHERE	AT1506.AssetID = AT1503.AssetID
										AND AT1506.DivisionID = AT1503.DivisionID
										AND AT1506.TranMonth + 100 * AT1506.TranYear <= @TranMonth + 100 * @TranYear
							) 
					THEN (	SELECT		TOP 1 AT1506.ConvertedNewAmount
							FROM		AT1506
							WHERE		AT1506.AssetID = AT1503.AssetID
										AND AT1506.DivisionID = AT1503.DivisionID
										AND AT1506.TranMonth + 100 * AT1506.TranYear <= @TranMonth + 100 * @TranYear
							ORDER BY	AT1506.TranYear DESC, AT1506.TranMonth DESC
						)
				ELSE AT1503.ConvertedAmount
		   END AS ConvertedAmount,
		   AT1503.DepAccountID,
		   AT1503.DebitDepAccountID1,
		   AT1503.DepPercent1,
		   AT1503.DebitDepAccountID2,
		   AT1503.DepPercent2,
		   AT1503.DebitDepAccountID3,
		   AT1503.DepPercent3,
		   AT1503.DebitDepAccountID4,
		   AT1503.DepPercent4,
		   AT1503.DebitDepAccountID5,
		   AT1503.DepPercent5,
		   AT1503.DebitDepAccountID6,
		   AT1503.DepPercent6,
		   AT1503.Ana01ID1, AT1503.Ana02ID1, AT1503.Ana03ID1, AT1503.Ana04ID1, AT1503.Ana05ID1, AT1503.Ana06ID1,
		   AT1503.Ana01ID2, AT1503.Ana02ID2, AT1503.Ana03ID2, AT1503.Ana04ID2, AT1503.Ana05ID2, AT1503.Ana06ID2,
		   AT1503.Ana01ID3, AT1503.Ana02ID3, AT1503.Ana03ID3, AT1503.Ana04ID3, AT1503.Ana05ID3, AT1503.Ana06ID3,
		   AT1503.Ana01ID4, AT1503.Ana02ID4, AT1503.Ana03ID4, AT1503.Ana04ID4, AT1503.Ana05ID4, AT1503.Ana06ID4,
		   AT1503.Ana01ID5, AT1503.Ana02ID5, AT1503.Ana03ID5, AT1503.Ana04ID5, AT1503.Ana05ID5, AT1503.Ana06ID5,
		   AT1503.Ana01ID6, AT1503.Ana02ID6, AT1503.Ana03ID6, AT1503.Ana04ID6, AT1503.Ana05ID6, AT1503.Ana06ID6,
		   CASE WHEN EXISTS (	SELECT	TOP 1 AssetID
								FROM	AT1506
								WHERE	AT1506.AssetID = AT1503.AssetID
										AND AT1506.DivisionID = AT1503.DivisionID
										AND AT1506.TranMonth + 100 * AT1506.TranYear <= @TranMonth + 100 * @TranYear
						) THEN ROUND((	SELECT		TOP 1 AT1506.DepNewAmount
										FROM		AT1506
										WHERE		AT1506.AssetID = AT1503.AssetID
													AND AT1506.DivisionID = AT1503.DivisionID
													AND AT1506.TranMonth + 100 * AT1506.TranYear <= @TranMonth + 100 * @TranYear
						              	ORDER BY	AT1506.TranYear DESC, AT1506.TranMonth DESC
						 ), @ConvertedDecimals)
				ELSE ROUND(AT1503.DepAmount, @ConvertedDecimals)
		   END AS TotalDepAmount,
		   CASE WHEN EXISTS (	SELECT	TOP 1 AssetID
								FROM	AT1506
								WHERE	AT1506.AssetID = AT1503.AssetID
										AND AT1506.DivisionID = AT1503.DivisionID
										AND AT1506.TranMonth + 100 * AT1506.TranYear <= @TranMonth + 100 * @TranYear) 
					THEN (	SELECT		TOP 1 AT1506.DepNewPercent
							FROM		AT1506
							WHERE		AT1506.AssetID = AT1503.AssetID
										AND AT1506.DivisionID = AT1503.DivisionID
										AND AT1506.TranMonth + 100 * AT1506.TranYear <= @TranMonth + 100 * @TranYear
					      	ORDER BY	AT1506.TranYear DESC, AT1506.TranMonth DESC
						)
				ELSE AT1503.DepPercent
		   END AS DepPercent,
		   AT1503.MethodID,
		   CASE WHEN EXISTS (	SELECT	TOP 1 AssetID
								FROM	AT1506
								WHERE	AT1506.AssetID = AT1503.AssetID
										AND AT1506.DivisionID = AT1503.DivisionID
										AND AT1506.TranMonth + 100 * AT1506.TranYear <= @TranMonth + 100 * @TranYear
					 ) THEN (	SELECT		TOP 1 AT1506.ResidualNewValue
								FROM		AT1506
								WHERE		AT1506.AssetID = AT1503.AssetID
											AND AT1506.DivisionID = AT1503.DivisionID
											AND AT1506.TranMonth + 100 * AT1506.TranYear <= @TranMonth + 100 * @TranYear
					         	ORDER BY	AT1506.TranYear DESC, AT1506.TranMonth DESC
					 )
				ELSE AT1503.ResidualValue
		   END AS ResidualValue,
		   AT1503.SourcePercent1,
		   AT1503.SourcePercent2,
		   AT1503.SourcePercent3,
		   AT1503.SourceID1,
		   AT1503.SourceID2,
		   AT1503.SourceID3,
		   AT1503.PeriodID01,
		   AT1503.PeriodID02,
		   AT1503.PeriodID03,
		   AT1503.PeriodID04,
		   AT1503.PeriodID05,
		   AT1503.PeriodID06,
		   AT1503.UseCofficientID, 
		   AT1503.CoefficientID
	FROM   AT1503
	WHERE  AT1503.DivisionID = @DivisionID
	       AND (BeginMonth + BeginYear * 100) <= (@TranMonth + @TranYear * 100)
		   AND AT1503.AssetStatus = 0

OPEN @Asset_cur
FETCH NEXT FROM @Asset_cur INTO @AssetID,				@ConvertedAmount,	@DepAccountID, 
								@DebitDepAccountID1,	@DepPercent1,		@DebitDepAccountID2,	@DepPercent2,	@DebitDepAccountID3, 
								@DepPercent3, 
								@DebitDepAccountID4,	@DepPercent4,		@DebitDepAccountID5,	@DepPercent5,	@DebitDepAccountID6, 
								@DepPercent6, 
		                        @Ana01ID1 , @Ana02ID1 , @Ana03ID1 , @Ana04ID1 , @Ana05ID1 , @Ana06ID1 , 
		                        @Ana01ID2 , @Ana02ID2 , @Ana03ID2 , @Ana04ID2 , @Ana05ID2 , @Ana06ID2 , 
		                        @Ana01ID3 , @Ana02ID3 , @Ana03ID3 , @Ana04ID3 , @Ana05ID3 , @Ana06ID3 , 
		                        @Ana01ID4 , @Ana02ID4 , @Ana03ID4 , @Ana04ID4 , @Ana05ID4 , @Ana06ID4 , 
		                        @Ana01ID5 , @Ana02ID5 , @Ana03ID5 , @Ana04ID5 , @Ana05ID5 , @Ana06ID5 , 
		                        @Ana01ID6 , @Ana02ID6 , @Ana03ID6 , @Ana04ID6 , @Ana05ID6 , @Ana06ID6 , 
								@TotalDepAmount,		@DepPercent,		@MethodID,				@ResidualValue, 
								@SourcePercent1,		@SourcePercent2,	@SourcePercent3,		@SourceID1,		@SourceID2,				@SourceID3, 
								@PeriodID01,			@PeriodID02,		@PeriodID03,			@PeriodID04,	@PeriodID05,			@PeriodID06,
								@UseCofficientID,		@CoefficientID

WHILE @@Fetch_Status = 0
BEGIN
    IF @MethodID = 0
        --- Khau hao theo PP duong thang
        EXEC AP1501	@DivisionID,
        			@TranMonth,				@TranYear,
					@AssetID,				@DepAccountID,
					@ResidualValue,
					@DebitDepAccountID1,	@DepPercent1,
					@DebitDepAccountID2,	@DepPercent2,
					@DebitDepAccountID3,	@DepPercent3,
					@DebitDepAccountID4,	@DepPercent4,
					@DebitDepAccountID5,	@DepPercent5,
					@DebitDepAccountID6,	@DepPercent6,
					@Ana01ID1,				@Ana02ID1,		@Ana03ID1,		@Ana01ID2,		@Ana02ID2,
					@Ana03ID2,				@Ana01ID3,		@Ana02ID3,
					@Ana03ID3,
					@Ana01ID4,
					@Ana02ID4,
					@Ana03ID4,
					@Ana01ID5,
					@Ana02ID5,
					@Ana03ID5,
					@Ana01ID6,
					@Ana02ID6,
					@Ana03ID6,
					@TotalDepAmount,
					@DepPercent,
					@SourceID1,
					@SourceID2,
					@SourceID3,
					@SourcePercent1,
					@SourcePercent2,
					@SourcePercent3,
					@PeriodID01,
					@PeriodID02,
					@PeriodID03,
					@PeriodID04,
					@PeriodID05,
					@PeriodID06,
					@VoucherTypeID,
					@VoucherNo,
					@VoucherDate,
					@BDescription,
					@UserID,
					@UseCofficientID,
					@CoefficientID,					
					@Ana04ID1, @Ana05ID1, @Ana06ID1,
					@Ana04ID2, @Ana05ID2, @Ana06ID2,
					@Ana04ID3, @Ana05ID3, @Ana06ID3,
					@Ana04ID4, @Ana05ID4, @Ana06ID4,
					@Ana04ID5, @Ana05ID5, @Ana06ID5,
					@Ana04ID6, @Ana05ID6, @Ana06ID6
    
    IF @MethodID = 1
        -- khau hao nhanh
        PRINT 'TEST1'
    
    IF @MethodID = 2
        -- khau hao theo san luong
        PRINT 'TEST2'
    
	FETCH NEXT FROM @Asset_cur INTO @AssetID,				@ConvertedAmount,	@DepAccountID, 
									@DebitDepAccountID1,	@DepPercent1,		@DebitDepAccountID2,	@DepPercent2,	@DebitDepAccountID3, 
									@DepPercent3, 
									@DebitDepAccountID4,	@DepPercent4,		@DebitDepAccountID5,	@DepPercent5,	@DebitDepAccountID6, 
									@DepPercent6, 
		                            @Ana01ID1 , @Ana02ID1 , @Ana03ID1 , @Ana04ID1 , @Ana05ID1 , @Ana06ID1 , 
		                            @Ana01ID2 , @Ana02ID2 , @Ana03ID2 , @Ana04ID2 , @Ana05ID2 , @Ana06ID2 , 
		                            @Ana01ID3 , @Ana02ID3 , @Ana03ID3 , @Ana04ID3 , @Ana05ID3 , @Ana06ID3 , 
		                            @Ana01ID4 , @Ana02ID4 , @Ana03ID4 , @Ana04ID4 , @Ana05ID4 , @Ana06ID4 , 
		                            @Ana01ID5 , @Ana02ID5 , @Ana03ID5 , @Ana04ID5 , @Ana05ID5 , @Ana06ID5 , 
		                            @Ana01ID6 , @Ana02ID6 , @Ana03ID6 , @Ana04ID6 , @Ana05ID6 , @Ana06ID6 , 
									@TotalDepAmount,		@DepPercent,		@MethodID,				@ResidualValue, 
									@SourcePercent1,		@SourcePercent2,	@SourcePercent3,		@SourceID1,		@SourceID2,				@SourceID3, 
									@PeriodID01,			@PeriodID02,		@PeriodID03,			@PeriodID04,	@PeriodID05,			@PeriodID06,
									@UseCofficientID,		@CoefficientID


END

CLOSE @Asset_cur

GO

SET QUOTED_IDENTIFIER OFF
GO

SET ANSI_NULLS ON
GO

