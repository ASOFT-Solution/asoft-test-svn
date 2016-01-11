IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP4802]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP4802]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[AP4802] 	
				@DivisionID nvarchar(50), 
				@ReportCode as nvarchar(50),
				@FromMonth as int, 
				@FromYear as int,
				@ToMonth as int, 
				@ToYear as int,
				@FromDate Datetime,
				@ToDate Datetime,
				@IsDate as tinyint,
				@Selection01From nvarchar(20),  
				@Selection01To nvarchar(20),
				@Selection02From nvarchar(20),  
				@Selection02To nvarchar(20),
				@Selection03From nvarchar(20),  
				@Selection03To nvarchar(20),
				@Selection04From nvarchar(20),  
				@Selection04To nvarchar(20)
AS

	Declare @Column as nvarchar(20),
		@sSQL as nvarchar(MAX),
		@sGroup  nvarchar(MAX),
		@FromAccountID as nvarchar(50),
		@ToAccountID as nvarchar(50),
		@Selection01ID   as nvarchar(50),      
		@Selection02ID  as nvarchar(50),       
		@Selection03ID   as nvarchar(50),      
		@Selection04ID   as nvarchar(50),             		
		@Level01   as nvarchar(20),                   
		@Level02   as nvarchar(20),                   
		@Level03    as nvarchar(20),                  
		@Level04  as nvarchar(20),
		@I as int,
		@ColumnType as nvarchar(20),
		@ColumnData as nvarchar(20),
		@sSQLColumn as nvarchar(MAX),
		@Select1 as nvarchar(MAX),
		@From1 as nvarchar(MAX)

Select 	top 1 @FromAccountID = FromAccountID, @ToAccountID = ToAccountID,
	@Selection01ID = Selection01ID, @Selection02ID = Selection02ID,
	@Selection03ID = Selection03ID, @Selection04ID = Selection04ID,
	@Level01 = Level01, @Level02 = Level02, 	
	@Level03 = Level03, @Level04 = Level04
From AT4801
Where ReportCode = @ReportCode and DivisionID = @DivisionID
 	
---------1------------------- Xu ly Group-----------------------------------------------
Set @sSQL = ' Select V31.DivisionID, '


If isnull(@Level01,'') <>'' 
	Exec AP4700 @Level01 ,  @Column  output
Set @sSQL = @sSQL+ ' '+@Column+'  as Group01ID, '
Set @sGroup =' Group by V31.DivisionID, '+@Column+'  '

Set  @Column =''     
If isnull(@Level02,'') <>'' 
   Begin
	Exec AP4700 @Level02 ,  @Column  output
	Set @sSQL = @sSQL+ ' '+@Column+'  as Group02ID, '
	Set @sGroup = @sGroup+' ,  ' +@Column
 End	
Else
	Set @sSQL = @sSQL+ ' ''''  as Group02ID, '

Set  @Column =''     
If isnull(@Level03,'') <>'' 
   Begin
	Exec AP4700 @Level03 ,  @Column  output
	Set @sSQL = @sSQL+ ' '+@Column+'  as Group03ID, '
	Set @sGroup = @sGroup+' ,  ' +@Column
 End	
Else
	Set @sSQL = @sSQL+ ' ''''  as Group03ID, '

If isnull(@Level04,'') <>'' 
   Begin
	Exec AP4700 @Level04 ,  @Column  output
	Set @sSQL = @sSQL+ ' '+@Column+'  as Group04ID, '
	Set @sGroup = @sGroup+' ,  ' +@Column
 End	
