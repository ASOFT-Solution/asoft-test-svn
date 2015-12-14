using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using DevExpress.XtraEditors;
using CDTLib;
using CDTDatabase;
using System.Globalization;
using CDTControl;
using DevExpress.XtraGrid.Views.Base;
using DevExpress.XtraGrid.Columns;
using System.Collections;
using System.Data.SqlClient;
using DevExpress.XtraEditors.Repository;

namespace ToKhaiThueGTGT
{
    public partial class LaySoLieu : DevExpress.XtraEditors.XtraForm
    {
        #region ---- Enums, Structs, Constants ----

        private const string CT21 = "[21]";
        private const string CT22 = "[22]";
        private const string CT23 = "[23]";
        private const string CT24 = "[24]";
        private const string CT25 = "[25]";
        private const string CT26 = "[26]";
        private const string CT27 = "[27]";
        private const string CT28 = "[28]";
        private const string CT29 = "[29]";
        private const string CT30 = "[30]";
        private const string CT31 = "[31]";
        private const string CT32 = "[32]";
        private const string CT33 = "[33]";
        private const string CT34 = "[34]";
        private const string CT35 = "[35]";
        private const string CT36 = "[36]";
        private const string CT37 = "[37]";
        private const string CT38 = "[38]";
        private const string CT39 = "[39]";
        private const string CT40a = "[40a]";
        private const string CT40b = "[40b]";
        private const string CT40 = "[40]";
        private const string CT41 = "[41]";
        private const string CT42 = "[42]";
        private const string CT43 = "[43]";

        public enum FormAction
        {
            Edit,
            AddNew
        }

        #endregion

        #region ---- Member variables ----

        private CDTDatabase.Database _Database = null;
        private string _MToKhaiID = string.Empty;
        private int _NamTaiChinh = -1;
        private int _Ky = -1;
        private DateTime _NgapLap = DateTime.MinValue;
        private string _DienGiai = string.Empty;
        private bool _InLanDau = false;
        private bool _IsPeriod = false;
        private int _BoSungLan = int.MinValue;
        private Dictionary<int, bool[]> _EditStatus = null;
        private DataTable _DataMain = null;
        private FormAction _Action = FormAction.AddNew;

        private double _TG22 = 0;
        private double _TG23 = 0;
        private double _TG24 = 0;
        private double _TG25 = 0;
        private double _TG26 = 0;
        private double _TG27 = 0;
        private double _TG28 = 0;
        private double _TG29 = 0;
        private double _TG30 = 0;
        private double _TG31 = 0;
        private double _TG32 = 0;
        private double _TG33 = 0;
        private double _TG34 = 0;
        private double _TG35 = 0;
        private double _TG36 = 0;
        private double _TG37 = 0;
        private double _TG38 = 0;
        private double _TG39 = 0;
        private double _TG40 = 0;
        private double _TG40a = 0;
        private double _TG40b = 0;
        private double _TG41 = 0;
        private double _TG42 = 0;
        private double _TG43 = 0;

        private double _TG23_bk = 0;
        private double _TG24_bk = 0;
        private double _TG25_bk = 0;
        private double _TG26_bk = 0;
        private double _TG27_bk = 0;
        private double _TG28_bk = 0;
        private double _TG29_bk = 0;
        private double _TG30_bk = 0;
        private double _TG31_bk = 0;
        private double _TG32_bk = 0;
        private double _TG33_bk = 0;
        private double _TG34_bk = 0;
        private double _TG35_bk = 0;
        private double _TG36_bk = 0;
        private bool _HasClearData = false;

        #endregion

        #region ---- Properties ----

        public string MToKhaiID
        {
            get
            {
                return _MToKhaiID;
            }
            set
            {
                _MToKhaiID = value;
            }
        }

        public int Ky
        {
            get
            {
                return _Ky;
            }
            set
            {
                _Ky = value;
            }
        }

        public DateTime NgapLap
        {
            get
            {
                return _NgapLap;
            }
            set
            {
                _NgapLap = value;
            }
        }

        public string DienGiai
        {
            get
            {
                return _DienGiai;
            }
            set
            {
                _DienGiai = value;
            }
        }

