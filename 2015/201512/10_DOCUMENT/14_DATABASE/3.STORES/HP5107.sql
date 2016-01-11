IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP5107]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP5107]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
----Object:  StoredProcedure [dbo].[HP5107]    Script Date: 08/05/2010 10:04:34 ******/
----- 	Created by Dang Le Bao Quynh, Date 09/06/2004
----  	Purpose: Tao view in bao cao ket qua san xuat theo to nhom 
--- Edited by: [GS] [Minh Lâm] [02/08/2010]
--Tố Oanh: thêm trường HT2.TrackingDate [12/06/2013]
-- Bổ sung chấm theo ca
/* EXEC HP5107 4,2013,'CTY','PQS','%'
     select * from HV5107 */
     
CREATE PROCEDURE [dbo].[HP5107]
       @TranMonth int ,
       @TranYear int ,
       @DivisionID nvarchar(50) ,
       @DepartmentID nvarchar(50) ,
       @TeamID nvarchar(50)
AS
DECLARE @sSQL nvarchar(4000)
IF EXISTS ( SELECT id
            FROM  sysobjects
            WHERE id = object_id('HV5107') AND xtype = 'V' )
   BEGIN
         DROP VIEW HV5107
   END

   
IF EXISTS
(SELECT TOP 1 1 FROM HT0289  WHERE DivisionID = @DivisionID AND TranMonth=@TranMonth AND TranYear=@TranYear AND DepartmentID like @DepartmentID
 AND TeamID like isnull(@TeamID,''))
 OR EXISTS
 (SELECT TOP 1 1 FROM HT0287 WHERE DivisionID = @DivisionID AND TranMonth=@TranMonth AND TranYear=@TranYear AND DepartmentID like @DepartmentID
 AND TeamID like isnull(@TeamID,''))
SET @sSQL = 'CREATE VIEW HV5107 --Tao boi HP5107
AS
SELECT TOP 100 PERCENT HT2.DivisionID, HT2.DepartmentID,AT1.DepartmentName,HT2.TeamID,HT11.TeamName,
HT10.ProductID,HT10.ProductName,HT2.Quantity ,HT10.UnitPrice,HT2.Quantity*HT10.UnitPrice as Amount, HT2.TrackingDate 
FROM HT0289 HT2 
INNER JOIN HT1015 HT10 ON HT2.ProductID=HT10.ProductID AND HT2.DivisionID=HT10.DivisionID
INNER JOIN AT1102 AT1 ON HT2.DepartmentID=AT1.DepartmentID And HT2.DivisionID=AT1.DivisionID
INNER JOIN HT1101 HT11 ON HT2.TeamID=HT11.TeamID  And HT2.DivisionID=HT11.DivisionID 
WHERE TranMonth=' + ltrim(@TranMonth) + ' and TranYear=' + ltrim(@TranYear) + ' and HT2.DivisionID=''' + @DivisionID + ''' and HT2.DepartmentID like ''' + @DepartmentID + ''' and HT2.TeamID like ''' + @TeamID + ''' ORDER BY AT1.DepartmentID,HT11.TeamID,HT10.ProductID
UNION ALL
SELECT TOP 100 PERCENT HT2.DivisionID, HT2.DepartmentID,AT1.DepartmentName,HT2.TeamID,HT11.TeamName,
HT10.ProductID,HT10.ProductName,HT2.Quantity ,HT10.UnitPrice,HT2.Quantity*HT10.UnitPrice as Amount, HT2.TrackingDate 
FROM HT0287 HT2 
INNER JOIN HT1015 HT10 ON HT2.ProductID=HT10.ProductID AND HT2.DivisionID=HT10.DivisionID
INNER JOIN AT1102 AT1 ON HT2.DepartmentID=AT1.DepartmentID And HT2.DivisionID=AT1.DivisionID
INNER JOIN HT1101 HT11 ON HT2.TeamID=HT11.TeamID  And HT2.DivisionID=HT11.DivisionID 
WHERE TranMonth=' + ltrim(@TranMonth) + ' and TranYear=' + ltrim(@TranYear) + ' and HT2.DivisionID=''' + @DivisionID + ''' and HT2.DepartmentID like ''' + @DepartmentID + ''' and HT2.TeamID like ''' + @TeamID + ''' ORDER BY AT1.DepartmentID,HT11.TeamID,HT10.ProductID
'                            
ELSE SET @sSQL = 'CREATE VIEW HV5107 --Tao boi HP5107
AS
SELECT TOP 100 PERCENT HT2.DivisionID, HT2.DepartmentID,AT1.DepartmentName,HT2.TeamID,HT11.TeamName,
HT10.ProductID,HT10.ProductName,HT2.Quantity ,HT10.UnitPrice,HT2.Quantity*HT10.UnitPrice as Amount, HT2.TrackingDate 
FROM HT2413 HT2 
INNER JOIN HT1015 HT10 ON HT2.ProductID=HT10.ProductID AND HT2.DivisionID=HT10.DivisionID
INNER JOIN AT1102 AT1 ON HT2.DepartmentID=AT1.DepartmentID And HT2.DivisionID=AT1.DivisionID
INNER JOIN HT1101 HT11 ON HT2.TeamID=HT11.TeamID  And HT2.DivisionID=HT11.DivisionID 
WHERE TranMonth=' + ltrim(@TranMonth) + ' and TranYear=' + ltrim(@TranYear) + ' and HT2.DivisionID=''' + @DivisionID + ''' and HT2.DepartmentID like ''' + @DepartmentID + ''' and HT2.TeamID like ''' + @TeamID + ''' ORDER BY AT1.DepartmentID,HT11.TeamID,HT10.ProductID'

EXEC (@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON