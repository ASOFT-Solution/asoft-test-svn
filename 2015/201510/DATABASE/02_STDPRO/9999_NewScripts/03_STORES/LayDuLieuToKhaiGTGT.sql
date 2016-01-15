IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[LayDuLieuToKhaiGTGT]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[LayDuLieuToKhaiGTGT]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- <Summary>
---- Load chi tieu du lieu to khai thue gtgt (phan biet to khai lan dau va to khai bo sung)
---- <Param>
---- 
---- <Return>
---- 
---- <Reference>
---- 
---- <History>
---- Create on ... by ...
---- Modify on 20/07/2015, by Phan thanh hoang vu: Gộp chung 2 Store LayDuLieuToKhaiGTGT và LayDuLieuToKhaiGTGTQuy thành 1 thay đổi theo thông tư 119
---- 
---- <Example>
---- Exec LayDuLieuToKhaiGTGT 1, 1, 2013, 0,1, 0,0
---- 

CREATE PROCEDURE [dbo].[LayDuLieuToKhaiGTGT] 
		@DeclareType as int, --1: Tờ khai tháng; 2: Tờ khai quý; 0: Không khai
		@Ky as int,
		@Nam as int,
		@InLanDau int, --1: Tờ khai lần đầu; 0: Tờ khai bổ sung
		@SoLanIn as int, --So lần in chỉ áp dũng cho trường hợp tờ khai bổ sung
		@IsInputAppendix as int, --1: lấy số liệu phụ lục mua vào, 0: không lấy số liệu phụ lục mua vào
		@IsOutputAppendix as int --1: lấy số liệu phụ lục bán ra, 0: Không lấy số liệu phụ lục bán ra 

AS
Declare @KyTruoc int,
		@NamTruoc int,
		@QuyTruoc int,
		@TG22 decimal(28,6),
		@TG23 decimal(28,6),
		@TG24 decimal(28,6),
		@TG25 decimal(28,6),
		@TG26 decimal(28,6),
		@TG27 decimal(28,6),
		@TG28 decimal(28,6),
		@TG29 decimal(28,6),
		@TG30 decimal(28,6),
		@TG31 decimal(28,6),
		@TG32 decimal(28,6),
		@TG33 decimal(28,6),
		@TG34 decimal(28,6),
		@TG35 decimal(28,6),
		@TG36 decimal(28,6),
		@TG37 decimal(28,6),
		@TG38 decimal(28,6),
		@TG39 decimal(28,6),
		@TG40 decimal(28,6),
		@TG40a decimal(28,6),
		@TG40b decimal(28,6),
		@TG41 decimal(28,6),
		@TG42 decimal(28,6),
		@TG43 decimal(28,6),
		@strSoLanIn int



