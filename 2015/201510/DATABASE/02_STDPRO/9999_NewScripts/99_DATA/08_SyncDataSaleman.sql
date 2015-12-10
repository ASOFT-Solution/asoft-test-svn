-- Update dữ liệu field Saleman mới thêm vào BLTK đối với các KH đã sử dụng dữ liệu Saleman ở các nghiệp vụ MT31, MT32, MT33, MT43 để lên báo cáo
-- Chi tiết công nợ phải thu theo nhân viên
Update BLTK set Saleman = (select Saleman from MT31 mt where mt.MT31ID = MTID and mt.Saleman is not null)
where MTID IN (select MT31ID from MT31 where Saleman is not null) and Saleman is null

Update BLTK set Saleman = (select Saleman from MT32 mt where mt.MT32ID = MTID and mt.Saleman is not null)
where MTID IN (select MT32ID from MT32 where Saleman is not null) and Saleman is null

Update BLTK set Saleman = (select Saleman from MT33 mt where mt.MT33ID = MTID and mt.Saleman is not null)
where MTID IN (select MT33ID from MT33 where Saleman is not null) and Saleman is null

Update BLTK set Saleman = (select Saleman from MT43 mt where mt.MT43ID = MTID and mt.Saleman is not null)
where MTID IN (select MT43ID from MT43 where Saleman is not null) and Saleman is null