        public bool InLanDau
        {
            get
            {
                return _InLanDau;
            }
            set
            {
                _InLanDau = value;
            }
        }

        public bool IsPeriod
        {
            get
            {
                return _IsPeriod;
            }
            set
            {
                _IsPeriod = value;
            }
        }

        public int BoSungLan
        {
            get
            {
                return _BoSungLan;
            }
            set
            {
                _BoSungLan = value;
            }
        }

        public FormAction Action
        {
            get
            {
                return _Action;
            }
            set
            {
                _Action = value;
            }
        }

        #endregion

        #region ---- Constructors & Destructors ----

        public LaySoLieu()
        {
            InitializeComponent();
        }

        #endregion

        #region ---- Handle events ----

        /// <summary>
        /// LaySoLieu_Load
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void LaySoLieu_Load(object sender, EventArgs e)
        {
            this.FormatColumns();

            this._Database = Database.NewDataDatabase();
            _NamTaiChinh = Config.GetValue("NamLamViec") == null ? -1 : int.Parse(Config.GetValue("NamLamViec").ToString());

            gridView2.OptionsBehavior.Editable = true;
            InitialEditStatus();

            if (_InLanDau)
            {
                _BoSungLan = 0;
            }

            if (this._Action == FormAction.AddNew)
            {
                _DataMain = this.GetStandardData();
            }
            else
            {
                _DataMain = this.GetData();
            }

            if (_DataMain != null)
            {
                grdDetail.DataSource = _DataMain;
            }

            CalculateAmount();

            if (Config.GetValue("Language").ToString() == "1")
            {
                FormFactory.DevLocalizer.Translate(this);
            }
        }

        private void colThueGTGT_ParseEditValue(object sender, DevExpress.XtraEditors.Controls.ConvertEditValueEventArgs e)
        {
            if (e.Value == null)
                return;
            e.Value = Utils.parseDecimal(e.Value).ToString(colThueGTGT.DisplayFormat.FormatString);
            e.Handled = true;
        }

        private void colGTHHDV_ParseEditValue(object sender, DevExpress.XtraEditors.Controls.ConvertEditValueEventArgs e)
        {
            if (e.Value == null)
                return;
            e.Value = Utils.parseDecimal(e.Value).ToString(colGTHHDV.DisplayFormat.FormatString);
            e.Handled = true;
        }

        /// <summary>
        /// btnClose_Click
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnClose_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        /// <summary>
        /// btnSave_Click
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnSave_Click(object sender, EventArgs e)
        {
            string pMstID = string.Empty;

            if (this._Action == FormAction.AddNew)
            {
                if (InsertMaster(out pMstID))
                {
                    if (InsertDetail(pMstID))
                    {
                        showASoftMsg("Tờ khai thuế GTGT tạo thành công!");
                        this.Close();
                    }
                }
            }
            else
            {
                if (UpdateMaster() && UpdateDetail())
                {
                    showASoftMsg("Cập nhật tờ khai thuế GTGT thành công!");
                    this.Close();
                }
            }
        }

        /// <summary>
        /// gridView2_ShowingEditor
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void gridView2_ShowingEditor(object sender, CancelEventArgs e)
        {
            int sortOrder = int.MinValue;
            bool[] editStatus = null;

            try
            {
                // Get SortOrder
                object obj = gridView2.GetRowCellValue(gridView2.FocusedRowHandle, "SortOrder");
                if (obj != null)
                {
                    sortOrder = int.Parse(obj.ToString());
                }

                // Get target
                if (_EditStatus.ContainsKey(sortOrder))
                {
                    editStatus = _EditStatus[sortOrder];

                    // Editing GTHHDV
                    if (gridView2.FocusedColumn.Name.Equals("colGTHHDV"))
                    {
                        // Not editable
                        if (!editStatus[0])
                        {
                            e.Cancel = true;
                        }
                    }
                    // Editing ThueGTGT
                    else
                        if (gridView2.FocusedColumn.Name.Equals("colThueGTGT"))
                        {
                            // Not editable
                            if (!editStatus[1])
                            {
                                e.Cancel = true;
                            }
                        }
                        // Other columns
                        else
                        {
                            e.Cancel = true;
                        }
                }
                else
                {
                    e.Cancel = true;
                }
            }
            catch (Exception ex)
            {
                XtraMessageBox.Show(ex.Message);
            }
        }

