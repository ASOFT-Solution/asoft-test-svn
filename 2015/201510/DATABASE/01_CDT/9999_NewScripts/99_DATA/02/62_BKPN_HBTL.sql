-- [ACC_MAXPRO] Bảng kê phiếu nhập hàng trả lại ko thể hiện chứng từ
Use CDT

Update sysReport set 
Query = N'Select mt.*, dt.*, v.ThueNT as ThueNT, v.Thue as Thue, 
case when @@lang = 1 then dmkh.tenkh2 else dmkh.tenkh end as tenkh, 
case when @@lang = 1 then vt.tenvt2 else vt.tenvt end as tenvt
From MT33 mt, DT33 dt, dmkh, VatOut v, dmvt vt 
where mt.mt33id = dt.mt33id 
and dt.mt33id *= v.mtid and dt.dt33id *= v.mtiddt
and mt.makh = dmkh.makh
and vt.mavt = dt.mavt and @@ps'
where ReportName = N'Bảng kê phiếu nhập hàng bán trả lại'