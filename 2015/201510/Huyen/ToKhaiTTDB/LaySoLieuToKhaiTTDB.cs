using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using DevExpress.XtraEditors;
using CDTLib;
using CDTControl;
using DevExpress.XtraLayout.Utils;
using FormFactory;
using DevExpress.Utils;
using DevExpress.XtraEditors.Controls;
using DevExpress.XtraEditors.Repository;
using DevExpress.XtraGrid.Columns;
using DevExpress.XtraLayout;
using CDTDatabase;

namespace ToKhaiTTDB
{
    public partial class LaySoLieuToKhaiTTDB : DevExpress.XtraEditors.XtraForm
    {
        #region ---- Enums, Structs, Constants ----
        private enum ListType
        {
            KyToKhaiTTDB = 1,
            InputDate = 2
        }

        public enum FormAction
        {
            Edit,
            AddNew
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
        private int NamTaiChinh()
        {
            return (Config.GetValue("NamLamViec") == null ? -1 : int.Parse(Config.GetValue("NamLamViec").ToString()));
        }

        #endregion ---- Enums, Structs, Constants ----

        #region ---- Properties ----

        public string MToKhaiTTDBID
        {
            get { return _MToKhaiTTDBID; }
            set { _MToKhaiTTDBID = value; }
        }
        #endregion ---- Properties ----

        #region ---- Member variables ----

        private Database _Database = Database.NewDataDatabase();
        private int _NamTaiChinh = -1;
        private string query = string.Empty;
        private string _MToKhaiTTDBID = string.Empty;
        private DataTable _DataMain = null;
        private DataTable _dtKHBS = null;
        private int _SortOrder = 1;
        private bool _GetOriginalData = false;
        private FormAction _Action = FormAction.AddNew;

        #endregion ---- Member variables ----

        #region ---- Member variablesTaxCheck ----
        // Giá trị giữ lại trước khi check
        private int _rowCount = 0;
        private const int VALUE_AMOUNT = 4;

        private double[,] _originalData;
        private double[,] _currentData;

        #endregion ---- Member variablesTaxCheck ----

        #region ---- Constructors & Destructors ----

        public LaySoLieuToKhaiTTDB()
        {
            InitializeComponent();
        }

        #endregion ---- Constructors & Destructors ----

        #region ---- Handle events ----

        private void LaySoLieuToKhaiTTDB_Load(object sender, EventArgs e)
        {
            // Năm tài chính hiện tại
            _NamTaiChinh = Config.GetValue("NamLamViec") == null ? -1 : int.Parse(Config.GetValue("NamLamViec").ToString());

            this.dtmNgayToKhaiTTDB.EditValue = String.Format("{0:d}", DateTime.Now);
            this.LoadMaster();
            this.checkComboStatus();
            this.checkComboIsExten();
            this.checkInLanDau();
            this.FormatTextbox();
            this.FormatColumns();
            this.LoadTTDB();
            gvToKhai.OptionsBehavior.Editable = true;
            dtmNgayToKhaiTTDB.EditValue = DateTime.Now.ToShortDateString();
            dtmAmendedReturnDate.EditValue = DateTime.Now.ToShortDateString();
            dtmPayableDate.EditValue = DateTime.Now.ToShortDateString();
            if (this.Action == FormAction.AddNew)
            {
                sepExperiedDay.EditValue = 0;
                _DataMain = this.GetStandardData();
            }
            else if (this.Action == FormAction.Edit)
            {
                this.LoadTTDBEdit();
                _DataMain = LoadDetail();
                LoadTaxCheckEdit(0);
                InitDataTable(1);
                btnReadData.Enabled = false;
            }
            if (_DataMain != null)
            {
                gcToKhai.DataSource = _DataMain;
            }
            dtmInputDate.EditValueChanged += new EventHandler(dtmInputDate_EditValueChanged);
            cboKyToKhaiTTDB.EditValueChanged += new EventHandler(cboKyToKhaiTTDB_EditValueChanged);
            sepSoLanIn.EditValueChanged += new EventHandler(sepSoLanIn_EditValueChanged);
            if (Config.GetValue("Language").ToString() == "1")
            {
                FormFactory.DevLocalizer.Translate(this);
            }

            //DisableCell();
            //foreach (GridColumn column in gvToKhai.Columns)
            //column.OptionsColumn.AllowSort = DefaultBoolean.False;
        }
        private void DisableCell()
        {
            dummy.ReadOnly = true;
            dummy.Appearance.BackColor = Color.FromArgb(240, 240, 240);
            dummy.Appearance.BackColor2 = dummy.Appearance.BackColor;
            dummy.Appearance.ForeColor = Color.Black;
            dummy.AllowFocused = false;
        }
        private void cboTaxDepartmentID_EditValueChanged(object sender, EventArgs e)
        {
            LoadDMThueCapQL();
        }
        private void radDeclareType_SelectedIndexChanged(object sender, EventArgs e)
        {
            checkComboStatus();
        }
        private void chkIsExten_CheckedChanged(object sender, EventArgs e)
        {
            checkComboIsExten();
        }
        private void chkInLanDau_CheckedChanged(object sender, EventArgs e)
        {
            checkInLanDau();
            Solanin();
            
        }
        private void gvToKhai_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Handled) return;

            if (e.Modifiers == Keys.None)
            {
                switch (e.KeyCode)
                {
                    case Keys.F2:
                        ProcessShortcutF2(e);
                        break;

                    case Keys.F4:
                        ProcessShortcutF4(e);
                        break;

                    case Keys.Enter:
                        if (!gvToKhai.IsEditing)
                        {
                            int rowIndex = gvToKhai.FocusedRowHandle;
                            int colIndex = gvToKhai.Columns.IndexOf(gvToKhai.FocusedColumn);

                            do
                            {
                                colIndex++;
                                if (colIndex == gvToKhai.Columns.Count)
                                {
                                    colIndex = 0;
                                    rowIndex++;
                                }

                                if (rowIndex >= gvToKhai.RowCount) break;

                                if (gvToKhai.Columns[colIndex].Visible
                                    && gvToKhai.Columns[colIndex].OptionsColumn.AllowEdit
                                    && CheckAllowEdit(rowIndex, gvToKhai.Columns[colIndex].FieldName))
                                {
                                    gvToKhai.FocusedColumn = gvToKhai.Columns[colIndex];
                                    gvToKhai.FocusedRowHandle = rowIndex;
                                    break;
                                }

                            } while (true);
                        }
                        break;
                }
            }
        }
        private void gvToKhai_FocusedColumnChanged(object sender, DevExpress.XtraGrid.Views.Base.FocusedColumnChangedEventArgs e)
        {
            gvToKhai.ShowEditor();
        }
        private void gvToKhai_FocusedRowChanged(object sender, DevExpress.XtraGrid.Views.Base.FocusedRowChangedEventArgs e)
        {
            gvToKhai.ShowEditor();
        }

        ///fgjytduuuuuuuuuuuuuuuuuuuuuuuuuuuuuuur
        ///
        /////

        #endregion ---- Handle events ----

        #region ---- Private methods ----
        private bool CheckAllowEdit(int index, string fieldName)
        {
            try
            {
                string code = GetString(index, "Code");

                if (code.StartsWith("03") && fieldName.Contains("Ps2"))
                {
                    return false;
                }
                if (code.EndsWith("00") && fieldName.Equals("Check"))
                    return true;
                else if (code.EndsWith("00") && !fieldName.Equals("Check"))
                    return false;
            }
            catch { return false; }

            return true;
        }
        private string GetString(int index, string fieldName)
        {
            string result = string.Empty;

            object obj = gvToKhai.GetRowCellValue(index, fieldName);
            if (obj != null) result = obj.ToString();

            return result;
        }
        private decimal GetDecimal(DataRow row, string fieldName)
        {
            decimal result = 0;
            decimal.TryParse(GetString(row, fieldName), out result);
            return result;
        }
        private string GetString(DataRow row, string fieldName)
        {
            string result = string.Empty;

            object obj = row[fieldName];
            if (obj != null) result = obj.ToString();

            return result;
        }
        /// <summary>
        /// Xử lý phím F2. Thêm dữ liệu vào lưới Tờ khai
        /// </summary>
        /// <param name="e"></param>
        private void ProcessShortcutF2(KeyEventArgs e)
        {
            string parentCode = GetString(gvToKhai.FocusedRowHandle, "Code");
            if (parentCode.Length < 4) return;

            // Kiểm tra có thêm dòng mới hay không
            parentCode = parentCode.Substring(0, 4);
            if (parentCode.StartsWith("00")
                || parentCode.StartsWith("99")
                || parentCode.StartsWith("0300")) return;

            int newSTT = GetInt32(gvToKhai.FocusedRowHandle, "Stt");
            int newIndex = gvToKhai.FocusedRowHandle;

            // Lấy vị trí với dòng cuối cùng
            do
            {
                newIndex++;
                newSTT++;
            } while (GetString(newIndex, "Code").StartsWith(parentCode));

            // Kiểm tra nếu dòng cuối cùng là rỗng thì không thêm dòng mới
            if (string.IsNullOrEmpty(GetString(newIndex - 1, "MaNhomTTDB"))
                && string.IsNullOrEmpty(GetString(newIndex - 1, "TenNhomTTDB"))
                && string.IsNullOrEmpty(GetString(newIndex - 1, "SoLuong"))
                && string.IsNullOrEmpty(GetString(newIndex - 1, "Ps"))
                && string.IsNullOrEmpty(GetString(newIndex - 1, "Ps2")))
                return;

            // Thêm dòng mới
            DataRow newRow = _DataMain.NewRow();
            newRow["Code"] = parentCode + newSTT.ToString("00");
            newRow["Stt"] = newSTT;
            _DataMain.Rows.InsertAt(newRow, newIndex);

            gvToKhai.FocusedColumn = gvToKhai.Columns["TenNhomTTDB"];
            gvToKhai.FocusedRowHandle++;
            e.Handled = true;
        }