        /// <summary>
        /// gridView2_CellValueChanged
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void gridView2_CellValueChanged(object sender, CellValueChangedEventArgs e)
        {
            try
            {
                object objCode = gridView2.GetRowCellValue(e.RowHandle, "CodeThue");
                double value = e.Value == null ? 0 : double.Parse(e.Value.ToString());

                if (objCode == null)
                    return;

                switch (objCode.ToString())
                {
                    case CT22:
                        _TG22 = value;
                        break;
                    case CT25:
                        _TG25 = value;
                        break;
                    case CT37:
                        _TG37 = value;
                        break;
                    case CT38:
                        _TG38 = value;
                        break;
                    case CT39:
                        _TG39 = value;
                        break;
                    case CT40b:
                        _TG40b = value;
                        break;
                    case CT42:
                        _TG42 = value;
                        break;
                    default:
                        break;
                }

                ReCalculate();
                FillCalculatedResult("CodeGT", "GTHHDV");
                FillCalculatedResult("CodeThue", "ThueGTGT");
            }
            catch (Exception ex)
            {
                XtraMessageBox.Show(ex.Message);
            }
        }

        /// <summary>
        /// LaySoLieu_KeyDown
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void LaySoLieu_KeyDown(object sender, KeyEventArgs e)
        {
            switch (e.KeyCode)
            {
                case Keys.F12:
                    btnSave_Click(sender, e);
                    break;
            }
        }

        /// <summary>
        /// gridView2_CustomRowCellEdit
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void gridView2_CustomRowCellEdit(object sender, DevExpress.XtraGrid.Views.Grid.CustomRowCellEditEventArgs e)
        {
            object obj = gridView2.GetRowCellValue(e.RowHandle, "CodeGT");

            if (obj == null)
                return;

            if (e.Column.FieldName == "GTHHDV")
            {
                if (CT21.Equals(obj.ToString()))
                {
                    e.RepositoryItem = chk21;
                }
            }
        }

        /// <summary>
        /// checkEdit_CheckedChanged
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void checkEdit_CheckedChanged(object sender, EventArgs e)
        {
            CheckEdit checkEdit = sender as CheckEdit;
            DataRow[] rows = _DataMain.Select(string.Format("CodeGT = '{0}'", CT21));
            if (rows.Length <= 0)
                return;

            if (checkEdit.Checked)
            {
                // Reset các số liệu hoạt động mua bán về 0
                if (this.showASoftMsg("Các số liệu đã có trong các chỉ tiêu phát sinh trong kỳ sẽ bị xóa bằng 0. Có đồng ý không?", "Thông báo") == DialogResult.Yes)
                {
                    rows[0]["GTHHDV"] = 1;

                    try
                    {
                        // Giữ lại giá trị cũ
                        _TG23_bk = _TG23;
                        _TG24_bk = _TG24;
                        _TG25_bk = _TG25;
                        _TG26_bk = _TG26;
                        _TG27_bk = _TG27;
                        _TG28_bk = _TG28;
                        _TG29_bk = _TG29;
                        _TG30_bk = _TG30;
                        _TG31_bk = _TG31;
                        _TG32_bk = _TG32;
                        _TG33_bk = _TG33;
                        _TG34_bk = _TG34;
                        _TG35_bk = _TG35;
                        _TG36_bk = _TG36;

                        // Reset về 0
                        _TG23 = 0;
                        _TG24 = 0;
                        _TG25 = 0;
                        _TG26 = 0;
                        _TG27 = 0;
                        _TG28 = 0;
                        _TG29 = 0;
                        _TG30 = 0;
                        _TG31 = 0;
                        _TG32 = 0;
                        _TG33 = 0;
                        _TG34 = 0;
                        _TG35 = 0;
                        _TG36 = 0;

                        _HasClearData = true;

                        ReCalculate();
                        FillCalculatedResult("CodeGT", "GTHHDV");
                        FillCalculatedResult("CodeThue", "ThueGTGT");
                    }
                    catch (Exception ex)
                    {
                        XtraMessageBox.Show(ex.Message);
                    }
                }
                else
                {
                    checkEdit.Checked = false;
                }
            }
            else
            {
                rows[0]["GTHHDV"] = 0;

                if (_HasClearData)
                {
                    try
                    {
                        // Phục hồi giá trị cũ
                        _TG23 = _TG23_bk;
                        _TG24 = _TG24_bk;
                        _TG25 = _TG25_bk;
                        _TG26 = _TG26_bk;
                        _TG27 = _TG27_bk;
                        _TG28 = _TG28_bk;
                        _TG29 = _TG29_bk;
                        _TG30 = _TG30_bk;
                        _TG31 = _TG31_bk;
                        _TG32 = _TG32_bk;
                        _TG33 = _TG33_bk;
                        _TG34 = _TG34_bk;
                        _TG35 = _TG35_bk;
                        _TG36 = _TG36_bk;

                        ReCalculate();
                        FillCalculatedResult("CodeGT", "GTHHDV");
                        FillCalculatedResult("CodeThue", "ThueGTGT");
                    }
                    catch (Exception ex)
                    {
                        XtraMessageBox.Show(ex.Message);
                    }
                }
            }

        }

