
/****** Object:  StoredProcedure [dbo].[MP0406]    Script Date: 07/30/2010 09:58:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

---Created by: Vo Thanh Huong, date: 05/05/2006
---purpose: Xoa ket chuyen DDCK thanh DDDK
/********************************************
'* Edited by: [GS] [Tố Oanh] [30/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP0406] @DivisionID nvarchar(50),
				@PeriodID nvarchar(50),
				@TranMonth int,
				@TranYear int
 AS

DELETE MT1612 Where FromPeriodID = @PeriodID and DivisionID = @DivisionID