        /// <summary>
        /// Xử lý phím tắt F4.
        /// </summary>
        /// <param name="e"></param>
        private void ProcessShortcutF4(KeyEventArgs e)
        {
            string parentCode = GetString(gvToKhai.FocusedRowHandle, "Code");
            // Không thể xóa các dòng cố định
            if (parentCode.EndsWith("00") || parentCode.Length < 4) return;

            // Lấy mã của nhóm cha
            parentCode = parentCode.Substring(0, 4);

            // Giữ lại số thứ tự của dòng cần xóa
            int index = gvToKhai.FocusedRowHandle;
            int stt = GetInt32(gvToKhai.FocusedRowHandle, "Stt");

            // Xóa
            _DataMain.Rows.RemoveAt(gvToKhai.FocusedRowHandle);

            // Cập nhật số thứ tự của các dòng dưới
            while (GetString(index, "Code").StartsWith(parentCode))
            {
                gvToKhai.SetRowCellValue(index, "Code", parentCode + stt.ToString("00"));
                gvToKhai.SetRowCellValue(index, "Stt", stt);

                stt++;
                index++;
            }

            e.Handled = true;

            // Tính toán lại.
            Recalculate();
        }
        private void Recalculate()
        {
            string code = string.Empty;
            decimal soLuong = 0;
            decimal ps = 0;
            decimal ps1 = 0;
            decimal thueSuat = 0;
            decimal ps2 = 0;
            decimal ps3 = 0;

            decimal groupTotalPs = 0;
            decimal groupTotalPs1 = 0;
            decimal groupTotalPs2 = 0;
            decimal groupTotalPs3 = 0;

            decimal totalPs = 0;
            decimal totalPs1 = 0;
            decimal totalPs2 = 0;
            decimal totalPs3 = 0;

            DataRow row = null;
            for (int i = _DataMain.Rows.Count - 1; i >= 0; i--)
            {
                row = _DataMain.Rows[i];
                code = GetString(row, "Code");

                // Nếu là dòng tổng cộng thì cập nhật giá trị
                if (code.EndsWith("0000"))
                {
                    row["Ps"] = Utils.RoundDecimalByFieldName(groupTotalPs, "Ps");
                    row["Ps1"] = Utils.RoundDecimalByFieldName(groupTotalPs1, "Ps1");

                    if (code.StartsWith("01") || code.StartsWith("02"))
                    {
                        row["Ps2"] = Utils.RoundDecimalByFieldName(groupTotalPs2, "Ps2");
                        row["Ps3"] = Utils.RoundDecimalByFieldName(groupTotalPs3, "Ps3");
                    }

                    totalPs += groupTotalPs;
                    totalPs1 += groupTotalPs1;
                    totalPs2 += groupTotalPs2;
                    totalPs3 += groupTotalPs3;

                    groupTotalPs = 0;
                    groupTotalPs1 = 0;
                    groupTotalPs2 = 0;
                    groupTotalPs3 = 0;
                }
                // Là dòng chi tiết thì tính toán sau đó cộng dồn
                else
                {
                    // Lấy dữ liệu
                    soLuong = GetDecimal(row, "SoLuong");
                    ps = GetDecimal(row, "Ps");
                    thueSuat = GetDecimal(row, "ThueSuat");
                    ps2 = GetDecimal(row, "Ps2");

                    // Tính toán
                    // Giá tính thuế TTDB = DS bán (chưa có VAT) / (1 + thuế suất TTDB)
                    ps1 = ps / (1 + (thueSuat / 100));
                    // Thuế TTDB phải nộp = giá tính thuế TTDB * Thuế suất –Thuế TTDB được khấu trừ
                    ps3 = ps1 * (thueSuat / 100) - ps2;

                    // Cập nhật giá trị mới lên lưới
                    row["Ps1"] = Utils.RoundDecimalByFieldName(ps1, "Ps1");
                    if (code.StartsWith("01") || code.StartsWith("02"))
                    {
                        row["Ps3"] = Utils.RoundDecimalByFieldName(ps3, "Ps3");
                    }

                    // Cộng dồn
                    groupTotalPs += ps;
                    groupTotalPs1 += ps1;
                    groupTotalPs2 += ps2;
                    groupTotalPs3 += ps3;
                }
            }

            // Dòng tổng cuối tờ khai
            row = _DataMain.Rows[_DataMain.Rows.Count - 1];
            row["Ps"] = Utils.RoundDecimalByFieldName(totalPs, "Ps");
            row["Ps1"] = Utils.RoundDecimalByFieldName(totalPs1, "Ps1");
            row["Ps2"] = Utils.RoundDecimalByFieldName(totalPs2, "Ps2");
            row["Ps3"] = Utils.RoundDecimalByFieldName(totalPs3, "Ps3");
        }

        private int GetInt32(int index, string fieldName)
        {
            int result = 0;
            int.TryParse(GetString(index, fieldName), out result);
            return result;
        }
        #region ---- Lấy thông tin combo ----

