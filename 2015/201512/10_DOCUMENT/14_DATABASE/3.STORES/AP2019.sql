/****** Object:  StoredProcedure [dbo].[AP2019]    Script Date: 08/05/2010 09:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

----- Create by Nguyen Van Nhan.
----- Date 25/05/2003.
----- Muc dich: In phieu chao gia

/********************************************
'* Edited by: [GS] [Minh Lâm] [28/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP2019]
       @DivisionID nvarchar(50) ,
       @QuotationID AS nvarchar(50)
AS
DECLARE @sSQL AS nvarchar(4000)

SET @sSQL = '
Select 	AT2010.DivisionID,
	Orders,
	TransactionID,
	AT2010.InventoryID,
	AT1302.InventoryName,
	UnitPrice,
	Quantity, 
	OriginalAmount,
	Attention1,
	Attention2,
	Condition,
	QuotationDate,
	Dear,
	RefNo1,
	RefNo2,
	RefNo3
From AT2010 	inner join AT1302 on AT1302.InventoryID = AT2010.InventoryID
		right join AV2009 on AV2009.QuotationID = AT2010.QuotationID
Where 	AV2009.QuotationID =''' + @QuotationID + ''' and
	AV2009.DivisionID =''' + @DivisionID + '''  '


IF NOT EXISTS ( SELECT
                    1
                FROM
                    sysObjects
                WHERE
                    Name = 'AV2019' )
   BEGIN
         EXEC ( 'Create view Av2019 as '+@sSQL )
   END
ELSE
   BEGIN
         EXEC ( 'Alter view Av2019 as '+@sSQL )


--select * From AV2009

   END