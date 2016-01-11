IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP1202]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP1202]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load combobox ObjectID cho màn hình OF0031 - Lập đơn hàng bán[Customize LAVO]
-- <History>
---- Create on 11/12/2014 by Lê Thị Hạnh 
---- Modified on ... by 
-- <Example>
/*
OP1202 @DivisionID = 'CTY', @UserID = 'ASOFTADMIN', @IsObject = 1,
       @RouteID = '01', @OrderID = NULL, @ConditionOB=N'('''')',@IsUsedConditionOB=N'(0=0)'
 */

CREATE PROCEDURE [dbo].[OP1202] 	
	@DivisionID NVARCHAR(50),
	@UserID NVARCHAR(50),
	@IsObject BIT, --1: search theo đối tượng
	@RouteID NVARCHAR(50), -- Truyền RouteID nếu IsObject = 0
	@OrderID NVARCHAR(50), -- SOrderID của đơn hàng bán
	@ConditionOB NVARCHAR(MAX), -- phân quyền đối tượng
	@IsUsedConditionOB NVARCHAR(50)
	
AS
DECLARE @sSQL1 NVARCHAR(MAX),
        @sWHERE NVARCHAR(MAX),
        @IsPermissionView TINYINT,
        @sFROM NVARCHAR(MAX)
		
SET @IsPermissionView = (SELECT TOP 1 ISNULL(IsPermissionView,0) FROM OT0001 WHERE DivisionID = @DivisionID)
SET @sFROM = ''
SET @sWHERE = ''
IF @IsPermissionView = 1 
BEGIN
	SET @sFROM = @sFROM + '
INNER JOIN AT0010 AT10 ON AT10.DivisionID = AT02.DivisionID AND AT10.AdminUserID = '''+@UserID+''' AND AT10.UserID = AT02.CreateUserID '
	SET @sWHERE = @sWHERE + ''
END
IF LTRIM(STR(@IsObject)) = 0
BEGIN
	SET @sFROM = @sFROM + '
LEFT JOIN AT0047 AT47 ON AT47.DivisionID = AT02.DivisionID AND AT47.ObjectID = AT02.ObjectID '
	SET @sWHERE = @sWHERE + '
	  AND AT47.StationID IN (SELECT AT36.StationID 
							  FROM AT0136 AT36 
							  WHERE AT36.DivisionID = '''+@DivisionID+''' AND AT36.RouteID = '''+@RouteID+''')'
END

SET @sSQL1 = '
SELECT DISTINCT AT02.*, AT08.DueType
FROM AT1202 AT02
LEFT JOIN AT1208 AT08 ON AT08.DivisionID = AT02.DivisionID AND AT08.PaymentTermID = AT02.RePaymentTermID '+@sFROM+'
WHERE AT02.DivisionID = '''+@DivisionID+''' AND (AT02.IsCustomer = 1 OR AT02.IsUpdateName = 1) AND AT02.[Disabled] = 0
	  AND (ISNULL(AT02.ObjectID, ''#'') IN ('+@ConditionOB+') OR '+@IsUsedConditionOB+') '+@sWHERE+'
ORDER BY AT02.ObjectID
'
EXEC (@sSQL1)
PRINT (@sSQL1)


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
