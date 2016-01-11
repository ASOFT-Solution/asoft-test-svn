IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1310]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP1310]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


------- Kiem tra ForeignKey CHO ma phan loai ma hang, ma doi tuong, ma phan tich, ma TSCD, Mã phụ 
------Last Edit Thuy Tuyen, date 01/02/2007

/********************************************
'* Edited by: [GS] [Việt Khánh] [29/07/2010]
'********************************************/
--- Modified on 03/10/2013 by Thanh Sơn theo bug: 0020937 (keimr tra thêm bảng OT2102 cho Ana01IS -> Ana01ID)
--- Modified on 18/02/2014 by Bảo Anh: kiểm tra MPT9 có dùng trong bảng giá chưa (Sinolife)
--- Modified on 23/06/2015 by Hoang VU: kiểm tra ExtraID có dùng trong bảng giá chưa (Secoin) => bỏ
--- Modified on 01/12/2015 by Phương Thảo: Customize Kh Meiko : Danh mục Mã PT (A03, A04) là danh mục Phòng ban, tổ nhóm

CREATE PROCEDURE [dbo].[AP1310] 
    @TableID NVARCHAR(50), 
    @STypeID NVARCHAR(50), 
    @KeyValues NVARCHAR(50)
AS

DECLARE @Status TINYINT, @CustomerName INT

CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)

SET @Status = 0;
IF @TableID = 'AT1207' --- ma phan loai doi tuong
    BEGIN
        IF @STypeID = 'O01' 
            IF EXISTS (SELECT TOP 1 1 FROM AT1202 WHERE S1 = @KeyValues)
                BEGIN
                    SET @Status = 1
                    GOTO RETURN_VALUES
                END
        IF @STypeID = 'O02' 
            IF EXISTS (SELECT TOP 1 1 FROM AT1202 WHERE S2 = @KeyValues)
                BEGIN
                    SET @Status = 1
                    GOTO RETURN_VALUES
                END
        IF @STypeID = 'O03' 
            IF EXISTS (SELECT TOP 1 1 FROM AT1202 WHERE S3 = @KeyValues)
                BEGIN
                    SET @Status = 1
                    GOTO RETURN_VALUES
                END
    END

IF @TableID = 'AT1310' --- ma phan loai mat hang
    BEGIN
        IF @STypeID = 'I01' 
            IF EXISTS (SELECT TOP 1 1 FROM AT1302 WHERE S1 = @KeyValues)
                BEGIN
                    SET @Status = 1
                    GOTO RETURN_VALUES
                END
        IF @STypeID = 'I02' 
            IF EXISTS (SELECT TOP 1 1 FROM AT1302 WHERE S2 = @KeyValues)
                BEGIN
                    SET @Status = 1
                    GOTO RETURN_VALUES
                END
        IF @STypeID = 'I03' 
            IF EXISTS (SELECT TOP 1 1 FROM AT1302 WHERE S3 = @KeyValues)
                BEGIN
                    SET @Status = 1
                    GOTO RETURN_VALUES
                END
    END

IF @TableID = 'AT1505' --- ma phan loai TSCD
    BEGIN
        IF @STypeID = 'F01' 
            IF EXISTS (SELECT TOP 1 1 FROM AT1503 WHERE S1 = @KeyValues)
                BEGIN
                    SET @Status = 1
                    GOTO RETURN_VALUES
                END
        IF @STypeID = 'F02' 
            IF EXISTS (SELECT TOP 1 1 FROM AT1503 WHERE S2 = @KeyValues)
                BEGIN
                    SET @Status = 1
                    GOTO RETURN_VALUES
                END
        IF @STypeID = 'F03' 
            IF EXISTS (SELECT TOP 1 1 FROM AT1503 WHERE S3 = @KeyValues)
                BEGIN
                    SET @Status = 1
                    GOTO RETURN_VALUES
                END
    END

