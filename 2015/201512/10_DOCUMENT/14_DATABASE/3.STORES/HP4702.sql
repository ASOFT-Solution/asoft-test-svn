
/****** Object:  StoredProcedure [dbo].[HP4702]    Script Date: 07/30/2010 11:49:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP4702]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP4702]
GO

/****** Object:  StoredProcedure [dbo].[HP4702]    Script Date: 07/30/2010 11:49:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


-----Created date: 21/09/2005
-----purpose: Tinh tong luong phuc vu cho HP7007

/**********************************************
** Edited by: [GS] [Cẩm Loan] [02/08/2010]
***********************************************/

CREATE PROCEDURE [dbo].[HP4702] @Signs as nvarchar(50),	-----dau+,-,*,/
				@IsSerie as tinyint,	------tinh lien tuc hay cach quang
				@FromColumn as int,	------tu cot 
				@ToColumn as int,	-----den cot
				@sColumn as nvarchar(4000) OutPut, -------tra ra ket qua
				@ColumnID as int -------dang tinh cho cot thu k trong HT4712, neu cach tinh la lien tuc tu cot i den cot j, 
							----neu tu cot i den cot j co chua cot k la ColumnID thi loai cot k ra
			
AS
Declare @str nvarchar(4000), 
	@count as int	


Set @str=''
If @IsSerie=1 
	Begin
		If @FromColumn< @ToColumn
			Begin
				Set @count=@FromColumn
				Set @str='Isnull(ColumnAmount'+(Case when @count <10 then '0' else '' End)+ltrim(rtrim(str(@count))) + ',0)'	
				While @count < @ToColumn
					Begin
					Set @count=@count+1	
					If @count <> @ColumnID
						Set @str=@str+ @Signs+ 'Isnull(ColumnAmount' +(Case when @count <10 then '0' else '' End)+ltrim(rtrim(str(@count)))	 + ',0)'	
					End
			
			End
		Else
			Begin
			Set @count=@ToColumn
				Set @str='Isnull(ColumnAmount'+(Case when @count <10 then '0' else '' End)+ltrim(rtrim(str(@count))) + ',0)'
				While @count < @FromColumn
					Begin
					Set @count=@count+1	
					If @count <> @ColumnID
					Set @str=@str+ @Signs +'Isnull(ColumnAmount' +(Case when @count <10 then '0' else '' End)+ltrim(rtrim(str(@count)))	 + ',0)'	
					End
			End

		SELECT  @sColumn=@str
		RETURN
	End

Else ----tinh cach quang

Begin

set @str=@str+ 'Isnull(ColumnAmount'+(Case when @FromColumn <10 then '0' else '' End)+ltrim(rtrim(str(@FromColumn))) + ',0)' + @Signs +
		'Isnull(ColumnAmount'+(Case when @ToColumn <10 then '0' else '' End)+ltrim(rtrim(str(@ToColumn))) + ',0)'
		
Select  @sColumn=@str
Return
End

GO

