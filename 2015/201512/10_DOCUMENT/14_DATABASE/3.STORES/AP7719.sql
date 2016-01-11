/****** Object:  StoredProcedure [dbo].[AP7719]    Script Date: 12/06/2010 16:18:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


-------------- 	Created by Nguyen Van Nhan
--------------	Created Date 24/04/2005
--------------	Purpose: Xu ly tinh toan In bao cao Luy ke Hang ton kho

/********************************************
'* Edited by: [GS] [Minh Lâm] [29/07/2010]
'********************************************/


ALTER PROCEDURE [dbo].[AP7719]
       @Field AS nvarchar(200) ,
       @ColumnName AS nvarchar(250) ,
       @SQL AS nvarchar(4000) OUTPUT ,
       @MonthYear01 AS int ,
       @MonthYear02 AS int ,
       @MonthYear03 AS int ,
       @MonthYear04 AS int ,
       @MonthYear05 AS int ,
       @MonthYear06 AS int ,
       @MonthYear07 AS int ,
       @MonthYear08 AS int ,
       @MonthYear09 AS int ,
       @MonthYear10 AS int ,
       @MonthYear11 AS int ,
       @MonthYear12 AS int ,
       @MonthYear13 AS int ,
       @MonthYear14 AS int ,
       @MonthYear15 AS int ,
       @MonthYear16 AS int ,
       @MonthYear17 AS int ,
       @MonthYear18 AS int ,
       @MonthYear19 AS int ,
       @MonthYear20 AS int
