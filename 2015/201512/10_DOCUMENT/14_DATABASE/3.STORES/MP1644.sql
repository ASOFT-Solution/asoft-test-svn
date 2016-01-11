
/****** Object:  StoredProcedure [dbo].[MP1644]    Script Date: 07/29/2010 16:19:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created by Hoang Thi Lan 
--Date 27/11/2003
--Purpose : Bao cao Danh muc gia thanh san pham
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [02/08/2010]
'**************************************************************/

ALTER PROCEDURE [dbo].[MP1644] @FromMonth as int,@FromYear as int ,@ToMonth as int,@ToYear as int
 AS
Declare  @sSQL as nvarchar(4000),
	 @FromPeriod as int,
 	 @ToPeriod as int

Set @FromPeriod = @FromMonth + @FromYear*100
Set @ToPeriod = @ToMonth + @ToYear *100

Set @sSQL ='Select * From MT1601 Where  not(((ToMonth+ToYear*100)<'+str(@FromPeriod)+') Or ((FromMonth+FromYear*100)>'+str(@ToPeriod)+')) '
If not exists (Select top 1 1 From SysObjects Where name = 'MV1644' and Xtype ='V')
	Exec ('Create view MV1644 as '+@sSQL)
Else
	Exec ('Alter view MV1644 as '+@sSQL)

