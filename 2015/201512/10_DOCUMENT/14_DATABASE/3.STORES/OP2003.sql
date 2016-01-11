IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP2003]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP2003]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Kiem tra truoc khi luu lich giao hang
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 22/12/2011 by Vo Thanh Huong
---- 
---- Modified on 22/12/2011 by Le Thi Thu Hien : Bo sung bien de load ngay giao hang cua man don hang ban tai man hinh tien do giao hang (Customize cho khach hang Toan Thang)
-- <Example>
---- 


CREATE PROCEDURE [dbo].[OP2003] 	
				@Mode tinyint, ----1: Don hang ban, 2: Don hang mua
				@IsEdit tinyint, ----1:Sua, 0: Them moi
				@OrderID nvarchar(50),
				@Date01 datetime, @Date02 datetime, @Date03 datetime, @Date04 datetime, @Date05 datetime,
				@Date06 datetime, @Date07 datetime, @Date08 datetime, @Date09 datetime, @Date10 datetime,
				@Date11 datetime, @Date12 datetime, @Date13 datetime, @Date14 datetime, @Date15 datetime,
				@Date16 datetime, @Date17 datetime, @Date18 datetime, @Date19 datetime, @Date20 datetime,
				@Date21 datetime, @Date22 datetime, @Date23 datetime, @Date24 datetime, @Date25 datetime,
				@Date26 datetime, @Date27 datetime, @Date28 datetime, @Date29 datetime, @Date30 DATETIME,
				@IsDelivery AS TINYINT = 0  -- 1 : Load ngay giao hang tai man hinh tien do giao hang
AS
DECLARE @VietMess nvarchar(250),
		@EngMess nvarchar(250),	
		@Param nvarchar(50),	
		@Status  tinyint,
		@sSQL  nvarchar(4000),
		@cur cursor, 
		@Time int,
		@Date nvarchar(10)

IF @IsDelivery = 1
BEGIN
	SELECT DISTINCT O.DeliveryDate 
	FROM OT2002 O 
	WHERE O.SOrderID = @OrderID
	ORDER BY O.DeliveryDate
END
ELSE
	BEGIN

Select @Status = 0, @VietMess = '', @EngMess = '', @sSQL = '', @Param = ''

