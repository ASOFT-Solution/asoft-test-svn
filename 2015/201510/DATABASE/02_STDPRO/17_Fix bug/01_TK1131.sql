declare @bacTKMe int

if exists (select top 1 1 from DMTK where TK = '1131')
BEGIN
	if exists (select top 1 1 from DMTK where TK = '113')	
	BEGIN
		select @bacTKMe = GradeTK from DMTK where TK = '113'
		
		Update DMTK set TKMe = '113', GradeTK = @bacTKMe + 1
		where TK = '1131' and TKMe is null
	END
END