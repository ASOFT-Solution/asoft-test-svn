
/****** Object:  StoredProcedure [dbo].[AP7612]    Script Date: 07/29/2010 11:38:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP7612]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP7612]
GO

/****** Object:  StoredProcedure [dbo].[AP7612]    Script Date: 07/29/2010 11:38:34 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER ON
GO


----- Created by Nguyen Van Nhan.
---- Created Date 03/03/2006

/**********************************************
** Edited by: [GS] [Cẩm Loan] [30/07/2010]
***********************************************/

CREATE PROCEDURE [dbo].[AP7612]
			@DivisionID as nvarchar(50), 
			@FromMonth as int, 
			@FromYear as int, 
			@ToMonth as int , 
			@ToYear as int ,
			@FromDate as datetime,
			@ToDate as datetime,
			@ReportCode  nvarchar(50), 
			@IsDate as tinyint, --(=0 n?u theo k?, 1 n?u thao ngày)
			@Type as tinyint, ---- (0, 1, 2 ?ng v?i các option Lo?i báo cáo”)
			@TDescription as nvarchar(250) = ''

AS
Declare @sSQL as nvarchar(4000)
If @Type = 0 
	Exec AP7609 @DivisionID, @FromDate, @ToDate, @ReportCode, @TDescription
Else
If @Type = 1
	Exec AP7611  @DivisionID,@FromMonth ,@FromYear, @ToMonth,@ToYear, @FromDate,@ToDate, @IsDate
Else

Begin
---set @sSQL=''

	set @sSQL ='	Select AT7613.DivisionID, BookNo, BookDate, AT7613.ConvertedAmount
			From AT7613 left join AT7611 on AT7611.ReportCode = AT7613.ReportCode and AT7611.DivisionID = AT7613.DivisionID
			Where (AT7611.TranMonth+AT7611.TranYear*100 between '+str(@FromMonth)+' + 100*'+str(@FromYear)+' and '+str(@ToMonth)+' + 100*'+str(@ToYear)+' ) and 
				At7611.DivisionID ='''+@DivisionID+'''  and AT7613.Orders = 1'
		If not exists (Select name from sysobjects Where id = Object_id(N'[dbo].[AV7612]') and OBJECTPROPERTY(id, N'IsView') = 1)
		   Exec ('  Create View AV7612 		   -- tao boi AP7612
							as ' + @sSQL)
		Else
		 Exec ('  Alter View AV7612    -- tao boi AP7612
							As ' + @sSQL)

	print @sSQL

End
GO

