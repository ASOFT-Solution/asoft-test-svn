-- CTGS
if not exists (select top 1 1 from CTGS where SoHieu = 'CTT')
Insert into CTGS(SoHieu, NDKT, MaCT) Values ('CTT', N'Khấu trừ, điều chỉnh, hoàn thuế', 'CTT')
