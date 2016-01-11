/****** Object: StoredProcedure [dbo].[AP1319] Script Date: 07/29/2010 09:45:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

----- Created by: Thuy Tuyen, date 29/03/2010
---- Purpose: Kiem tra rang buoc du lieu cho phep Sua, Xoa khi lap cong thuc DVT qui doi ASOFT CI

/********************************************
'* Edited by: [GS] [Việt Khánh] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP1319] 
    @DivisionID NVARCHAR(50), 
    @FormulaID NVARCHAR(50), 
    @TableName NVARCHAR(50), 
    @IsEdit TINYINT         --- 0: Xoa
                            --- 1: Sua
AS

DECLARE 
    @Status TINYINT,     --- 1: Khong cho xoa, sua
                            --- 2: Co canh bao nhung cho xoa cho sua; 
                            --- 3: Cho sua mot phan thoi
    @EngMessage NVARCHAR(250), 
    @VieMessage NVARCHAR(250)

SELECT @Status = 0, @EngMessage = '', @VieMessage = ''

IF @TableName = 'AT1309' AND @IsEdit = 0
    BEGIN
        IF EXISTS (SELECT TOP 1 1 FROM AT1309 WHERE FormulaID = @FormulaID AND DivisionID = @DivisionID)
            BEGIN
                SET @Status = 1
                SET @VieMessage = 'C«ng thøc nµy ®· ®­îc dïng.B¹n kh«ng ®­îc phÐp xo¸. '
                SET @EngMessage = 'This formula is used. You can not delete one. You must check!'
                Goto EndMess
            END 
    END

IF @TableName = 'AT1309' AND @IsEdit = 1
    BEGIN
        IF EXISTS (SELECT TOP 1 1 FROM AT1309 WHERE FormulaID = @FormulaID AND DivisionID = @DivisionID)
            BEGIN
                SET @Status = 1
                SET @VieMessage = 'C«ng thøc nµy ®· ®­îc dïng.B¹n kh«ng ®­îc phÐp söa. '
                SET @EngMessage = 'This order is used. You can not edit one. You must check!'
                Goto EndMess
            END 
    END
-------------------------------------------------------------------
EndMess:
SELECT @Status AS Status, @EngMessage AS EngMessage, @VieMessage AS VieMessage