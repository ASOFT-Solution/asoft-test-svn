/****** Object:  StoredProcedure [dbo].[MP5621]    Script Date: 12/16/2010 11:42:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------ Created BY Nguyen Van Nhan AND Hoang Thi Lan, Date 06/11/2003
------ Purpose Kiem tra tinh hop le cua chi phi NVL truc tiep
------ Edit BY Thanh Huong, date : 14/04/2005
------ Edit BY: Dang Le Bao Quynh; Date 21/05/2008
------ Purpose: Sua lai cach kiem tra dinh muc NVL
----- Modify on 24/04/2014 by Bảo Anh: Bổ sung kiểm tra nếu là NVL thay thế (phân bổ theo định mức)
/********************************************
'* Edited BY: [GS] [Thành Nguyên] [03/08/2010]
'********************************************/    

ALTER PROCEDURE  [dbo].[MP5621] @DivisionID NVARCHAR(50), 
                    @PeriodID  NVARCHAR(50), 
                    @TranMonth AS INT, 
                    @TranYear AS INT, 
                    @DistributionID  NVARCHAR(50), 
                    @Status AS TINYINT OUTPUT, 
                    @Message AS NVARCHAR(500) OUTPUT
AS
DECLARE     @MethodID AS NVARCHAR(50), 
    @CoefficientID AS NVARCHAR(50), 
    @ApportionID AS NVARCHAR(50), 
    @MaterialTypeID AS NVARCHAR(50), 
    @Expense_621 AS CURSOR, 
    @sSQL NVARCHAR(4000), 
    @cur AS CURSOR, 
    @ProductID NVARCHAR(50)
    
             
SET NOCOUNT ON

    
---- IsDistributed = 1                 
DELETE MT0621 WHERE ExpenseID ='COST001'
SET @Expense_621 = CURSOR SCROLL KEYSET FOR 
SELECT MethodID, CoefficientID, ApportionID, MaterialTypeID
FROM MT5001 
WHERE DistributionID = @DistributionID AND ExpenseID = 'COST001' AND IsDistributed = 1 
    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
    AND MaterialTypeID IN (SELECT DISTINCT MaterialTypeID FROM MV9000
                            WHERE ExpenseID = 'COST001' AND PeriodID = @PeriodID AND TranMonth = @TranMonth AND TranYear = @TranYear
                                AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))
                
