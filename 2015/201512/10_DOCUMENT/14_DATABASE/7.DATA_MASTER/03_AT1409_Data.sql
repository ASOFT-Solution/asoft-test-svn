-- <Summary>
---- Them vao module commission management
-- <History>
---- Create on 17/12/2013 by Khanh Van
---- Modified on ... by ...
---- <Example> 

DECLARE @DivisionID NVarchar(50)

DECLARE cur_AllDivision CURSOR FOR
SELECT AT1101.DivisionID FROM AT1101

OPEN cur_AllDivision
FETCH NEXT FROM cur_AllDivision INTO @DivisionID

WHILE @@fetch_status = 0
  BEGIN	
		
		IF not exists (Select top 1 1 From AT1409 Where ModuleID = 'ASOFTCM' and DivisionID=@DivisionID)
		INSERT into AT1409 (DivisionID, ModuleID, Description, DescriptionE)
		(Select @DivisionID, ModuleID, Description, DescriptionE from AT1409STD where ModuleID='ASOFTCM')
	
	    FETCH NEXT FROM cur_AllDivision INTO @DivisionID
  END
  
CLOSE cur_AllDivision
DEALLOCATE cur_AllDivision