If @DeclareType = 1--Tờ khai theo tháng
	Begin

			if @Ky = 1
					BEGIN
						set @KyTruoc = 12
						set @NamTruoc = @Nam - 1
					END

			else
					BEGIN
						set @KyTruoc = @Ky - 1
						set @NamTruoc = @Nam
					END
			If @InLanDau = 1 
			Begin
						-- Chi tieu [22]
						select @TG22 = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
						where NamToKhai = @NamTruoc and KyToKhai = @KyTruoc  and CodeThue = '[43]'

						
						If @IsInputAppendix = 1 --Trường hợp tờ khai có check vào lấy phụ lục mua vào
						Begin
							-- Chi tieu [23], [24]
							Select @TG23 = sum(TTien), @TG24 = sum(Thue) from MVATIn mst inner join DVATIn dt on mst.MVATInID = dt.MVATInID
							where  MaLoaiThue  in (1,2,3) and KyBKMV = @Ky and NamBKMV = @Nam
							-- Chi tieu [25]
							Select @TG25 = Sum(Thue) From MVATIn mst inner join DVATIn dt on mst.MVATInID = dt.MVATInID  
							where MaLoaiThue in (1,3) and KyBKMV = @Ky and NamBKMV = @Nam
						End
						Else --Trường hợp tờ khai có check vào không lấy phụ lục mua vào
						Begin
							Select @TG23 = 0, @TG24 = 0, @TG25 = 0
						End
						
						If @IsOutputAppendix = 1 --Trường hợp tờ khai có check vào lấy phụ lục bán
						Begin
								-- Chi tieu [26]
								Select  @TG26 = sum(TTien) From MVATOut mst inner join DVATout dt on mst.MVATOutID = dt.MVATOutID 
								where dt.MaThue = 'KT' and KyBKBR = @Ky and NamBKBR = @Nam

								-- Chi tieu [29]
								Select @TG29 = sum(TTien) From  MVATOut mst inner join DVATout dt on mst.MVATOutID = dt.MVATOutID 
								where  MaThue = '00' and KyBKBR = @Ky and NamBKBR = @Nam

								-- Chi tieu [30], [31]
								Select @TG30 = sum(TTien), @TG31 = sum(Thue) From  MVATOut mst inner join DVATout dt on mst.MVATOutID = dt.MVATOutID 
								where  MaThue = '05' and KyBKBR = @Ky and NamBKBR = @Nam

								-- Chi tieu [32], [33]
								Select @TG32 = sum(TTien), @TG33 = sum(Thue) From  MVATOut mst inner join DVATout dt on mst.MVATOutID = dt.MVATOutID 
								where  MaThue = '10' and KyBKBR = @Ky and NamBKBR = @Nam
						End
						Else --Trường hợp tờ khai có check vào lấy phụ lục bán ra
						Begin	
							Select @TG26 = 0, @TG29 = 0, @TG30 = 0, @TG31 = 0, @TG32 = 0, @TG33 = 0
						End

						-- Chi tieu [27]=29+30+32
						set @TG27 = isnull(@TG29,0) + isnull(@TG30,0) + isnull(@TG32,0)

						-- Chi tieu [28] = 31+33
						set @TG28 = isnull(@TG31,0) + isnull(@TG33,0)

						-- Chi tieu [34] = 26+27
						set @TG34 = isnull(@TG26,0) + isnull(@TG27,0)

						-- Chi tieu [35] = 28
						set @TG35 = isnull(@TG28,0)

						-- Chi tieu [36] = [35] - [25]
						set @TG36 = isnull(@TG35,0) - isnull(@TG25,0)

						-- Chi tieu [37]
						Select  @TG37 = sum(Totalps) from MT36 
						Where MaLCTThue in (5,2) and KyKTT = @KyTruoc and Year(NgayCt) = @NamTruoc

						-- Chi tieu [38]
						Select  @TG38 = sum(Totalps) from MT36 
						Where MaLCTThue in (4,3) and KyKTT = @KyTruoc and Year(NgayCt) = @NamTruoc

						-- Chi tieu [40a] = 36 - 22 + 37 - 38 -39 > 0 va [41]
						set @TG40a = isnull(@TG36,0) - isnull(@TG22,0) + isnull(@TG37,0) - isnull(@TG38,0) - isnull(@TG39,0)
						if @TG40a < 0 
							BEGIN
								set @TG41 = -@TG40a
								set @TG40a = 0
							END

						-- Chi tieu [40]=40a-40b	
						set @TG40 = isnull(@TG40a,0) - isnull(@TG40b,0)

						-- Chi tieu [43] = [41] - [42]
						set @TG43 = isnull(@TG41,0) - isnull(@TG42,0)
				End
			Else
				Begin
						-- Chi tieu [21]
						select @TG22 = dt.GTHHDV from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
						where NamToKhai = @Nam and KyToKhai = @Ky  and CodeGT = N'[21]'
							  and SoLanIn = @SoLanIn - 1

						-- Chi tieu [22]
						select @TG22 = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
						where NamToKhai = @Nam and KyToKhai = @Ky  and CodeThue = '[22]'
							  and SoLanIn = @SoLanIn - 1

						-- Chi tieu [23]
						Select @TG23 = dt.GTHHDV from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
						where NamToKhai = @Nam and KyToKhai = @Ky  and CodeGT = '[23]'
							  and SoLanIn = @SoLanIn - 1

						-- Chi tieu [24]
						Select @TG24 = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
						where NamToKhai = @Nam and KyToKhai = @Ky  and CodeThue = '[24]'
							  and SoLanIn = @SoLanIn - 1

						-- Chi tieu [25]
						Select @TG25 = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
						where NamToKhai = @Nam and KyToKhai = @Ky  and CodeThue = '[25]'
							  and SoLanIn = @SoLanIn - 1

						-- Chi tieu [26]
						Select @TG24 = dt.GTHHDV from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
						where NamToKhai = @Nam and KyToKhai = @Ky  and CodeGT = '[26]'
							  and SoLanIn = @SoLanIn - 1

						-- Chi tieu [27]
						Select @TG27 = dt.GTHHDV from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
						where NamToKhai = @Nam and KyToKhai = @Ky  and CodeGT = '[27]'
							  and SoLanIn = @SoLanIn - 1

						-- Chi tieu [28]
						Select @TG28 = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
						where NamToKhai = @Nam and KyToKhai = @Ky  and CodeThue = '[28]'
							  and SoLanIn = @SoLanIn - 1

						-- Chi tieu [29]
						Select @TG29 = dt.GTHHDV from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
						where NamToKhai = @Nam and KyToKhai = @Ky  and CodeGT = '[29]'
							  and SoLanIn = @SoLanIn - 1

						-- Chi tieu [30]
						Select @TG30 = dt.GTHHDV from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
						where NamToKhai = @Nam and KyToKhai = @Ky  and CodeGT = '[30]'
							  and SoLanIn = @SoLanIn - 1

						-- Chi tieu [31]

						Select @TG31 = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 

						where NamToKhai = @Nam and KyToKhai = @Ky  and CodeThue = '[31]'

							  and SoLanIn = @SoLanIn - 1

						-- Chi tieu [32]
						Select @TG32 = dt.GTHHDV from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
						where NamToKhai = @Nam and KyToKhai = @Ky  and CodeGT = '[32]'
							  and SoLanIn = @SoLanIn - 1

						-- Chi tieu [33]
						Select @TG33 = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
						where NamToKhai = @Nam and KyToKhai = @Ky  and CodeThue = '[33]'
							  and SoLanIn = @SoLanIn - 1

						-- Chi tieu [34]
						Select @TG34 = dt.GTHHDV from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
						where NamToKhai = @Nam and KyToKhai = @Ky  and CodeGT = '[34]'
							  and SoLanIn = @SoLanIn - 1

						-- Chi tieu [35]
						Select @TG35 = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
						where NamToKhai = @Nam and KyToKhai = @Ky  and CodeThue = '[35]'
							  and SoLanIn = @SoLanIn - 1

						-- Chi tieu [36]
						Select @TG36 = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
						where NamToKhai = @Nam and KyToKhai = @Ky  and CodeThue = '[36]'
							  and SoLanIn = @SoLanIn - 1

						-- Chi tieu [37]
						Select @TG37 = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
						where NamToKhai = @Nam and KyToKhai = @Ky  and CodeThue = '[37]'
							  and SoLanIn = @SoLanIn - 1

						-- Chi tieu [38]
						Select @TG38 = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
						where NamToKhai = @Nam and KyToKhai = @Ky  and CodeThue = '[38]'
							  and SoLanIn = @SoLanIn - 1

						-- Chi tieu [39]
						Select @TG39 = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
						where NamToKhai = @Nam and KyToKhai = @Ky  and CodeThue = '[39]'
							  and SoLanIn = @SoLanIn - 1

						-- Chi tieu [40a]
						Select @TG40a = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
						where NamToKhai = @Nam and KyToKhai = @Ky  and CodeThue = '[40a]'
							  and SoLanIn = @SoLanIn - 1

						-- Chi tieu [40b]
						Select @TG40b = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
						where NamToKhai = @Nam and KyToKhai = @Ky  and CodeThue = '[40b]'
							  and SoLanIn = @SoLanIn - 1

						-- Chi tieu [40]
						Select @TG40 = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
						where NamToKhai = @Nam and KyToKhai = @Ky  and CodeThue = '[40]'
							  and SoLanIn = @SoLanIn - 1

						-- Chi tieu [41]
						Select @TG41 = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
						where NamToKhai = @Nam and KyToKhai = @Ky  and CodeThue = '[41]'
							  and SoLanIn = @SoLanIn - 1

						-- Chi tieu [42]
						Select @TG42 = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
						where NamToKhai = @Nam and KyToKhai = @Ky  and CodeThue = '[42]'
							  and SoLanIn = @SoLanIn - 1

						-- Chi tieu [43]
						Select @TG43 = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
						where NamToKhai = @Nam and KyToKhai = @Ky  and CodeThue = '[43]'
							  and SoLanIn = @SoLanIn - 1
				End
	End