IF @TableID = 'AT1011' --- ma phan tich
    BEGIN
    IF @STypeID = 'A01' 
        IF EXISTS (SELECT TOP 1 1 FROM AT9000 WHERE Ana01ID = @KeyValues) 
            OR EXISTS (SELECT TOP 1 1 FROM AT1503 WHERE Ana01ID1 = @KeyValues OR Ana01ID2 = @KeyValues OR Ana01ID3 = @KeyValues)
            OR EXISTS (SELECT TOP 1 1 FROM OT2102 WHERE Ana01ID = @KeyValues)
            OR EXISTS (SELECT TOP 1 1 FROM OT2002 WHERE Ana01ID = @KeyValues)
            OR EXISTS (SELECT TOP 1 1 FROM OT3102 WHERE Ana01ID = @KeyValues)
            OR EXISTS (SELECT TOP 1 1 FROM OT3002 WHERE Ana01ID = @KeyValues)
            OR EXISTS (SELECT TOP 1 1 FROM OT3002 WHERE Ana01ID = @KeyValues)
            BEGIN
                SET @Status = 1
                GOTO RETURN_VALUES
            END
    IF @STypeID = 'A02'	
        IF EXISTS (SELECT TOP 1 1 FROM AT9000 WHERE Ana02ID = @KeyValues) 
            OR EXISTS (SELECT TOP 1 1 FROM AT1503 WHERE Ana02ID1 = @KeyValues OR Ana02ID2 = @KeyValues OR Ana02ID3 = @KeyValues)
            OR EXISTS (SELECT TOP 1 1 FROM OT2102 WHERE Ana02ID = @KeyValues)
            OR EXISTS (SELECT TOP 1 1 FROM OT2002 WHERE Ana02ID = @KeyValues)
            OR EXISTS (SELECT TOP 1 1 FROM OT3102 WHERE Ana02ID = @KeyValues)
            OR EXISTS (SELECT TOP 1 1 FROM OT3002 WHERE Ana02ID = @KeyValues)
			OR (exists (Select top 1 1  From AT1103  Where DepartmentID = @KeyValues) and @CustomerName = 50)
			OR (exists (Select top 1 1  From HT1101  Where DepartmentID = @KeyValues) and @CustomerName = 50)
			OR (exists (Select top 1 1  From HV1400  Where DepartmentID = @KeyValues) and @CustomerName = 50)
			OR (exists (Select top 1 1  From MT2002  Where DepartmentID = @KeyValues) and @CustomerName = 50)
            BEGIN
                SET @Status = 1
                GOTO RETURN_VALUES
            END
	
    IF @STypeID = 'A03'
        IF EXISTS (SELECT TOP 1 1 FROM AT9000 WHERE Ana03ID = @KeyValues) 
            OR EXISTS (SELECT TOP 1 1 FROM AT1503 WHERE Ana03ID1 = @KeyValues OR Ana03ID2 = @KeyValues OR Ana03ID3 = @KeyValues)
            OR EXISTS (SELECT TOP 1 1 FROM OT2102 WHERE Ana03ID = @KeyValues)
            OR EXISTS (SELECT TOP 1 1 FROM OT3102 WHERE Ana03ID = @KeyValues)
            OR EXISTS (SELECT TOP 1 1 FROM OT3002 WHERE Ana03ID = @KeyValues)
			OR (exists (Select top 1 1  From HV1400  Where DepartmentID = @KeyValues) and @CustomerName = 50)
			BEGIN
                SET @Status = 1
                GOTO RETURN_VALUES
            END
    IF @STypeID = 'A04'
        IF EXISTS (SELECT TOP 1 1 FROM AT9000 WHERE Ana04ID = @KeyValues) 
            OR EXISTS (SELECT TOP 1 1 FROM AT1503 WHERE Ana04ID1 = @KeyValues OR Ana04ID2 = @KeyValues OR Ana04ID3 = @KeyValues)
             OR EXISTS (SELECT TOP 1 1 FROM OT2102 WHERE Ana04ID = @KeyValues)
             OR EXISTS (SELECT TOP 1 1 FROM OT2002 WHERE Ana04ID = @KeyValues)
             OR EXISTS (SELECT TOP 1 1 FROM OT3102 WHERE Ana04ID = @KeyValues)
             OR EXISTS (SELECT TOP 1 1 FROM OT3002 WHERE Ana04ID = @KeyValues)
            BEGIN
                SET @Status = 1
                GOTO RETURN_VALUES
            END
    IF @STypeID = 'A05' 
        IF EXISTS (SELECT TOP 1 1 FROM AT9000 WHERE Ana05ID = @KeyValues) 
            OR EXISTS (SELECT TOP 1 1 FROM AT1503 WHERE Ana05ID1 = @KeyValues OR Ana05ID2 = @KeyValues OR Ana05ID3 = @KeyValues)
             OR EXISTS (SELECT TOP 1 1 FROM OT2102 WHERE Ana05ID = @KeyValues)
             OR EXISTS (SELECT TOP 1 1 FROM OT2002 WHERE Ana05ID = @KeyValues)
             OR EXISTS (SELECT TOP 1 1 FROM OT3102 WHERE Ana05ID = @KeyValues)
             OR EXISTS (SELECT TOP 1 1 FROM OT3002 WHERE Ana05ID = @KeyValues)
            BEGIN
                SET @Status = 1
                GOTO RETURN_VALUES
            END
    END
    
    IF @STypeID = 'A06'
        IF EXISTS (SELECT TOP 1 1 FROM AT9000 WHERE Ana06ID = @KeyValues) 
            OR EXISTS (SELECT TOP 1 1 FROM AT1503 WHERE Ana06ID1 = @KeyValues OR Ana06ID2 = @KeyValues OR Ana06ID3 = @KeyValues)
             OR EXISTS (SELECT TOP 1 1 FROM OT2102 WHERE Ana06ID = @KeyValues)
             OR EXISTS (SELECT TOP 1 1 FROM OT2002 WHERE Ana06ID = @KeyValues)
             OR EXISTS (SELECT TOP 1 1 FROM OT3102 WHERE Ana06ID = @KeyValues)
             OR EXISTS (SELECT TOP 1 1 FROM OT3002 WHERE Ana06ID = @KeyValues)
            BEGIN
                SET @Status = 1
                GOTO RETURN_VALUES
            END
            
            IF @STypeID = 'A07'
        IF EXISTS (SELECT TOP 1 1 FROM AT9000 WHERE Ana07ID = @KeyValues) 
            OR EXISTS (SELECT TOP 1 1 FROM AT1503 WHERE Ana07ID1 = @KeyValues OR Ana07ID2 = @KeyValues OR Ana07ID3 = @KeyValues)
             OR EXISTS (SELECT TOP 1 1 FROM OT2102 WHERE Ana07ID = @KeyValues)
             OR EXISTS (SELECT TOP 1 1 FROM OT2002 WHERE Ana07ID = @KeyValues)
             OR EXISTS (SELECT TOP 1 1 FROM OT3102 WHERE Ana07ID = @KeyValues)
             OR EXISTS (SELECT TOP 1 1 FROM OT3002 WHERE Ana07ID = @KeyValues)
            BEGIN
                SET @Status = 1
                GOTO RETURN_VALUES
            END
            
            IF @STypeID = 'A08'
        IF EXISTS (SELECT TOP 1 1 FROM AT9000 WHERE Ana08ID = @KeyValues) 
            OR EXISTS (SELECT TOP 1 1 FROM AT1503 WHERE Ana08ID1 = @KeyValues OR Ana08ID2 = @KeyValues OR Ana08ID3 = @KeyValues)
             OR EXISTS (SELECT TOP 1 1 FROM OT2102 WHERE Ana08ID = @KeyValues)
             OR EXISTS (SELECT TOP 1 1 FROM OT2002 WHERE Ana08ID = @KeyValues)
             OR EXISTS (SELECT TOP 1 1 FROM OT3102 WHERE Ana08ID = @KeyValues)
             OR EXISTS (SELECT TOP 1 1 FROM OT3002 WHERE Ana08ID = @KeyValues)
            BEGIN
                SET @Status = 1
                GOTO RETURN_VALUES
            END
            
            IF @STypeID = 'A09'
        IF EXISTS (SELECT TOP 1 1 FROM AT9000 WHERE Ana09ID = @KeyValues) 
            OR EXISTS (SELECT TOP 1 1 FROM AT1503 WHERE Ana09ID1 = @KeyValues OR Ana09ID2 = @KeyValues OR Ana09ID3 = @KeyValues)
             OR EXISTS (SELECT TOP 1 1 FROM OT2102 WHERE Ana09ID = @KeyValues)
             OR EXISTS (SELECT TOP 1 1 FROM OT2002 WHERE Ana09ID = @KeyValues)
             OR EXISTS (SELECT TOP 1 1 FROM OT3102 WHERE Ana09ID = @KeyValues)
             OR EXISTS (SELECT TOP 1 1 FROM OT3002 WHERE Ana09ID = @KeyValues)
             --- Kiểm tra có dùng trong bảng giá (Sinolife dùng MPT9 làm phương thức thanh toán)
             OR EXISTS (SELECT TOP 1 1 FROM OT1302 WHERE PaymentID = @KeyValues)
            BEGIN
                SET @Status = 1
                GOTO RETURN_VALUES
            END
            
            IF @STypeID = 'A10'
        IF EXISTS (SELECT TOP 1 1 FROM AT9000 WHERE Ana10ID = @KeyValues) 
            OR EXISTS (SELECT TOP 1 1 FROM AT1503 WHERE Ana10ID1 = @KeyValues OR Ana10ID2 = @KeyValues OR Ana10ID3 = @KeyValues)
             OR EXISTS (SELECT TOP 1 1 FROM OT2102 WHERE Ana10ID = @KeyValues)
             OR EXISTS (SELECT TOP 1 1 FROM OT2002 WHERE Ana10ID = @KeyValues)
             OR EXISTS (SELECT TOP 1 1 FROM OT3102 WHERE Ana10ID = @KeyValues)
             OR EXISTS (SELECT TOP 1 1 FROM OT3002 WHERE Ana10ID = @KeyValues)
            BEGIN
                SET @Status = 1
                GOTO RETURN_VALUES
            END
    
---- Tra ra gia tri
RETURN_VALUES:
SELECT @Status AS Status


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

