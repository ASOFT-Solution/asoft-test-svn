/****** Object:  StoredProcedure [dbo].[AP0523]    Script Date: 07/29/2010 09:02:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


--Created by Nguyen Thi Ngoc Minh
--Date: 22/10/2004
--Purpose: Cap nhat phieu xuat kho khi xoa phieu xuat kho theo bo
/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP0523]		@DivisionID nvarchar(50), 
					@RDVoucherID nvarchar(50)
			
AS

DELETE From AT2007 Where DivisionID = @DivisionID and VoucherID = @RDVoucherID