Else If @DeclareType = 2 --Tờ khai theo quý
	Begin 
				if @Ky = 1
				BEGIN
					set @QuyTruoc = 4
					set @NamTruoc = @Nam - 1
				END
				else
				BEGIN
					set @QuyTruoc = @Ky - 1
					set @NamTruoc = @Nam
				END
				If @InLanDau = 1 
					Begin
							-- Chi tieu [22]
							select @TG22 = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
							where NamToKhai = @NamTruoc and QuyToKhai = @QuyTruoc
							and CodeThue = '[43]'
							If @IsInputAppendix = 1 --Trường hợp tờ khai có check vào lấy phụ lục mua vào
							Begin
									-- Chi tieu [23], [24]
									Select @TG23 = sum(TTien), @TG24 = sum(Thue) from MVATIn mst inner join DVATIn dt on 
									mst.MVATInID = dt.MVATInID
									where  MaLoaiThue  in (1,2,3)
									and QuyBKMV = @Ky and NamBKMV = @Nam

									-- Chi tieu [25]
									Select @TG25 = Sum(Thue) From MVATIn mst inner join DVATIn dt on 
									mst.MVATInID = dt.MVATInID  
									where MaLoaiThue in (1,3)
									and QuyBKMV = @Ky and NamBKMV = @Nam
							End
							Else --Trường hợp tờ khai có check vào không lấy phụ lục mua vào
								Select @TG23 =0, @TG24 = 0, @TG25 = 0

							If @IsOutputAppendix = 1 --Trường hợp tờ khai có check vào lấy phụ lục bán ra
							Begin
									-- Chi tieu [26]
									Select  @TG26 = sum(TTien) From MVATOut mst inner join DVATout dt on 
									mst.MVATOutID = dt.MVATOutID 
									where dt.MaThue = 'KT'
									and QuyBKBR = @Ky and NamBKBR = @Nam

									-- Chi tieu [29]
									Select @TG29 = sum(TTien) From  MVATOut mst inner join DVATout dt on 
									mst.MVATOutID = dt.MVATOutID 
									where  MaThue = '00'
									and QuyBKBR = @Ky and NamBKBR = @Nam

									-- Chi tieu [30], [31]
									Select @TG30 = sum(TTien), @TG31 = sum(Thue) From  MVATOut mst inner join DVATout dt on 
									mst.MVATOutID = dt.MVATOutID 
									where  MaThue = '05'
									and QuyBKBR = @Ky and NamBKBR = @Nam

									-- Chi tieu [32], [33]
									Select @TG32 = sum(TTien), @TG33 = sum(Thue) From  MVATOut mst inner join DVATout dt on 
									mst.MVATOutID = dt.MVATOutID 
									where  MaThue = '10'
									and QuyBKBR = @Ky and NamBKBR = @Nam
							End
							Else --Trường hợp tờ khai có check vào không lấy phụ lục bán
								Select @TG26 = 0, @TG29 = 0, @TG30 = 0, @TG31 = 0, @TG32 = 0, @TG33 = 0

							-- Chi tieu [27]=29+30+32
							set @TG27 = isnull(@TG29,0) + isnull(@TG30,0) + isnull(@TG32,0)

							-- Chi tieu [28] = 31+33
							set @TG28 = isnull(@TG31,0) + isnull(@TG33,0)

							-- Chi tieu [34] = 26+27
							set @TG34 = isnull(@TG26,0) + isnull(@TG27,0)

							-- Chi tieu [35] = 28
							set @TG35 = isnull(@TG28,0)

							-- Chi tieu [36] = [35] - [25]
							set @TG36 = isnull(@TG35,0) - isnull(@TG25,0)

							-- Chi tieu [37]
							Select  @TG37 = sum(Totalps) from MT36 
							Where MaLCTThue in (5,2) 
							and QuyKTT = @QuyTruoc and Year(NgayCt) = @NamTruoc

							-- Chi tieu [38]
							Select  @TG38 = sum(Totalps) from MT36 
							Where MaLCTThue in (4,3) 
							and QuyKTT = @QuyTruoc and Year(NgayCt) = @NamTruoc

							-- Chi tieu [40a] = 36 - 22 + 37 - 38 -39 > 0 va [41]
							set @TG40a = isnull(@TG36,0) - isnull(@TG22,0) + isnull(@TG37,0) - isnull(@TG38,0) - isnull(@TG39,0)

							if @TG40a < 0 
							BEGIN
								set @TG41 = -@TG40a
								set @TG40a = 0
							END

							-- Chi tieu [40]=40a-40b	
							set @TG40 = isnull(@TG40a,0) - isnull(@TG40b,0)

							-- Chi tieu [43] = [41] - [42]
							set @TG43 = isnull(@TG41,0) - isnull(@TG42,0)
						end
					Else
						Begin
							-- Chi tieu [21]
							select @TG22 = dt.GTHHDV from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
							where NamToKhai = @Nam and QuyToKhai = @Ky  and CodeGT = N'[21]'
								  and SoLanIn = @SoLanIn - 1

							-- Chi tieu [22]
							select @TG22 = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
							where NamToKhai = @Nam and QuyToKhai = @Ky  and CodeThue = N'[22]'
								  and SoLanIn = @SoLanIn - 1

							-- Chi tieu [23]
							Select @TG23 = dt.GTHHDV from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
							where NamToKhai = @Nam and QuyToKhai = @Ky  and CodeGT = N'[23]'
								  and SoLanIn = @SoLanIn - 1

							-- Chi tieu [24]
							Select @TG24 = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
							where NamToKhai = @Nam and QuyToKhai = @Ky  and CodeThue = N'[24]'
								  and SoLanIn = @SoLanIn - 1

							-- Chi tieu [25]
							Select @TG25 = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
							where NamToKhai = @Nam and QuyToKhai = @Ky  and CodeThue = N'[25]'
								  and SoLanIn = @SoLanIn - 1

							-- Chi tieu [26]
							Select @TG24 = dt.GTHHDV from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
							where NamToKhai = @Nam and QuyToKhai = @Ky  and CodeGT = N'[26]'
								  and SoLanIn = @SoLanIn - 1

							-- Chi tieu [27]
							Select @TG27 = dt.GTHHDV from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
							where NamToKhai = @Nam and QuyToKhai = @Ky  and CodeGT = N'[27]'
								  and SoLanIn = @SoLanIn - 1

							-- Chi tieu [28]
							Select @TG28 = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
							where NamToKhai = @Nam and QuyToKhai = @Ky  and CodeThue = N'[28]'
								  and SoLanIn = @SoLanIn - 1

							-- Chi tieu [29]
							Select @TG29 = dt.GTHHDV from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
							where NamToKhai = @Nam and QuyToKhai = @Ky  and CodeGT = N'[29]'
								  and SoLanIn = @SoLanIn - 1

							-- Chi tieu [30]
							Select @TG30 = dt.GTHHDV from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
							where NamToKhai = @Nam and QuyToKhai = @Ky  and CodeGT = N'[30]'
								  and SoLanIn = @SoLanIn - 1

							-- Chi tieu [31]

							Select @TG31 = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 

							where NamToKhai = @Nam and QuyToKhai = @Ky  and CodeThue = N'[31]'

								  and SoLanIn = @SoLanIn - 1

							-- Chi tieu [32]
							Select @TG32 = dt.GTHHDV from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
							where NamToKhai = @Nam and QuyToKhai = @Ky  and CodeGT = N'[32]'
								  and SoLanIn = @SoLanIn - 1

							-- Chi tieu [33]
							Select @TG33 = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
							where NamToKhai = @Nam and QuyToKhai = @Ky  and CodeThue = N'[33]'
								  and SoLanIn = @SoLanIn - 1

							-- Chi tieu [34]
							Select @TG34 = dt.GTHHDV from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
							where NamToKhai = @Nam and QuyToKhai = @Ky  and CodeGT = N'[34]'
								  and SoLanIn = @SoLanIn - 1

							-- Chi tieu [35]
							Select @TG35 = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
							where NamToKhai = @Nam and QuyToKhai = @Ky  and CodeThue = N'[35]'
								  and SoLanIn = @SoLanIn - 1

							-- Chi tieu [36]
							Select @TG36 = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
							where NamToKhai = @Nam and QuyToKhai = @Ky  and CodeThue = N'[36]'
								  and SoLanIn = @SoLanIn - 1

							-- Chi tieu [37]
							Select @TG37 = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
							where NamToKhai = @Nam and QuyToKhai = @Ky  and CodeThue = N'[37]'
								  and SoLanIn = @SoLanIn - 1

							-- Chi tieu [38]
							Select @TG38 = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
							where NamToKhai = @Nam and QuyToKhai = @Ky  and CodeThue = N'[38]'
								  and SoLanIn = @SoLanIn - 1

							-- Chi tieu [39]
							Select @TG39 = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
							where NamToKhai = @Nam and QuyToKhai = @Ky  and CodeThue = N'[39]'
								  and SoLanIn = @SoLanIn - 1

							-- Chi tieu [40a]
							Select @TG40a = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
							where NamToKhai = @Nam and QuyToKhai = @Ky  and CodeThue = N'[40a]'
								  and SoLanIn = @SoLanIn - 1

							-- Chi tieu [40b]
							Select @TG40b = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
							where NamToKhai = @Nam and QuyToKhai = @Ky  and CodeThue = N'[40b]'
								  and SoLanIn = @SoLanIn - 1

							-- Chi tieu [40]
							Select @TG40 = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
							where NamToKhai = @Nam and QuyToKhai = @Ky  and CodeThue = N'[40]'
								  and SoLanIn = @SoLanIn - 1

							-- Chi tieu [41]
							Select @TG41 = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
							where NamToKhai = @Nam and QuyToKhai = @Ky  and CodeThue = N'[41]'
								  and SoLanIn = @SoLanIn - 1

							-- Chi tieu [42]
							Select @TG42 = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
							where NamToKhai = @Nam and QuyToKhai = @Ky  and CodeThue = N'[42]'
								  and SoLanIn = @SoLanIn - 1

							-- Chi tieu [43]
							Select @TG43 = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
							where NamToKhai = @Nam and QuyToKhai = @Ky  and CodeThue = N'[43]'
								  and SoLanIn = @SoLanIn - 1
						End
	End
--In ket qua 
select   @TG22 as TG22 
		,@TG23 as TG23 
		,@TG24 as TG24 
		,@TG25 as TG25 
		,@TG26 as TG26 
		,@TG27 as TG27 
		,@TG28 as TG28 
		,@TG29 as TG29 
		,@TG30 as TG30 
		,@TG31 as TG31 
		,@TG32 as TG32 
		,@TG33 as TG33 
		,@TG34 as TG34 
		,@TG35 as TG35 
		,@TG36 as TG36 
		,@TG37 as TG37 
		,@TG38 as TG38 
		,@TG39 as TG39 
		,@TG40 as TG40 
		,@TG40a as TG40a
		,@TG40b as TG40b
		,@TG41  as TG41 
		,@TG42  as TG42 
		,@TG43  as TG43 



			