OPEN @Expense_621
FETCH NEXT FROM @Expense_621 INTO @MethodID, @CoefficientID, @ApportionID, @MaterialTypeID        
WHILE @@Fetch_Status = 0
BEGIN
    IF @MethodID ='D01' --- Phan bo truc tiep            
        BEGIN    
            IF EXISTS ( SELECT 1 FROM MV9000 
                        WHERE ExpenseID = 'COST001' AND MaterialTypeID = @MaterialTypeID 
                            AND PeriodID = @PeriodID AND ISNULL(ProductID, '') = '' 
                            AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))
                BEGIN
                    SET @Status = 1
                    SET @Message = N'MFML000159|' + @MaterialTypeID
                    GOTO EndMess
                END
                
            IF EXISTS ( SELECT DISTINCT ProductID 
                        FROM MV9000 
                        WHERE ExpenseID = 'COST001' AND MaterialTypeID = @MaterialTypeID AND PeriodID = @PeriodID AND ISNULL(ProductID, '') <> '' 
                            AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
                            AND ProductID NOT IN (SELECT ISNULL(ProductID, '') 
                                                FROM  MT1001 INNER JOIN MT0810 ON MT0810.DivisionID = MT1001.DivisionID AND Mt0810.VoucherID = MT1001.VoucherID 
                                                WHERE ResultTypeID IN ('R01', 'R03') AND PeriodID = @PeriodID 
                                                    AND MT0810.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))
                     )
                BEGIN
                    SET @sSQL = 'SELECT DISTINCT ProductID 
                                FROM MV9000 
                                WHERE ExpenseID = ''COST001'' AND MaterialTypeID = '''+@MaterialTypeID+''' 
                                    AND PeriodID = '''+@PeriodID+''' AND ISNULL(ProductID, '''') <> '''' 
                                    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID('''+@DivisionID+'''))
                                    AND ProductID NOT IN (SELECT ISNULL(ProductID, '''') 
                                                        FROM  MT1001 INNER JOIN MT0810 ON MT0810.DivisionID = MT1001.DivisionID AND Mt0810.VoucherID = MT1001.VoucherID 
                                                        WHERE ResultTypeID IN (''R01'', ''R03'') AND PeriodID = '''+@PeriodID+'''
                                                            AND MT0810.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID('''+@DivisionID+''')))
                            '
                            print @sSQL;
                    IF EXISTS (SELECT TOP 1 1 FROM sysObjects WHERE XType = 'V' AND Name = 'MV5621')
                        DROP VIEW MV5621
                    EXEC('CREATE VIEW MV5621 ---tao boi MP5621
                        AS ' + @sSQL)
                        
                    SET @sSQL = ''
                    SET @cur = CURSOR SCROLL KEYSET FOR SELECT ProductID FROM MV5621 Order BY ProductID
                    OPEN @cur
                    FETCH NEXT FROM @cur INTO @ProductID    
                    WHILE @@FETCH_STATUS = 0 
                        BEGIN
                            SET @sSQL = @sSQL + @ProductID + ', '  
                            FETCH NEXT FROM @cur INTO @ProductID    
                        END

                    SET @Status = 1
                    SET @Message = N'MFML000161|' + CASE WHEN len(@sSQL) > 180 then LEFT(@sSQL, 180) + '....' ELSE LEFT(@sSQL, len(@sSQL) - 1)  END
                        
                    GOTO EndMess        
                    END
        END    --- Of MethodID ='D01

    IF @MethodID ='D02' ---- Phan bo theo he so
        BEGIN
            IF EXISTS ( SELECT DISTINCT ProductID 
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
                    IF EXISTS (SELECT TOP 1 1 FROM sysObjects WHERE XType = 'V' AND Name = 'MV5621')
                        DROP VIEW MV5621
                    EXEC('CREATE VIEW MV5621 ---tao boi MP5621
                        AS ' + @sSQL)
                        
                    SET @sSQL = ''
                    SET @cur = CURSOR SCROLL KEYSET FOR SELECT ProductID FROM MV5621 Order BY ProductID
                    OPEN @cur
                    FETCH NEXT FROM @cur INTO @ProductID    
                    WHILE @@FETCH_STATUS = 0 
                        BEGIN
                            SET @sSQL = @sSQL + @ProductID + ', '  
                            FETCH NEXT FROM @cur INTO @ProductID    
                        END

                    SET @Status = 2        
                    SET @Message = N'MFML000155|'+ CASE WHEN len(@sSQL) > 180 then LEFT(@sSQL, 180) + '....' ELSE LEFT(@sSQL, len(@sSQL) - 1) END
                    
                    GOTO EndMess                    
                END
        END

    IF @MethodID = 'D03' ---- Phan bo theo dinh muc
        BEGIN
            ---Kiem tra thanh pham
            IF EXISTS ( SELECT DISTINCT ProductID 
                        FROM MT1001 INNER JOIN MT0810 ON MT0810.DivisionID = MT1001.DivisionID AND MT0810.VoucherID = MT1001.VoucherID 
                        WHERE ResultTypeID = 'R01' AND PeriodID = @PeriodID 
                            AND ProductID NOT IN (SELECT ProductID FROM MT1603 WHERE ApportionID = @ApportionID
                                                    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))))
                BEGIN
                    SET @sSQL =  'SELECT DISTINCT ProductID 
                        FROM MT1001 INNER JOIN MT0810 ON MT0810.DivisionID = MT1001.DivisionID AND MT0810.VoucherID = MT1001.VoucherID 
                        WHERE ResultTypeID = ''R01'' AND PeriodID = '''+@PeriodID+'''
                            AND ProductID NOT IN (SELECT ProductID FROM MT1603 WHERE ApportionID = '''+@ApportionID+'''
                                                    AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID('''+@DivisionID+''')))'
                                                  
                    IF EXISTS (SELECT TOP 1 1 FROM sysObjects WHERE XType = 'V' AND Name = 'MV5621')
                        DROP VIEW MV5621
                    EXEC('CREATE VIEW MV5621 ---tao boi MP5621
                        AS ' + @sSQL)
                        
                    SET @sSQL = ''
                    SET @cur = CURSOR SCROLL KEYSET FOR SELECT ProductID FROM MV5621 Order BY ProductID
                    OPEN @cur
                    FETCH NEXT FROM @cur INTO @ProductID    
                    WHILE @@FETCH_STATUS = 0 
                        BEGIN
                            SET @sSQL = @sSQL + @ProductID + ', '  
                            FETCH NEXT FROM @cur INTO @ProductID    
                        END

                    SET @Status = 2        
                    SET @Message = N'MFML000153|'+ CASE WHEN len(@sSQL) > 180 then LEFT(@sSQL, 180) + '....' ELSE LEFT(@sSQL, len(@sSQL) - 1)  END
                    GOTO EndMess
                END

            ---Kiem tra NVL
            IF EXISTS ( SELECT DISTINCT InventoryID AS ProductID  FROM MV9000 
                        WHERE ExpenseID = 'COST001' AND PeriodID = @PeriodID                         
                            AND MaterialTypeID = @MaterialTypeID AND ISNULL(InventoryID, '') <> '' 
                            AND DivisionID = @DivisionID
                            AND InventoryID NOT IN (SELECT DISTINCT MaterialID FROM MT1603 
                                                    WHERE ApportionID = @ApportionID AND MaterialID IS NOT NULL
                                                        AND DivisionID = @DivisionID)
                            AND InventoryID NOT IN (SELECT MT0007.MaterialID
															FROM MT0007
															Inner join MT1603 On MT0007.DivisionID = MT1603.DivisionID And MT0007.MaterialGroupID = MT1603.MaterialGroupID And Isnull(MT1603.IsExtraMaterial,0) = 1
															WHERE MT0007.DivisionID = @DivisionID And MT1603.ApportionID = @ApportionID AND MT1603.MaterialID IS NOT NULL
													))
                BEGIN
                    SET @sSQL = 'SELECT DISTINCT InventoryID AS ProductID  FROM MV9000 
                                WHERE ExpenseID = ''COST001'' AND PeriodID = '''+@PeriodID+'''                       
                                    AND MaterialTypeID = '''+@MaterialTypeID+''' AND ISNULL(InventoryID, '''') <> '''' 
                                    AND DivisionID = ''' + @DivisionID + '''
                                    AND InventoryID NOT IN (SELECT DISTINCT MaterialID FROM MT1603 
                                                            WHERE ApportionID = '''+@ApportionID+''' AND MaterialID IS NOT NULL
                                                                AND DivisionID = ''' + @DivisionID + ''')
                                    AND InventoryID NOT IN (SELECT MT0007.MaterialID
															FROM MT0007
															Inner join MT1603 On MT0007.DivisionID = MT1603.DivisionID And MT0007.MaterialGroupID = MT1603.MaterialGroupID And Isnull(MT1603.IsExtraMaterial,0) = 1
															WHERE MT0007.DivisionID = ''' + @DivisionID + ''' And MT1603.ApportionID = ''' + @ApportionID + ''' AND MT1603.MaterialID IS NOT NULL
															)'
                                      
                    IF EXISTS (SELECT TOP 1 1 FROM sysObjects WHERE XType = 'V' AND Name = 'MV5621')
                        DROP VIEW MV5621
                    EXEC('CREATE VIEW  MV5621 ---tao boi MP5621
                        AS ' + @sSQL)
                        
                    SET @sSQL = ''
                    SET @cur = CURSOR SCROLL KEYSET FOR SELECT ProductID FROM MV5621 Order BY ProductID
                        
                    OPEN @cur
                    FETCH NEXT FROM @cur INTO @ProductID    
                    WHILE @@FETCH_STATUS = 0 
                        BEGIN
                            SET @sSQL = @sSQL + @ProductID + ', '  
                            FETCH NEXT FROM @cur INTO @ProductID    
                        END
                    SET @Status = 2                    
                    SET @Message = N'MFML000151|'+ CASE WHEN len(@sSQL) > 180 then LEFT(@sSQL, 180) + '....' ELSE LEFT(@sSQL, len(@sSQL) - 1) END

                    GOTO EndMess 
                END    
        END    

    --IF @MethodID ='D04' ---- Phan bo theo nguyen vat lieu (khong su dung cho loai chi phi nay)
    /*
    IF @MethodID ='D05' --- Phan bo theo luong (luong phai tinh truoc)
        
    BEGIN
        IF NOT EXISTS (SELECT MT0621.ProductID FROM MT0621 Full JOIN MT2222 ON  MT0621.ProductID = MT2222.ProductID 
                      WHERE ExpenseID = 'COST002' )                            
            BEGIN

                SET @Status = 1
                SET @Message =N'S¶n phÈm nµy ch­a ph©n bæ theo l­¬ng .B¹n kh«ng thÓ ph©n bæ chi phÝ ®­îc.'
                GOTO EndMess
                --Print @MethodID
            END
    END    
*/
    IF @MethodID ='D06' --- Phan bo truc  tiep ket hop he so
        BEGIN

        IF EXISTS ( SELECT DISTINCT ProductID 
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
                IF EXISTS (SELECT TOP 1 1 FROM sysObjects WHERE XType = 'V' AND Name = 'MV5621')
                    DROP VIEW MV5621
                EXEC('CREATE VIEW  MV5621 ---tao boi MP5621
                    AS ' + @sSQL)
                    
                SET @sSQL = ''
                SET @cur = CURSOR SCROLL KEYSET FOR SELECT ProductID FROM MV5621 ORDER BY ProductID
                
                OPEN @cur
                FETCH NEXT FROM @cur INTO @ProductID    
                WHILE @@FETCH_STATUS = 0 
                    BEGIN
                        SET @sSQL = @sSQL + @ProductID + ', '  
                        FETCH NEXT FROM @cur INTO @ProductID    
                    END

                SET @Status = 2
                SET @Message = N'MFML000155|'+ CASE WHEN len(@sSQL) > 180 then LEFT(@sSQL, 180) + '....' ELSE LEFT(@sSQL, len(@sSQL) - 1) END
                GOTO EndMess                    --Print @MethodID
            END
    END


    IF @MethodID ='D07' --- Phanbo truc tiep ket hop dinh muc
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
                            WHERE ResultTypeID = ''R01'' AND PeriodID = '''+@PeriodID+'''
                                AND MT1001.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID('''+@DivisionID+'''))
                                AND ProductID NOT IN (SELECT ProductID FROM MT1603 WHERE ApportionID = '''+@ApportionID+'''
                                                        AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID('''+@DivisionID+''')))'
                IF EXISTS (SELECT TOP 1 1 FROM sysObjects WHERE XType = 'V' AND Name = 'MV5621')
                    DROP VIEW MV5621
                EXEC('CREATE VIEW  MV5621 ---tao boi MP5621
                    AS ' + @sSQL)
                SET @sSQL = ''
                SET @cur = CURSOR SCROLL KEYSET FOR SELECT ProductID FROM MV5621 Order BY ProductID
                OPEN @cur
                FETCH NEXT FROM @cur INTO @ProductID    
                WHILE @@FETCH_STATUS = 0 
                    BEGIN
                        SET @sSQL = @sSQL + @ProductID + ', '  
                        FETCH NEXT FROM @cur INTO @ProductID    
                    END
                    
                SET @Status = 2
                SET @Message = N'MFML000156|' + CASE WHEN len(@sSQL) > 180 then LEFT(@sSQL, 180) + '....' ELSE LEFT(@sSQL, len(@sSQL) - 1) END
                GOTO EndMess
            END
    END    

    FETCH NEXT FROM @Expense_621 INTO @MethodID, @CoefficientID, @ApportionID, @MaterialTypeID  
END

CLOSE @Expense_621

EndMess:

SET NOCOUNT OFF
Return @Status 
Return @Message
