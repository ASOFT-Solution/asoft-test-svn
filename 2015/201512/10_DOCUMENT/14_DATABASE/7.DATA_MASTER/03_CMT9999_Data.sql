-- <Summary>
---- 
-- <History>
---- Create on 26/12/2014 by Khánh Vân
---- Modified on ... by 
-- <Example>
DECLARE @DivisionID NVarchar(50)

DECLARE cur_AllDivision CURSOR FOR
SELECT AT1101.DivisionID FROM AT1101

OPEN cur_AllDivision
FETCH NEXT FROM cur_AllDivision INTO @DivisionID

WHILE @@fetch_status = 0
  BEGIN
	
	If exists(Select Top 1 1 From sysObjects Where XType = 'U' and Name = 'CMT0000')
	Begin
		If not Exists (Select 1 From CMT0000 where DefDivisionID = @DivisionID)
		Insert  CMT0000  (DefDivisionID, DefTranMonth, DefTranYear)
		Select DivisionID, BeginMonth, BeginYear
		From AT1101 where DivisionID=@DivisionID
	End
	If exists(Select Top 1 1 From sysObjects Where XType = 'U' and Name = 'CMT0000')
	Begin
		If not Exists (Select 1 From CMT9999 where DivisionID = @DivisionID)
		Insert  CMT9999  (DivisionID, TranMonth, TranYear, Disabled,  BeginDate, EndDate )
		Select DivisionID, BeginMonth, BeginYear, 0, ltrim(rtrim(str(BeginMonth)))+'/01/'+ltrim(rtrim(str(BeginYear))) , DATEADD(day, -1, DATEADD(MONTH, 1, ltrim(rtrim(str(BeginMonth))) + '/01/' + ltrim(rtrim(str(BeginYear)))))
		From AT1101 where DivisionID=@DivisionID
	End
	
    FETCH NEXT FROM cur_AllDivision INTO @DivisionID
  END
  
CLOSE cur_AllDivision
DEALLOCATE cur_AllDivision