AS
SET @SQL = ''
Set @SQL =''
	If @MonthYear01<>0 	
		Set @SQL=@SQL +',  Cast(Sum( Case when Period = '+str(@MonthYear01)+' then '+@Field+' else 0 end ) as decimal(28,8)) as ColumnValue01 '
	Else  
		Set @SQL = @SQL + ', Cast(0 as decimal(28,8)) as ColumnValue01  '
	If @MonthYear02<>0 	
		Set @SQL=@SQL +',  Cast(Sum( Case when Period = '+str(@MonthYear02)+' then '+@Field+' else 0 end ) as decimal(28,8)) as ColumnValue02 '
	Else  
		Set @SQL = @SQL + ', Cast(0 as decimal(28,8)) as ColumnValue02  '
	If @MonthYear03<>0 	
		Set @SQL=@SQL +',  Cast(Sum( Case when Period = '+str(@MonthYear03)+' then '+@Field+' else 0 end ) as decimal(28,8)) as ColumnValue03 '
	Else  
		Set @SQL = @SQL + ', Cast(0 as decimal(28,8)) as ColumnValue03  '
	If @MonthYear04<>0 	
		Set @SQL=@SQL +',  Cast(Sum( Case when Period = '+str(@MonthYear04)+' then '+@Field+' else 0 end ) as decimal(28,8)) as ColumnValue04 '
	Else  
		Set @SQL = @SQL + ', Cast(0 as decimal(28,8)) as ColumnValue04  '
	If @MonthYear05<>0 	
		Set @SQL=@SQL +',  Cast(Sum( Case when Period = '+str(@MonthYear05)+' then '+@Field+' else 0 end ) as decimal(28,8)) as ColumnValue05 '
	Else  
		Set @SQL = @SQL + ', Cast(0 as decimal(28,8)) as ColumnValue05  '
	If @MonthYear06<>0 	
		Set @SQL=@SQL +',  Cast(Sum( Case when Period = '+str(@MonthYear06)+' then '+@Field+' else 0 end )as decimal(28,8)) as ColumnValue06 '
	Else  
		Set @SQL = @SQL + ', Cast(0 as decimal(28,8)) as ColumnValue06  '
	If @MonthYear07<>0 	
		Set @SQL=@SQL +',  Cast(Sum( Case when Period = '+str(@MonthYear07)+' then '+@Field+' else 0 end ) as decimal(28,8)) as ColumnValue07 '
	Else  
		Set @SQL = @SQL + ', Cast(0 as decimal(28,8)) as ColumnValue07  '
	If @MonthYear08<>0 	
		Set @SQL=@SQL +',  Cast(Sum( Case when Period = '+str(@MonthYear08)+' then '+@Field+' else 0 end ) as decimal(28,8)) as ColumnValue08 '
	Else  
		Set @SQL = @SQL + ', Cast(0 as decimal(28,8)) as ColumnValue08  '
	If @MonthYear09<>0 	
		Set @SQL=@SQL +',  Cast(Sum( Case when Period = '+str(@MonthYear09)+' then '+@Field+' else 0 end ) as decimal(28,8)) as ColumnValue09 '
	Else  
		Set @SQL = @SQL + ', Cast(0 as decimal(28,8)) as ColumnValue09  '
	If @MonthYear10<>0 	
		Set @SQL=@SQL +',  Cast(Sum( Case when Period = '+str(@MonthYear10)+' then '+@Field+' else 0 end ) as decimal(28,8)) as ColumnValue10 '
	Else  
		Set @SQL = @SQL + ', Cast(0 as decimal(28,8)) as ColumnValue10  '

	If @MonthYear11<>0 	
		Set @SQL=@SQL +',  Cast(Sum( Case when Period = '+str(@MonthYear11)+' then '+@Field+' else 0 end ) as decimal(28,8)) as ColumnValue11 '
	Else  
		Set @SQL = @SQL + ', Cast(0 as decimal(28,8)) as ColumnValue11  '
	If @MonthYear12<>0 	
		Set @SQL=@SQL +',  Cast(Sum( Case when Period = '+str(@MonthYear12)+' then '+@Field+' else 0 end ) as decimal(28,8)) as ColumnValue12 '
	Else  
		Set @SQL = @SQL + ', Cast(0 as decimal(28,8)) as ColumnValue12  '
	If @MonthYear13<>0 	
		Set @SQL=@SQL +',  Cast(Sum( Case when Period = '+str(@MonthYear13)+' then '+@Field+' else 0 end ) as decimal(28,8)) as ColumnValue13 '
	Else  
		Set @SQL = @SQL + ', Cast(0 as decimal(28,8)) as ColumnValue13  '
	If @MonthYear04<>0 	
		Set @SQL=@SQL +',  Cast(Sum( Case when Period = '+str(@MonthYear14)+' then '+@Field+' else 0 end ) as decimal(28,8)) as ColumnValue14 '
	Else  
		Set @SQL = @SQL + ', Cast(0 as decimal(28,8)) as ColumnValue14  '
	If @MonthYear05<>0 	
		Set @SQL=@SQL +',  Cast(Sum( Case when Period = '+str(@MonthYear15)+' then '+@Field+' else 0 end ) as decimal(28,8)) as ColumnValue15 '
	Else  
		Set @SQL = @SQL + ', Cast(0 as decimal(28,8)) as ColumnValue15  '
	If @MonthYear06<>0 	
		Set @SQL=@SQL +',  Cast(Sum( Case when Period = '+str(@MonthYear16)+' then '+@Field+' else 0 end ) as decimal(28,8)) as ColumnValue16 '
	Else  
		Set @SQL = @SQL + ', Cast(0 as decimal(28,8)) as ColumnValue16  '
	If @MonthYear07<>0 	
		Set @SQL=@SQL +',  Cast(Sum( Case when Period = '+str(@MonthYear17)+' then '+@Field+' else 0 end ) as decimal(28,8)) as ColumnValue17 '
	Else  
		Set @SQL = @SQL + ', Cast(0 as decimal(28,8)) as ColumnValue17  '
	If @MonthYear08<>0 	
		Set @SQL=@SQL +',  Cast(Sum( Case when Period = '+str(@MonthYear18)+' then '+@Field+' else 0 end ) as decimal(28,8)) as ColumnValue18 '
	Else  
		Set @SQL = @SQL + ', Cast(0 as decimal(28,8)) as ColumnValue18  '
	If @MonthYear09<>0 	
		Set @SQL=@SQL +',  Cast(Sum( Case when Period = '+str(@MonthYear19)+' then '+@Field+' else 0 end ) as decimal(28,8)) as ColumnValue19 '
	Else  
		Set @SQL = @SQL + ', Cast(0 as decimal(28,8)) as ColumnValue19  '
	If @MonthYear10<>0 	
		Set @SQL=@SQL +',  Cast(Sum( Case when Period = '+str(@MonthYear20)+' then '+@Field+' else 0 end ) as decimal(28,8)) as ColumnValue20 '
	Else  
		Set @SQL = @SQL + ', Cast(0 as decimal(28,8)) as ColumnValue20  '