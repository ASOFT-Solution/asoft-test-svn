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
            DataRow dr = _data.DsData.Tables[0].Rows[_data.CurMasterIndex];
            if (dr.RowState == DataRowState.Deleted)
            {
                dr.RejectChanges();
		// Kiểm tra vật tư đã phát sinh chưa.
                string sql = string.Format("Select top 1  MaVT from BLVT where MaVT = {0}", dr["MaVT"]);
                if (_dbData.GetValue(sql) == null)
                {
                    dr.Delete();
                    _info.Result = true;
                }
                else
                {
                    XtraMessageBox.Show("Vật tư đã phát sinh, không được phép chỉnh sửa.");
                    dr.RejectChanges();
                    _info.Result = false;
                }
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
            DataRow dr = _data.DsData.Tables[0].Rows[_data.CurMasterIndex];
            if (dr.RowState == DataRowState.Added)
                return;
            DataSet dsCopy = _data.DsData.Copy();
            DataTable dt = dsCopy.Tables[0];
            DataRow drTemp = dt.Rows[_data.CurMasterIndex];
            drTemp.RejectChanges();
            string sql = string.Format("Select top 1  MaVT from BLVT where MaVT = {0}", drTemp["MaVT"]);
            if (_dbData.GetValue(sql) != null)
            {
                if (dr["MaVT"] == drTemp["MaVT"]) //Nếu không sửa mã vật tư thì được sửa các thông tin còn lại
                    _info.Result = true;
                else
                {
                    XtraMessageBox.Show("Vật tư đã phát sinh, không được phép chỉnh sửa.");
                    dr.RejectChanges();
                    _info.Result = false;
                }
            }
        }
    }
}
