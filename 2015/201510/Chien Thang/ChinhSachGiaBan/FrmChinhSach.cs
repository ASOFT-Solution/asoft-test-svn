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
using CDTControl;

namespace ChinhSachGiaBan
{
    public partial class FrmChinhSach : DevExpress.XtraEditors.XtraForm
    {
        private DataRow _drCurMaster;
        private DataTable _dt;
        private Database _dbData = Database.NewDataDatabase();
        public DataView Result = null;
        private int numRowCheck = 0;
        public List<int> RowChangeColor = new List<int>(); //Danh sách chứa các vật tư chưa nhập kho để đổi màu
        public FrmChinhSach(DataRow drCurMaster)
        {
            InitializeComponent();
            _drCurMaster = drCurMaster;
        }

        private void FrmChinhSach_Load(object sender, EventArgs e)
        {
            FormatColumnString();
            LoadData();
            if (Config.GetValue("Language").ToString() != "0")
                FormFactory.DevLocalizer.Translate(this);
        }
        private void LoadData()
        {
            //Kiểm tra đã nhập kho chưa
            string sql = string.Format("SELECT d.MaKH, k.TenKH, d.MaVT, v.TenVT, d.MaDVT, d.Gia FROM DMChinhSachGia d inner join DMKH k on d.MaKH=k.MaKH inner join DMVT v on d.MaVT=v.MaVT Where d.MaKH = '{0}'", _drCurMaster["MaKH"]);
            _dt = _dbData.GetDataTable(sql);
            CreateCheckColumn();
            gcCS.DataSource = _dt;
            gvCS.ExpandAllGroups();
        }
        private void FormatColumnString() //Định dạng lại kiểu hiện thị dữ liệu
        {
            colGia.DisplayFormat.FormatString = FormatString.GetReportFormat("DonGia");
        }

        private void btClose_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btSave_Click(object sender, EventArgs e)
        {
            SaveData();
        }
        private void SaveData()
        {
            RowChangeColor.Clear();
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
                    if (_dbData.GetValue(sql) == null) //Vật tư chưa nhập kho thì đưa vào List để đổi màu
                    {
                        int rowIndex = _dt.Rows.IndexOf(dv[i].Row); //Lấy vị trí của dòng chưa nhập kho
                        RowChangeColor.Add(rowIndex);
                        gvCS.RefreshRow(rowIndex);
                    }
                }
                if (RowChangeColor.Count > 0)
                {
                    ShowMessageBox("Vật tư chưa nhập kho, vui lòng chon vật tư khác hoặc nhập kho vật tư hiện tại");
                }
                else
                {
                    Result = dv;
                    this.Close();
                }
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

        private void gvCS_RowStyle(object sender, RowStyleEventArgs e) //Sự kiện đổi màu dòng
        {
            try
            {
                for (int i = 0; i < RowChangeColor.Count; i++)
                {
                    if (RowChangeColor[i] == e.RowHandle)
                        e.Appearance.BackColor = Color.Red;
                }
            }
            catch
            {
            }
        }

        private void gvCS_CellValueChanging(object sender, CellValueChangedEventArgs e)
        {
            if (e.Column.FieldName != "Check")
                return;
            if (e.Value.Equals(true)) //Khi check sẽ tăng biến đếm lên
                numRowCheck++;
            else
                numRowCheck--;
            if (numRowCheck == gvCS.DataRowCount) //Nếu biến đếm bằng với số dòng trong Gridview thì check vào ô check all
                checkBox.Checked = true;
            else
                checkBox.Checked = false;
        }

        private void checkBox_Click(object sender, EventArgs e)
        {
            if (checkBox.Checked) //Check hết vào tất cả các ô
            {
                foreach (DataRow dr in _dt.Rows)
                {
                    dr["Check"] = true;
                    numRowCheck = gvCS.DataRowCount;
                }
            }
            else //Bỏ check
            {
                foreach (DataRow dr in _dt.Rows)
                {
                    dr["Check"] = false;
                    numRowCheck = 0;
                }
            }
            gvCS.RefreshData();
        }
    }
}
