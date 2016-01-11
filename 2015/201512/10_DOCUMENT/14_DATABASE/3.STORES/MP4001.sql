/****** Object: StoredProcedure [dbo].[MP4001] Script Date: 08/02/2010 10:53:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created BY Hoang Thi Lan 
--Date 17/12/2003
--Purpose : KiÓm tra tr­íc khi chiÕt tÝnh gi¸ thµnh

/********************************************
'* Edited BY: [GS] [Mỹ Tuyền] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP4001]
    @DivisionID AS NVARCHAR(50),
    @PeriodID AS NVARCHAR(50)
AS

DECLARE 
    @sSQL AS NVARCHAR(4000), 
    @Status AS TINYINT, 
    @Message AS NVARCHAR(250)
    
--Kiểm tra đã tính giá thành chưa?
SET @Status = 0
IF NOT EXISTS (SELECT TOP 1 1 FROM MT1601 WHERE IsCost = 1 AND PeriodID = @PeriodID AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))
    BEGIN
        SET @Status = 1      
        SET @Message = N'MFML000169' -- This Period was NOT costed .You can NOT cost it IN detail!
        GOTO RETURN_VALUES
    END 

--Kiểm tra đã chiết tính giá thành chưa?
IF NOT EXISTS(SELECT TOP 1 1 FROM MT1601 WHERE IsDetailCost = 0 AND PeriodID = @PeriodID AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))
    BEGIN
        SET @Status = 2
        SET @Message = N'MFML000171' -- This Period was costed IN detail .Do you want to see it?
        GOTO RETURN_VALUES
    END

RETURN_VALUES:
SELECT @Status AS Status, @Message AS Message










