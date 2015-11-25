using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using CDTControl;
using CDTDatabase;
using CDTLib;
using DevExpress.XtraEditors;
using DevExpress.XtraEditors.Repository;
using DevExpress.XtraGrid;
using DevExpress.XtraGrid.Columns;
using DevExpress.XtraGrid.Views.Base;
using DevExpress.XtraGrid.Views.Grid;
using DevExpress.XtraGrid.Views.Grid.ViewInfo;
using DevExpress.XtraEditors.DXErrorProvider;
using DevExpress.XtraEditors.Controls;


namespace FormChinhSachGia
{
    public partial class FrmCSGTheoKH : DevExpress.XtraEditors.XtraForm
    {
        #region "Variables"

        private DataRow _drCurMaster;
        private DataRow _drCurDetail;
        private DataTable _dtVT = null;
        public DataView Result = null;
        private Database _dbData1 = Database.NewDataDatabase();
        private Database _dbData2 = Database.NewDataDatabase();
        private bool _isUserUnchecked = false;
        

        #endregion

        //[Lệ Huyền] Tạo mới [05/11/2015]
        // Tạo mới màn hình chính sách giá bán vật tư theo khách hàng
        //[Lệ Huyền] update [25/11/2015]
        public FrmCSGTheoKH(DataRow drCurMaster, DataRow drCurDetail)
        {
            InitializeComponent();
            _drCurMaster = drCurMaster;
            _drCurDetail = drCurDetail;
        }

        #region "Method"

        /// <summary>
        /// Init
        /// </summary>
        private void InitData()
        {
            string sql = @"SELECT d.MaKH,  k.TenKH,  d.MaVT, v.TenVT,  d.MaDVT,  d.Gia
                            FROM DMChinhSachGia d inner join DMKH k on d.MaKH=k.MaKH
                                   inner join DMVT v on d.MaVT=v.MaVT
                            Where d.MaKH = '" + _drCurMaster["MaKH"].ToString() + "'";
            _dtVT = _dbData1.GetDataTable(sql);
            DataColumn column = new DataColumn("Check", typeof(Boolean));
            column.DefaultValue = false;
            _dtVT.Columns.Add(column);
            gcPN.DataSource = _dtVT;
            gvPN.ExpandAllGroups();
            gvPN.BestFitColumns();
        }
        /// <summary>
        /// Format column
        /// </summary>
        private void FormatColumnString()
        {
            clGia.DisplayFormat.FormatString = FormatString.GetReportFormat("Gia");
        }
        /// <summary>
        /// Check/Uncheck All
        /// </summary>
        public void SelectAll(bool isSelectAll)
        {
            if (_isUserUnchecked)
                return;
            for (int i = 0; i < gvPN.DataRowCount; i++)
            {
                DataRow row = gvPN.GetDataRow(i) as DataRow;
                row["Check"] = isSelectAll;
            }
            _isUserUnchecked = false;

        }

        /// <summary>
        /// Handling node Save
        /// </summary>
        private void HandlingSave()
        {

            DataView dv = new DataView(_dtVT);
            dv.RowFilter = "Check = true";
            if (dv.Count > 0)
            {
                foreach (DataRowView drv in dv)
                {
                    string strTemp1 = drv["MaVT"].ToString();
                    string strTemp2 = drv["MaDVT"].ToString();
                    string _sql = @"Select MaVT, MaDVT from wTonKhoTucThoi Where MaVT = '" + strTemp1 + "' and MaDVT = '" + strTemp2 + "'";
                    DataTable dt = _dbData2.GetDataTable(_sql);
                    DataView dv2 = new DataView(dt);
                    
                    if (dv2.Count == 0)
                    {
                        drv["Check"] = "false";
                        drv.Row.SetColumnError("MaVT", "Vật tư chưa nhập kho");
                        string msg = "Vật tư chưa nhập kho, vui lòng chon vật tư khác hoặc nhập kho vật tư hiện tại";
                        if (Config.GetValue("Language").ToString() == "1")
                            msg = UIDictionary.Translate(msg);
                        XtraMessageBox.Show(msg);
                    }

                }

            }
            if (dv.Count > 0)
            {
                Result = dv;
                this.DialogResult = DialogResult.OK;
                this.Close();
            }
            else
            {
                string msg = "Phải chọn ít nhất một Vật tư!";
                if (Config.GetValue("Language").ToString() == "1")
                    msg = UIDictionary.Translate(msg);
                XtraMessageBox.Show(msg);
                return;
            }
           
                
        }
        /// <summary>
        /// Handling node repositoryItemCheckEdit
        /// </summary>
        private bool SelectIndex()
        { 
            gvPN.FocusedRowHandle++;
            string cellValue;
            for (int i = 0; i < gvPN.DataRowCount; i++)
            {
                cellValue = gvPN.GetRowCellValue(i, "Check").ToString();
                if (cellValue == "False")
                    return true;
            }
            return false;
        }

        #endregion


        #region "Event"

        /// <summary>
        /// Form Load
        /// </summary>
        private void FormCSGTheoKH_Load(object sender, EventArgs e)
        {
            FormatColumnString();
            InitData();
            this.KeyPreview = true;
            this.KeyUp += new KeyEventHandler(FrmCSGTheoKH_KeyUp);
            this.repositoryItemCheckEdit1.CheckStateChanged += new EventHandler(Checkchange);
            if (Config.GetValue("Language").ToString() != "0")
                FormFactory.DevLocalizer.Translate(this);
        }

        ///<summary>
        /// Handling KeyUp
        /// </summary>
        private void FrmCSGTheoKH_KeyUp(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.F12)
            {
                gvPN.FocusedRowHandle++;
                HandlingSave();
            }
            else if (e.KeyCode == Keys.Escape)
            {
                this.Close();
            }

        }
        /// <summary>
        /// Handling node Cancel
        /// </summary>
        private void btCancel_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
            this.Close();
        }
        /// <summary>
        /// Save
        /// </summary>
        private void btOk_Click(object sender, EventArgs e)
        {
            HandlingSave();
        }
        /// <summary>
        /// Handling Check/Uncheck All
        /// </summary>
        private void CheckAll_CheckedChanged(object sender, EventArgs e)
        {
            SelectAll(CheckAll.Checked);
        }
        /// <summary>
        /// Handling repositoryItemCheckEdit1 change
        /// </summary>
        private void Checkchange(object sender, EventArgs e)
        {
            if (SelectIndex() == true)
            {
                _isUserUnchecked = true;
                CheckAll.CheckState = CheckState.Unchecked;
            }
            else
            {
                _isUserUnchecked = false;
                CheckAll.CheckState = CheckState.Checked;
            }
        }

        #endregion
       
    }
        
 }