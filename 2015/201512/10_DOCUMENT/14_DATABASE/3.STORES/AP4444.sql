IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP4444]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP4444]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
-- Viết lại bởi Thanh Sơn on 20/10/2014
-- Nội dung: Bổ sung tính năng tự động lấy lại CustomerName cũ, 
--			 Không cần phải chạy lại store AP4444 mỗi khi chạy fix lại cho khách hàng
 */
 
CREATE PROCEDURE AP4444 AS
DECLARE @CustomerName INT = -1, --Nhập CustomerName tương ứng
		@ImportExcel INT = 0	--Nhập ImportExcel tương ứng

IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[CustomerIndex]') AND TYPE IN (N'U'))
CREATE TABLE CustomerIndex (CustomerName INT, ImportExcel INT)
IF NOT EXISTS (SELECT TOP 1 1 FROM CustomerIndex)
	INSERT INTO CustomerIndex (CustomerName, ImportExcel)
	VALUES (@CustomerName, @ImportExcel)
ELSE 
	BEGIN
		IF @CustomerName <> -1 
		UPDATE CustomerIndex SET CustomerName = @CustomerName
		IF @ImportExcel <> 0  
		UPDATE CustomerIndex SET ImportExcel = @ImportExcel
	END	
SELECT CustomerName, ImportExcel FROM CustomerIndex
-----------------------DANH MỤC KHÁCH HÀNG CUSTOMIZE------------------------------------------------------
/*
		-1______Standard
		 0______MVI
		 1______Minh Phương
		 2______Ngọc Tề
		 3______Trung Dũng
		 4______Viễn Tín
		 5______Toàn Thắng
		 6______Đông Quang
		 7______Quang Huy
		 8______Binh Tay
		 9______KonDo
		10______An Tin
		11______EUROVIE
		12______Thuận Lợi
		13______Tiên Tiến
		14______Tân Thành
		15______2T
		16______Cường Thanh, Siêu Thanh
		17______IPL
		18______Fine Fruit Asia
		19______Cảng Sài Gòn
		20______Sinolife
		21______Unicare
		22______Dacin
		23______Viện Gut
		24______Long Trường Vũ
		25______King Com (Hoàng Vũ)
		26______PrintTech
		27______An Phúc Thịnh
		28______Sun Viet
		29______TBIV
		30______Hưng Vượng
		31______Vimec
		32______PHÚC LONG (Hoàng Vũ)
		33______Minh Tiến (Quốc Tuấn)
		34______XƯƠNG RỒNG (Thanh Sơn)
		35______EIS 
		36______Sài Gòn Petro (Thị Hạnh)
		37______SOFA (Quốc Tuấn)
		38______BBL - BounBon Bến Lức (Trí Thiện)
		39______Vân Khánh (Trí Thiện)
		40______Long Giang (Thanh Sơn)
		41______QTC		
		42______HUA HEONG VN
		43______SECOIN (Hoàng Vũ)
		44______SAVIPHARM 
		45______ABA (Thị Hạnh)
		46______HUYNDAE (Thanh Sơn)
		47______Đại Nam Phát (Quốc Tuấn)
		48______An Phú Gia (Tiểu Mai)
		49______Figla(Thịnh)
		50______MeiKo (Kim Vũ)
		51______Hoàng Trần (Hoàng Vũ)
		52______KOYO (Tiểu Mai)
		53______OFFICIENCE
		54______An Phát (Tiểu Mai)
		55______SAMSUN (Bảo Đăng)
		56______TMDVQ3 (Hoàng Vũ POS)
		57______ANGEL (Bảo Anh)
*/
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON