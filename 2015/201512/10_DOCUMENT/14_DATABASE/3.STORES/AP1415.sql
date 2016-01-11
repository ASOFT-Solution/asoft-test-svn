IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1415]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP1415]
GO
/****** Object:  StoredProcedure [dbo].[AP1415]    Script Date: 12/21/2010 09:47:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Thanh Tram
-- Create date: 13/12/2010
-- Description:	Tạo dữ liệu từ các bảng standar khi tạo đơn vị
-- =============================================
CREATE PROCEDURE [dbo].[AP1415] 
	@DivisionID NVARCHAR(50)
AS
BEGIN

	SELECT * FROM AT1101 WHERE DivisionID = @DivisionID

	----Insert dữ liệu từ các bản standar vào table 	
	--DELETE FROM AT0002 WHERE DivisionID = @DivisionID;

	--DELETE FROM AT0005 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM AT0006 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM AT1001 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM AT1002 WHERE DivisionID = @DivisionID;

	--DELETE FROM AT1004 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM AT1005 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM AT1006 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM AT1007 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM AT1008 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM AT1009 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM AT1010 WHERE DivisionID = @DivisionID;
		
	--DELETE FROM AT1017 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM AT1201 WHERE DivisionID = @DivisionID;
		
	--DELETE FROM AT1206 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM AT1301 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM AT1304 WHERE DivisionID = @DivisionID;
		
	--DELETE FROM AT1305 WHERE DivisionID = @DivisionID;
		
	--DELETE FROM AT1306 WHERE DivisionID = @DivisionID;
		
	--DELETE FROM AT1401 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM AT1402 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM AT1403 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM AT1404 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM AT1405 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM AT1408 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM AT1409 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM AT1410 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM AT1502 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM AT1598 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM AT1599 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM AT4700 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM AT4701 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM AT4710 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM AT6000 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM AT6100 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM AT6101 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM AT6501 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM AT6502 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM AT7410 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM AT7420 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM AT7433 WHERE DivisionID = @DivisionID;
				
	--DELETE FROM AT7434 WHERE DivisionID = @DivisionID;

	--DELETE FROM AT7601 WHERE DivisionID = @DivisionID;

	--DELETE FROM AT7602 WHERE DivisionID = @DivisionID;

	--DELETE FROM AT7801 WHERE DivisionID = @DivisionID;

	--DELETE FROM AT7802 WHERE DivisionID = @DivisionID;

	--DELETE FROM AT7901 WHERE DivisionID = @DivisionID;

	--DELETE FROM AT7902 WHERE DivisionID = @DivisionID;

	--DELETE FROM AT8000 WHERE DivisionID = @DivisionID;

	--DELETE FROM AT8001 WHERE DivisionID = @DivisionID;

	--DELETE FROM AT8888 WHERE DivisionID = @DivisionID;

	--DELETE FROM AT9011 WHERE DivisionID = @DivisionID;

	--DELETE FROM CT0005 WHERE DivisionID = @DivisionID;

	--DELETE FROM CT2222 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM CT8888 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM HT0001 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM HT0002 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM HT0003 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM HT0005 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM HT0006 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM HT1000 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM HT1001 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM HT1002 WHERE DivisionID = @DivisionID;

	--DELETE FROM HT1005 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM HT1006 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM HT1007 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM HT1010 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM HT1103 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM HT2222 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM HT2223 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM HT2225 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM HT8888 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM MT0699 WHERE DivisionID = @DivisionID;
	
	----DELETE FROM MT0700 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM MT0811 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM MT1619 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM MT1620 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM MT5002 WHERE DivisionID = @DivisionID;

	--DELETE FROM MT8888 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM OT0001 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM OT1005 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM OT1006 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM OT1101 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM OT4011 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM OT4012 WHERE DivisionID = @DivisionID;
	
	--DELETE FROM OT8888 WHERE DivisionID = @DivisionID;
	
END
