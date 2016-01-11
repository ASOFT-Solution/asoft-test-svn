
/****** Object:  StoredProcedure [dbo].[MP1602]    Script Date: 07/30/2010 11:23:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--created by Hoang Thi Lan
--date 10/10/2003
--Purpose : lÊy d÷ liÖu ®èi t­îng tËp hîp chi phÝ ,dïng cho form MF1602
/********************************************
'* Edited by: [GS] [Tố Oanh] [30/07/2010]
'********************************************/

ALTER procedure [dbo].[MP1602]  @CoefficentID as nvarchar(50)
as
declare 
@sSQL as nvarchar(4000)
set @sSQL='
Select MT1606.CoefficientID,
       MT1606.CoefficientName,
       MT1606.Disabled,
       MT1606.CoType,
       MT1607.CoValue,
       MT1607.DivisionID,
       MT1607.Notes,
       MT1607.PeriodID,
       MT1601.Description
From MT1606 inner join MT1607 on MT1606.CoefficientID=MT1607.CoefficientID
	    inner join MT1601 on MT1607.PeriodID=MT1601.PeriodID	
where MT1606.Disabled=0
	and MT1601.IsForPeriodID=0
	and MT1606.CoefficientID = '''+  @CoefficentID +''''

--print @sSQL
If not exists (Select top 1 1 From SysObjects Where name = 'MV1606' and Xtype ='V')
	Exec ('Create view MV1606 as '+@sSQL)
Else
	Exec ('Alter view MV1606 as '+@sSQL)




