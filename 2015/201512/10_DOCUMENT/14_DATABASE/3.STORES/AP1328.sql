
/****** Object: StoredProcedure [dbo].[AP1328] Script Date: 07/29/2010 09:45:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

---- CREATE by Nguyen Quoc Huy, Date 10/06/2009
---- Purpose: Tra ra mat hang va so luong khuyen mai.

/********************************************
'* Edited by: [GS] [Việt Khánh] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP1328] 
    @DivisionID NVARCHAR(50), 
    @InventoryID NVARCHAR(50), 
    @Quantity DECIMAL
AS

DECLARE @sSQl NVARCHAR(4000)

SET @sSQl = '
    SELECT PromoteInventoryID AS InventoryID, 
        PromoteQuantity AS Quantity 
    FROM AT1328 
    WHERE InventoryID = ''' + @InventoryID + '''
        AND DivisionID = ''' + @DivisionID + '''
        AND ' + STR(@Quantity) + ' BETWEEN FromQuantity AND ToQuantity
    ' 
--PRINT @sSQl

EXEC (@sSQl)