        /// <summary>
        /// gridView2_ValidatingEditor
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void gridView2_ValidatingEditor(object sender, DevExpress.XtraEditors.Controls.BaseContainerValidateEditorEventArgs e)
        {
            object objCode = gridView2.GetRowCellValue(gridView2.FocusedRowHandle, "CodeThue");
            if (objCode == null)
                return;

            // Chi tieu 42
            if (!objCode.Equals(CT42))
            {
                return;
            }

            double ct42 = 0;
            if (double.TryParse(e.Value.ToString(), out ct42))
            {
                // Chi tieu 42 > 41
                if (gridView2.FocusedColumn == colThueGTGT &&
                ct42 > _TG41)
                {
                    string msg = "Chỉ tiêu [42] không thể lớn hơn chỉ tiêu [41]!";
                    if (Config.GetValue("Language").ToString() == "1")
                        msg = UIDictionary.Translate(msg);
                    e.ErrorText = msg;
                    e.Valid = false;
                }
            }
        }

        #endregion

        #region ---- Private methods ----

        /// <summary>
        /// Format columns in grid
        /// </summary>
        private void FormatColumns()
        {
            colGTHHDV.DisplayFormat.FormatString = FormatString.GetReportFormat("Tien");
            if (colGTHHDV.RealColumnEdit != null)
            {
                colGTHHDV.RealColumnEdit.EditFormat.FormatString = colGTHHDV.DisplayFormat.FormatString;
                colGTHHDV.RealColumnEdit.EditFormat.FormatType = colGTHHDV.DisplayFormat.FormatType;
                colGTHHDV.RealColumnEdit.ParseEditValue += new DevExpress.XtraEditors.Controls.ConvertEditValueEventHandler(colGTHHDV_ParseEditValue);
            }

            colThueGTGT.DisplayFormat.FormatString = FormatString.GetReportFormat("Tien");
            if (colThueGTGT.RealColumnEdit != null)
            {
                colThueGTGT.RealColumnEdit.EditFormat.FormatString = colThueGTGT.DisplayFormat.FormatString;
                colThueGTGT.RealColumnEdit.EditFormat.FormatType = colThueGTGT.DisplayFormat.FormatType;
                colThueGTGT.RealColumnEdit.ParseEditValue += new DevExpress.XtraEditors.Controls.ConvertEditValueEventHandler(colThueGTGT_ParseEditValue);
            }
        }

        /// <summary>
        /// Recalculate all values
        /// </summary>
        private void ReCalculate()
        {
            _TG36 = _TG35 - _TG25;

            _TG40a = _TG36 - _TG22 + _TG37 - _TG38 - _TG39;

            if (_TG40a < 0)
            {
                _TG41 = -_TG40a;
                _TG40a = 0;
            }
            else
            {
                _TG41 = 0;
            }

            _TG40 = _TG40a - _TG40b;
            _TG43 = _TG41 - _TG42;
        }

