/****** Object:  StoredProcedure [dbo].[AP7804]    Script Date: 08/05/2010 09:52:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

-- Created by Nguyen Thi ThuyTuyen, Date 21/07/2006
----- Purpose: Lay du lieu in bao cao he so phan bo.

/********************************************
'* Edited by: [GS] [Minh Lâm] [29/07/2010]
'********************************************/


ALTER PROCEDURE [dbo].[AP7804] ---	@DivisionID as nvarchar(20),
       @CoefficientID AS nvarchar(50)
AS
DECLARE @sSQL AS nvarchar(4000)
SET @sSQL = ' Select AT7804.DivisionID, DetailID, AT7803.CoefficientID,
	Description,
	AT7804.AnaID,
	AnaName,
	Covalues,
	AT7804.Notes
From AT7804 inner join AT7803 on  AT7803.CoefficientID = AT7804.CoefficientID and AT7803.DivisionID = AT7804.DivisionID
	    inner Join AT1011 on AT1011.AnaID = AT7804.AnaID and AT1011.DivisionID = AT7804.DivisionID
Where AT7803.CoefficientID = N''' + @CoefficientID + '''  AND AnaTypeID =''A01''
                          '
---Print @sSQL 

IF NOT EXISTS ( SELECT
                    1
                FROM
                    sysObjects
                WHERE
                    Xtype = 'V' AND Name = 'AV7804' )
   BEGIN
         EXEC ( ' Create view AV7804 as '+@sSQL ) ----tao boi AP7804----

   END
ELSE
   BEGIN
         EXEC ( ' Alter view AV7804 as '+@sSQL ) ----tao boi AP7804----
   END