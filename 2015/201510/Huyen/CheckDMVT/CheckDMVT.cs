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
            DataRow row1 = _data.DsData.Tables[0].Rows[_data.CurMasterIndex];
            if (row1.RowState != DataRowState.Deleted)
            {
                return;
            }
            row1.RejectChanges();
            string _sqlCheckError = string.Format("Select top 1 MaVT from BLVT where MaVT = '{0}'", row1["MaVT"]);
            if(_dbData.GetValue(_sqlCheckError) != null)
            {
                if (row1.RowState == DataRowState.Unchanged)
                {
                    row1.RejectChanges();
                    XtraMessageBox.Show("Vật tư đã phát sinh, không được phép xóa!");
                }
            }
            else
            {
                row1.Delete();
            }
        }
        public void ExecuteBeforeCheckRules()
        {
            DataRow row = _data.DsData.Tables[0].Rows[_data.CurMasterIndex];
            string _sqlCheckError = string.Format("Select top 1 MaVT from BLVT where MaVT = '{0}'", row["MaVT"]);
            _dbData = _data.DbData;
            if (row.RowState == DataRowState.Added)
            {
                return;
            }
            if (row.RowState == DataRowState.Modified)
            {
                DataSet dsCopy = _data.DsData.Copy();
                DataRow rowTemp = dsCopy.Tables[0].Rows[_data.CurMasterIndex];
                rowTemp.RejectChanges(); 
                string MaVT = row["MaVT"].ToString(); 
                if (row["MaVT"] != rowTemp["MaVT"])
                { 
                    MaVT = rowTemp["MaVT"].ToString();
                }
                string _sqlCheckErrorModified = string.Format("Select top 1 MaVT from BLVT where MaVT = '{0}'", MaVT);
                if (_dbData.GetValue(_sqlCheckErrorModified) != null)
                {
                    row.RejectChanges();
                    XtraMessageBox.Show("Vật tư đã phát sinh, không được phép chỉnh sửa!");
                    return;
                }
            }
        }
        #endregion
    }
}