        /// <summary>
        /// Insert table MVATOut
        /// </summary>
        /// <returns></returns>
        private bool InsertMaster(out string pId)
        {
            List<string> fieldName = new List<string>();
            List<string> Values = new List<string>();
            pId = GetNewID();

            try
            {
                fieldName.Add("MToKhaiID");
                fieldName.Add("KyToKhai");
                fieldName.Add("NamToKhai");
                fieldName.Add("NgayToKhai");
                fieldName.Add("DienGiai");
                fieldName.Add("InLanDau");
                fieldName.Add("SoLanIn");
                fieldName.Add("QuyToKhai");

                Values.Clear();
                Values.Add("convert( uniqueidentifier,'" + pId + "')");

                if (this._IsPeriod)
                    Values.Add("'" + _Ky + "'");
                else
                    Values.Add("'0'");

                Values.Add("'" + _NamTaiChinh.ToString() + "'");
                Values.Add("cast('" + _NgapLap.ToShortDateString() + "' as datetime)");
                Values.Add("N'" + _DienGiai + "'");
                Values.Add("'" + (_InLanDau ? "1" : "0") + "'");
                Values.Add("'" + _BoSungLan + "'");

                if (!this._IsPeriod)
                    Values.Add("'" + _Ky + "'");
                else
                    Values.Add("'0'");

                return this._Database.insertRow("MToKhai", fieldName, Values);
            }
            catch (Exception e)
            {
                XtraMessageBox.Show(e.Message);
                return false;
            }
        }

        /// <summary>
        /// InsertDetail
        /// </summary>
        /// <returns></returns>
        private bool InsertDetail(string pMstID)
        {
            bool result = false;

            List<string> fieldName = new List<string>();
            List<string> Values = new List<string>();
            string pId = string.Empty;
            try
            {
                fieldName.Add("DToKhaiID");
                fieldName.Add("MToKhaiID");
                fieldName.Add("Stt");
                fieldName.Add("ChiTieu");
                fieldName.Add("CodeGT");
                fieldName.Add("GTHHDV");
                fieldName.Add("CodeThue");
                fieldName.Add("ThueGTGT");
                fieldName.Add("SortOrder");

                if (_DataMain != null)
                {
                    foreach (DataRow dr in _DataMain.Rows)
                    {
                        Values.Clear();
                        pId = GetNewID();
                        Values.Add("convert( uniqueidentifier,'" + pId + "')");
                        Values.Add("convert( uniqueidentifier,'" + pMstID + "')");
                        Values.Add("'" + (dr["Stt"] == DBNull.Value ? string.Empty : dr["Stt"].ToString()) + "'");
                        Values.Add("N'" + (dr["ChiTieu"] == DBNull.Value ? string.Empty : dr["ChiTieu"].ToString()) + "'");
                        Values.Add("'" + (dr["CodeGT"] == DBNull.Value ? string.Empty : dr["CodeGT"].ToString()) + "'");
                        Values.Add("'" + (dr["GTHHDV"] == DBNull.Value ? "0" : dr["GTHHDV"].ToString().Replace(",", ".")) + "'");
                        Values.Add("'" + (dr["CodeThue"] == DBNull.Value ? string.Empty : dr["CodeThue"].ToString()) + "'");
                        Values.Add("'" + (dr["ThueGTGT"] == DBNull.Value ? "0" : dr["ThueGTGT"].ToString().Replace(",", ".")) + "'");
                        Values.Add("'" + (dr["SortOrder"] == DBNull.Value ? "0" : dr["SortOrder"].ToString()) + "'");
                        result = this._Database.insertRow("DToKhai", fieldName, Values);
                    }
                }

                return result;
            }
            catch (Exception e)
            {
                XtraMessageBox.Show(e.Message);
                return false;
            }
        }

        /// <summary>
        /// UpdateMaster
        /// </summary>
        /// <returns></returns>
        private bool UpdateMaster()
        {
            bool result = false;
            string pId = string.Empty;
            StringBuilder strBuilder = new StringBuilder();

            try
            {
                strBuilder.Append(string.Format("Update MToKhai set NgayToKhai = '{0}', DienGiai=N'{1}', InLanDau={2},SoLanIn={3} ",
                _NgapLap.ToShortDateString(),
                _DienGiai.Replace("'", "''"),
                (_InLanDau ? "1" : "0"),
                _BoSungLan));
                strBuilder.Append(string.Format("where MToKhaiID='{0}' ", _MToKhaiID));

                result = this._Database.UpdateByNonQuery(strBuilder.ToString());

                return result;
            }
            catch (Exception e)
            {
                XtraMessageBox.Show(e.Message);
                return false;
            }
        }

