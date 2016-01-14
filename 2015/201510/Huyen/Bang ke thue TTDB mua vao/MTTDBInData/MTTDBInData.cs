using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Plugins;
using CDTLib;
using DevExpress.XtraEditors;
using System.Data;
using CDTDatabase;

namespace MTTDBInData
{
    class MTTDBInData : ICData
    {
         #region "Private variables"

        private InfoCustomData _info;
        private DataCustomData _data; 
        private string _TableName = string.Empty;
        private const string _APPLYTABLE = "MTTDBIn";
        #endregion "Private variables"
        //Lệ Huyền create ngày 28/12/2015
        //Kiểm tra trước khi lưu và xóa
        #region "Constructors"

        public MTTDBInData()
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
            _TableName = _data.DrTableMaster["TableName"].ToString();
            if (_data.CurMasterIndex < 0) return;
            if (_APPLYTABLE.Contains(_TableName))
            {
                DataView dvMst = new DataView(_data.DsData.Tables[0]);
                string query = string.Empty;
                object exists = null;
                DataRowView drv = null;
                // kiểm tra tồn tại của bảng kê khi thêm mới
                dvMst.RowStateFilter = DataViewRowState.Added;
                if (dvMst.Count > 0)
                {
                    drv = dvMst[0];
                    query = string.Format(@"select Top 1 1  from  MTTDBIn
                where (Case when {0} = 1 then KyBKMVTTDB end) = {1}
                or
               (Case when {0} = 2 then InputDate end) = cast('{2}' as datetime)
                and NamBKMVTTDB = {3}", drv["DeclareType"].ToString(), drv["KyBKMVTTDB"].ToString() == "" ? "NULL" : drv["KyBKMVTTDB"].ToString(), drv["InputDate"].ToString() == "" ? DateTime.Now.Date.ToShortDateString() : drv["InputDate"].ToString(), NamTaiChinh());
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
                    drv = dvMst[0];
                    query = string.Format(@"select  Top 1 1  from  MToKhaiTTDB
                    where IsInputAppendix = 1 and
                    (Case when {0} = 1 then KyToKhaiTTDB end) = {1}  or
                    (Case when {0} = 2 then InputDate end) = cast('{2}' as datetime)
                    and NamToKhaiTTDB = {3}", drv["DeclareType"].ToString(), drv["KyBKMVTTDB"].ToString() == "" ? "NULL" : drv["KyBKMVTTDB"].ToString(), drv["InputDate"].ToString() == "" ? DateTime.Now.ToShortDateString() : drv["InputDate"].ToString(), NamTaiChinh());
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
