-- <Summary>
---- 
-- <History>
---- Create on 23/12/2012 by Huỳnh Tấn Phú
---- Modified on ... by
-- <Example>
Update MT5002STD set IsCoefficient = 1
where DistributedMethod IN ('D02', 'D06', 'D08')
Update MT5002 set IsCoefficient = 1
where DistributedMethod IN ('D02', 'D06', 'D08')
Update MT5002STD set IsApportion = 1
where DistributedMethod IN ('D03', 'D07')
Update MT5002 set IsApportion = 1
where DistributedMethod IN ('D03', 'D07')