Else
	Set @sSQL = @sSQL+ ' ''''  as Group04ID  '

--Print @sGroup
---------2------------------- Xu ly Detail  -----------------------------------------------
Set @I = 1
While @i<=10 
	Begin
		set @ColumnType =''
		Select top 1 @ColumnType = AmountTypeID,  @ColumnData  = CaculatorID
		From AT4802 Where ReportCode = @ReportCode and ColumnID = @I and DivisionID = @DivisionID
		If isnull(@ColumnType,'')<>''
		  Begin
			EXEC AP4899 @FromMonth, @FromYear, @ToMonth, @ToYear, @FromDate,@ToDate,@IsDate,@ColumnType, @ColumnData , @sSQLColumn output
			If @I = 10
			  	Set @sSQL =@sSQL+ ',  '+@sSQLColumn+'  as ColumnAmount'+ltrim(rtrim(str(@I)))+'  '
			Else 
				Set @sSQL =@sSQL+ ',  '+@sSQLColumn+'  as ColumnAmount0'+ltrim(rtrim(str(@I)))+'  '
		End
		  Else
			Begin
				If @I = 10
					Set @sSQL =@sSQL+ ', sum(0) as ColumnAmount'+ltrim(rtrim(str(@I)))+'  '	
				Else
					Set @sSQL =@sSQL+ ', sum(0) as ColumnAmount0'+ltrim(rtrim(str(@I)))+'  '	
			End
		Set @I = @i+1

	End	




Set @sSQL = @sSQL +'  From AV4301 V31 
			Where  DivisionID = DivisionID and
				AccountID between '''+@FromAccountID+''' and '''+@ToAccountID+''' '

If isnull(@Selection01ID,'') <>'' 
   Begin
	Exec AP4700 @Selection01ID ,  @Column  output
	Set @sSQL = @sSQL+ ' and ( '+@Column+' Between '''+@Selection01From+''' and '''+@Selection01To+''' ) '
  End 

If isnull(@Selection02ID,'') <>'' 
   Begin
	Exec AP4700 @Selection02ID ,  @Column  output
	Set @sSQL = @sSQL+ ' and ( '+@Column+' Between '''+@Selection02From+''' and '''+@Selection02To+''' ) '
  End 

If isnull(@Selection03ID,'') <>'' 
   Begin
	Exec AP4700 @Selection03ID ,  @Column  output
	Set @sSQL = @sSQL+ ' and ( '+@Column+' Between '''+@Selection03From+''' and '''+@Selection03To+''' ) '
  End 


If isnull(@Selection04ID,'') <>'' 
   Begin
	Exec AP4700 @Selection04ID ,  @Column  output
	Set @sSQL = @sSQL+ ' and ( '+@Column+' Between '''+@Selection04From+''' and '''+@Selection04To+''' ) '
  End 

Set @sSQL = @sSQL + @sGroup


If not Exists (Select 1 From SysObjects Where Xtype='V' and Name ='AV4812')
	Exec('Create view AV4812 	--Created by AP4802
			as '+@sSQL)
Else	
	Exec('Alter view AV4812 		--Created by AP4802
			as '+@sSQL)



if left(@Level01,2) ='A0'
	Begin
		Set @Select1 ='T11.RefDate, T11.Notes,T11.Note01, T11.Note02, T11.Note03, T11.Note04, T11.Note05,
			T11.Amount01, T11.Amount02,T11.Amount03,T11.Amount04,T11.Amount05'
		Set @From1 ='left join AT1011 T11 on 	T11.AnaTypeID ='''+@Level01+''' And	T11.AnaID = V12.Group01ID '
	
	End
 Else
	Begin
		Set @Select1=' null as RefDate, '' as Notes, '' as Note01, '' as Note02, '' as Note03, '' as Note04, '' as Note05,
			0.0 as Amount01, 0.0 as Amount02, 0.0 as Amount03, 0.0 as Amount04, 0.0 as Amount05 '
		 Set @From1 ='  '
	end
Set @sSQL =' 	Select  V12.DivisionID, V12.Group01ID,            V12.Group02ID,  V12.Group03ID, V12.Group04ID, 
			Case  when V12.ColumnAmount01 <0 then 0.0 else V12.ColumnAmount01 end as ColumnAmount01,                        
			Case  when V12.ColumnAmount02 <0 then 0.0 else V12.ColumnAmount02 end as ColumnAmount02,                        
			Case  when V12.ColumnAmount03 <0 then 0.0 else V12.ColumnAmount03 end as ColumnAmount03,                        
			Case  when V12.ColumnAmount04 <0 then 0.0 else V12.ColumnAmount04 end as ColumnAmount04,                        
			Case  when V12.ColumnAmount05 <0 then 0.0 else V12.ColumnAmount05 end as ColumnAmount05,                        
			Case  when V12.ColumnAmount06 <0 then 0.0 else V12.ColumnAmount06 end as ColumnAmount06,                        
			Case  when V12.ColumnAmount07 <0 then 0.0 else V12.ColumnAmount07 end as ColumnAmount07,                        
			Case  when V12.ColumnAmount08 <0 then 0.0 else V12.ColumnAmount08 end as ColumnAmount08,                        
			Case  when V12.ColumnAmount09 <0 then 0.0 else V12.ColumnAmount09 end as ColumnAmount09,                        
			Case  when V12.ColumnAmount10 <0 then 0.0 else V12.ColumnAmount10 end as ColumnAmount10                        
				 '
If isnull(@Level01,'') <>'' 
  	Set @sSQL =@sSQL +',   V61.SelectionName as GroupName01 '
Else
	Set @sSQL =@sSQL +',  ''''  GroupName01 '	

