/****** Object:  StoredProcedure [dbo].[AP7710]    Script Date: 08/05/2010 09:46:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/********************************************
'* Edited by: [GS] [Minh Lâm] [02/08/2010]
'********************************************/
----- Created by Nguyen Van Nhan.
----- Created Date 19/03/2005
----- Purpose: To define the Column Name

ALTER PROCEDURE [dbo].[AP7710]
       @ColumnTypeID AS varchar(20) ,
       @ColumnName AS varchar(20) OUTPUT
AS
IF @ColumnTypeID = 'IN'
   BEGIN
         SET @ColumnName = 'InventoryID'
   END
ELSE
   BEGIN
         IF LEFT(@ColumnTypeID , 2) = 'CI'
            BEGIN
                  SET @ColumnName = 'CI' + RIGHT(@ColumnTypeID , 1) + 'ID'
            END
         ELSE
            BEGIN
                  IF LEFT(@ColumnTypeID , 2) = 'I0'
                     BEGIN
                           SET @ColumnName = 'I0' + RIGHT(@ColumnTypeID , 1) + 'ID'
                     END
                  ELSE
                     BEGIN
                           IF LEFT(@ColumnTypeID , 2) = 'WA'
                              BEGIN
                                    SET @ColumnName = 'WareHouseID'
                              END
                           ELSE
                              BEGIN
                                    IF LEFT(@ColumnTypeID , 2) = 'MO'
                                       BEGIN
                                             SET @ColumnName = 'MonthYear'
                                       END
                                    ELSE
                                       BEGIN
                                             IF LEFT(@ColumnTypeID , 2) = 'QU'
                                                BEGIN
                                                      SET @ColumnName = 'Quarter'
                                                END
                                             ELSE
                                                BEGIN
                                                      IF LEFT(@ColumnTypeID , 2) = 'YE'
                                                         BEGIN
                                                               SET @ColumnName = 'Year'
                                                         END
                                                END
                                       END
                              END
                     END
            END
   END

---Add by Quoc Huy
IF LEFT(@ColumnTypeID , 2) = 'VD'  ---- VoucherDate
   BEGIN
         SELECT
             @ColumnName = 'VoucherDate'
         RETURN
   END

IF LEFT(@ColumnTypeID , 2) = 'OB'  ---- ObjectID
   BEGIN
         SELECT
             @ColumnName = 'ObjectID'
         RETURN
   END

IF LEFT(@ColumnTypeID , 2) = 'A0'		---- Ma phan tich
   BEGIN
         SELECT
             @ColumnName = 'Ana' + RIGHT(@ColumnTypeID , 2) + 'ID'
         RETURN
   END

--End by Quoc Huy