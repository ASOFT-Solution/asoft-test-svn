IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7622]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP7622]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

------------------- Created by Dang Le Bao Quynh.
------------------ Created Date 18/10/2006
----------------- Purpose: In bao cao bang ket qua kinh doanh. theo ngan sach
----- Modified on 06/11/2012 by Lê Thị Thu Hiền : Bổ sung in nhiều đơn vị
----- Modified on 22/07/2014 by Bảo Anh : Truyền thêm @FilterMaster và @AnaIDMaster để in theo 1 MPT (ví dụ in KQKD theo ngân sách của 1 bộ phận)

CREATE PROCEDURE [dbo].[AP7622]
       @DivisionID nvarchar(50) ,
       @PeriodID nvarchar(50) ,
       @CaculatorID nvarchar(50) ,
       @FromAccountID nvarchar(50) ,
       @ToAccountID nvarchar(50) ,
       @FromCorAccountID nvarchar(50) ,
       @ToCorAccountID nvarchar(50) ,
       @FilterMaster nvarchar(50),
       @AnaIDMaster nvarchar(50),
       @AnaTypeID nvarchar(50) ,
       @FromAnaID nvarchar(50) ,
       @ToAnaID nvarchar(50) ,
       @BudgetID AS nvarchar(50) ,
       @Amount decimal(28,8) OUTPUT,
       @StrDivisionID AS NVARCHAR(4000) = ''
AS
DECLARE
        @AnaID AS nvarchar(50) ,
        @sSQL AS nvarchar(4000)

