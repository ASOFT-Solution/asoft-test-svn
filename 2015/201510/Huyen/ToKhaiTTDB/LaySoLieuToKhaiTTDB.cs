using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using DevExpress.XtraEditors;
using CDTDatabase;
using CDTLib;
using CDTControl;
using DevExpress.XtraLayout.Utils;
using FormFactory;
using DevExpress.Utils;
using DevExpress.XtraEditors.Controls;
using DevExpress.XtraEditors.Repository;
using DevExpress.XtraGrid.Columns;

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
        private string _MToKhaiTTDBID = string.Empty;
        public FormAction Action { get; set; }
        private DataTable _DataMain1 = null;
        private DataTable _DataMain2 = null;

        #endregion ---- Member variables ----

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
            _NamTaiChinh = Config.GetValue("NamToKhaiTTDB") == null ? -1 : int.Parse(Config.GetValue("NamToKhaiTTDB").ToString());
            this.FormatColumns();
            this.dtmNgayToKhaiTTDB.EditValue = String.Format("{0:d}", DateTime.Now);
            this.LoadMaster();
            this.checkComboStatus();
            this.checkComboIsExten();
            this.checkInLanDau();
            this.LoadTTDB();
            if (this.Action == FormAction.New)
            {
                _DataMain1 = this.GetStandardData();
            }
            else
            {
                _DataMain1 = this.GetData();
            }

            if (_DataMain1 != null)
            {
                gcToKhai.DataSource = _DataMain1;
            }

            if (Config.GetValue("Language").ToString() == "1")
            {
                FormFactory.DevLocalizer.Translate(this);
            }
            foreach (GridColumn column in gvToKhai.Columns)
                column.OptionsColumn.AllowSort = DefaultBoolean.False;
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
        //private void gvToKhai_RowCellStyle(object sender, DevExpress.XtraGrid.Views.Grid.RowCellStyleEventArgs e)
        //{
        //    try
        //    {
        //        bool checkAllowEdit = CheckAllowEdit(e.RowHandle, e.Column.FieldName);
        //        if (!e.Column.OptionsColumn.AllowEdit || !checkAllowEdit)
        //        {
        //            e.Appearance.BackColor = Color.FromArgb(240, 240, 240);
        //            e.Appearance.BackColor2 = e.Appearance.BackColor;
        //            e.Appearance.ForeColor = Color.Black;
        //            if (!checkAllowEdit)
        //            {
        //                e.Appearance.Font = new Font(e.Appearance.Font, FontStyle.Bold);
        //            }
        //            return;
        //        }
        //    }
        //    catch { }
        //}

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

                if (code.EndsWith("00") || (code.StartsWith("03") && fieldName.Contains("Ps2")))
                {
                    return false;
                }
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
         private decimal ParseDecimal(object obj)
         {
             decimal result = (obj == null || obj == DBNull.Value) ? 0 : decimal.Parse(obj.ToString());
             return result;
         }
        //Xử lý phim F2
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
             DataRow newRow = _DataMain1.NewRow();
             newRow["Code"] = parentCode + newSTT.ToString("00");
             newRow["Stt"] = newSTT;
             _DataMain1.Rows.InsertAt(newRow, newIndex);

             gvToKhai.FocusedColumn = gvToKhai.Columns["TenNhomTTDB"];
             gvToKhai.FocusedRowHandle++;

             e.Handled = true;
         }

         /// <summary>
         /// Xử lý phím tắt F4.
         /// </summary>
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
             _DataMain1.Rows.RemoveAt(gvToKhai.FocusedRowHandle);

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
             for (int i = _DataMain1.Rows.Count - 1; i >= 0; i--)
             {
                 row = _DataMain1.Rows[i];
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
             row = _DataMain1.Rows[_DataMain1.Rows.Count - 1];
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
            string query1 = @"Select * from DMThueCapCuc";
            DataTable table1 = _Database.GetDataTable(query1);
            cboTaxDepartmentID.Properties.DataSource = table1;
            cboTaxDepartmentID.Properties.DisplayMember = "TaxDepartmentName";
            cboTaxDepartmentID.Properties.ValueMember = "TaxDepartmentID";
            //Đổ dữ liệu lên combox Gia hạn
            string query2 = @"Select * from DMGH";
            DataTable table2 = _Database.GetDataTable(query2);
            cboExtenID.Properties.DataSource = table2;
            cboExtenID.Properties.DisplayMember = "ExtenName";
            cboExtenID.Properties.ValueMember = "ExtenID";
            //Đổ dữ liệu lên combox Danh mục ngành nghề
            string query3 = @"Select * from DMNN Where TaxType = N'TTDB'";
            DataTable table3 = _Database.GetDataTable(query3);
            cboVocationID.Properties.DataSource = table3;
            cboVocationID.Properties.DisplayMember = "VocationName";
            cboVocationID.Properties.ValueMember = "VocationID";
            // Load default kỳ kế toán
            for (int i = 1; i < 13; i++)
            {
                cboKyToKhaiTTDB.Properties.Items.Add(i);
            }              
        }
        //lấy thông tin mã nhóm thuế
        private void LoadTTDB()
        {
            string query1 = "select MaNhomTTDB,TenNhomTTDB, ThueSuatTTDB, DVT from DMThueTTDB where ThueSuatTTDB > 0 and MaNhomTTDB like 'I.%'";
            DataTable table1 = _Database.GetDataTable(query1);
            this.lueTenNhomTTDB1.Properties.DataSource = table1;
            this.lueTenNhomTTDB1.Properties.NullText = "";

            string query2 = "select MaNhomTTDB, TenNhomTTDB, ThueSuatTTDB, DVT from DMThueTTDB where ThueSuatTTDB > 0 and MaNhomTTDB like 'II.%'";
            DataTable table2 = _Database.GetDataTable(query2);
            this.lueTenNhomTTDB2.Properties.DataSource = table2;
            this.lueTenNhomTTDB2.Properties.NullText = "";

            if (Config.GetValue("Language").ToString() == "1")
            {
                FormFactory.DevLocalizer.Translate(this);
            }
        }
        private void LoadDMThueCapQL()
        {
            //Đổ dữ liệu lên combox Tên cơ quan thuế cấp cục
            object str = cboTaxDepartmentID.EditValue;
            string query4 = string.Format(@"Select * from DMThueCapQL Where  TaxDepartmentID = {0}", str);
            DataTable table4 = _Database.GetDataTable(query4);
            cboTaxDepartID.Properties.DataSource = table4;
            cboTaxDepartID.Properties.ValueMember = "TaxDepartID";
            cboTaxDepartID.Properties.DisplayMember = "TaxDepartName";
        }
        #endregion ---- Lấy thông tin combo ----

        // trạng thái chọn của rad
        private void checkComboStatus()
        {
            if (IsKyToKhaiTTDB())
            {
                dtmInputDate.Enabled = true;
                cboKyToKhaiTTDB.Enabled = false;
            }
            else
            {
                dtmInputDate.Enabled = false;
                cboKyToKhaiTTDB.Enabled = true;
            }
        }
        private bool IsKyToKhaiTTDB()
        {
            return Utils.parseInt(radDeclareType.EditValue).Equals((int)ListType.KyToKhaiTTDB);
        }
        
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

            }
        }
        private void checkComboIsExten()
        {
            if (this.chkIsExten.Checked)
            {
                cboExtenID.Enabled = true;
            }
            else
            {
                cboExtenID.Enabled = false;
            }
        }
        // dữ liệu lúc thêm mới
        private DataTable GetStandardData()
        {
            DataTable data = null;
            try
            {
                string query = @"select Code, Stt, MaNhomTTDB, TenNhomTTDB, MaDVT, SoLuong, Ps, Ps1, ThueSuat, Ps2, Ps3 from ToKhaiTTDB";
                data = _Database.GetDataTable(query);
                return data;
            }
            catch (Exception ex)
            {
                XtraMessageBox.Show(ex.Message);
                return null;
            }
        }
        //lấy dữ liệu lúc sửa
        private DataTable GetData()
        {
            DataTable data = null;

            try
            {
                string query = string.Format("select DToKhaiTTDBID, Stt,TenNhomTTDB, TaxCheck, MaDVT, SoLuong, Ps, Ps1, ThueSuat, Ps2, Ps3 from DToKhaiTTDB where MToKhaiTTDBID = '{0}' order by Code",
                    MToKhaiTTDBID);
                data = _Database.GetDataTable(query);

                return data;
            }
            catch (Exception ex)
            {
                XtraMessageBox.Show(ex.Message);
                return null;
            }
        }
       // Kiểm tra tờ khai đã tồn tại
        //(Thêm mới hoặc sửa)
        private bool CheckInput()
        {
            string query = string.Format(@"Select Top 1 * From MToKhaiTTDB
                            Where NamToKhaiTTDB = {0} 
                            and ((Case when {1} = 1 
                              then KyToKhaiTTDB end) = {2} or
                              (Case when {1} = 2 
                              then InputDate end) = Cast({3} as Datetime)) 
                            and SoLanin = isnull({4},0)", _NamTaiChinh, radDeclareType.EditValue, cboKyToKhaiTTDB.EditValue == null ? 0 : cboKyToKhaiTTDB.EditValue, dtmInputDate.EditValue == null ? String.Format("{0:d}", DateTime.Now) : dtmInputDate.EditValue, sepSoLanIn.EditValue);
            DataTable table = _Database.GetDataTable(query);
            if(table.Rows.Count > 0)
                return true;
            return false;
        }
  
        private bool InsertData()
        {
            
            string mtId = _Database.GetValue("select NEWID()").ToString();
            string stt = _Database.GetValue("select NEWID()").ToString();
            string query = string.Format(@"INSERT INTO MToKhaiTTDB
                         (MToKhaiTTDBID, Stt, DeclareType, KyToKhaiTTDB, InputDate, NamToKhaiTTDB
                          , NgayToKhaiTTDB, DienGiai, InLanDau, SoLanIn, AmendedReturnDate, IsExten
                          , ExtenID, VocationID, IsInputAppendix, IsOutputAppendix, ExperiedDay
                          , ExperiedAmount, PayableAmount, PayableCmt, PayableDate, TaxDepartmentID
                          , TaxDepartID, ReceivableExperied, ReceivableAmount, ExperiedReason)
                        VALUES
                        ({0}, {1}, {2}, {3}, {4}, {5}
                         , {6}, {7}, {8}, {9}, {10}, {11}
                         , {12}, {13}, {14}, {15}, {16}
                         , {17}, {18}, {19}, {20}, {21}
                         , {22}, {23}, {24}, {25})"
                          ,mtId, stt, radDeclareType.EditValue,cboKyToKhaiTTDB.EditValue == null ? 0 : cboKyToKhaiTTDB.EditValue
                          , dtmInputDate.EditValue == null ? String.Format("{0:d}", DateTime.Now) : dtmInputDate.EditValue,_NamTaiChinh
                          ,dtmNgayToKhaiTTDB.EditValue,txtDienGiai.EditValue,chkInLanDau.EditValue,sepSoLanIn.EditValue,dtmAmendedReturnDate.EditValue
                          ,chkIsExten.EditValue,cboExtenID.EditValue,cboVocationID.EditValue,chkIsInputAppendix.EditValue,chkIsOutputAppendix.EditValue
                          ,txtExperiedDay.EditValue,txtExperiedAmount.EditValue,txtPayableAmount.EditValue,txtPayableCmt.EditValue,dtmPayableDate.EditValue
                          ,cboTaxDepartmentID.EditValue,cboTaxDepartID.EditValue,txtReceivableExperied.EditValue,txtReceivableAmount.EditValue,memoExperiedReason.EditValue);
            DataTable table = _Database.GetDataTable(query);
            if(table.Rows.Count > 0)
                return true;
            return false;

        }
        private bool UpdateData()
        {
            bool sucess = false;
            return sucess;
        }
        private void ShowASoftMsg(string pMsg)
        {
            if (Config.GetValue("Language").ToString() == "1")
                pMsg = UIDictionary.Translate(pMsg);
            XtraMessageBox.Show(pMsg);
        }
        private void FormatColumns()
        {
            colSoLuong.DisplayFormat.FormatString = FormatString.GetReportFormat("SoLuong");
            colPs.DisplayFormat.FormatString = FormatString.GetReportFormat("Tien");
            colPs1.DisplayFormat.FormatString = FormatString.GetReportFormat("Tien");
            colThueSuat.DisplayFormat.FormatString = FormatString.GetReportFormat("ThueSuat");
            colPs2.DisplayFormat.FormatString = FormatString.GetReportFormat("Tien");
            colPs3.DisplayFormat.FormatString = FormatString.GetReportFormat("Tien");

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

        #endregion ---- Private methods ----
            ///////////////////////////////
             /////////////////////////////////
             ////////////////////////////////

        private void btnReadData_Click(object sender, EventArgs e)
        {
            
        }

        private void btnSave_Click(object sender, EventArgs e)
        {
            if (!CheckInput())
            {
                ShowASoftMsg("Tờ khai thuế đã tồn tại!");
                
            } return;

            if (this.Action == FormAction.New)
            {
                if (InsertData())
                {
                    ShowASoftMsg("Tạo tờ khai thuế TTĐB thành công.");
                    this.DialogResult = System.Windows.Forms.DialogResult.OK;
                    this.Close();
                }
            }
            else 
            {
                if (UpdateData())
                {
                    ShowASoftMsg("Cập nhật tờ khai thuế TTĐB thành công.");
                    this.DialogResult = System.Windows.Forms.DialogResult.OK;
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
                    string maNhomTTDB = e.Value == null || e.Value == DBNull.Value ? string.Empty : e.Value.ToString();
                    string code = GetString(row, "Code");
                    DataRowView row1 = lueTenNhomTTDB1.GetDataSourceRowByKeyValue(maNhomTTDB) as DataRowView;
                    DataRowView row2 = lueTenNhomTTDB2.GetDataSourceRowByKeyValue(maNhomTTDB) as DataRowView;

                    if (row1 != null)
                    {
                        row["MaNhomTTDB"] = row["MaNhomTTDB"];
                        row["MaDVT"] = row1["DVT"];
                        if (code.StartsWith("01") || code.StartsWith("02"))
                        {
                            row["MaDVT"] = row1["DVT"];
                            row["ThueSuat"] = row1["ThueSuatTTDB"];
                        }
                    }
                    else if (row2 != null)
                    {
                        row["MaNhomTTDB"] = row["MaNhomTTDB"];
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
            //string msg = string.Empty;

            //if (gvToKhai.FocusedColumn.FieldName.Equals("TenNhomTTDB"))
            //{
            //    if (e.Value == null) return;

            //    int index1 = gvToKhai.FocusedRowHandle;
            //    string tenNhomTTDB1 = e.Value.ToString();
            //    string code1 = GetString(index1, "Code");

            //    int index2 = index1;
            //    string tenNhomTTDB2 = string.Empty;
            //    string code2 = string.Empty;
            //    do
            //    {
            //        index2--;
            //        code2 = GetString(index2, "Code");
            //    } while (!code2.EndsWith("00"));

            //    do
            //    {
            //        index2++;
            //        code2 = GetString(index2, "Code");
            //        tenNhomTTDB2 = GetString(index2, "TenNhomTTDB");

            //        if (index1 != index2 && tenNhomTTDB2.Equals(tenNhomTTDB1))
            //        {
            //            msg = "Trùng mã nhóm thuế. Vui lòng chọn nhóm thuế khác.";
            //            if (Config.GetValue("Language").ToString() == "1")
            //                msg = UIDictionary.Translate(msg);
            //            e.ErrorText = msg;
            //            e.Valid = false;
            //        }
            //    } while (!code2.EndsWith("00"));
            //}
            //else if (ParseDecimal(e.Value) < 0)
            //{
            //    msg = "Phải nhập số lớn hơn 0.";
            //    if (Config.GetValue("Language").ToString() == "1")
            //        msg = UIDictionary.Translate(msg);
            //    e.ErrorText = msg;
            //    e.Valid = false;
            //}
            //else if (gvToKhai.FocusedColumn.FieldName.Equals("Ps2"))
            //{
            //    decimal thueSuat = ParseDecimal(gvToKhai.GetFocusedRowCellValue("ThueSuat"));
            //    decimal ps1 = ParseDecimal(gvToKhai.GetFocusedRowCellValue("Ps1"));
            //    decimal ps2 = ParseDecimal(e.Value);
            //    if (ps2 > (ps1 * thueSuat / 100))
            //    {
            //        msg = "Thuế TTĐB được khấu trừ (8) không được lớn hơn tổng thuế TTĐB đã điều chỉnh (6 x 7 - 9).";
            //        if (Config.GetValue("Language").ToString() == "1")
            //            msg = UIDictionary.Translate(msg);
            //        e.ErrorText = msg;
            //        e.Valid = false;
            //    }
            //}
            //else if (e.Value == null)
            //{
            //    e.Value = 0;
            //}
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

    }
}