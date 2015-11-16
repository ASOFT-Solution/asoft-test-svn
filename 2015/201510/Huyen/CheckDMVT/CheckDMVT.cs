using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Plugins;
using System.Data;
using CDTDatabase;
using DevExpress.XtraEditors;
using CDTLib;


namespace CheckDMVT
{

    class CheckDMVT : ICData
    {
        private Database _dbData = Database.NewDataDatabase();
        DataCustomData _data;
        InfoCustomData _info;

        public CheckDMVT()
        {
            _info = new InfoCustomData(IDataType.Single);
        }
        //[Lệ Huyền] tạo mới ngày [2/11/2015]
        //Kiểm tra phát sinh của vật tư
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
        //[Lệ Huyền] tạo mới ngày [2/11/2015]
        //Updated ngày [11/11/2015]
        public void ExecuteBefore()
        {
            CheckData(DataViewRowState.Deleted, "Vật tư đã phát sinh, không được phép xóa.");
        }
        public void ExecuteBeforeCheckRules()
        {
            CheckData(DataViewRowState.ModifiedOriginal, "Vật tư đã phát sinh, không được phép chỉnh sửa.");
        }

        private void CheckData(DataViewRowState filterState, string errorMessage)
        {
            DataView dv = new DataView(_data.DsData.Tables[0]);
            dv.RowStateFilter = filterState;
            if (dv.Count == 0)
                return;
            DataRowView drv = dv[0];
            if (CheckExist(drv["MaVT"].ToString()))
            {
                _data.DsData.RejectChanges();
                ShowMessageBox(errorMessage);
                _info.Result = false;
            }
            else
            {
                _info.Result = true;
            }
        }

         private bool CheckExist(string maVT)
        {
            string _sqlCheckError = string.Format("Select top 1 MaVT from BLVT where MaVT = '{0}'", maVT);
            if (_dbData.GetValue(_sqlCheckError) != null)
            {
                return true;
            }
            return false;
        }

         private void ShowMessageBox(string msg)
         {
             if (Config.GetValue("Language").ToString() == "1")
                 msg = UIDictionary.Translate(msg);
             XtraMessageBox.Show(msg);
         }
        #endregion
    }
}
