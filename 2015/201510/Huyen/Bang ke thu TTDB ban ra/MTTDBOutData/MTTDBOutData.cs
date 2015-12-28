using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Plugins;
using System.Windows.Forms;
using System.Data;
using DevExpress.XtraEditors;
using CDTLib;
using CDTDatabase;

namespace MTTDBOutData
{
    public class MTTDBOutData : ICData
    {
        #region "Private variables"

        private InfoCustomData _info;
        private DataCustomData _data;

        #endregion "Private variables"
        //Lệ Huyền create ngày 22/12/2015
        //Kiểm tra trước khi lưu và xóa
        #region "Constructors"

        public MTTDBOutData()
        {
            _info = new InfoCustomData(IDataType.MasterDetailDt);
        }

        #endregion "Constructors"

        #region ICData Members

        public DataCustomData Data
        {
            set { _data = value; }
        }
        public InfoCustomData Info
        {
            get { return _info; }
        }
        public void ExecuteAfter()
        {
        }
        public void ExecuteBefore()
        {
            DataView dvMst = new DataView(_data.DsData.Tables[0]);
            string query = string.Empty;
            DataRowView drv = dvMst[0];

            query = string.Format(@"select NgayHd as NgayHD, NgayCt, Sohoadon as SoHoaDon, SoSerie as SoSeries,TenKH, TenVT, SoLuong_TTDB as SoLuong, GiaNT_TTDB as GiaNT, Gia_TTDB as Gia, PSNT_TTDB as PsNT
                            , PS_TTDB as Ps, TienTTDBNT, TienTTDB, PS1NT_TTDB as Ps1NT, PS1_TTDB as Ps1 ,MaNhomTTDB, ThueSuatTTDB
                        from TTDBOut where year(NgayCt) = {0}
                       and 
                       (Case when {1} = 1 then month(NgayCt) end) = {2}
                       or
                       (Case when {1} = 2 then NgayCt end) = cast('{3}' as Datetime)", NamTaiChinh(), drv["DeclareType"].ToString(), drv["KyBKBRTTDB"].ToString(), drv["InputDate"].ToString() == "" ? DateTime.Now.ToShortDateString() : drv["InputDate"].ToString());
            DataSet table = _data.DbData.GetDataSet(query);
            object exists = null;
            // kiểm tra tồn tại của bảng kê khi thêm mới
            dvMst.RowStateFilter = DataViewRowState.Added;
            if (dvMst.Count > 0)
            {

                query = string.Format(@"select 1 from  MTTDBOut 
                                where (Case when {0} = 1 then KyBKBRTTDB end) = {1}
                                or
                               (Case when {0} = 2 then InputDate end) = cast('{2}' as datetime)
                                and NamBKBRTTDB = {3}", dvMst[0]["DeclareType"].ToString(), dvMst[0]["KyBKBRTTDB"].ToString(), dvMst[0]["InputDate"].ToString() == "" ? DateTime.Now.ToShortDateString() : dvMst[0]["InputDate"].ToString(), NamTaiChinh());
                exists = _data.DbData.GetValue(query);


                if (exists != null)
                {
                    ShowMessageBox("Bảng kê đã tồn tại!");
                    _info.Result = false;
                    return;
                }
                else
                {
                    _info.Result = true;

                }
            }
            // kiểm tra bảng kê đã được sử dụng hay chưa trước khi xóa
            dvMst.RowStateFilter = DataViewRowState.Deleted;
            if (dvMst.Count > 0)
            {
                query = string.Format(@"Select 1 from  MToKhaiTTDB Where IsOutputAppendix = 1 and  (Case when {0} = 1 then KyToKhaiTTDB end) = {1}  or
                                (Case when {0} = 2 then InputDate end) = cast('{2}' as datetime)
                                and NamToKhaiTTDB = {3}", dvMst[0]["DeclareType"].ToString(), dvMst[0]["KyBKBRTTDB"].ToString(), dvMst[0]["InputDate"].ToString() == "" ? DateTime.Now.ToShortDateString() : dvMst[0]["InputDate"].ToString(), NamTaiChinh());
                exists = _data.DbData.GetValue(query);
                if (exists != null)
                {
                    ShowMessageBox("Bảng kê được sử dụng bên tờ khai, bạn không được phép xóa.!");
                    _info.Result = false;
                    return;
                }
                else
                {
                    _info.Result = true;
                }
            }
        }
        public void ExecuteBeforeCheckRules()
        {

        }

        #endregion ICData Members

        #region "Private Methods"
        
        private int NamTaiChinh()
        {
            return (Config.GetValue("NamLamViec") == null ? -1 : int.Parse(Config.GetValue("NamLamViec").ToString()));
        }
        private void ShowMessageBox(string msg)
        {
            if (Config.GetValue("Language").ToString() == "1")
                msg = UIDictionary.Translate(msg);
            XtraMessageBox.Show(msg);
        }

        #endregion "Private Methods"

    }
}