DECLARE @StrDivisionID_New AS NVARCHAR(4000)
SELECT @StrDivisionID_New = CASE WHEN @StrDivisionID = '%' THEN ' LIKE ''' + 
@StrDivisionID + '''' ELSE ' IN (''' + REPLACE(@StrDivisionID, ',',''',''') + ''')' END

--Kiem tra tinh hop le cua du lieu truyen vao

--Kiem tra Tai khoan
IF ( @ToAccountID IS NULL ) OR ( @ToAccountID = '' )
   BEGIN
         SET @ToAccountID = @FromAccountID
   END

--Kiem tra TK doi ung
IF @FromCorAccountID IS NULL OR @FromCorAccountID = ''
   BEGIN
         SET @FromCorAccountID = NULL
         SET @ToCorAccountID = NULL
   END
ELSE
   BEGIN
         IF @ToCorAccountID IS NULL OR @ToCorAccountID = ''
            BEGIN
                  SET @ToCorAccountID = @FromCorAccountID
            END
   END

--Kiem tra ma phan tich

IF ( @AnaTypeID IS NOT NULL ) AND ( @AnaTypeID <> '' )
   BEGIN
         EXEC AP4702 @AnaTypeID , @AnaID OUTPUT

         IF @FromAnaID IS NULL OR @FromAnaID = ''
            BEGIN
                  SET @FromAnaID = NULL
            END
         ELSE
            BEGIN
                  IF @ToAnaID IS NULL OR @ToAnaID = ''
                     BEGIN
                           SET @ToAnaID = @FromAnaID
                     END
            END

   END
ELSE
   BEGIN
         SET @AnaTypeID = NULL
         SET @FromAnaID = NULL
   END


IF ( @FromAccountID IS NOT NULL ) AND ( @FromAccountID <> '' )
   BEGIN
	
		--If @CaculatorID ='PA'
		--	Begin
		--		print 'pa'
		--	End

         IF @CaculatorID = 'PD'
            BEGIN
                  IF @BudgetID <> 'M'
                     BEGIN
                           SET @sSQL = 'SELECT	Sum(isnull(SignAmount,0)) as SignAmount  
                                        FROM	AV9997 
                                        WHERE	' + 'PeriodID = ''' + @PeriodID + ''' 
												AND ' + 'AccountID Between ''' + @FromAccountID + ''' AND ''' + @ToAccountID + '''
												AND DivisionID '+@StrDivisionID_New+'' 
							          	
						--Neu co tinh tai khoan doi ung
                           IF @FromCorAccountID IS NOT NULL
                              BEGIN
                                    SET @sSQL = @sSQL + ' AND CorAccountID between ''' + @FromCorAccountID + ''' AND ''' + @ToCorAccountID + ''''
                              END
						--Neu co tinh ma phan tich theo từng dòng chi tiết được thiết lập
                           IF ( @AnaTypeID IS NOT NULL ) AND ( @FromAnaID IS NOT NULL )
                              BEGIN
                                    SET @sSQL = @sSQL + ' AND ' + @AnaID + ' between ''' + @FromAnaID + ''' AND ''' + @ToAnaID + ''''
                              END
						--- Lọc thêm MPT master
							IF Isnull(@FilterMaster,'') <> '' AND Isnull(@AnaIDMaster,'') <> ''
                              BEGIN
                                    SET @sSQL = @sSQL + ' AND ' + @FilterMaster + ' = ''' + @AnaIDMaster + ''''
                              END
                              
                           SET @sSQL = @sSQL + ' AND  BudgetID=''' + @BudgetID + ''' AND  SignAmount>=0'

                     END
                  ELSE
                     BEGIN
                           SET @sSQL = 'SELECT	SUM(ISNULL(SignAmount,0)) as SignAmount  
                                        FROM	AV9997 
                                        WHERE	' + 'PeriodID = ''' + @PeriodID + ''' 
												AND ' + 'AccountID Between ''' + @FromAccountID + ''' AND ''' + @ToAccountID + '''
												AND DivisionID '+@StrDivisionID_New+'' 
							          	
						--Neu co tinh ma phan tich theo từng dòng chi tiết được thiết lập
                           IF ( @AnaTypeID IS NOT NULL ) AND ( @FromAnaID IS NOT NULL )
                              BEGIN
                                    SET @sSQL = @sSQL + ' AND ' + @AnaID + ' between ''' + @FromAnaID + ''' AND ''' + @ToAnaID + ''''
                              END

						--- Lọc thêm MPT master
							IF Isnull(@FilterMaster,'') <> '' AND Isnull(@AnaIDMaster,'') <> ''
                              BEGIN
                                    SET @sSQL = @sSQL + ' AND ' + @FilterMaster + ' = ''' + @AnaIDMaster + ''''
                              END
                              
                           SET @sSQL = @sSQL + ' AND  BudgetID = ''M'' AND  SignAmount >= 0'
                     END

            END

         IF @CaculatorID = 'PC'
            BEGIN
                  IF @BudgetID <> 'M'
                     BEGIN
                           SET @sSQL = 'SELECT	SUM(ISNULL(-SignAmount,0)) as SignAmount  
                                        FROM	AV9997 
                                        WHERE	' + 'PeriodID = ''' + @PeriodID + ''' 
												AND ' + 'AccountID Between ''' + @FromAccountID + ''' AND ''' + @ToAccountID + '''
												AND DivisionID '+@StrDivisionID_New+'' 
							          	
						--Neu co tinh tai khoan doi ung
                           IF @FromCorAccountID IS NOT NULL
                              BEGIN
                                    SET @sSQL = @sSQL + ' AND CorAccountID between ''' + @FromCorAccountID + ''' AND ''' + @ToCorAccountID + ''''
                              END
						--Neu co tinh ma phan tich theo từng dòng chi tiết được thiết lập
                           IF ( @AnaTypeID IS NOT NULL ) AND ( @FromAnaID IS NOT NULL )
                              BEGIN
                                    SET @sSQL = @sSQL + ' AND ' + @AnaID + ' between ''' + @FromAnaID + ''' AND ''' + @ToAnaID + ''''
                              END

						--- Lọc thêm MPT master
							IF Isnull(@FilterMaster,'') <> '' AND Isnull(@AnaIDMaster,'') <> ''
                              BEGIN
                                    SET @sSQL = @sSQL + ' AND ' + @FilterMaster + ' = ''' + @AnaIDMaster + ''''
                              END
                              
                           SET @sSQL = @sSQL + ' AND  BudgetID=''' + @BudgetID + ''' AND  SignAmount<0'

                     END
                  ELSE
                     BEGIN
                           SET @sSQL = 'SELECT	SUM(ISNULL(-SignAmount,0)) as SignAmount 
                                        FROM	AV9997 
                                        WHERE	' + 'PeriodID = ''' + @PeriodID + ''' 
												AND ' + 'AccountID Between ''' + @FromAccountID + ''' AND ''' + @ToAccountID + '''
												AND DivisionID '+@StrDivisionID_New+'' 
							          	
						--Neu co tinh ma phan tich theo từng dòng chi tiết được thiết lập
                           IF ( @AnaTypeID IS NOT NULL ) AND ( @FromAnaID IS NOT NULL )
                              BEGIN
                                    SET @sSQL = @sSQL + ' AND ' + @AnaID + ' between ''' + @FromAnaID + ''' AND ''' + @ToAnaID + ''''
                              END

						--- Lọc thêm MPT master
							IF Isnull(@FilterMaster,'') <> '' AND Isnull(@AnaIDMaster,'') <> ''
                              BEGIN
                                    SET @sSQL = @sSQL + ' AND ' + @FilterMaster + ' = ''' + @AnaIDMaster + ''''
                              END
                              
                           SET @sSQL = @sSQL + ' AND  BudgetID=''M'' AND  SignAmount<0'
                     END
            END

         IF len(@sSQL) > 0
            BEGIN
				--Create View de lay so lieu
                  IF NOT EXISTS ( SELECT
                                      1
                                  FROM
                                      sysobjects
                                  WHERE
                                      Name = 'AV9091' AND Xtype = 'V' )
                     BEGIN
                           EXEC ( '  CREATE VIEW AV9091 AS '+@sSQL )
                     END
                  ELSE
                     BEGIN
                           EXEC ( '  ALTER VIEW AV9091  AS '+@sSQL )
                     END

                  IF EXISTS ( SELECT
                                  1
                              FROM
                                  sysobjects
                              WHERE
                                  Name = 'AV9091' AND Xtype = 'V' )
                     BEGIN
                           SELECT
                               *
                           INTO
                               #AV9091
                           FROM
                               AV9091
                           SET @Amount = ( SELECT
                                     SignAmount
                                           FROM
                                               #AV9091 )
                           DROP TABLE #AV9091
                     END
            END

   END
ELSE
   BEGIN
         SET @Amount = 0
   END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
