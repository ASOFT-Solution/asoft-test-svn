/****** Object:  StoredProcedure [dbo].[AP7803]    Script Date: 08/05/2010 09:51:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

------ Created by Nguyen Van Nhan, Date 24/09/2003
----- Purpose: Xoa but toan phan bo trong ky

ALTER PROCEDURE [dbo].[AP7803]
       @DivisionID AS nvarchar(50) ,
       @TranMonth AS int ,
       @TranYear AS int
AS
DELETE
        AT9000
WHERE
        TranMonth = @TranMonth AND TranYear = @TranYear AND DivisionID = @DivisionID AND TransactionTypeID = 'T98'