        /// <summary>
        /// UpdateDetail
        /// </summary>
        /// <returns></returns>
        private bool UpdateDetail()
        {
            bool result = false;
            string pId = string.Empty;
            StringBuilder strBuilder = new StringBuilder();

            try
            {
                if (this._DataMain != null)
                {
                    this._DataMain.TableName = "DToKhai";
                }

                strBuilder.Append("select dt.Stt, dt.ChiTieu, dt.CodeGT, dt.GTHHDV, dt.CodeThue, dt.ThueGTGT, dt.SortOrder, dt.DToKhaiID, dt.MToKhaiID ");
                strBuilder.Append("from DToKhai dt ");
                strBuilder.Append(string.Format("where dt.MToKhaiID='{0}' ", _MToKhaiID));

                result = this._Database.UpdateDataTable(strBuilder.ToString(), this._DataMain);

                return result;
            }
            catch (Exception e)
            {
                XtraMessageBox.Show(e.Message);
                return false;
            }
        }

        /// <summary>
        /// Get new ID
        /// </summary>
        /// <returns></returns>
        private string GetNewID()
        {
            string result = _Database.GetValue("select NEWID()").ToString();

            return result;
        }

        /// <summary>
        /// GetStandardData
        /// </summary>
        /// <returns></returns>
        private DataTable GetStandardData()
        {
            DataTable data = null;

            try
            {
                data = _Database.GetDataTable("select Stt, ChiTieu, CodeGT, GTHHDV, CodeThue, ThueGTGT, SortOrder from ToKhai");
                return data;
            }
            catch (Exception ex)
            {
                XtraMessageBox.Show(ex.Message);
                return null;
            }
        }

        /// <summary>
        /// GetData
        /// </summary>
        /// <returns></returns>
        private DataTable GetData()
        {
            DataTable data = null;
            StringBuilder strBuilder = new StringBuilder();
            try
            {
                strBuilder.Append("select dt.Stt, dt.ChiTieu, dt.CodeGT, dt.GTHHDV, dt.CodeThue, dt.ThueGTGT, dt.SortOrder, dt.DToKhaiID, dt.MToKhaiID ");
                strBuilder.Append("from DToKhai dt inner join MToKhai mst on mst.MToKhaiID = dt.MToKhaiID ");
                strBuilder.Append(string.Format("where mst.MToKhaiID='{0}' order by dt.SortOrder", _MToKhaiID));
                data = _Database.GetDataTable(strBuilder.ToString());
                return data;
            }
            catch (Exception ex)
            {
                XtraMessageBox.Show(ex.Message);
                return null;
            }
        }

        /// <summary>
        /// Initial status of column in grid
        /// </summary>
        /// <remarks>false: Not Editable; true: Editable</remarks>
        private void InitialEditStatus()
        {
            _EditStatus = new Dictionary<int, bool[]>();
            _EditStatus.Add(1, new bool[] { true, false });
            _EditStatus.Add(2, new bool[] { false, true });
            _EditStatus.Add(6, new bool[] { false, true });
            _EditStatus.Add(16, new bool[] { false, true });
            _EditStatus.Add(17, new bool[] { false, true });
            _EditStatus.Add(18, new bool[] { false, true });
            _EditStatus.Add(21, new bool[] { false, true });
            _EditStatus.Add(24, new bool[] { false, true });
        }

