IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1011]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP1011]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Insert tự động vào danh mục mã phân tích khi tạo mặt hàng là thành phẩm (TP) <Customize cho An Phú Gia>
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 11/09/2015 by Tiểu Mai
-- <Example>
---- 

--EXEC AP1011 N'AS','TP.001',N'Mặt hàng thành phẩm','ASOFTADMIN'
--select * from AT1011 where AnaTypeID = 'A02' and AnaID = 'TP.001'
-- delete At1011 where AnaTypeID = 'A02' and AnaID = 'TP.001'

CREATE PROCEDURE  [dbo].[AP1011] 
		@DivisionID nvarchar(50),
		@ProductID nvarchar(200),
		@ProductName NVARCHAR(200),
		@UserID NVARCHAR(50)
AS
DECLARE @sSQL nvarchar(4000)
SET @sSQL = ''


IF NOT EXISTS (SELECT TOP 1 1 FROM AT1011 WHERE DivisionID = @DivisionID AND AnaTypeID = 'A02' AND AnaID = @ProductID)
BEGIN 
SET @sSQL = '
INSERT INTO AT1011 (APK, DivisionID, AnaID,AnaTypeID,AnaName,Notes,CreateDate,CreateUserID,LastModifyUserID,LastModifyDate,[Disabled],
					RefDate,Amount01,Amount02,Amount03,Amount04,Amount05,Note01,Note02,Note03,Note04,Note05,
					Amount06,Amount07,Amount08,Amount09,Amount10,Note06,Note07,Note08,Note09,Note10,IsCommon,ObjectID,InventoryID)
VALUES (NEWID(), '''+@DivisionID+''', '''+@ProductID+''', ''A02'', N'''+@ProductName+''','''', getdate(),'''+@UserID+''',NULL,NULL,
0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,'''+@ProductID+''')'
END 

--PRINT @sSQL
EXEC (@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO




