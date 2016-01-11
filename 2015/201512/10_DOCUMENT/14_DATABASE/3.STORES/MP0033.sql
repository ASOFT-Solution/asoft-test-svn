
/****** Object:  StoredProcedure [dbo].[MP0033]    Script Date: 08/02/2010 14:11:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



--- created by Van Nhan, Date 07/05/2009.
--- Purpose: Phan bo, tinh gia thanh, chiet tinh gia thanh tu dong cho tung doi tuong THCP
---- Notes: Nam Hoa Cor. is first client that using this function
---- Edit by: Dang Le Bao Quynh; Date 03/09/2009
---- Purpose: Sua lai cach truyen tham so

/********************************************
'* Edited by: [GS] [Thanh Trẫm] [02/08/2010]
'********************************************/

ALTER PROCEDURE	[dbo].[MP0033] 	@PeriodID as nvarchar(50),
						@DivisionID as nvarchar(50),
						@TranMonth int,
						@TranYear int
 AS

Set Nocount on
Begin
	--1-- Phan bo chi phi
	Exec MP5000 @DivisionID, @PeriodID,  @TranMonth, @TranYear
	Exec MP0031 @DivisionID, @PeriodID,  @TranMonth, @TranYear  --- Xu ly luu vao bang MT0400
	
	--2-- Tinh gia thanh san pham
	Exec MP8005 @DivisionID,@PeriodID ,@TranMonth  ,@TranYear
	Exec MP0032 @DivisionID, @PeriodID,  @TranMonth, @TranYear 
	
	--3-- Chiet tinh gia thanh san pham
	Exec  MP4000	@DivisionID, @PeriodID, @TranMonth, @TranYear
	Exec MP0034 	@DivisionID, @PeriodID, @TranMonth, @TranYear
End

Set Nocount off