        /// <summary>
        /// LoadDataAddNew
        /// </summary>
        private void CalculateAmount()
        {
            if (this._Action == FormAction.AddNew)
            {
                DataTable dt = null;
                string[] paranames = new string[] { "@Ky", "@Nam" };
                object[] paraValues = new object[] { _Ky, _NamTaiChinh };

                if (this._IsPeriod)
                    dt = _Database.GetDataSetByStore("LayDuLieuToKhaiGTGT", paranames, paraValues);
                else
                    dt = _Database.GetDataSetByStore("LayDuLieuToKhaiGTGTQuy", paranames, paraValues);

                if (dt != null && dt.Rows.Count > 0)
                {
                    DataRow dr = dt.Rows[0];
                    if (dr != null)
                    {
                        _TG22 = dr[0] == DBNull.Value ? 0 : double.Parse(dr[0].ToString());
                        _TG23 = dr[1] == DBNull.Value ? 0 : double.Parse(dr[1].ToString());
                        _TG24 = dr[2] == DBNull.Value ? 0 : double.Parse(dr[2].ToString());
                        _TG25 = dr[3] == DBNull.Value ? 0 : double.Parse(dr[3].ToString());
                        _TG26 = dr[4] == DBNull.Value ? 0 : double.Parse(dr[4].ToString());
                        _TG27 = dr[5] == DBNull.Value ? 0 : double.Parse(dr[5].ToString());
                        _TG28 = dr[6] == DBNull.Value ? 0 : double.Parse(dr[6].ToString());
                        _TG29 = dr[7] == DBNull.Value ? 0 : double.Parse(dr[7].ToString());
                        _TG30 = dr[8] == DBNull.Value ? 0 : double.Parse(dr[8].ToString());
                        _TG31 = dr[9] == DBNull.Value ? 0 : double.Parse(dr[9].ToString());
                        _TG32 = dr[10] == DBNull.Value ? 0 : double.Parse(dr[10].ToString());
                        _TG33 = dr[11] == DBNull.Value ? 0 : double.Parse(dr[11].ToString());
                        _TG34 = dr[12] == DBNull.Value ? 0 : double.Parse(dr[12].ToString());
                        _TG35 = dr[13] == DBNull.Value ? 0 : double.Parse(dr[13].ToString());
                        _TG36 = dr[14] == DBNull.Value ? 0 : double.Parse(dr[14].ToString());
                        _TG37 = dr[15] == DBNull.Value ? 0 : double.Parse(dr[15].ToString());
                        _TG38 = dr[16] == DBNull.Value ? 0 : double.Parse(dr[16].ToString());
                        _TG39 = dr[17] == DBNull.Value ? 0 : double.Parse(dr[17].ToString());
                        _TG40 = dr[18] == DBNull.Value ? 0 : double.Parse(dr[18].ToString());
                        _TG40a = dr[19] == DBNull.Value ? 0 : double.Parse(dr[19].ToString());
                        _TG40b = dr[20] == DBNull.Value ? 0 : double.Parse(dr[20].ToString());
                        _TG41 = dr[21] == DBNull.Value ? 0 : double.Parse(dr[21].ToString());
                        _TG42 = dr[22] == DBNull.Value ? 0 : double.Parse(dr[22].ToString());
                        _TG43 = dr[23] == DBNull.Value ? 0 : double.Parse(dr[23].ToString());
                    }
                }

                FillCalculatedResult("CodeGT", "GTHHDV");
                FillCalculatedResult("CodeThue", "ThueGTGT");
            }
            else
            {
                StoreCalculatedResult("CodeGT", "GTHHDV");
                StoreCalculatedResult("CodeThue", "ThueGTGT");
            }
        }

