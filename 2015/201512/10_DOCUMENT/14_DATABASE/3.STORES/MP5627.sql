/****** Object:  StoredProcedure [dbo].[MP5627]    Script Date: 12/16/2010 13:07:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

------ Created BY Hoang Thi Lan, Date 06/11/2003
------ Purpose  KiÓm tra  Phan bo chi phi san xuat chung
------ Edit BY Quoc Hoai - them dieu kien DivisionID

/********************************************
'* Edited BY: [GS] [Việt Khánh] [29/07/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[MP5627]      
    @DivisionID NVARCHAR(50), 
    @PeriodID  NVARCHAR(50), 
    @TranMonth AS INT, 
    @TranYear AS INT, 
    @DistributionID  NVARCHAR(50), 
    @Status AS TINYINT OUTPUT, 
    @Message AS NVARCHAR(250) OUTPUT
AS

DECLARE    
    @MethodID AS NVARCHAR(50), 
    @CoefficientID AS NVARCHAR(50), 
    @ApportionID AS NVARCHAR(50), 
    @MaterialTypeID AS NVARCHAR(50), 
    @Expense_627 AS CURSOR, 
    @sSQL NVARCHAR(4000), 
    @cur CURSOR, 
    @ProductID NVARCHAR(50)
             
SET NOCOUNT ON

DELETE MT0621 WHERE ExpenseID = 'COST003' AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
SET @Expense_627 = CURSOR SCROLL KEYSET FOR 
SELECT MethodID, CoefficientID, ApportionID, MaterialTypeID 
FROM MT5001 
WHERE DistributionID = @DistributionID 
    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
    AND ExpenseID ='COST003' 
    AND IsDistributed = 1 
    AND MaterialTypeID IN (SELECT Distinct MaterialTypeID 
                            FROM MV9000
                            WHERE ExpenseID = 'COST001' AND PeriodID = @PeriodID 
                                AND TranMonth = @TranMonth AND TranYear = @TranYear
                                AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))

OPEN    @Expense_627
FETCH NEXT FROM @Expense_627 INTO  @MethodID, @CoefficientID, @ApportionID, @MaterialTypeID
WHILE @@Fetch_Status = 0
    BEGIN

        IF @MethodID ='D01' --- Phan bo truc tiep
          BEGIN
            IF EXISTS (SELECT 1 FROM MV9000 
                        WHERE ExpenseID = 'COST003' AND MaterialTypeID = @MaterialTypeID 
                            AND PeriodID = @PeriodID AND ISNULL(ProductID, '') ='' 
                            AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))
                BEGIN
                    
                    SET @Status = 1
                    SET @Message ='MFML000160|' + @MaterialTypeID
                    GOTO EndMess
                END
                IF EXISTS (SELECT 1 FROM MV9000 
                            WHERE ExpenseID = 'COST003' AND MaterialTypeID = @MaterialTypeID 
                                AND PeriodID = @PeriodID AND ISNULL(ProductID, '') <> '' 
                                AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
                                AND ProductID NOT IN (SELECT ProductID 
                                                        FROM MT1001 INNER JOIN MT0810 ON MT0810.DivisionID = MT1001.DivisionID AND MT0810.VoucherID = MT1001.VoucherID 
                                                        WHERE PeriodID = @PeriodID AND ResultTypeID IN ('R01', 'R03') 
                                                            AND MT1001.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
                                                     )
                            )
                BEGIN
                    SET @Status = 1
                    SET @Message ='MFML000157|' + @MaterialTypeID
                    GOTO EndMess
                END

        END
        IF @MethodID ='D02' ---- Phan bo theo he so
            IF EXISTS ( SELECT DISTINCT ProductID 
                        FROM MT1001 INNER JOIN MT0810 ON MT0810.DivisionID = MT1001.DivisionID AND MT0810.VoucherID = MT1001.VoucherID 
                        WHERE ResultTypeID = 'R01' AND PeriodID = @PeriodID 
                            AND MT1001.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
                            AND ProductID NOT IN (SELECT InventoryID FROM MT1605 WHERE CoefficientID =@CoefficientID
                                                    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))))
                BEGIN
                    SET @sSQL = 'SELECT DISTINCT ProductID 
                                FROM MT1001 INNER JOIN MT0810 ON MT0810.DivisionID = MT1001.DivisionID AND MT0810.VoucherID = MT1001.VoucherID 
                                WHERE ResultTypeID = ''R01'' AND PeriodID = '''+@PeriodID+'''
                                    AND MT1001.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID('''+@DivisionID+'''))
                                    AND ProductID NOT IN (SELECT InventoryID FROM MT1605 WHERE CoefficientID ='''+@CoefficientID+'''
                                                            AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID('''+@DivisionID+''')))'
                    IF EXISTS (SELECT TOP 1 1 FROM sysObjects WHERE XType = 'V' AND Name = 'MV5627')
                        DROP VIEW MV5627
                    EXEC('CREATE VIEW  MV5627 ---tao boi MP5627
                        AS ' + @sSQL)
                        
                    SET @sSQL = ''
                    SET @cur = CURSOR SCROLL KEYSET FOR SELECT ProductID FROM MV5627 ORDER BY ProductID
                    
                    OPEN @cur
                    FETCH NEXT FROM @cur INTO @ProductID    
                    While @@FETCH_STATUS = 0 
                        BEGIN
                            SET @sSQL = @sSQL + @ProductID + ', '  
                            FETCH NEXT FROM @cur INTO @ProductID    
                        END
                    
                    SET @Status = 2
                    SET @Message ='MFML000154|' + CASE WHEN LEN(@sSQL) > 180 THEN LEFT(@sSQL, 180) + '....' ELSE LEFT(@sSQL, LEN(@sSQL) - 1) END
                    GOTO EndMess
                END

        IF @MethodID ='D03' ---- Phan bo theo dinh muc
        BEGIN
            IF EXISTS ( SELECT DISTINCT ProductID 
                        FROM MT1001 INNER JOIN MT0810 ON MT0810.DivisionID = MT1001.DivisionID AND MT0810.VoucherID = MT1001.VoucherID 
                        WHERE ResultTypeID = 'R01' AND PeriodID = @PeriodID 
                            AND MT1001.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
                            AND ProductID NOT IN (SELECT ProductID FROM MT1603 WHERE ApportionID = @ApportionID
                                                    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))))
                BEGIN
                    SET @sSQL = 'SELECT DISTINCT ProductID 
                                FROM MT1001 INNER JOIN MT0810 ON MT0810.DivisionID = MT1001.DivisionID AND MT0810.VoucherID = MT1001.VoucherID 
                                WHERE ResultTypeID = ''R01'' AND PeriodID = '''+@PeriodID +'''
                                    AND MT1001.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID('''+@DivisionID+'''))
                                    AND ProductID NOT IN (SELECT ProductID FROM MT1603 WHERE ApportionID = '''+@ApportionID+'''
                                                            AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID('''+@DivisionID+''')))'
                    IF EXISTS (SELECT TOP 1 1 FROM sysObjects WHERE XType = 'V' AND Name = 'MV5627')
                        DROP VIEW MV5627
                    EXEC('CREATE VIEW  MV5627 ---tao boi MP5627
                        AS ' + @sSQL)
                        
                    SET @sSQL = ''
                    SET @cur = CURSOR SCROLL KEYSET FOR SELECT ProductID FROM MV5627 ORDER BY ProductID
                    
                    OPEN @cur
                    FETCH NEXT FROM @cur INTO @ProductID    
                    While @@FETCH_STATUS = 0 
                        BEGIN
                            SET @sSQL = @sSQL + @ProductID + ', '  
                            FETCH NEXT FROM @cur INTO @ProductID    
                        END
                    
                    SET @Status = 2
                    SET @Message ='MFML000152|' + CASE WHEN LEN(@sSQL) > 180 THEN LEFT(@sSQL, 180) + '....' ELSE LEFT(@sSQL, LEN(@sSQL) - 1) END
                    GOTO EndMess
                END
        END 
        /*
        IF @MethodID ='D04' ---- Phan bo theo nguyen vat lieu (NVL phai thuc hien truoc)
            BEGIN
            IF NOT EXISTS (SELECT MT0621.ProductID FROM MT0621 Full JOIN MT2222 ON  MT0621.ProductID = MT2222.ProductID 
                          WHERE ExpenseID = 'COST001' )                            
                BEGIN

                    SET @Status = 1
                    SET @Message ='S¶n phÈm nµy ch­a ph©n bæ theo NVL .B¹n kh«ng thÓ ph©n bæ chi phÝ ®­îc.'
                    GOTO EndMess
                    --Print @MethodID
                END
        END 
        
        IF @MethodID ='D05' --- phan bo theo luong
            BEGIN
            IF NOT EXISTS (SELECT MT0621.ProductID FROM MT0621 Full JOIN MT2222 ON  MT0621.ProductID = MT2222.ProductID 
                          WHERE ExpenseID = 'COST002' )                            
                BEGIN

                    SET @Status = 1
                    SET @Message ='S¶n phÈm nµy ch­a ph©n bæ theo l­¬ng .B¹n kh«ng thÓ ph©n bæ chi phÝ ®­îc.'
                    GOTO EndMess
                    --Print @MethodID
                END
        END 
        */
        IF @MethodID ='D06' --- Phan bo truc  tiep ket hop he so
             IF EXISTS (SELECT DISTINCT ProductID 
                        FROM MT1001 INNER JOIN MT0810 ON MT0810.DivisionID = MT1001.DivisionID AND MT0810.VoucherID = MT1001.VoucherID 
                        WHERE ResultTypeID = 'R01' AND PeriodID = @PeriodID 
                            AND MT1001.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
                            AND ProductID NOT IN (SELECT InventoryID FROM MT1605 WHERE CoefficientID = @CoefficientID
                                                    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))))
                BEGIN
                    SET @sSQL = 'SELECT DISTINCT ProductID 
                                FROM MT1001 INNER JOIN MT0810 ON MT0810.DivisionID = MT1001.DivisionID AND MT0810.VoucherID = MT1001.VoucherID 
                                WHERE ResultTypeID = ''R01'' AND PeriodID = '''+@PeriodID+'''
                                    AND MT1001.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID('''+@DivisionID+'''))
                                    AND ProductID NOT IN (SELECT InventoryID FROM MT1605 WHERE CoefficientID = '''+@CoefficientID+'''
                                                            AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID('''+@DivisionID+''')))'
                    IF EXISTS (SELECT TOP 1 1 FROM sysObjects WHERE XType = 'V' AND Name = 'MV5627')
                        DROP VIEW MV5627
                    EXEC('CREATE VIEW  MV5627 ---tao boi MP5627
                        AS ' + @sSQL)
                        
                    SET @sSQL = ''
                    SET @cur = CURSOR SCROLL KEYSET FOR SELECT ProductID FROM MV5627 ORDER BY ProductID
                    
                    OPEN @cur
                    FETCH NEXT FROM @cur INTO @ProductID    
                    While @@FETCH_STATUS = 0 
                        BEGIN
                            SET @sSQL = @sSQL + @ProductID + ', '  
                            FETCH NEXT FROM @cur INTO @ProductID    
                        END
                    
                    SET @Status = 2
                    SET @Message ='MFML000154|'+ CASE WHEN LEN(@sSQL) > 180 THEN LEFT(@sSQL, 180) + '....' ELSE LEFT(@sSQL, LEN(@sSQL) - 1) END
                    GOTO EndMess
                END

        IF @MethodID ='D07' --- Phanbo truc tiep ket hop dinh muc
            BEGIN
            IF EXISTS ( SELECT DISTINCT ProductID 
                        FROM MT1001 INNER JOIN MT0810 ON MT0810.VoucherID = MT1001.VoucherID 
                        WHERE ResultTypeID = 'R01' AND PeriodID = @PeriodID 
                            AND MT1001.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
                            AND ProductID NOT IN (SELECT ProductID FROM MT1603 WHERE ApportionID = @ApportionID
                                                    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))))
                BEGIN
                    SET @sSQL = 'SELECT DISTINCT ProductID 
                                FROM MT1001 INNER JOIN MT0810 ON MT0810.VoucherID = MT1001.VoucherID 
                                WHERE ResultTypeID = ''R01'' AND PeriodID = '''+@PeriodID+'''
                                    AND MT1001.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID('''+@DivisionID+'''))
                                    AND ProductID NOT IN (SELECT ProductID FROM MT1603 WHERE ApportionID = '''+@ApportionID+'''
                                                            AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID('''+@DivisionID+''')))'
                    IF EXISTS (SELECT TOP 1 1 FROM sysObjects WHERE XType = 'V' AND Name = 'MV5627')
                        DROP VIEW MV5627
                    EXEC('CREATE VIEW  MV5627 ---tao boi MP5627
                        AS ' + @sSQL)
                        
                    SET @sSQL = ''
                    SET @cur = CURSOR SCROLL KEYSET FOR SELECT ProductID FROM MV5627 ORDER BY ProductID
                    
                    OPEN @cur
                    FETCH NEXT FROM @cur INTO @ProductID    
                    While @@FETCH_STATUS = 0 
                        BEGIN
                            SET @sSQL = @sSQL + @ProductID + ', '  
                            FETCH NEXT FROM @cur INTO @ProductID    
                        END
                    
                    SET @Status = 2
                    SET @Message ='MFML000152|' + CASE WHEN LEN(@sSQL) > 180 THEN LEFT(@sSQL, 180) + '....' ELSE LEFT(@sSQL, LEN(@sSQL) - 1) END
                    GOTO EndMess
                    --Print @MethodID
                END
        END 

        FETCH NEXT FROM @Expense_627  INTO  @MethodID, @CoefficientID, @ApportionID, @MaterialTypeID  
    END

CLOSE @Expense_627

EndMess:
SET NOCOUNT OFF
RETURN @Status
RETURN @Message