If @Date01 is not null SET @sSQL = @sSQL + 'Select ''' + Convert(nvarchar(10), @Date01, 103) + ''' as Date, 1 as Time Union '
If @Date02 is not null SET @sSQL = @sSQL + 'Select ''' + Convert(nvarchar(10), @Date02, 103) + ''' as Date, 2 as Time Union '
If @Date03 is not null SET @sSQL = @sSQL + 'Select ''' + Convert(nvarchar(10), @Date03, 103) + ''' as Date, 3 as Time Union '
If @Date04 is not null SET @sSQL = @sSQL + 'Select ''' + Convert(nvarchar(10), @Date04, 103) + ''' as Date, 4 as Time Union '
If @Date05 is not null SET @sSQL = @sSQL + 'Select ''' + Convert(nvarchar(10), @Date05, 103) + ''' as Date, 5 as Time Union '
If @Date06 is not null SET @sSQL = @sSQL + 'Select ''' + Convert(nvarchar(10), @Date06, 103) + ''' as Date, 6 as Time Union '
If @Date07 is not null SET @sSQL = @sSQL + 'Select ''' + Convert(nvarchar(10), @Date07, 103) + ''' as Date, 7 as Time Union '
If @Date08 is not null SET @sSQL = @sSQL + 'Select ''' + Convert(nvarchar(10), @Date08, 103) + ''' as Date, 8 as Time Union '
If @Date09 is not null SET @sSQL = @sSQL + 'Select ''' + Convert(nvarchar(10), @Date09, 103) + ''' as Date, 9 as Time Union '
If @Date10 is not null SET @sSQL = @sSQL + 'Select ''' + Convert(nvarchar(10), @Date10, 103) + ''' as Date, 10 as Time Union '
If @Date11 is not null SET @sSQL = @sSQL + 'Select ''' + Convert(nvarchar(10), @Date11, 103) + ''' as Date, 11 as Time Union '
If @Date12 is not null SET @sSQL = @sSQL + 'Select ''' + Convert(nvarchar(10), @Date12, 103) + ''' as Date, 12 as Time Union '
If @Date13 is not null SET @sSQL = @sSQL + 'Select ''' + Convert(nvarchar(10), @Date13, 103) + ''' as Date, 13 as Time Union '
If @Date14 is not null SET @sSQL = @sSQL + 'Select ''' + Convert(nvarchar(10), @Date14, 103) + ''' as Date, 14 as Time Union '
If @Date15 is not null SET @sSQL = @sSQL + 'Select ''' + Convert(nvarchar(10), @Date15, 103) + ''' as Date, 15 as Time Union '
If @Date16 is not null SET @sSQL = @sSQL + 'Select ''' + Convert(nvarchar(10), @Date16, 103) + ''' as Date, 16 as Time Union '
If @Date17 is not null SET @sSQL = @sSQL + 'Select ''' + Convert(nvarchar(10), @Date17, 103) + ''' as Date, 17 as Time Union '
If @Date18 is not null SET @sSQL = @sSQL + 'Select ''' + Convert(nvarchar(10), @Date18, 103) + ''' as Date, 18 as Time Union '
If @Date19 is not null SET @sSQL = @sSQL + 'Select ''' + Convert(nvarchar(10), @Date19, 103) + ''' as Date, 19 as Time Union '
If @Date20 is not null SET @sSQL = @sSQL + 'Select ''' + Convert(nvarchar(10), @Date20, 103) + ''' as Date, 20 as Time Union '
If @Date21 is not null SET @sSQL = @sSQL + 'Select ''' + Convert(nvarchar(10), @Date21, 103) + ''' as Date, 21 as Time Union '
If @Date22 is not null SET @sSQL = @sSQL + 'Select ''' + Convert(nvarchar(10), @Date22, 103) + ''' as Date, 22 as Time Union '
If @Date23 is not null SET @sSQL = @sSQL + 'Select ''' + Convert(nvarchar(10), @Date23, 103) + ''' as Date, 23 as Time Union '
If @Date24 is not null SET @sSQL = @sSQL + 'Select ''' + Convert(nvarchar(10), @Date24, 103) + ''' as Date, 24 as Time Union '
If @Date25 is not null SET @sSQL = @sSQL + 'Select ''' + Convert(nvarchar(10), @Date25, 103) + ''' as Date, 25 as Time Union '
If @Date26 is not null SET @sSQL = @sSQL + 'Select ''' + Convert(nvarchar(10), @Date26, 103) + ''' as Date, 26 as Time Union '
If @Date27 is not null SET @sSQL = @sSQL + 'Select ''' + Convert(nvarchar(10), @Date27, 103) + ''' as Date, 27 as Time Union '
If @Date28 is not null SET @sSQL = @sSQL + 'Select ''' + Convert(nvarchar(10), @Date28, 103) + ''' as Date, 28 as Time Union '
If @Date29 is not null SET @sSQL = @sSQL + 'Select ''' + Convert(nvarchar(10), @Date29, 103) + ''' as Date, 29 as Time Union '
If @Date30 is not null SET @sSQL = @sSQL + 'Select ''' + Convert(nvarchar(10), @Date30, 103) + ''' as Date, 30 as Time Union '

If @sSQL not like '' 
Begin
	Set @sSQL = left(@sSQL, len(@sSQL) - 5) 
	IF NOT EXISTS (SELECT TOP 1 1 FROM SYSOBJECTS WHERE XTYPE = 'V' AND NAME = 'OV2003')
		EXEC('Create View OV2003 --- tao boi OP2003
			as ' +  @sSQL) 
		EXEC('Alter View OV2003 --- tao boi OP2003
			as ' +  @sSQL)
	
	Set @cur = Cursor scroll keyset for 
			Select Date, Time
			From 	OV2003
			Order by Time

	Open @cur
	Fetch next from @cur into @Date, @Time
	
	While @@FETCH_STATUS = 0 
	Begin
		If exists( Select Top 1 1
				From OV2003 
				Where convert(datetime, date, 103)  > convert(datetime, @Date, 103)  and Time < @Time) 		
			Set @Param = ltrim(rtrim(str(@Time)))
	
		Fetch next from @cur into @Date, @Time
	End
	Close @cur
End

If @Param not like ''
begin
	Set @Status =1
	Set @VietMess = 'OFML000170'
	--Set @EngMess = 'The time ' +  left(@EngMess, len(ltrim(rtrim(@EngMess)))-1) +  ' is need larger previous time ' 
end
Set nocount off

Goto EndMess

EndMess:
	Select @Status as Status, @VietMess as Vietmess, @EngMess as EngMess, @Param as Param

END


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

