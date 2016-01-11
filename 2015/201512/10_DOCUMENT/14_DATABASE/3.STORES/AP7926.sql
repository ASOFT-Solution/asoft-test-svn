
/****** Object:  StoredProcedure [dbo].[AP7926]    Script Date: 07/29/2010 12:58:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



-------- Created by Nguyen Minh Thuy
-------- Date 11/10/2006.
-------- Purpose: Cap that vao bang In "bang can doi ke toan" theo  ma phan tich (Thang/Quy/Nam)

/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP7926] 
		@LineID AS nvarchar(50),
		@PeriodNumber int,
		@DivisionID AS nvarchar(50)			
AS

DECLARE @TempLineID as nvarchar(50),
		@TempParrentLineID as nvarchar(50),
		@Index int,
		@sSQL nvarchar (MAX)
	Set @TempLineID = @LineID
	Set @TempParrentLineID= (Select top 1 ltrim(isnull(ParrentLineID,'')) From AT7902 Where LineID = @TempLineID AND DivisionID = @DivisionID)
	
	While	isnull(@TempParrentLineID, '') <> ''   --- Neu con cha thi van tiep thu
		Begin
			Set  @Index = 1  
			---Print ' Nhan @TempLineID +' +@TempLineID
			While @Index<=@PeriodNumber
			Begin
				Set @sSQL = N'
				UPDATE 	AT7925
				SET		Amount' + ltrim(@Index) + ' = Isnull( Amount' + ltrim(@Index) + ',0) + 
						(Select isnull(sum(isnull(Amount' + ltrim(@Index) + ' ,0)),0) From AT7925 Where LineID
						In (Select LineID From AT7902 Where LineID = ''' + @LineID + ''' AND DivisionID = ''' + @DivisionID + ''')
						AND DivisionID = ''' + @DivisionID + ''') 
				WHERE	LineID = ''' + @TempParrentLineID + ''' AND DivisionID = ''' + @DivisionID + ''''
				Exec(@sSQL)
				Set @Index = @Index + 1
			End

			Set	@TempLineID = @TempParrentLineID		
			Set @TempParrentLineID = (Select top 1 ltrim(isnull(ParrentLineID,'')) From AT7902 Where LineID = @TempLineID AND DivisionID = @DivisionID)		

		End