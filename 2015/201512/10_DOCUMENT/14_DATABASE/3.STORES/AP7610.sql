IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7610]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP7610]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



----- In bang ket qua kinh doanh.
----- Created by Nguyen Van Nhan, Date 12.09.2003

/**********************************************
** Edited by: [GS] [Cáº©m Loan] [30/07/2010]
***********************************************/
---- Modified on 22/10/2012 by Lê Thị Thu Hiền : Bổ sung in nhiều đơn vị

CREATE PROCEDURE [dbo].[AP7610]
			@DivisionID AS nvarchar(50),
			@TranMonthFrom AS INT,
			@TranYearFrom AS INT,
			@TranMonthTo AS INT,
			@TranYearTo AS INT,
			@ReportCode AS nvarchar(50), 	---- Ma bao cao can tinh toan
			@AmountUnit AS TINYINT,		---- Don vi tinh (khi in)
			@TypeID as TINYINT,
			@StrDivisionID AS NVARCHAR(4000) = ''


AS


	----- Phan 1: Lo, lai
	if @TypeID = 1
		EXEC AP7604 @DivisionID, @TranMonthFrom, @TranYearFrom, @TranMonthTo, @TranYearTo, @ReportCode, @AmountUnit, @StrDivisionID
	----- Phan 2: Tinh hinh thuc hien nghia vu voi nha nuoc
	If @TypeID =2
		 EXEC AP7606 @DivisionID, @TranMonthFrom, @TranYearFrom, @TranMonthTo, @TranYearTo, @ReportCode, @AmountUnit, @StrDivisionID
	----- Phan 3: Thue GTGT duoc khau tru; hoan lai,...
	If @TypeID =3
		EXEC AP7608 @DivisionID, @TranMonthFrom, @TranYearFrom, @TranMonthTo, @TranYearTo, @ReportCode, @AmountUnit, @StrDivisionID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

