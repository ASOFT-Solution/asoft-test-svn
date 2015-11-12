using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using DevExpress.XtraEditors;
using CDTDatabase;
using DevExpress.XtraGrid.Columns;
using DevExpress.XtraGrid;
using DevExpress.XtraGrid.Views.Grid;
using CDTControl;
using DevExpress.XtraGrid.Views.Base;
using CDTLib;

namespace ChinhSachGiaBan
{
    public partial class FrmChinhSach : DevExpress.XtraEditors.XtraForm
    {
        private DataRow _drCurMaster;
        private DataTable _dt;
        private Database _dbData = Database.NewDataDatabase();
        public DataView Result = null;
        private List<int> rowCheck = new List<int>();
        public FrmChinhSach(DataRow drCurMaster)
        {
            InitializeComponent();
            _drCurMaster = drCurMaster;
        }

        private void FrmChinhSach_Load(object sender, EventArgs e)
        {
            LoadData();
        }
        private void LoadData()
        {
            //Kiểm tra đã nhập kho chưa
            string sql = string.Format("SELECT d.MaKH, k.TenKH, d.MaVT, v.TenVT, d.MaDVT, d.Gia FROM DMChinhSachGia d inner join DMKH k on d.MaKH=k.MaKH inner join DMVT v on d.MaVT=v.MaVT Where d.MaKH = '{0}'", _drCurMaster["MaKH"]);
            _dt = _dbData.GetDataTable(sql);
            CreateCheckColumn();
            gcCS.DataSource = _dt;
            colGia.DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            colGia.DisplayFormat.FormatString = "{0:n0}";
            gvCS.ExpandAllGroups();
        }

        private void btClose_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void checkBox_CheckedChanged(object sender, EventArgs e)
        {
            if (checkBox.Checked) //Check hết vào tất cả các ô
            {
                foreach (DataRow dr in _dt.Rows)
                {
                    dr["Check"] = true;
                }
            }
            else //Bỏ check
            {
                foreach (DataRow dr in _dt.Rows)
                {
                    dr["Check"] = false;
                }
            }
            gvCS.RefreshData();
        }

        private void btSave_Click(object sender, EventArgs e)
        {
            SaveData();
        }
        private void SaveData()
        {
            DataView dv = new DataView(_dt);
            dv.RowFilter = "Check = true";
            if (dv.Count == 0) //Trường hợp chưa chọn vật tư
            {
                ShowMessageBox("Phải chọn ít nhất một vật tư");
            }
            else
            {
                for (int i = 0; i < dv.Count; i++)
                {
                    string sql = string.Format("Select * From wTonkhoTucThoi Where MaVT = '{0}' and MaDVT = '{1}'", dv[i]["MaVT"], dv[i]["MaDVT"]);
                    if (_dbData.GetValue(sql) == null) //Vật tư chưa nhập kho thì xóa khỏi Dataview
                    {
                        dv.Delete(i);
                        ShowMessageBox("Vật tư chưa nhập kho, vui lòng chon vật tư khác hoặc nhập kho vật tư hiện tại");
                    }
                }
                Result = dv;
                this.Close();
            }

        }

        private void CreateCheckColumn() // Tạo thêm cột chọn
        {
            DataColumn column = new DataColumn("Check", typeof(Boolean));
            column.DefaultValue = false;
            _dt.Columns.Add(column);
        }

        private void FrmChinhSach_KeyDown(object sender, KeyEventArgs e)
        {
            switch (e.KeyCode)
            {
                case Keys.F12:
                    gvCS.FocusedRowHandle++; // Phải có dòng này để khi ấn phím F12 mới nhận đủ dữ liệu
                    SaveData();
                    break;
                case Keys.Escape:
                    this.Close();
                    break;
            }
        }
        private void ShowMessageBox(string msg)
        {
            if (Config.GetValue("Language").ToString() == "1")
            {
                msg = UIDictionary.Translate(msg);
            }
            XtraMessageBox.Show(msg);
        }
    }
}