        /// <summary>
        /// Fill calculated result to grid
        /// </summary>
        private void FillCalculatedResult(string pColCode, string pColValue)
        {
            if (this._DataMain != null)
            {
                if (!this._DataMain.Columns.Contains(pColCode) ||
                !this._DataMain.Columns.Contains(pColValue))
                    return;

                string code = string.Empty;

                foreach (DataRow dr in this._DataMain.Rows)
                {
                    code = dr[pColCode] == DBNull.Value ? string.Empty : dr[pColCode].ToString();

                    // Chi tieu [22]
                    switch (code)
                    {
                        case CT22:
                            dr[pColValue] = _TG22;
                            break;
                        case CT23:
                            dr[pColValue] = _TG23;
                            break;
                        case CT24:
                            dr[pColValue] = _TG24;
                            break;
                        case CT25:
                            dr[pColValue] = _TG25;
                            break;
                        case CT26:
                            dr[pColValue] = _TG26;
                            break;
                        case CT27:
                            dr[pColValue] = _TG27;
                            break;
                        case CT28:
                            dr[pColValue] = _TG28;
                            break;
                        case CT29:
                            dr[pColValue] = _TG29;
                            break;
                        case CT30:
                            dr[pColValue] = _TG30;
                            break;
                        case CT31:
                            dr[pColValue] = _TG31;
                            break;
                        case CT32:
                            dr[pColValue] = _TG32;
                            break;
                        case CT33:
                            dr[pColValue] = _TG33;
                            break;
                        case CT34:
                            dr[pColValue] = _TG34;
                            break;
                        case CT35:
                            dr[pColValue] = _TG35;
                            break;
                        case CT36:
                            dr[pColValue] = _TG36;
                            break;
                        case CT37:
                            dr[pColValue] = _TG37;
                            break;
                        case CT38:
                            dr[pColValue] = _TG38;
                            break;
                        case CT39:
                            dr[pColValue] = _TG39;
                            break;
                        case CT40a:
                            dr[pColValue] = _TG40a;
                            break;
                        case CT40b:
                            dr[pColValue] = _TG40b;
                            break;
                        case CT40:
                            dr[pColValue] = _TG40;
                            break;
                        case CT41:
                            dr[pColValue] = _TG41;
                            break;
                        case CT42:
                            dr[pColValue] = _TG42;
                            break;
                        case CT43:
                            dr[pColValue] = _TG43;
                            break;
                        default:
                            break;
                    }
                }
            }
        }

        /// <summary>
        /// Store calculated result in variables
        /// </summary>
        private void StoreCalculatedResult(string pColCode, string pColValue)
        {
            if (this._DataMain != null)
            {
                if (!this._DataMain.Columns.Contains(pColCode) ||
                !this._DataMain.Columns.Contains(pColValue))
                    return;

                string code = string.Empty;
                double value = 0;

                foreach (DataRow dr in this._DataMain.Rows)
                {
                    code = dr[pColCode] == DBNull.Value ? string.Empty : dr[pColCode].ToString();
                    value = dr[pColValue] == DBNull.Value ? 0 : double.Parse(dr[pColValue].ToString());

                    switch (code)
                    {
                        case CT22:
                            _TG22 = value;
                            break;
                        case CT23:
                            _TG23 = value;
                            break;
                        case CT24:
                            _TG24 = value;
                            break;
                        case CT25:
                            _TG25 = value;
                            break;
                        case CT26:
                            _TG26 = value;
                            break;
                        case CT27:
                            _TG27 = value;
                            break;
                        case CT28:
                            _TG28 = value;
                            break;
                        case CT29:
                            _TG29 = value;
                            break;
                        case CT30:
                            _TG30 = value;
                            break;
                        case CT31:
                            _TG31 = value;
                            break;
                        case CT32:
                            _TG32 = value;
                            break;
                        case CT33:
                            _TG33 = value;
                            break;
                        case CT34:
                            _TG34 = value;
                            break;
                        case CT35:
                            _TG35 = value;
                            break;
                        case CT36:
                            _TG36 = value;
                            break;
                        case CT37:
                            _TG37 = value;
                            break;
                        case CT38:
                            _TG38 = value;
                            break;
                        case CT39:
                            _TG39 = value;
                            break;
                        case CT40a:
                            _TG40a = value;
                            break;
                        case CT40b:
                            _TG40b = value;
                            break;
                        case CT40:
                            _TG40 = value;
                            break;
                        case CT41:
                            _TG41 = value;
                            break;
                        case CT42:
                            _TG42 = value;
                            break;
                        case CT43:
                            _TG43 = value;
                            break;
                        default:
                            break;
                    }
                }
            }
        }

        private void showASoftMsg(string pMsg)
        {
            if (Config.GetValue("Language").ToString() == "1")
                pMsg = UIDictionary.Translate(pMsg);
            XtraMessageBox.Show(pMsg);
        }

        private DialogResult showASoftMsg(string pMsg, string pCaption)
        {

            if (Config.GetValue("Language").ToString() == "1")
                pMsg = UIDictionary.Translate(pMsg);
            return XtraMessageBox.Show(pMsg, pCaption, MessageBoxButtons.YesNo);
        }

        #endregion
    }
}
