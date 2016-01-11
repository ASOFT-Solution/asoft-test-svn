IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP03371]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP03371]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- <Summary>

---- Create on 10/12/2013 by Khanh Van
CREATE PROCEDURE [dbo].[HP03371]
( 
	@DivisionID as nvarchar(50),
	@MethodID as nvarchar(50)
) 
AS 

If ISNULL(@MethodID,'')=''
Begin
	Select DivisionID, IncomeID, IncomeName, IncomeNameE, 0 as IsUsed, 1 as Coefficient
	From(
	Select DivisionID,IncomeID,Caption as IncomeName,CaptionE as IncomeNameE
	From HT0002
	Where DivisionID=@DivisionID and IsUsed = 1
	Union 
	Select DivisionID, SubID as IncomeID, Caption as IncomeName ,CaptionE as IncomeNameE
	From HT0005
	Where DivisionID=@DivisionID and IsUsed = 1
	)A

End
Else
Begin
	Select HT0336.DivisionID, HT0336.MethodID, HT0336.TaxStepID, (Select top 1 Description from HT0332 where DivisionID = HT0336.DivisionID and TaxStepID=HT0336.TaxStepID) as TaxStepName, Description, Disabled, HT0337.InComeID, (Case when HT0337.InComeID like 'I%' then (Select Caption from HT0002 where DivisionID=HT0336.DivisionID and IncomeID=HT0337.InComeID) else (Select Caption from HT0005 where DivisionID=HT0336.DivisionID and SubID=HT0337.InComeID) end )as IncomeName, (Case when HT0337.InComeID like 'I%' then (Select CaptionE from HT0002 where DivisionID=HT0336.DivisionID and IncomeID=HT0337.InComeID) else (Select CaptionE from HT0005 where DivisionID=HT0336.DivisionID and SubID=HT0337.InComeID) end )as IncomeNameE, HT0337.IsUsed, HT0336.UnitAmount, HT0337.Coefficient
From HT0336 inner join HT0337 on HT0336.DivisionID = HT0337.DivisionID	and HT0336.MethodID = HT0337.MethodID
Where HT0336.DivisionID = @DivisionID and HT0336.MethodID = @MethodID
End

GO

-- Exec HP03371 'TH', ''