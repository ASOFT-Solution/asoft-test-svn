IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP9090]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP9090]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- Created by: Bảo Anh, date:  21/07/2014
--- In báo cáo ngân sách chỉ tiêu trong tháng/quý/năm
--- AP9090 'AS',5,2012,'M'

CREATE PROCEDURE [dbo].[AP9090] 
				@DivisionID nvarchar(50),
				@TranMonth int,
				@TranYear int,
				@BudgetType nvarchar(100)
					
AS

DECLARE @sSQL nvarchar(max)
		
		
Set @sSQL = '
Select 	T90.*, AT1202.ObjectName, (case when Isnull(DebitAccountID,'''') = '''' then ''S'' else ''C'' end) as TypeID
From AT9090 T90
		left join AT1202 on T90.DivisionID = AT1202.DivisionID and T90.ObjectID = AT1202.ObjectID
		
Where T90.DivisionID = ''' + @DivisionID + ''' and T90.BudgetType = ''' + @BudgetType + ''''

IF @BudgetType = 'Y'
	Set @sSQL = @sSQL + ' and T90.TranYear = ' + CONVERT(nvarchar(4),@TranYear)
ELSE
	Set @sSQL = @sSQL + ' and T90.TranMonth = ' + CONVERT(nvarchar(2),@TranMonth) + ' and T90.TranYear = ' + CONVERT(nvarchar(4),@TranYear)
	
EXEC(@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON