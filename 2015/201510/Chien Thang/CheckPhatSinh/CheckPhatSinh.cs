using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using Plugins;
using CDTLib;
using DevExpress.XtraEditors;
using CDTDatabase;

namespace CheckPhatSinh
{
    public class CheckPhatSinh : ICData
    {
        public CheckPhatSinh()
        {
            _info = new InfoCustomData(IDataType.Single);
        }
        private InfoCustomData _info;
        private DataCustomData _data;
        private Database _dbData = Database.NewDataDatabase();
        private DataView _dv;
        public DataCustomData Data
        {
            set
            {
                _data = value;
            }
        }
        public void ExecuteAfter()
        {

        }
        public void ExecuteBefore()
        {
            // [Chiến Thắng] Tạo mới 05/10/2015
            // Kiểm tra nếu dữ liệu đã phát sinh thì không cho chỉnh sửa mã vật tư.

            //Trường hợp xóa
            _dv = new DataView(_data.DsData.Tables[0]);
            _dv.RowStateFilter = DataViewRowState.Deleted; // Hiện thị dòng dữ liệu trước khi bị xóa
            if (_dv.Count == 0)
                return;
            DataRowView drv = _dv[0];
            if (CheckExist(drv["MaVT"].ToString())) // Kiểm tra dữ liệu đã phát sinh chưa
            {
                ShowMessageBox();
            }
            
        }
        public InfoCustomData Info
        {
            get
            {
                return _info;
            }
        }
        public void ExecuteBeforeCheckRules()
        {
            //Trường hợp sửa
            _dv = new DataView(_data.DsData.Tables[0]);
            string maVTModify = _dv[_data.CurMasterIndex]["MaVT"].ToString(); //Mã vật tư sau khi sửa
            _dv.RowStateFilter = DataViewRowState.ModifiedOriginal; // Hiện thị dòng dữ liệu trước khi được chỉnh sửa
            if (_dv.Count == 0)
                return;
            DataRowView drv = _dv[0];
            if (CheckExist(drv["MaVT"].ToString())) // Kiểm tra dữ liệu đã phát sinh chưa
            {
                if (drv["MaVT"].ToString() == maVTModify) // Kiểm tra mã vật tư trước khi sủa và sau khi sủa
                {
                    _info.Result = true;
                }
                    
                else
                {
                    ShowMessageBox();
                }
            }
        }
        private bool CheckExist(string maVT) // Kiểm tra dữ liệu đã phát sinh chưa
        {
            string sql = string.Format("Select top 1  MaVT from BLVT where MaVT = '{0}'", maVT);
            if (_dbData.GetValue(sql) != null)
                return true;
            return false;
        }
        private void ShowMessageBox()
        {
            _data.DsData.RejectChanges();
            string msg = "Vật tư đã phát sinh, không được phép chỉnh sửa.";
            if (Config.GetValue("Language").ToString() == "1")
            {
                msg = UIDictionary.Translate(msg);
            }
            XtraMessageBox.Show(msg);
            _info.Result = false;
        }
    }
}
