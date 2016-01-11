
/****** Object:  StoredProcedure [dbo].[HP2223]    Script Date: 12/27/2011 12:05:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2223]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2223]
GO



/****** Object:  StoredProcedure [dbo].[HP2223]    Script Date: 12/27/2011 12:05:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



-----Created by: Vo Thanh Huong
-----Created date: 16/07/2004
-----purpose: In bao cao Bang doi chieu  so lieu nop BHXH, BHYT

CREATE PROCEDURE [dbo].[HP2223]  @DivisionID nvarchar(50),
				@TranQuater int,
				@TranYear int
AS

DECLARE @sSQL as nvarchar(4000)

SET @sSQL =  ' INSERT HT2227(DivisionID, Status, TranQuater, TranYear, TranMonth, Orders,					
			Amount1, Amount2, Amount3, Description, Bold)
		  Select DivisionID, 0 as Status, TranQuater, TranYear, TranMonth, TranMonth  as Orders,
				 Amount1, Amount2, Amount3,Description, 0 as Bold
			From HT2224 
			Where DivisionID = ''' + @DivisionID + ''' and TranQuater = ' + STR(@TranQuater)   + ' and TranYear = ' + STR(@TranYear) + '
		Union 
			Select ''' + @DivisionID  + ''' as DivisionID, 1 as Status, ' + STR(@TranQuater) + '  as TranQuater, ' + STR(@TranYear) + '  as TranYear, 0 as TranMonth, 0 as Orders,
				 0 as Amount1, 0 as Amount2, 0 as Amount3, ''' + '''  as Description, 0 as Bold
  		Union 
			Select ''' + @DivisionID  + ''' as DivisionID, 2 as Status, TranQuater, TranYear, 0 as TranMonth, Orders,
				 Amount1, Amount2, 0 as Amount2, Description, Bold
			From HT2226 
			Where DivisionID = ''' + @DivisionID + ''' and TranQuater = ' + STR(@TranQuater)   + ' and TranYear = ' + STR(@TranYear) + '
			Order by Status, TranMonth, Orders'

DELETE HT2227 
EXEC( @sSQL)




GO