        /// <summary>
        /// Lấy thông tin kỳ tờ khai.
        /// </summary>
        /// <history>
        ///     [Lệ Huyền] Tạo mới [14/12/2015]
        /// </history>
        private void LoadMaster()
        {
            //Đổ dữ liệu lên combox Danh mục thuế cấp cục
            query = @"Select * from DMThueCapCuc";
            gluTaxDepartmentID.Properties.DataSource = _Database.GetDataTable(query); ;
            gluTaxDepartmentID.Properties.DisplayMember = "TaxDepartmentName";
            gluTaxDepartmentID.Properties.ValueMember = "TaxDepartmentID";
            gluTaxDepartmentID.Properties.BestFitMode = DevExpress.XtraEditors.Controls.BestFitMode.BestFitResizePopup;
            gluTaxDepartmentID.Properties.View.OptionsView.ShowAutoFilterRow = true;
            //Đổ dữ liệu lên combox Gia hạn
            query = @"Select * from DMGH";
            gluExtenID.Properties.DataSource = _Database.GetDataTable(query);
            gluExtenID.Properties.DisplayMember = "ExtenName";
            gluExtenID.Properties.ValueMember = "ExtenID";
            gluExtenID.Properties.BestFitMode = DevExpress.XtraEditors.Controls.BestFitMode.BestFitResizePopup;
            gluExtenID.Properties.View.OptionsView.ShowAutoFilterRow = true;
            //Đổ dữ liệu lên combox Danh mục ngành nghề
            query = @"Select * from DMNN Where TaxType = N'TTDB'";
            gluVocationID.Properties.DataSource = _Database.GetDataTable(query);
            gluVocationID.Properties.DisplayMember = "VocationName";
            gluVocationID.Properties.ValueMember = "VocationID";
            gluVocationID.Properties.BestFitMode = DevExpress.XtraEditors.Controls.BestFitMode.BestFitResizePopup;
            gluVocationID.Properties.View.OptionsView.ShowAutoFilterRow = true;
            gluVocationID.Text = "";
            // Load default kỳ kế toán
            for (int i = 1; i < 13; i++)
            {
                cboKyToKhaiTTDB.Properties.Items.Add(i);
            }
        }
        //Load tờ khai lúc sửa
        private void LoadTTDBEdit()
        {
            if (string.IsNullOrEmpty(_MToKhaiTTDBID)) return;
            query = string.Format(@"Select mst.MToKhaiTTDBID, mst.NgayToKhaiTTDB
                      , mst.DeclareType, mst.KyToKhaiTTDB, mst.InputDate
                      , mst.NamToKhaiTTDB, mst.InLanDau, mst.SoLanIn
                      , mst.DienGiai, mst.AmendedReturnDate,  mst.IsExten
                      , mst.ExtenID, mst.VocationID, mst.IsInputAppendix
                      , mst.IsOutputAppendix, mst.ExperiedDay
                      , mst.ExperiedAmount, mst.PayableAmount
                      , mst.PayableCmt, mst.PayableDate, mst.TaxDepartmentID
                      , mst.TaxDepartID, mst.ReceivableExperied
                      , mst.ReceivableAmount, mst.ExperiedReason
                    From MToKhaiTTDB mst
                    Where mst.MToKhaiTTDBID = '{0}'
                    Order by mst.DeclareType, mst.KyToKhaiTTDB
                    .InputDate, mst.SoLanIn", _MToKhaiTTDBID);
            DataTable table = _Database.GetDataTable(query);
            if (table.Rows.Count > 0)
            {
                DataRow row = table.Rows[0];
                this.dtmNgayToKhaiTTDB.EditValue = row["NgayToKhaiTTDB"];
                if (row["DeclareType"].ToString().Equals("1"))
                {
                    cboKyToKhaiTTDB.EditValue = row["KyToKhaiTTDB"];
                }
                else
                {
                    radDeclareType.EditValue = row["DeclareType"];
                    dtmInputDate.EditValue = row["InputDate"];
                }
                chkInLanDau.EditValue = row["InLanDau"];
                sepSoLanIn.EditValue = row["SoLanIn"];
                dtmAmendedReturnDate.EditValue = row["AmendedReturnDate"];
                chkIsExten.EditValue = row["IsExten"];
                gluExtenID.EditValue = row["ExtenID"];
                txtDienGiai.EditValue = row["DienGiai"];
                if (row["VocationID"].ToString() == "")
                {
                    gluVocationID.Text = "";
                }
                else
                {
                    gluVocationID.EditValue = row["VocationID"];
                }
                chkIsInputAppendix.EditValue = row["IsInputAppendix"];
                chkIsOutputAppendix.EditValue = row["IsOutputAppendix"];
                sepExperiedDay.EditValue = row["ExperiedDay"];
                calExperiedAmount.EditValue = row["PayableAmount"];
                txtPayableCmt.EditValue = row["PayableCmt"];
                dtmPayableDate.EditValue = row["PayableDate"];
                gluTaxDepartmentID.EditValue = row["TaxDepartmentID"];
                gluTaxDepartID.EditValue = row["TaxDepartID"];
                sepReceivableExperied.EditValue = row["ReceivableExperied"];
                calReceivableAmount.EditValue = row["ReceivableAmount"];
                memoExperiedReason.EditValue = row["ExperiedReason"];

                radDeclareType.Properties.ReadOnly = true;
                cboKyToKhaiTTDB.Properties.ReadOnly = dtmInputDate.Properties.ReadOnly = true;
                chkInLanDau.Properties.ReadOnly = true;
                sepSoLanIn.Properties.ReadOnly = true;
            }
        }
        /// <summary>
        /// load dữ liệu lúc sửa
        /// </summary>
        /// <returns></returns>
        private DataTable LoadDetail()
        {
            DataTable data = null;
            try
            {
                query = string.Format(@"Select DToKhaiTTDBID, MToKhaiTTDBID, Code, Stt, MaNhomTTDB
                              , TenNhomTTDB, MaDVT, SoLuong, Ps, Ps1, ThueSuat
                              , Ps2, Ps3 From DToKhaiTTDB 
                            where MToKhaiTTDBID = '{0}'
                            order by Code", _MToKhaiTTDBID);
                data = _Database.GetDataTable(query);
                DataColumn column = new DataColumn("Check", typeof(Decimal));
                data.Columns.Add(column);
                gcToKhai.DataSource = data;
                gvToKhai.BestFitColumns();
                return data;
            }
            catch (Exception ex)
            {
                XtraMessageBox.Show(ex.Message); 
                return null;
            }
        }
        /// <summary>
        /// Check or Uncheck lúc sửa hay lúc đọc tờ khai
        /// </summary>
        /// <param name="option"></param>
        private void LoadTaxCheckEdit(int option)
        {
            if (option == 0)// lúc sửa
            {
                query = string.Format(@"Select Top 1 TaxCheck from DToKhaiTTDB
                                     where MToKhaiTTDBID = '{0}'
                                    order by Code", _MToKhaiTTDBID);
                string v = _Database.GetValue(query).ToString();
                if (_Database.GetValue(query).ToString() == "True")
                    IsCheckEdit("1");
                else
                    IsCheckEdit("0");
            }
            else if (option == 1)// lúc đọc tờ khai
            {
                string soLanIn = string.Empty;
                if (chkInLanDau.Checked)
                {
                    soLanIn = "0";
                    IsCheckEdit("0");
                }
                else
                {
                    soLanIn = sepSoLanIn.EditValue.ToString();
                    string query1 = string.Format(@"select MToKhaiTTDBID
                        from MToKhaiTTDB 
                        Where NamToKhaiTTDB = {0} 
                        and ((Case when {1} = 1 then KyToKhaiTTDB end) = {2} or
                         (Case when {1} = 2 then InputDate end) = Cast('{3}' as Datetime)) 
                        and SoLanin = isnull({4},0)-1 ", NamTaiChinh(), radDeclareType.SelectedIndex == 0 ? "1" : "2", cboKyToKhaiTTDB.EditValue == null ? 0 : cboKyToKhaiTTDB.EditValue, dtmInputDate.EditValue == null ? DateTime.Now.ToShortDateString() : dtmInputDate.DateTime.ToShortDateString(), soLanIn);
                    string key = _Database.GetValue(query1).ToString();

                    query = string.Format(@"Select Top 1 TaxCheck from DToKhaiTTDB
                                     where MToKhaiTTDBID = '{0}'
                                    order by Code", key);
                    string v = _Database.GetValue(query).ToString();
                    if (_Database.GetValue(query).ToString() == "True")
                        IsCheckEdit("1");
                    else
                        IsCheckEdit("0");

                }

               
            }
        }
        /// <summary>
        /// Check/Uncheck taxcheck
        /// </summary>
        /// <param name="isCheck"></param>
        private void IsCheckEdit(string isCheck)
        {
            gvToKhai.FocusedRowHandle++;
            DataRow row = gvToKhai.GetDataRow(0) as DataRow;
            row["Check"] = isCheck;
        }
        private void LoadTTDB()
        {
            query = "select MaNhomTTDB,TenNhomTTDB, ThueSuatTTDB, DVT from DMThueTTDB where ThueSuatTTDB > 0 and MaNhomTTDB like 'I.%'";
            this.lueTenNhomTTDB1.Properties.DataSource = _Database.GetDataTable(query);
            this.lueTenNhomTTDB1.Properties.NullText = "";
            lueTenNhomTTDB1.BestFitMode = DevExpress.XtraEditors.Controls.BestFitMode.BestFitResizePopup;

            query = "select MaNhomTTDB, TenNhomTTDB, ThueSuatTTDB, DVT from DMThueTTDB where ThueSuatTTDB > 0 and MaNhomTTDB like 'II.%'";
            this.lueTenNhomTTDB2.Properties.DataSource = _Database.GetDataTable(query);
            this.lueTenNhomTTDB2.Properties.NullText = "";
            lueTenNhomTTDB2.BestFitMode = DevExpress.XtraEditors.Controls.BestFitMode.BestFitResizePopup;


            if (Config.GetValue("Language").ToString() == "1")
            {
                FormFactory.DevLocalizer.Translate(this);
            }
        }
        /// <summary>
        /// load combobox danh mục thuế cấp quản lý
        /// </summary>
        private void LoadDMThueCapQL()
        {
            //Đổ dữ liệu lên combox Tên cơ quan thuế cấp cục
            query = string.Format(@"Select * from DMThueCapQL Where  TaxDepartmentID = '{0}'", gluTaxDepartmentID.EditValue);
            gluTaxDepartID.Properties.DataSource = _Database.GetDataTable(query);
            gluTaxDepartID.Properties.ValueMember = "TaxDepartID";
            gluTaxDepartID.Properties.DisplayMember = "TaxDepartName";
            gluTaxDepartID.Properties.BestFitMode = DevExpress.XtraEditors.Controls.BestFitMode.BestFitResizePopup;
            gluTaxDepartID.Properties.View.OptionsView.ShowAutoFilterRow = true;
        }
        /// <summary>
        /// Xử lý định dạng textbox
        /// </summary>
        private void FormatTextbox()
        {
            calReceivableAmount.Properties.DisplayFormat.FormatString = FormatString.GetReportFormat("Tien");
            calReceivableAmount.Properties.Mask.EditMask = FormatString.GetReportFormat("Tien");
            calReceivableAmount.Properties.EditFormat.FormatString = FormatString.GetReportFormat("Tien");

            calPayableAmount.Properties.DisplayFormat.FormatString = FormatString.GetReportFormat("Tien");
            calPayableAmount.Properties.Mask.EditMask = FormatString.GetReportFormat("Tien");
            calPayableAmount.Properties.EditFormat.FormatString = FormatString.GetReportFormat("Tien");

            calExperiedAmount.Properties.DisplayFormat.FormatString = FormatString.GetReportFormat("Tien");
            calExperiedAmount.Properties.Mask.EditMask = FormatString.GetReportFormat("Tien");
            calExperiedAmount.Properties.EditFormat.FormatString = FormatString.GetReportFormat("Tien");

            sepExperiedDay.Properties.DisplayFormat.FormatString = FormatString.GetReportFormat("Tien");
            sepExperiedDay.Properties.Mask.EditMask = FormatString.GetReportFormat("Tien");
            sepExperiedDay.Properties.EditFormat.FormatString = FormatString.GetReportFormat("Tien");
        }
        #endregion ---- Lấy thông tin combo ----

        /// <summary>
        /// Trạng thái chọn của radiogroup
        /// </summary>
        private void checkComboStatus()
        {
            if (IsKyToKhaiTTDB())
            {
                dtmInputDate.Enabled = true;
                cboKyToKhaiTTDB.Enabled = false;
                cboKyToKhaiTTDB.EditValue = null;
            }
            else
            {
                dtmInputDate.Enabled = false;
                cboKyToKhaiTTDB.Enabled = true;
                dtmInputDate.EditValue = null;
            }
        }
        private bool IsKyToKhaiTTDB()
        {
            return Utils.parseInt(radDeclareType.EditValue).Equals((int)ListType.KyToKhaiTTDB);
        }

        /// <summary>
        /// Xử lý khi check In lần đầu
        /// </summary>
        private void checkInLanDau()
        {
            if (this.chkInLanDau.Checked)
            {
                this.layoutControlSoLanIn.Visibility = LayoutVisibility.Never;
                this.layoutControlNgayKHBS.Visibility = LayoutVisibility.Never;
                this.layoutControlChamNop.Visibility = LayoutVisibility.Never;
                this.layoutControlNoiDung.Visibility = LayoutVisibility.Never;
                this.layoutControlKHBS.Visibility = LayoutVisibility.Never;
                this.layoutControlPhuLuc.Visibility = LayoutVisibility.Always;
                this.xtraTabControl1.TabPages[1].PageVisible = false;
                this.layoutControlDienGiai.Visibility = LayoutVisibility.Always;
                this.layoutControlVocation.Visibility = LayoutVisibility.Always;
                this.layoutControlNgayToKhai.Visibility = LayoutVisibility.Always;
                this.layoutControlKyToKhai.Visibility = LayoutVisibility.Always;
                this.layoutControlInputDate.Visibility = LayoutVisibility.Always;
                this.layoutControlIsExten.Visibility = LayoutVisibility.Always;
                this.layoutControlExtenID.Visibility = LayoutVisibility.Always;
                this.xtraTabControl1.TabPages[0].PageVisible = true;
                this.layoutControlReadData.Visibility = LayoutVisibility.Always;
                this.layoutControlItem1.Location = this.layoutControlPhuLuc.Location;
            }
            else
            {
                this.layoutControlPhuLuc.Visibility = LayoutVisibility.Never;
                this.layoutControlSoLanIn.Visibility = LayoutVisibility.Always;
                this.layoutControlNgayKHBS.Visibility = LayoutVisibility.Always;
                this.layoutControlChamNop.Visibility = LayoutVisibility.Always;
                this.layoutControlNoiDung.Visibility = LayoutVisibility.Always;
                this.layoutControlKHBS.Visibility = LayoutVisibility.Always;
                this.xtraTabControl1.TabPages[1].PageVisible = true;
                this.layoutControlDienGiai.Visibility = LayoutVisibility.Always;
                this.layoutControlVocation.Visibility = LayoutVisibility.Always;
                this.layoutControlNgayToKhai.Visibility = LayoutVisibility.Always;
                this.layoutControlKyToKhai.Visibility = LayoutVisibility.Always;
                this.layoutControlInputDate.Visibility = LayoutVisibility.Always;
                this.layoutControlIsExten.Visibility = LayoutVisibility.Always;
                this.layoutControlExtenID.Visibility = LayoutVisibility.Always;
                this.xtraTabControl1.TabPages[0].PageVisible = true;
                this.layoutControlReadData.Visibility = LayoutVisibility.Always;
                InitDataTable(0);

            }
        }
        /// <summary>
        /// Xử lý check gia hạn
        /// </summary>
        private void checkComboIsExten()
        {
            if (this.chkIsExten.Checked)
            {
                gluExtenID.Enabled = true;
            }
            else
            {
                gluExtenID.Enabled = false;
            }
        }
        /// <summary>
        /// load dữ liệu lúc thêm mới
        /// </summary>
        /// <returns></returns>
        private DataTable GetStandardData()
        {
            DataTable data = null;
            try
            {
                query = @"select Code, Stt, MaNhomTTDB, TenNhomTTDB, MaDVT, SoLuong, Ps, Ps1, ThueSuat, Ps2, Ps3 from ToKhaiTTDB";
                data = _Database.GetDataTable(query);
                DataColumn column = new DataColumn("Check", typeof(Decimal));
                data.Columns.Add(column);
                return data;
            }
            catch (Exception ex)
            {
                XtraMessageBox.Show(ex.Message);
                return null;
            }
        }
        /// <summary>
        /// Check tồn tại tờ khai(Thêm mới)
        /// </summary>
        /// <returns></returns>
        private bool CheckExist()
        {
            string soLanIn = string.Empty;
            if (chkInLanDau.Checked)
                soLanIn = "0";
            else
                soLanIn = sepSoLanIn.EditValue.ToString();
            query = string.Format(@"Select Top 1 1 From MToKhaiTTDB
                            Where NamToKhaiTTDB = {0} 
                            and ((Case when {1} = 1 
                              then KyToKhaiTTDB end) = {2} or
                              (Case when {1} = 2 
                              then InputDate end) = Cast({3} as Datetime)) 
                            and SoLanin = isnull({4},0)", NamTaiChinh(), radDeclareType.SelectedIndex == 0 ? "1" : "2", cboKyToKhaiTTDB.EditValue == null ? 0 : cboKyToKhaiTTDB.EditValue, dtmInputDate.EditValue == null ? DateTime.Now.ToShortDateString() : dtmInputDate.DateTime.ToShortDateString(), soLanIn);
            if (_Database.GetValue(query) != null)
                return true;
            return false;
        }
        /// <summary>
        /// Kiểm tra tờ khai hiện tại đã phát sinh tờ khai bổ sung hay tờ khai kỳ tiếp theo hay chưa
        /// </summary>
        /// <returns></returns>
        private bool CheckIncurred()
        {
            query = string.Format(@"Declare @SoLanIn int,
                  @Nam int,
                  @Ky int,
                  @DeclareType int,
                  @InputDate datetime
                Select @SoLanIn = isnull(SoLanIn, 0),@Nam = NamToKhaiTTDB, @Ky = KyToKhaiTTDB
                  , @DeclareType = Isnull(DeclareType, 1), @InputDate = InputDate
                From MToKhaiTTDB
                Where MToKhaiTTDBID = '{0}'
                Select Top 1 1 from
                  (-- Kiểm tra đã tồn tại tiếp theo 
                   Select  DeclareType, NamToKhaiTTDB, KyToKhaiTTDB
                     , InputDate, SoLanIn, MToKhaiTTDBID   
                   From MToKhaiTTDB
                   Where NamToKhaiTTDB >= @Nam 
                     and ((Case when @DeclareType = 1 and KyToKhaiTTDB != 0 
                       then KyToKhaiTTDB end) > @Ky or
                      (Case when @DeclareType = 2 and InputDate is not null 
                       then InputDate end) > Cast(@InputDate as Datetime))
                   Union all 
                   --Kiềm tra đã tồn tại lần bổ sung tiếp theo
                   Select DeclareType, NamToKhaiTTDB, KyToKhaiTTDB
                     , InputDate, SoLanIn, MToKhaiTTDBID   
                   From MToKhaiTTDB
                   Where NamToKhaiTTDB = @Nam 
                     and ((Case when @DeclareType = 1 and KyToKhaiTTDB != 0 
                       then KyToKhaiTTDB end) = @Ky or
                      (Case when @DeclareType = 2 and InputDate is not null 
                       then InputDate end) = Cast(@InputDate as Datetime))
                     and SoLanin > @SoLanIn
                  ) x", _MToKhaiTTDBID);
            if (_Database.GetValue(query) != null)
                return true;
            return false;
        }
        /// <summary>
        /// Check số lần in
        /// </summary>
        private bool CheckSoLanIn(int SoLanIn)
        {
            query = string.Format(@"select Max(M.SoLanIn)
                    from MToKhaiTTDB M
                    Where M.NamToKhaiTTDB = {0} 
                    and ((Case when {1} = 1 then M.KyToKhaiTTDB end) = {2} or
                     (Case when {1} = 2 then M.InputDate end) = Cast('{3}' as Datetime))", NamTaiChinh(), radDeclareType.SelectedIndex == 0 ? "1" : "2", cboKyToKhaiTTDB.EditValue == null ? 0 : cboKyToKhaiTTDB.EditValue, dtmInputDate.EditValue == null ? DateTime.Now.ToShortDateString() : dtmInputDate.DateTime.ToShortDateString());
            if (chkInLanDau.Checked)
                return true;
            if (_Database.GetValue(query) != DBNull.Value)
            {
                int _in = Convert.ToInt32(_Database.GetValue(query));
                if (SoLanIn > (_in + 1))
                    return false;
            }
            return true;
        }
        /// <summary>
        /// CheckInput trước khi lưu
        /// </summary>
        private bool CheckInput()
        {
            int flag = 0;
            string msg = "Không được phép để trống!";
            if (Config.GetValue("Language").ToString() == "1")
                msg = UIDictionary.Translate(msg);
            if (radDeclareType.SelectedIndex == 0 && cboKyToKhaiTTDB.Text == string.Empty)
            {
                cboKyToKhaiTTDB.ErrorText = msg;
                flag++;
            }
            if (radDeclareType.SelectedIndex == 1 && dtmInputDate.Text == string.Empty)
            {
                dtmInputDate.ErrorText = msg;
                flag++;
            }
            if (chkIsExten.Checked && gluExtenID.Text == string.Empty)
            {
                gluExtenID.ErrorText = msg;
                flag++;
            }
            if (flag != 0)
                return false;
            else
                return true;

        }
        /// <summary>
        /// Insert MToKhaiTTDB(lúc thêm mới)
        /// </summary>
        private bool InsertMaster(out string pId)
        {
            List<string> fieldName = new List<string>();
            List<string> Values = new List<string>();
            pId = GetNewID();
            string InputDate = "cast('" + dtmInputDate.DateTime.ToShortDateString() + "' as smalldatetime)";
            try
            {
                fieldName.Clear();
                fieldName.Add("MToKhaiTTDBID");
                fieldName.Add("NgayToKhaiTTDB");
                fieldName.Add("NamToKhaiTTDB");
                fieldName.Add("DeclareType");
                fieldName.Add("KyToKhaiTTDB");
                fieldName.Add("InputDate");
                fieldName.Add("DienGiai");
                fieldName.Add("IsExten");
                fieldName.Add("ExtenID");
                fieldName.Add("VocationID");
                fieldName.Add("InLanDau");
                fieldName.Add("SoLanIn");
                fieldName.Add("AmendedReturnDate");
                fieldName.Add("IsInputAppendix");
                fieldName.Add("IsOutputAppendix");
                fieldName.Add("ExperiedDay");
                fieldName.Add("ExperiedAmount");
                fieldName.Add("PayableAmount");
                fieldName.Add("PayableCmt");
                fieldName.Add("PayableDate");
                fieldName.Add("TaxDepartmentID");
                fieldName.Add("TaxDepartID");
                fieldName.Add("ReceivableExperied");
                fieldName.Add("ReceivableAmount");
                fieldName.Add("ExperiedReason");

                Values.Clear();

                Values.Add("convert( uniqueidentifier,'" + pId + "')");
                Values.Add("cast('" + dtmNgayToKhaiTTDB.DateTime.ToShortDateString() + "' as smalldatetime)");
                Values.Add("'" + NamTaiChinh() + "'");
                Values.Add("'" + (radDeclareType.SelectedIndex == 0 ? "1" : "2") + "'");
                Values.Add("" + (radDeclareType.SelectedIndex == 0 ? cboKyToKhaiTTDB.EditValue.ToString() : "NULL") + "");
                Values.Add("" + (radDeclareType.SelectedIndex == 1 ? InputDate : "NULL") + "");
                if (txtDienGiai.Text == string.Empty)
                    Values.Add("NULL");
                else
                    Values.Add("N'" + txtDienGiai.Text + "'");
                Values.Add("'" + (chkIsExten.Checked ? "1" : "0") + "'");
                if (chkIsExten.Checked)
                    Values.Add("'" + gluExtenID.EditValue.ToString() + "'");
                else
                    Values.Add("NULL");
                if (gluVocationID.Text == string.Empty)
                    Values.Add("NULL");
                else
                    Values.Add("'" + gluVocationID.EditValue.ToString() + "'");
                if (chkInLanDau.Checked)
                {
                    Values.Add("'1'");
                    Values.Add("'0'");
                    Values.Add("NULL");
                    Values.Add("'" + (chkIsInputAppendix.Checked ? "1" : "0") + "'");
                    Values.Add("'" + (chkIsOutputAppendix.Checked ? "1" : "0") + "'");
                    Values.Add("NULL");
                    Values.Add("NULL");
                    Values.Add("NULL");
                    Values.Add("NULL");
                    Values.Add("NULL");
                    Values.Add("NULL");
                    Values.Add("NULL");
                    Values.Add("NULL");
                    Values.Add("NULL");
                    Values.Add("NULL");
                }
                else
                {
                    Values.Add("'0'");
                    Values.Add("'" + sepSoLanIn.EditValue.ToString() + "'");
                    Values.Add("cast('" + dtmAmendedReturnDate.DateTime.ToShortDateString() + "' as smalldatetime)");
                    Values.Add("NULL");
                    Values.Add("NULL");
                    Values.Add("'" + sepExperiedDay.EditValue.ToString() + "'");
                    if (calExperiedAmount.Text == string.Empty)
                        Values.Add("NULL");
                    else
                        Values.Add("'" + calExperiedAmount.EditValue.ToString() + "'");

                    if (calPayableAmount.Text == string.Empty)
                        Values.Add("NULL");
                    else
                        Values.Add("'" + calPayableAmount.EditValue.ToString() + "'");

                    if (txtPayableCmt.Text == string.Empty)
                        Values.Add("NULL");
                    else
                        Values.Add("'" + txtPayableCmt.Text + "'");

                    Values.Add("cast('" + dtmPayableDate.DateTime.ToShortDateString() + "' as smalldatetime)");

                    if (gluTaxDepartmentID.Text == string.Empty)
                    {
                        Values.Add("NULL");
                        Values.Add("NULL");
                    }
                    else
                    {
                        Values.Add("'" + gluTaxDepartmentID.EditValue.ToString() + "'");
                        Values.Add("'" + gluTaxDepartID.EditValue.ToString() + "'");
                    }
                    Values.Add("'" + sepReceivableExperied.EditValue.ToString() + "'");
                    if (calReceivableAmount.Text == string.Empty)
                        Values.Add("NULL");
                    else
                        Values.Add("'" + calReceivableAmount.EditValue.ToString() + "'");
                    Values.Add("N'" + memoExperiedReason.Text + "'");
                }
                return this._Database.insertRow("MToKhaiTTDB", fieldName, Values);

            }
            catch (Exception ex)
            {

                XtraMessageBox.Show(ex.Message);
                return false;
            }
        }
        /// <summary>
        /// InsertDetail(lúc thêm mới)
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
                fieldName.Clear();
                fieldName.Add("DToKhaiTTDBID");
                fieldName.Add("MToKhaiTTDBID");
                fieldName.Add("Stt");
                fieldName.Add("Code");
                fieldName.Add("TaxCheck");
                fieldName.Add("MaNhomTTDB");
                fieldName.Add("TenNhomTTDB");
                fieldName.Add("MaDVT");
                fieldName.Add("SoLuong");
                fieldName.Add("Ps");
                fieldName.Add("Ps1");
                fieldName.Add("ThueSuat");
                fieldName.Add("Ps2");
                fieldName.Add("Ps3");

                if (_DataMain != null)
                {
                    foreach (DataRow dr in _DataMain.Rows)
                    {
                        Values.Clear();
                        pId = GetNewID();
                        Values.Add("convert( uniqueidentifier,'" + pId + "')");
                        Values.Add("convert( uniqueidentifier,'" + pMstID + "')");
                        Values.Add("N'" + Utils.parseString(dr["Stt"]).Replace("'", "''") + "'");
                        Values.Add("N'" + Utils.parseString(dr["Code"]).Replace("'", "''") + "'");
                        if (SelectTaxCheck())
                            Values.Add("1");
                        else
                            Values.Add("0");
                        Values.Add("N'" + Utils.parseString(dr["MaNhomTTDB"]).Replace("'", "''") + "'");
                        Values.Add("N'" + Utils.parseString(dr["TenNhomTTDB"]).Replace("'", "''") + "'");
                        Values.Add("N'" + Utils.parseString(dr["MaDVT"]).Replace("'", "''") + "'");
                        Values.Add(Utils.parseDecimal(dr["SoLuong"]).ToString());
                        Values.Add(Utils.parseDecimal(dr["Ps"]).ToString());
                        Values.Add(Utils.parseDecimal(dr["Ps1"]).ToString());
                        Values.Add(Utils.parseDecimal(dr["ThueSuat"]).ToString());
                        Values.Add(Utils.parseDecimal(dr["Ps2"]).ToString());
                        Values.Add(Utils.parseDecimal(dr["Ps3"]).ToString());
                        result = this._Database.insertRow("DToKhaiTTDB", fieldName, Values);
                        if (!result)
                            break;
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
        private bool SelectTaxCheck()
        {
            gvToKhai.FocusedRowHandle++;
            string cellValue = string.Empty;
            cellValue = gvToKhai.GetRowCellValue(0, "Check").ToString();//lấy ra value của cột Check trên mỗi dòng
            if (cellValue == "1")
                return true;
            return false;
        }
        /// <summary>
        /// Insert vào bảng DToKhaiKHBS(Giải trình bổ sung)
        /// </summary>
        /// <returns></returns>
        private bool InsertDToKhaiKHBS(string pMstID)
        {
            bool result = false;

            List<string> fieldName = new List<string>();
            List<string> Values = new List<string>();
            string pId = string.Empty;
            //try
            //{
                fieldName.Add("DToKhaiKHBSID");
                fieldName.Add("MToKhaiID");
                fieldName.Add("SortOrder");
                fieldName.Add("TargetTypeID");
                fieldName.Add("TargetName");
                fieldName.Add("TargetID");
                fieldName.Add("TargetReturn");
                fieldName.Add("TargetAmended");
                fieldName.Add("TargetDifference");

                if (_dtKHBS != null)
                {
                    foreach (DataRow dr in _dtKHBS.Rows)
                    {
                        Values.Clear();
                        pId = GetNewID();
                        Values.Add("convert( uniqueidentifier,'" + pId + "')");
                        Values.Add("convert( uniqueidentifier,'" + pMstID + "')");
                        Values.Add("'" + (dr["SortOrder"] == DBNull.Value ? string.Empty : dr["SortOrder"].ToString()) + "'");
                        Values.Add("N'" + (dr["TargetTypeID"] == DBNull.Value ? string.Empty : dr["TargetTypeID"].ToString()) + "'");
                        Values.Add("N'" + (dr["TargetName"] == DBNull.Value ? string.Empty : dr["TargetName"].ToString()) + "'");
                        Values.Add("'" + (dr["TargetID"] == DBNull.Value ? string.Empty : dr["TargetID"].ToString()) + "'");
                        Values.Add("'" + (dr["TargetReturn"] == DBNull.Value ? "0" : dr["TargetReturn"].ToString().Replace(",", ".")) + "'");
                        Values.Add("'" + (dr["TargetAmended"] == DBNull.Value ? "0" : dr["TargetAmended"].ToString().Replace(",", ".")) + "'");
                        Values.Add("'" + (dr["TargetDifference"] == DBNull.Value ? "0" : dr["TargetDifference"].ToString().Replace(",", ".")) + "'");
                        result = this._Database.insertRow("DToKhaiKHBS", fieldName, Values);
                    }
                }
                
                return result;
            //}
            //catch (Exception e)
            //{
             //   XtraMessageBox.Show(e.Message);
             //   return false;
            //}
        }
        /// <summary>
        /// Update MToKhaiTTDB(lúc sửa)
        /// </summary>
        private bool UpdateMaster()
        {
            bool result = false;
            string pId = string.Empty;
            if (CheckIncurred())
            {
                ShowASoftMsg("Đã tồn tại tờ khai thuế kỳ tiếp theo hoặc khai bổ sung. Bạn không được phép sửa/Xóa.");
                return false;
            }
            //try
            //{
                List<string> fieldName = new List<string>();
                List<object> Values = new List<object>();
                query = @"Update MToKhaiTTDB set NgayToKhaiTTDB = @NgayToKhaiTTDB, AmendedReturnDate = @AmendedReturnDate, IsExten = @IsExten,
                                                 ExtenID = @ExtenID, DienGiai = @DienGiai, VocationID = @VocationID, IsInputAppendix = @IsInputAppendix, IsOutputAppendix = @IsOutputAppendix, ExperiedDay = @ExperiedDay,
                                                 ExperiedAmount = @ExperiedAmount, PayableAmount = @PayableAmount, PayableCmt = @PayableCmt, PayableDate = @PayableDate, TaxDepartmentID = @TaxDepartmentID, TaxDepartID = @TaxDepartID,
                                                 ReceivableExperied = @ReceivableExperied, ReceivableAmount = @ReceivableAmount, ExperiedReason = @ExperiedReason
                                                 Where MToKhaiTTDBID = @MToKhaiTTDBID";
                fieldName.Add("NgayToKhaiTTDB");
                fieldName.Add("AmendedReturnDate");
                fieldName.Add("IsExten");
                fieldName.Add("ExtenID");
                fieldName.Add("DienGiai");
                fieldName.Add("VocationID");
                fieldName.Add("IsInputAppendix");
                fieldName.Add("IsOutputAppendix");
                fieldName.Add("ExperiedDay");
                fieldName.Add("ExperiedAmount");
                fieldName.Add("PayableAmount");
                fieldName.Add("PayableCmt");
                fieldName.Add("PayableDate");
                fieldName.Add("TaxDepartmentID");
                fieldName.Add("TaxDepartID");
                fieldName.Add("ReceivableExperied");
                fieldName.Add("ReceivableAmount");
                fieldName.Add("ExperiedReason");
                fieldName.Add("MToKhaiTTDBID");


                Values.Add(dtmNgayToKhaiTTDB.DateTime.ToShortDateString());
                if (chkInLanDau.Checked)
                    Values.Add(DBNull.Value);
                else
                    Values.Add(dtmAmendedReturnDate.DateTime.ToShortDateString());
                Values.Add((chkIsExten.Checked ? "1" : "0"));
                if (chkIsExten.Checked)
                    Values.Add(gluExtenID.EditValue.ToString());
                else
                    Values.Add(DBNull.Value);

                if (txtDienGiai.Text == string.Empty)
                    Values.Add(DBNull.Value);
                else
                    Values.Add(txtDienGiai.Text);

                if (gluVocationID.Text == string.Empty)
                    Values.Add(DBNull.Value);
                else
                    Values.Add(gluVocationID.EditValue.ToString());

                Values.Add((chkIsInputAppendix.Checked ? "1" : "0"));
                Values.Add((chkIsOutputAppendix.Checked ? "1" : "0"));
                if (!chkInLanDau.Checked)
                    Values.Add(sepExperiedDay.EditValue.ToString());
                else
                    Values.Add(DBNull.Value);

                if (calExperiedAmount.Text == string.Empty)
                    Values.Add(DBNull.Value);
                else
                    Values.Add(calExperiedAmount.EditValue.ToString());

                if (calPayableAmount.Text == string.Empty)
                    Values.Add(DBNull.Value);
                else
                    Values.Add(calPayableAmount.EditValue.ToString());

                if (txtPayableCmt.Text == string.Empty)
                    Values.Add(DBNull.Value);
                else
                    Values.Add(txtPayableCmt.EditValue.ToString());

                if (!chkInLanDau.Checked)
                    Values.Add(dtmPayableDate.DateTime.ToShortDateString());
                else
                    Values.Add(DBNull.Value);

                if (gluTaxDepartmentID.Text == string.Empty)
                {
                    Values.Add(DBNull.Value);
                    Values.Add(DBNull.Value);
                }
                else
                {
                    Values.Add(gluTaxDepartmentID.EditValue.ToString());
                    Values.Add(gluTaxDepartID.EditValue.ToString());
                }
                if (sepReceivableExperied.Text == string.Empty)
                    Values.Add(DBNull.Value);
                else
                    Values.Add(sepReceivableExperied.EditValue.ToString());

                if (calReceivableAmount.Text == string.Empty)
                    Values.Add(DBNull.Value);
                else
                    Values.Add(calReceivableAmount.EditValue.ToString());

                if (memoExperiedReason.Text == string.Empty)
                    Values.Add(DBNull.Value);
                else
                    Values.Add(memoExperiedReason.Text);

                Values.Add(_MToKhaiTTDBID);

                result = _Database.UpdateDatabyPara(query, fieldName.ToArray(), Values.ToArray());

                return result;
            //}
            //catch (Exception ex)
            //{

                //XtraMessageBox.Show(ex.Message);
                //return false;
            //}
        }
        /// <summary>
        /// Update DToKhaiTTDB(lúc sửa)
        /// </summary>
        private bool UpdateDetailToKhai()
        {
            bool result = false;
            string pId = string.Empty;
            string mstId = string.Empty;
            StringBuilder strBuilder = new StringBuilder();
            try
            {
                if (this._DataMain != null)
                {
                    this._DataMain.TableName = "DToKhaiTTDB";
                }
                foreach (DataRow dr in _DataMain.Rows)
                {
                    pId = dr["DToKhaiTTDBID"].ToString();
                    mstId = dr["MToKhaiTTDBID"].ToString();
                    if (pId == "" && mstId == "")
                    {
                        pId = GetNewID();
                        mstId = _MToKhaiTTDBID;
                        result = InsertDetailEdit(pId, mstId, dr);
                    }
                    else
                    {
                        query = string.Format("Update DToKhaiTTDB Set Code = N'{0}', Stt = N'{1}', MaNhomTTDB = N'{2}', TenNhomTTDB = N'{3}', MaDVT = N'{4}', SoLuong = {5}, Ps = {6}, Ps1 = {7}, ThueSuat = {8}, Ps2 = {9}, Ps3 = {10} where MToKhaiTTDBID = '{11}' and DToKhaiTTDBID = '{12}'",
                           Utils.parseString(dr["Code"]).Replace("'", "''"), Utils.parseString(dr["Stt"]).Replace("'", "''"), Utils.parseString(dr["MaNhomTTDB"]).Replace("'", "''"), Utils.parseString(dr["TenNhomTTDB"]).Replace("'", "''"), Utils.parseString(dr["MaDVT"]).Replace("'", "''"), Utils.parseDecimal(dr["SoLuong"]).ToString(), Utils.parseDecimal(dr["Ps"]).ToString(), Utils.parseDecimal(dr["Ps1"]).ToString(), Utils.parseDecimal(dr["ThueSuat"]).ToString(), Utils.parseDecimal(dr["Ps2"]).ToString(), Utils.parseDecimal(dr["Ps3"]).ToString(), MToKhaiTTDBID, pId);

                        if (_Database.UpdateByNonQuery(query))
                            result = true;
                        else
                            result = false;
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
        private bool InsertDetailEdit(string pID, string mstID, DataRow dr)
        {
            bool result = false;
            List<string> fieldName = new List<string>();
            List<string> Values = new List<string>();
            try
            {
                fieldName.Clear();
                fieldName.Add("DToKhaiTTDBID");
                fieldName.Add("MToKhaiTTDBID");
                fieldName.Add("Stt");
                fieldName.Add("Code");
                fieldName.Add("TaxCheck");
                fieldName.Add("MaNhomTTDB");
                fieldName.Add("TenNhomTTDB");
                fieldName.Add("MaDVT");
                fieldName.Add("SoLuong");
                fieldName.Add("Ps");
                fieldName.Add("Ps1");
                fieldName.Add("ThueSuat");
                fieldName.Add("Ps2");
                fieldName.Add("Ps3");

                    Values.Clear();
                    Values.Add("convert( uniqueidentifier,'" + pID + "')");
                    Values.Add("convert( uniqueidentifier,'" + mstID + "')");
                Values.Add("N'" + Utils.parseString(dr["Stt"]).Replace("'", "''") + "'");
                Values.Add("N'" + Utils.parseString(dr["Code"]).Replace("'", "''") + "'");
                if (SelectTaxCheck())
                    Values.Add("1");
                else
                    Values.Add("0");
                Values.Add("N'" + Utils.parseString(dr["MaNhomTTDB"]).Replace("'", "''") + "'");
                Values.Add("N'" + Utils.parseString(dr["TenNhomTTDB"]).Replace("'", "''") + "'");
                Values.Add("N'" + Utils.parseString(dr["MaDVT"]).Replace("'", "''") + "'");
                Values.Add(Utils.parseDecimal(dr["SoLuong"]).ToString());
                Values.Add(Utils.parseDecimal(dr["Ps"]).ToString());
                Values.Add(Utils.parseDecimal(dr["Ps1"]).ToString());
                Values.Add(Utils.parseDecimal(dr["ThueSuat"]).ToString());
                Values.Add(Utils.parseDecimal(dr["Ps2"]).ToString());
                Values.Add(Utils.parseDecimal(dr["Ps3"]).ToString());

                result = this._Database.insertRow("DToKhaiTTDB", fieldName, Values);
                return result;
            }
            catch (Exception e)
            {
                XtraMessageBox.Show(e.Message);
                return false;
            }
            
        }
        /// <summary>
        /// Update fieldname TaxCheck của bảng DToKhaiTTDB
        /// </summary>
        /// <returns></returns>
        private bool UpdateTaxCheck()
        {
            string key = string.Empty;
            if (SelectTaxCheck())
                key = "1";
            else
                key = "0";
            try
            {

                query = string.Format(@"update DToKhaiTTDB set TaxCheck = {0} where MToKhaiTTDBID = '{1}'", key.ToString(), _MToKhaiTTDBID);
                if (_Database.UpdateByNonQuery(query))
                    return true;
                return false;
            }
            catch (Exception e)
            {
                XtraMessageBox.Show(e.Message);
                return false;
            }
        }
        /// <summary>
        /// Update DTKhaiKHBS
        /// </summary>
        /// <returns></returns>
        private bool UpdateDTKhaiKHBS()
        {
            bool result = false;

            try
            {
                _Database.BeginMultiTrans();
                string sqlDelete = string.Format("Delete From DToKhaiKHBS Where MToKhaiID = '{0}'", _MToKhaiTTDBID);
                if (_Database.UpdateByNonQuery(sqlDelete))
                    _Database.EndMultiTrans();
                else
                {
                    _Database.RollbackMultiTrans();
                    return false;
                }

                result = InsertDToKhaiKHBS(_MToKhaiTTDBID);

                return result;
            }
            catch (Exception e)
            {
                XtraMessageBox.Show(e.Message);
                return false;
            }
        }
        private void ShowASoftMsg(string pMsg)
        {
            if (Config.GetValue("Language").ToString() == "1")
                pMsg = UIDictionary.Translate(pMsg);
            XtraMessageBox.Show(pMsg);
        }
        private DialogResult ShowASoftMsg(string pMsg, string pCaption)
        {

            if (Config.GetValue("Language").ToString() == "1")
                pMsg = UIDictionary.Translate(pMsg);
            return XtraMessageBox.Show(pMsg, pCaption, MessageBoxButtons.YesNo);
        }
        private void FormatColumns()
        {
            colSoLuong.DisplayFormat.FormatString = FormatString.GetReportFormat("SoLuong");
            colPs.DisplayFormat.FormatString = FormatString.GetReportFormat("Tien");
            colPs1.DisplayFormat.FormatString = FormatString.GetReportFormat("Tien");
            colThueSuat.DisplayFormat.FormatString = FormatString.GetReportFormat("ThueSuat");
            colPs2.DisplayFormat.FormatString = FormatString.GetReportFormat("Tien");
            colPs3.DisplayFormat.FormatString = FormatString.GetReportFormat("SoLuong");
            colTargetAmended.DisplayFormat.FormatString = FormatString.GetReportFormat("Tien");
            colTargetAmended.DisplayFormat.FormatString = FormatString.GetReportFormat("Tien");
            colTargetAmended.DisplayFormat.FormatString = FormatString.GetReportFormat("Tien");
            //master
            sepExperiedDay.Properties.Mask.EditMask = "d";
            sepExperiedDay.Properties.Mask.UseMaskAsDisplayFormat = true;
            sepExperiedDay.Properties.Mask.MaskType = DevExpress.XtraEditors.Mask.MaskType.Numeric;

            sepReceivableExperied.Properties.Mask.EditMask = "d";
            sepReceivableExperied.Properties.Mask.UseMaskAsDisplayFormat = true;
            sepReceivableExperied.Properties.Mask.MaskType = DevExpress.XtraEditors.Mask.MaskType.Numeric;

            calExperiedAmount.Properties.Mask.EditMask = "d";
            calExperiedAmount.Properties.Mask.UseMaskAsDisplayFormat = true;
            calExperiedAmount.Properties.Mask.MaskType = DevExpress.XtraEditors.Mask.MaskType.Numeric;

            calPayableAmount.Properties.Mask.EditMask = "d";
            calPayableAmount.Properties.Mask.UseMaskAsDisplayFormat = true;
            calPayableAmount.Properties.Mask.MaskType = DevExpress.XtraEditors.Mask.MaskType.Numeric;

            calReceivableAmount.Properties.Mask.EditMask = "d";
            calReceivableAmount.Properties.Mask.UseMaskAsDisplayFormat = true;
            calReceivableAmount.Properties.Mask.MaskType = DevExpress.XtraEditors.Mask.MaskType.Numeric;

            if (colSoLuong.ColumnEdit != null)
            {
                (colSoLuong.ColumnEdit as RepositoryItemCalcEdit).EditMask = colSoLuong.DisplayFormat.FormatString;
                (colSoLuong.ColumnEdit as RepositoryItemCalcEdit).Mask.UseMaskAsDisplayFormat = true;
                (colSoLuong.ColumnEdit as RepositoryItemCalcEdit).Mask.EditMask = colSoLuong.DisplayFormat.FormatString;
                (colSoLuong.ColumnEdit as RepositoryItemCalcEdit).ParseEditValue += new DevExpress.XtraEditors.Controls.ConvertEditValueEventHandler(columns_ParseEditValue);
                (colSoLuong.ColumnEdit as RepositoryItemCalcEdit).FormatEditValue += new DevExpress.XtraEditors.Controls.ConvertEditValueEventHandler(columns_FormatEditValue);
            }

            if (colPs.ColumnEdit != null)
            {
                (colPs.ColumnEdit as RepositoryItemCalcEdit).EditMask = colPs.DisplayFormat.FormatString;
                (colPs.ColumnEdit as RepositoryItemCalcEdit).Mask.UseMaskAsDisplayFormat = true;
                (colPs.ColumnEdit as RepositoryItemCalcEdit).Mask.EditMask = colPs.DisplayFormat.FormatString;
                (colPs.ColumnEdit as RepositoryItemCalcEdit).ParseEditValue += new DevExpress.XtraEditors.Controls.ConvertEditValueEventHandler(columns_ParseEditValue);
                (colPs.ColumnEdit as RepositoryItemCalcEdit).FormatEditValue += new DevExpress.XtraEditors.Controls.ConvertEditValueEventHandler(columns_FormatEditValue);
            }

            if (colPs2.ColumnEdit != null)
            {
                (colPs2.ColumnEdit as RepositoryItemCalcEdit).EditMask = colPs2.DisplayFormat.FormatString;
                (colPs2.ColumnEdit as RepositoryItemCalcEdit).Mask.UseMaskAsDisplayFormat = true;
                (colPs2.ColumnEdit as RepositoryItemCalcEdit).Mask.EditMask = colPs2.DisplayFormat.FormatString;
                (colPs2.ColumnEdit as RepositoryItemCalcEdit).ParseEditValue += new DevExpress.XtraEditors.Controls.ConvertEditValueEventHandler(columns_ParseEditValue);
                (colPs2.ColumnEdit as RepositoryItemCalcEdit).FormatEditValue += new DevExpress.XtraEditors.Controls.ConvertEditValueEventHandler(columns_FormatEditValue);
            }

            if (colPs1.RealColumnEdit != null)
            {
                colPs1.RealColumnEdit.EditFormat.FormatString = colPs1.DisplayFormat.FormatString;
                colPs1.RealColumnEdit.EditFormat.FormatType = colPs1.DisplayFormat.FormatType;
                colPs1.RealColumnEdit.ParseEditValue += new DevExpress.XtraEditors.Controls.ConvertEditValueEventHandler(colPs1_ParseEditValue);
            }

            if (colThueSuat.RealColumnEdit != null)
            {
                colThueSuat.RealColumnEdit.EditFormat.FormatString = colThueSuat.DisplayFormat.FormatString;
                colThueSuat.RealColumnEdit.EditFormat.FormatType = colThueSuat.DisplayFormat.FormatType;
                colThueSuat.RealColumnEdit.ParseEditValue += new DevExpress.XtraEditors.Controls.ConvertEditValueEventHandler(colThueSuat_ParseEditValue);
            }

            if (colPs3.RealColumnEdit != null)
            {
                colPs3.RealColumnEdit.EditFormat.FormatString = colPs3.DisplayFormat.FormatString;
                colPs3.RealColumnEdit.EditFormat.FormatType = colPs3.DisplayFormat.FormatType;
                colPs3.RealColumnEdit.ParseEditValue += new DevExpress.XtraEditors.Controls.ConvertEditValueEventHandler(colPs3_ParseEditValue);
            }
        }

        /// <summary>
        /// Get new ID
        /// </summary>
        private string GetNewID()
        {
            string result = _Database.GetValue("select NEWID()").ToString();

            return result;
        }

        #endregion ---- Private methods ----

        private void btnReadData_Click(object sender, EventArgs e)
        {
            if (this._Action == FormAction.AddNew)
            {
                if (CheckInput())
                {
                    _DataMain = GetData();
                    LoadTaxCheckEdit(1);
                    InitDataTable(0);
                    this.FormatColumns();
                    gvToKhai.RefreshData();
                }
            }
            if (_DataMain != null)
            {
                gcToKhai.DataSource = _DataMain;
            }
            if (_dtKHBS != null)
                gcKHBS.DataSource = _dtKHBS;

            // Tính toán lại.
            Recalculate();
        }
        /// <summary>
        /// Đọc dữ liệu kì liền kề trước đó để load nên tờ khai
        /// </summary>
        /// <returns></returns>
        private DataTable GetData()
        {
            DataTable data = null;
            try
            {
                string soLanIn = string.Empty;
                if (chkInLanDau.Checked)
                {
                    soLanIn = "0";
                    data = GetStandardData();
                }
                else
                {
                    soLanIn = sepSoLanIn.EditValue.ToString();
                    query = string.Format(@"select M.NgayToKhaiTTDB, M.DeclareType, M.KyToKhaiTTDB, M.NamToKhaiTTDB, M.InputDate
                          , M.InLanDau, M.SoLanIn, D.DToKhaiTTDBID, D.Code, D.Stt, D.MaNhomTTDB
                          , D.TenNhomTTDB, D.MaDVT, D.SoLuong, D.Ps, D.Ps1, D.ThueSuat, D.Ps2, D.Ps3 
                        from DToKhaiTTDB D  inner join MToKhaiTTDB M on M.MToKhaiTTDBID = D.MToKhaiTTDBID
                        Where M.NamToKhaiTTDB = {0} 
                        and ((Case when {1} = 1 then M.KyToKhaiTTDB end) = {2} or
                         (Case when {1} = 2 then M.InputDate end) = Cast('{3}' as Datetime)) 
                        and M.SoLanin = isnull({4},0)-1
                        order by D.Code", NamTaiChinh(), radDeclareType.SelectedIndex == 0 ? "1" : "2", cboKyToKhaiTTDB.EditValue == null ? 0 : cboKyToKhaiTTDB.EditValue, dtmInputDate.EditValue == null ? DateTime.Now.ToShortDateString() : dtmInputDate.DateTime.ToShortDateString(), soLanIn);
                    data = _Database.GetDataTable(query);
                    DataColumn column = new DataColumn("Check", typeof(Decimal));
                    data.Columns.Add(column);
                }
                gcToKhai.DataSource = data;
                gvToKhai.BestFitColumns();
                return data;
            }
            catch (Exception ex)
            {
                XtraMessageBox.Show(ex.Message);
                return null;
            }
        }
        /// <summary>
        /// Handling Save
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnSave_Click(object sender, EventArgs e)
        {
            if (_DataMain != null && _DataMain.HasErrors)
            {
                ShowASoftMsg("Dữ liệu chưa chính xác!");
                return;
            }
            if (this._Action == FormAction.AddNew)
            {
                if (_DataMain == null)
                {
                    ShowASoftMsg("Chưa nhập dữ liệu tờ khai");
                    return;
                }
                if (!CheckInput())
                {
                    ShowASoftMsg("Không được phép để trống");
                    return;
                }
                if (CheckExist())
                {
                    ShowASoftMsg("Tờ khai thuế đã tồn tại");
                    return;
                }
                string pMstID = string.Empty;
                _Database.BeginMultiTrans();
                if (InsertMaster(out pMstID))
                {
                    if (InsertDetail(pMstID))
                    {
                        if (!chkInLanDau.Checked)
                        {
                            InsertDToKhaiKHBS(pMstID);
                            //{
                                //_Database.RollbackMultiTrans();
                            //}
                        }
                        ShowASoftMsg("Tờ khai thuế tạo thành công!");
                        this.Close();

                    }
                    else
                    {
                        _Database.RollbackMultiTrans();
                    }
                }
                else
                {
                    _Database.RollbackMultiTrans();
                }
                _Database.EndMultiTrans();
            }
            else if (this.Action == FormAction.Edit)
            {
                if (_DataMain == null)
                {
                    ShowASoftMsg("Chưa nhập dữ liệu tờ khai");
                    return;
                }
                if (UpdateTaxCheck() && UpdateDetailToKhai() && UpdateMaster())
                {

                    if (!chkInLanDau.Checked)
                    {
                        if (!UpdateDTKhaiKHBS())
                        {
                        }
                    }
                     ShowASoftMsg("Cập nhật tờ khai thuế GTGT thành công!");
                            this.Close();
                }
            }
        }

        private void gvToKhai_CustomRowCellEditForEditing(object sender, DevExpress.XtraGrid.Views.Grid.CustomRowCellEditEventArgs e)
        {
            try
            {
                string fieldName = gvToKhai.FocusedColumn.FieldName;
                string code = GetString(gvToKhai.FocusedRowHandle, "Code");


                if (fieldName.Contains("TenNhomTTDB"))
                {
                    if ((code.StartsWith("01") || code.StartsWith("03")))
                    {
                        e.RepositoryItem = lueTenNhomTTDB1;
                    }
                    else if (code.StartsWith("02"))
                    {
                        e.RepositoryItem = lueTenNhomTTDB2;
                    }
                }
            }
            catch { }
        }

        private void gvToKhai_CellValueChanged(object sender, DevExpress.XtraGrid.Views.Base.CellValueChangedEventArgs e)
        {
            DataRow row = null;

            if (e.Column.FieldName.Equals("TenNhomTTDB"))
            {
                row = gvToKhai.GetDataRow(e.RowHandle);
                if (row != null)
                {
                    string tenNhomTTDB = e.Value == null || e.Value == DBNull.Value ? string.Empty : e.Value.ToString();
                    string code = GetString(row, "Code");
                    DataRowView row1 = lueTenNhomTTDB1.GetDataSourceRowByDisplayValue(tenNhomTTDB) as DataRowView;
                    DataRowView row2 = lueTenNhomTTDB2.GetDataSourceRowByDisplayValue(tenNhomTTDB) as DataRowView;

                    if (row1 != null)
                    {
                        row["MaNhomTTDB"] = row1["MaNhomTTDB"];
                        row["MaDVT"] = row1["DVT"];
                        if (code.StartsWith("01") || code.StartsWith("02"))
                        {
                            row["MaDVT"] = row1["DVT"];
                            row["ThueSuat"] = row1["ThueSuatTTDB"];
                        }
                    }
                    else if (row2 != null)
                    {
                        row["MaNhomTTDB"] = row2["MaNhomTTDB"];
                        row["MaDVT"] = row2["DVT"];
                        if (code.StartsWith("01") || code.StartsWith("02"))
                        {
                            row["MaDVT"] = row2["DVT"];
                            row["ThueSuat"] = row2["ThueSuatTTDB"];
                        }
                    }
                    else
                    {
                        row["MaNhomTTDB"] = null;
                        row["MaDVT"] = null;
                        row["ThueSuat"] = null;
                    }
                }
                this.FormatColumns();
                gvToKhai.RefreshData();
            }

            // Tính toán lại.
            Recalculate();
        }

        private void gvToKhai_ValidatingEditor(object sender, BaseContainerValidateEditorEventArgs e)
        {
            string msg = string.Empty;

            if (gvToKhai.FocusedColumn.FieldName.Equals("TenNhomTTDB"))
            {
                if (e.Value == null) return;

                int index1 = gvToKhai.FocusedRowHandle;
                string tenNhomTTDB1 = e.Value.ToString();
                string code1 = GetString(index1, "Code");

                int index2 = index1;
                string tenNhomTTDB2 = string.Empty;
                string code2 = string.Empty;
                do
                {
                    index2--;
                    code2 = GetString(index2, "Code");
                } while (!code2.EndsWith("00"));

                do
                {
                    index2++;
                    code2 = GetString(index2, "Code");
                    tenNhomTTDB2 = GetString(index2, "TenNhomTTDB");

                    if (index1 != index2 && tenNhomTTDB2.Equals(tenNhomTTDB1))
                    {
                        msg = "Trùng mã nhóm thuế. Vui lòng chọn nhóm thuế khác.";
                        if (Config.GetValue("Language").ToString() == "1")
                            msg = UIDictionary.Translate(msg);
                        e.ErrorText = msg;
                        e.Valid = false;
                    }
                } while (!code2.EndsWith("00"));
            }
            else if (Utils.parseDecimal(e.Value) < 0)
            {
                msg = "Phải nhập số lớn hơn 0.";
                if (Config.GetValue("Language").ToString() == "1")
                    msg = UIDictionary.Translate(msg);
                e.ErrorText = msg;
                e.Valid = false;
            }
            else if (gvToKhai.FocusedColumn.FieldName.Equals("Ps2"))
            {
                decimal thueSuat = Utils.parseDecimal(gvToKhai.GetFocusedRowCellValue("ThueSuat"));
                decimal ps1 = Utils.parseDecimal(gvToKhai.GetFocusedRowCellValue("Ps1"));
                decimal ps2 = Utils.parseDecimal(e.Value);
                if (ps2 > (ps1 * thueSuat / 100))
                {
                    msg = "Thuế TTĐB được khấu trừ (8) không được lớn hơn tổng thuế TTĐB đã điều chỉnh (6 x 7 - 9).";
                    if (Config.GetValue("Language").ToString() == "1")
                        msg = UIDictionary.Translate(msg);
                    e.ErrorText = msg;
                    e.Valid = false;
                }
            }
            else if (e.Value == null)
            {
                e.Value = 0;
            }
        }

        private void gvToKhai_ShowingEditor(object sender, CancelEventArgs e)
        {
            e.Cancel = !CheckAllowEdit(gvToKhai.FocusedRowHandle, gvToKhai.FocusedColumn.FieldName);

        }


        private void columns_ParseEditValue(object sender, DevExpress.XtraEditors.Controls.ConvertEditValueEventArgs e)
        {
            CalcEdit calc = sender as CalcEdit;
            if (calc == null || e.Value == null) return;
            e.Value = Utils.parseDecimal(e.Value).ToString(calc.Properties.EditMask);
            e.Handled = true;
        }
        private void columns_FormatEditValue(object sender, DevExpress.XtraEditors.Controls.ConvertEditValueEventArgs e)
        {
            CalcEdit calc = sender as CalcEdit;
            if (calc == null || e.Value == null) return;
            e.Value = Utils.parseDecimal(e.Value).ToString(calc.Properties.EditMask);
            calc.EditValue = Utils.parseDecimal(e.Value);
            e.Handled = true;
        }
        private void colPs1_ParseEditValue(object sender, DevExpress.XtraEditors.Controls.ConvertEditValueEventArgs e)
        {
            if (e.Value == null) return;
            e.Value = Utils.parseDecimal(e.Value).ToString(colPs1.DisplayFormat.FormatString);
            e.Handled = true;
        }

        private void colThueSuat_ParseEditValue(object sender, DevExpress.XtraEditors.Controls.ConvertEditValueEventArgs e)
        {
            if (e.Value == null) return;
            e.Value = Utils.parseDecimal(e.Value).ToString(colThueSuat.DisplayFormat.FormatString);
            e.Handled = true;
        }

        private void colPs3_ParseEditValue(object sender, DevExpress.XtraEditors.Controls.ConvertEditValueEventArgs e)
        {
            if (e.Value == null) return;
            e.Value = Utils.parseDecimal(e.Value).ToString(colPs3.DisplayFormat.FormatString);
            e.Handled = true;
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void gvToKhai_CustomRowCellEdit(object sender, DevExpress.XtraGrid.Views.Grid.CustomRowCellEditEventArgs e)
        {
            string str = "000000";
            object obj = gvToKhai.GetRowCellValue(e.RowHandle, "Code");
            if (obj == null || obj.ToString() == string.Empty)
                return;
            if (e.Column.FieldName == "Check")
            {
                if (str.Equals(obj.ToString()))
                {
                    taxCheck.CheckStyle = CheckStyles.Standard;
                    e.RepositoryItem = taxCheck;
                }
                else
                {
                    e.RepositoryItem = dummy;
                }
            }
        }
        /// <summary>
        /// Xử lý event Checkedchange của checkbox taxCheck
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void taxCheck_CheckedChanged(object sender, EventArgs e)
        {
            CheckEdit taxEdit = sender as CheckEdit;
            DataRow[] rows = _DataMain.Select(string.Format("Code = 000000"));
            if (rows.Length <= 0) return;
            if (taxEdit.Checked)
            {
                // Restart các số liệu hoạt động mua bán về 0
                if (this.ShowASoftMsg("Các số liệu đã có trong các chỉ tiêu phát sinh trong kỳ sẽ bị xóa bằng 0. Có đồng ý không?", "Thông báo") == DialogResult.Yes)
                {
                    GetValue();

                    // giữ lại giá trị cũ
                    //_SoLuong_before = _soLuong;
                    //_Ps_before = _ps;
                    //_Ps1_before = _ps1;
                    //_ThueSuat_before = _thueSuat;

                    for (int i = 0; i < _rowCount; i++)
                    {
                        for (int j = 0; j < VALUE_AMOUNT; j++)
                        {
                            _originalData[i, j] = _currentData[i, j];
                        }
                    }

                    for (int i = 0; i < _rowCount; i++)
                    {
                        for (int j = 0; j < VALUE_AMOUNT; j++)
                        {
                            _currentData[i, j] = 0;
                        }
                    }

                    _GetOriginalData = true;

                    // Tính toán lại.
                    Recalculate();
                    FillResult();
                }

                else
                {
                    taxEdit.Checked = false;
                }
            }
            else
            {
                //rollback data
                if (_GetOriginalData)
                {
                    for (int i = 0; i < _rowCount; i++)
                    {
                        for (int j = 0; j < VALUE_AMOUNT; j++)
                        {
                            _currentData[i, j] = _originalData[i, j];
                        }
                    }

                    // Tính toán lại.
                    Recalculate();
                    FillResult();
                }

            }
        }
        private void GetValue()
        {
            _rowCount = gvToKhai.RowCount;
            _originalData = new double[_rowCount, VALUE_AMOUNT];
            _currentData = new double[_rowCount, VALUE_AMOUNT];

            for (int i = 0; i < gvToKhai.RowCount; i++)
            {
                DataRow row = gvToKhai.GetDataRow(i);
                string code = GetString(i, "Code");
                if (code.StartsWith("01") || code.StartsWith("02"))
                {
                    int j = 0;
                    _currentData[i, j++] = row["SoLuong"] == DBNull.Value ? 0 : double.Parse(row["SoLuong"].ToString());
                    _currentData[i, j++] = row["Ps"] == DBNull.Value ? 0 : double.Parse(row["Ps"].ToString());
                    _currentData[i, j++] = row["Ps1"] == DBNull.Value ? 0 : double.Parse(row["Ps1"].ToString());
                    _currentData[i, j++] = row["ThueSuat"] == DBNull.Value ? 0 : double.Parse(row["ThueSuat"].ToString());
                }
            }
        }
        /// <summary>
        /// Fill dữ liệu/ rollback dữ liệu khi check rồi lại uncheck
        /// </summary>
        private void FillResult()
        {
            for (int i = 0; i < gvToKhai.RowCount; i++)
            {
                DataRow row = gvToKhai.GetDataRow(i);
                string code = GetString(i, "Code");
                if (code.StartsWith("01") || code.StartsWith("02"))
                {
                    int j = 0;
                    row["SoLuong"] = _currentData[i, j++];
                    row["Ps"] = _currentData[i, j++];
                    row["Ps1"] = _currentData[i, j++];
                    row["ThueSuat"] = _currentData[i, j++];
                }
            }
        }
        /// <summary>
        /// Handling event rowcellstyle
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void gvToKhai_RowCellStyle(object sender, DevExpress.XtraGrid.Views.Grid.RowCellStyleEventArgs e)
        {
            try
            {
                bool checkAllowEdit = CheckAllowEdit(e.RowHandle, e.Column.FieldName);
                if (!e.Column.OptionsColumn.AllowEdit || !checkAllowEdit)
                {
                    e.Appearance.BackColor = Color.FromArgb(240, 240, 240);
                    e.Appearance.BackColor2 = e.Appearance.BackColor;
                    e.Appearance.ForeColor = Color.Black;
                    if (!checkAllowEdit)
                    {
                        e.Appearance.Font = new Font(e.Appearance.Font, FontStyle.Bold);
                    }
                    return;
                }
                if (e.Column.FieldName == "Check")
                {
                     e.Appearance.BackColor = Color.FromArgb(240, 240, 240);
                    e.Appearance.BackColor2 = e.Appearance.BackColor;
                    e.Appearance.ForeColor = Color.Black;
                }
            }
            catch { }
        }
        /// <summary>
        /// Thay đổi số lần bổ sung thì cần kiểm tra xem lần bổ sung đó là lần kế tiếp hay không 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void sepSoLanIn_EditValueChanged(object sender, EventArgs e)
        {
            if (!CheckSoLanIn(int.Parse(sepSoLanIn.EditValue.ToString())))
            {
                ShowASoftMsg("Không tồn tại tờ khai thuế này trong kỳ tính thuế trên!");
                Solanin();
                return;
            }
        }
        private void dtmInputDate_EditValueChanged(object sender, EventArgs e)
        {
            Solanin();
        }
        private void cboKyToKhaiTTDB_EditValueChanged(object sender, EventArgs e)
        {
            Solanin();
        }
        /// <summary>
        /// Xử lý Load số lần in khi tờ khai là khai bổ sung
        /// </summary>
        private void Solanin()
        {
            if (chkInLanDau.Checked)
                return;
            int _in = 0;
            object a = cboKyToKhaiTTDB.EditValue;
            query = string.Format(@"select Max(M.SoLanIn)
                    from MToKhaiTTDB M
                    Where M.NamToKhaiTTDB = {0} 
                    and ((Case when {1} = 1 then M.KyToKhaiTTDB end) = {2} or
                     (Case when {1} = 2 then M.InputDate end) = Cast('{3}' as Datetime))", NamTaiChinh(), radDeclareType.SelectedIndex == 0 ? "1" : "2", cboKyToKhaiTTDB.EditValue == null ? 0 : cboKyToKhaiTTDB.EditValue, dtmInputDate.EditValue == null ? DateTime.Now.ToShortDateString() : dtmInputDate.DateTime.ToShortDateString());
            object b = _Database.GetValue(query);
            if (b != DBNull.Value)
            {
                _in = Convert.ToInt32(_Database.GetValue(query));
                sepSoLanIn.EditValue = _in + 1;
            }
            else
            {
                sepSoLanIn.EditValue = 0;
            }
        }
        /// <summary>
        /// Handling button Tổng hợp tờ khai
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnKHBS_Click(object sender, EventArgs e)
        {
            if (CheckInput())
            {
                FillResultKHBS();
                xtraTabControl1.SelectedTabPageIndex = 1;
            }
        }
        /// <summary>
        /// Tạo DataTable chứa các cột trong bảng DToKhaiKHBS
        /// </summary>
        private void InitDataTable(int option)
        {
            if (!chkInLanDau.Checked)
            {
                if (option == 0) //Trường hợp thêm mới thì tạo datatable rỗng
                    _dtKHBS = _Database.GetDataTable("Select * From DToKhaiKHBS Where 2=1");

                else if(option == 1) //Trường hợp edit
                {
                    string sql = string.Format(@"Select *
                                                From DToKhaiKHBS
                                                Where MToKhaiID= '{0}'
                                                Order by SortOrder", _MToKhaiTTDBID);
                    _dtKHBS = _Database.GetDataTable(sql);
                    //gcKHBS.DataSource = _dtKHBS;
                    //gvKHBS.BestFitColumns();
                    //gvKHBS.RefreshData();
                }
                gcKHBS.DataSource = _dtKHBS;
                gvKHBS.BestFitColumns();
                gvKHBS.RefreshData();

            }
        }
        /// <summary>
        /// Fill dữ liệu qua tab Giải trình bổ sung
        /// </summary>
        private void FillResultKHBS()
        {
            DataRow rowbefore = null;
            DataRow row = null;
            DataRow dr = null;
            string code = string.Empty;
            decimal ps2 = 0;
            decimal ps3 = 0;
            decimal ps2before = 0;
            decimal ps3before = 0;

            // Lấy dữ liệu chưa chỉnh sửa

            DataTable _BeforeTable = ChiTieuSoSanhKHBS();
            rowbefore = _BeforeTable.Rows[0];
            ps2before = GetDecimal(rowbefore, "Ps2");
            ps3before = GetDecimal(rowbefore, "Ps3");

            // lấy dữ liệu đã chỉnh sửa
         
            row = _DataMain.Rows[_DataMain.Rows.Count - 1];
            code = GetString(row, "Code");

            // Nếu là dòng tổng cộng thì lấy giá trị của Ps2 và Ps3
            if (code.EndsWith("0000"))
            {
                ps2 = GetDecimal(row, "Ps2");
                ps3 = GetDecimal(row, "Ps3");

            }
            // So sánh
            if (_dtKHBS.Rows.Count > 0)
            {
                _SortOrder = 1;
                _dtKHBS.Rows.Clear();
            }


            if (ps2before == ps2)
            {
                // dòng 1
                dr = _dtKHBS.NewRow();
                dr["SortOrder"] = _SortOrder;
                dr["TargetTypeID"] = "I. Chỉ tiêu điều chỉnh tăng số thuế phải nộp";
                dr["TargetReturn"] = 0;
                dr["TargetAmended"] = 0;
                dr["TargetDifference"] = 0;
                _dtKHBS.Rows.Add(dr);
                _SortOrder++;
                //dòng 2
                dr = _dtKHBS.NewRow();
                dr["SortOrder"] = _SortOrder;
                dr["TargetTypeID"] = "II. Chỉ tiêu điều chỉnh giảm số thuế phải nộp";
                dr["TargetReturn"] = 0;
                dr["TargetAmended"] = 0;
                dr["TargetDifference"] = 0;
                _dtKHBS.Rows.Add(dr);
                _SortOrder++;
                // dòng 3
                dr = _dtKHBS.NewRow();
                dr["SortOrder"] = _SortOrder;
                dr["TargetTypeID"] = "III. Tổng hợp điều chỉnh số thuế phải nộp (tăng: +; giảm: -)";
                dr["TargetName"] = "Thuế TTDB phải nộp";
                dr["TargetID"] = 9;
                dr["TargetReturn"] = 0;
                dr["TargetAmended"] = 0;
                dr["TargetDifference"] = ps3 - ps3before;
                _dtKHBS.Rows.Add(dr);
            }
            else if (ps2before < ps2)
            {
                // dòng 1
                dr = _dtKHBS.NewRow();
                dr["SortOrder"] = _SortOrder;
                dr["TargetTypeID"] = "I. Chỉ tiêu điều chỉnh tăng số thuế phải nộp";
                dr["TargetReturn"] = 0;
                dr["TargetAmended"] = 0;
                dr["TargetDifference"] = 0;
                _dtKHBS.Rows.Add(dr);
                _SortOrder++;
                //dòng 2
                dr = _dtKHBS.NewRow();
                dr["SortOrder"] = _SortOrder;
                dr["TargetTypeID"] = "II. Chỉ tiêu điều chỉnh giảm số thuế phải nộp";
                dr["TargetName"] = "Thuế TTDB được khấu trừ";
                dr["TargetID"] = 8;
                dr["TargetReturn"] = ps2before;
                dr["TargetAmended"] = ps2;
                dr["TargetDifference"] = ps2 - ps2before;
                _dtKHBS.Rows.Add(dr);
                _SortOrder++;
                // dòng 3
                dr = _dtKHBS.NewRow();
                dr["SortOrder"] = _SortOrder;
                dr["TargetTypeID"] = "III. Tổng hợp điều chỉnh số thuế phải nộp (tăng: +; giảm: -)";
                dr["TargetName"] = "Thuế TTDB phải nộp";
                dr["TargetID"] = 9;
                dr["TargetReturn"] = 0;
                dr["TargetAmended"] = 0;
                dr["TargetDifference"] = ps3 - ps3before;
                _dtKHBS.Rows.Add(dr);
            }
            else if (ps2before > ps2)
            {
                // dòng 1
                dr = _dtKHBS.NewRow();
                dr["SortOrder"] = _SortOrder;
                dr["TargetTypeID"] = "II. Chỉ tiêu điều chỉnh giảm số thuế phải nộp";
                dr["TargetName"] = "Thuế TTDB được khấu trừ";
                dr["TargetID"] = 8;
                dr["TargetReturn"] = ps2before;
                dr["TargetAmended"] = ps2;
                dr["TargetDifference"] = ps2 - ps2before;
                _dtKHBS.Rows.Add(dr);
                _SortOrder++;
                //dòng 2
                dr = _dtKHBS.NewRow();
                dr["SortOrder"] = _SortOrder;
                dr["TargetTypeID"] = "I. Chỉ tiêu điều chỉnh tăng số thuế phải nộp";
                dr["TargetReturn"] = 0;
                dr["TargetAmended"] = 0;
                dr["TargetDifference"] = 0;
                _dtKHBS.Rows.Add(dr);
                _SortOrder++;
                // dòng 3
                dr = _dtKHBS.NewRow();
                dr["SortOrder"] = _SortOrder;
                dr["TargetTypeID"] = "III. Tổng hợp điều chỉnh số thuế phải nộp (tăng: +; giảm: -)";
                dr["TargetName"] = "Thuế TTDB phải nộp";
                dr["TargetID"] = 9;
                dr["TargetReturn"] = 0;
                dr["TargetAmended"] = 0;
                dr["TargetDifference"] = ps3 - ps3before;
                _dtKHBS.Rows.Add(dr);
            }
        }
        /// <summary>
        /// Return table contain có số liệu cần so sánh khi tổng hợp giải trình bổ sung
        /// </summary>
        /// <returns></returns>
        private DataTable ChiTieuSoSanhKHBS()
        {
            DataTable data = null;
            string soLanIn = string.Empty;
            if (chkInLanDau.Checked)
                soLanIn = "0";
            else
                soLanIn = sepSoLanIn.EditValue.ToString();
            string query1 = string.Format(@"select MToKhaiTTDBID
                        from MToKhaiTTDB 
                        Where NamToKhaiTTDB = {0} 
                        and ((Case when {1} = 1 then KyToKhaiTTDB end) = {2} or
                         (Case when {1} = 2 then InputDate end) = Cast('{3}' as Datetime)) 
                        and SoLanin = isnull({4},0)-1 ", NamTaiChinh(), radDeclareType.SelectedIndex == 0 ? "1" : "2", cboKyToKhaiTTDB.EditValue == null ? 0 : cboKyToKhaiTTDB.EditValue, dtmInputDate.EditValue == null ? DateTime.Now.ToShortDateString() : dtmInputDate.DateTime.ToShortDateString(), soLanIn);
            string key = _Database.GetValue(query1).ToString();

            query = string.Format(@"Select Ps2, Ps3, Code from DToKhaiTTDB
                                     where MToKhaiTTDBID = '{0}' and Code = '990000' order by Code", key);
            data = _Database.GetDataTable(query);
            if (data.Rows.Count > 0)
                return data;
            return null;
        }

        private void gvToKhai_CellMerge(object sender, DevExpress.XtraGrid.Views.Grid.CellMergeEventArgs e)
        {
            if (e.Column != gvToKhai.Columns["Check"]) return;
            e.Merge = true;
            e.Handled = true;
        }
    }
}