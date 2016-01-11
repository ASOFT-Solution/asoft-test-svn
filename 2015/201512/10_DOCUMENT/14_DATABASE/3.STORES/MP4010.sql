/****** Object: StoredProcedure [dbo].[MP4010] Script Date: 08/03/2010 16:18:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Created BY: Vo Thanh Huong, date: 30/05/2005
--purpose: Kiem tra truoc khi xoa phan bo, phan bo CPDD
--- Modify on 30/01/2013 by Bao Anh: Sua thu tu kiem tra (Bo ELSE)
/********************************************
'* Edited BY: [GS] [Thành Nguyên] [03/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP4010] 
    @DivisionID NVARCHAR(50),
    @PeriodID NVARCHAR(50), 
    @Type INT

AS

DECLARE 
    @Message NVARCHAR(4000),
    @Status INT, ---0: Cho phep xoa, 1: Chua phan bo, 2: Da tinh do dang, 3: Da tinh gia thanh, 4: Da chiet tinh gia thanh 
    @IsInProcess TINYINT,
    @IsCost TINYINT,
    @IsDetailCost TINYINT,
    @IsDistribute TINYINT

SELECT 
    @Status = 0, 
    @Message = '', 
    @IsInProcess = IsInProcess, 
    @IsCost = IsCost, 
    @IsDetailCost = IsDetailCost, 
    @IsDistribute = IsDistribute
FROM MT1601 
WHERE PeriodID = @PeriodID AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))

IF @Type = 0 
    BEGIN    
        IF @IsDistribute = 0 SELECT @Status = 1, @Message = N'MFML000162' ---ELSE --This period has NOT been distributed. You can NOT deleted!
        IF @IsInProcess = 1  SELECT @Status = 2, @Message = N'MFML000166' ---ELSE --This period has been caculated haft-done. Would you like deleted it!
        IF @IsCost = 1       SELECT @Status = 3, @Message = N'MFML000167' ---ELSE --This period has been caculated cost price. Would you like deleted it!
        IF @IsDetailCost = 1 SELECT @Status = 4, @Message = N'MFML000165'      --This period has been caculated detail cost price. Would you like deleted it!
    END    
ELSE IF @Type = 1
    BEGIN
        IF @IsInProcess = 0  SELECT @Status = 1, @Message = N'MFML000163' ---ELSE --This period has NOT been caculated. you can NOT deleted!
        IF @IsCost = 1       SELECT @Status = 2, @Message = N'MFML000167' ---ELSE --This period has been caculated cost price. Would you like deleted it!
        IF @IsDetailCost = 1 SELECT @Status = 3, @Message = N'MFML000165'      --This period has been caculated detail cost price. Would you like deleted it!
    END
ELSE IF @Type = 2
    BEGIN
        IF @IsCost = 0       SELECT @Status = 1, @Message = N'MFML000164' ---ELSE --This period has NOT been caculated cost price. You can NOT deleted it!
        IF @IsDetailCost = 1 SELECT @Status = 2, @Message = N'MFML000165'      --This period has been caculated detail cost price. Would you like deleted it!
    END

RETURN_VALUES:
SELECT @Status AS Status, @Message AS Message
GO
