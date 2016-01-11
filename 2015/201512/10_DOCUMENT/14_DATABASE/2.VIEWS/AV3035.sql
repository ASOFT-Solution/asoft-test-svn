/****** Object: View [dbo].[AV3035] Script Date: 12/16/2010 15:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--PP:Tao view de truy van chi phi mua hang (Detail)
--Au:Thuy Tuyen
--Dates:30/06/2008

ALTER VIEW [dbo].[AV3035]
as

SELECT 
AT1202.ObjectName,
AT9000.* 
From AT9000 
LEFT JOIN AT1202 ON AT9000.DivisionID = AT1202.DivisionID AND AT9000.ObjectID = AT1202.ObjectID 
WHERE AT9000.TransactionTypeID IN ('T23') AND AT9000.TableID ='AT9000'

GO