If isnull(@Level02,'') <>'' 
  Set @sSQL =@sSQL +',   V62.SelectionName as GroupName02 '		
Else
	Set @sSQL =@sSQL +' , ''''  GroupName02 '	

If isnull(@Level03,'') <>'' 
  Set @sSQL =@sSQL +',   V63.SelectionName as GroupName03 '		
Else
  Set @sSQL =@sSQL +',  ''''  GroupName03 '	

If isnull(@Level04,'') <>'' 
  Set @sSQL =@sSQL +',   V64.SelectionName as GroupName04 '		
Else
  Set @sSQL =@sSQL +',  ''''  GroupName04 '	

Set @sSQL=@sSQL+', '+@Select1

Set @sSQL =@sSQL+'
	From AV4812 V12 '

If isnull(@Level01,'') <>'' 
Set @sSQL = @sSQL +' left join AV6666 V61 on 	V61.SelectionType ='''+@Level01+''' And
						V61.SelectionID = V12.Group01ID and V61.DivisionID = V12.DivisionID '

If isnull(@Level02,'') <>'' 
Set @sSQL = @sSQL +' left join AV6666 V62 on 	V62.SelectionType ='''+@Level02+''' And
						V62.SelectionID = V12.Group02ID and V62.DivisionID = V12.DivisionID '

If isnull(@Level03,'') <>'' 
Set @sSQL = @sSQL +' left join AV6666 V63 on 	V63.SelectionType ='''+@Level03+''' And
						V63.SelectionID = V12.Group03ID and V63.DivisionID = V12.DivisionID  '

If isnull(@Level04,'') <>'' 
Set @sSQL = @sSQL +' left join AV6666 V64 on 	V64.SelectionType ='''+@Level04+''' And
						V64.SelectionID = V12.Group04ID and V64.DivisionID = V12.DivisionID '

Set @sSQL=@sSQL+@From1

Set @sSQL = @sSQL +' Where 	ColumnAmount01<>0 or ColumnAmount02<>0 or ColumnAmount03<>0 or ColumnAmount04<>0 or ColumnAmount05<>0
				Or  ColumnAmount06<>0 or ColumnAmount07<>0 or ColumnAmount08<>0 or ColumnAmount09<>0 or ColumnAmount10<>0 '



If not Exists (Select 1 From SysObjects Where Xtype='V' and Name ='AV4802')
	Exec('Create view AV4802 	--Created by AP4802
			as '+@sSQL)
Else	
	Exec('Alter view AV4802 		--Created by AP4802
			as '+@sSQL)

--Print @sSQL

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

