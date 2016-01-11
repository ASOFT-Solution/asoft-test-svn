/****** Object:  View [dbo].[AV1005]    Script Date: 12/16/2010 14:53:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

--View chet

ALTER VIEW [dbo].[AV1005] as 
Select  AT1005.DivisionID,
	AccountID, AccountName,AccountNameE,
	AT1005.GroupID, GroupName,
	GroupNameE, 
	AT1005.IsNotShow,
	AT1005.IsObject,
	AT1005.IsDebitBalance,
	AT1005.IsBalance,
	AT1005.CreateDate,
	AT1005.CreateUserID,         
	AT1005.LastModifyDate,
	AT1005.LastModifyUserID,
	AT1005.Disabled 
From AT1005 inner join AT1006 on AT1006.GroupID = AT1005.GroupID and AT1006.DivisionID = AT1005.DivisionID

GO


