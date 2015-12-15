using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using DevExpress.XtraEditors;
using CDTControl;
using CDTLib;
using CDTDatabase;

namespace ToKhaiThueGTGT
{
    public partial class CapNhatToKhai : DevExpress.XtraEditors.XtraForm
    {
        public CapNhatToKhai()
        {
            InitializeComponent();
        }
        #region ---- Member variables ----

        private Database _Database = Database.NewDataDatabase();
        private string _MToKhaiID = string.Empty;

        #endregion ---- Member variables ----


        #region ---- Properties ----

        public string MToKhaiID
        {
            get { return _MToKhaiID; }
            set { _MToKhaiID = value; }
        }

        #endregion ---- Properties ----


        #region ----Private Methods----
        /// <summary>
        /// Load tờ khai hiện tại
        /// </summary>
        private void LoadToKhaiHienTai()
        {
            if (string.IsNullOrEmpty(_MToKhaiID)) return;
            string sql = string.Format(@"Select  mst.MToKhaiID, mst.KyToKhai, mst.DeclareType, mst.NamToKhai, mst.NgayToKhai
                                         , mst.QuyToKhai, mst.DienGiai, mst.InLanDau, mst.SoLanIn
                                         , mst.AmendedReturnDate,  mst.IsExten, mst.ExtenID, mst.VocationID
                                         , mst.IsInputAppendix, mst.IsOutputAppendix, mst.ExperiedDay
                                         , mst.ExperiedAmount, mst.PayableAmount, mst.PayableCmt, mst.PayableDate
                                         , mst.TaxDepartmentID, mst.TaxDepartID, mst.ReceivableExperied
                                         , mst.ReceivableAmount, mst.ExperiedReason
                                From MToKhai mst
                                Where mst.MToKhaiID='{0}'", _MToKhaiID);
            DataTable dt = _Database.GetDataTable(sql);
            if (dt.Rows.Count > 0)
            {
                this.dtNgayToKhai.EditValue = dt.Rows[0]["NgayToKhai"];
                if (dt.Rows[0]["DeclareType"].ToString().Equals("1"))
                {
                    cbKyToKhai.EditValue = dt.Rows[0]["KyToKhai"];
                }
                else
                {
                    rdgChonToKhai.EditValue = dt.Rows[0]["DeclareType"];
                    cbQuyToKhai.EditValue = dt.Rows[0]["QuyToKhai"];
                }
                chkInLanDau.EditValue = dt.Rows[0]["InLanDau"];
                speSoLanIn.EditValue = dt.Rows[0]["SoLanIn"];
                dtAmendedReturnDate.EditValue = dt.Rows[0]["AmendedReturnDate"];
                chkIsExten.EditValue = dt.Rows[0]["IsExten"];
                gleExtenID.EditValue = dt.Rows[0]["ExtenID"];
                txtDienGiai.EditValue = dt.Rows[0]["DienGiai"];
                gleVocationID.EditValue = dt.Rows[0]["VocationID"];
                chkIsInputAppendix.EditValue = dt.Rows[0]["IsInputAppendix"];
                chkIsOutputAppendix.EditValue = dt.Rows[0]["IsOutputAppendix"];
                speExperiedDay.EditValue = dt.Rows[0]["ExperiedDay"];
                txtExperiedAmount.EditValue = dt.Rows[0]["ExperiedAmount"];
                txtPayableAmount.EditValue = dt.Rows[0]["PayableAmount"];
                txtPayableCmt.EditValue = dt.Rows[0]["PayableCmt"];
                dtPayableDate.EditValue = dt.Rows[0]["PayableDate"];
                gleTaxDepartmentID.EditValue = dt.Rows[0]["TaxDepartmentID"];
                gleTaxDepartID.EditValue = dt.Rows[0]["TaxDepartID"];
                speReceivableExperied.EditValue = dt.Rows[0]["ReceivableExperied"];
                txtReceivableAmount.EditValue = dt.Rows[0]["ReceivableAmount"];
                memoExperiedReason.EditValue = dt.Rows[0]["ExperiedReason"];

                rdgChonToKhai.Properties.ReadOnly = true;
                cbKyToKhai.Properties.ReadOnly = cbQuyToKhai.Properties.ReadOnly = true;
                chkInLanDau.Properties.ReadOnly = true;
                speSoLanIn.Properties.ReadOnly = true;
            }

        }

        /// <summary>
        /// Load dữ liệu combobox
        /// </summary>
        private void LoadComboBox()
        {
            //Combobox VocationID
            string sqlVocation = "Select * from DMNN Where TaxType = 'GTGT'";
            gleVocationID.Properties.DataSource = _Database.GetDataTable(sqlVocation);
            gleVocationID.Properties.ValueMember = "VocationID";
            gleVocationID.Properties.DisplayMember = "VocationName";
            gleVocationID.Properties.BestFitMode = DevExpress.XtraEditors.Controls.BestFitMode.BestFitResizePopup;
            gleVocationID.Properties.View.OptionsView.ShowAutoFilterRow = true;

            //Combobox ExtenID
            string sqlExtenID = "Select * from DMGH";
            gleExtenID.Properties.DataSource = _Database.GetDataTable(sqlExtenID);
            gleExtenID.Properties.ValueMember = "ExtenID";
            gleExtenID.Properties.DisplayMember = "ExtenName";
            gleExtenID.Properties.BestFitMode = DevExpress.XtraEditors.Controls.BestFitMode.BestFitResizePopup;
            gleExtenID.Properties.View.OptionsView.ShowAutoFilterRow = true;

            //Combobox TaxDepartmentID
            string TaxDepartmentID = "Select * from DMThueCapCuc";
            gleTaxDepartmentID.Properties.DataSource = _Database.GetDataTable(TaxDepartmentID);
            gleTaxDepartmentID.Properties.ValueMember = "TaxDepartmentID";
            gleTaxDepartmentID.Properties.DisplayMember = "TaxDepartmentName";
            gleTaxDepartmentID.Properties.BestFitMode = DevExpress.XtraEditors.Controls.BestFitMode.BestFitResizePopup;
            gleTaxDepartmentID.Properties.View.OptionsView.ShowAutoFilterRow = true;
        }
        /// <summary>
        /// Xử lý định dạng textbox
        /// </summary>
        private void FormatTextbox()
        {
            txtReceivableAmount.Properties.DisplayFormat.FormatString = FormatString.GetReportFormat("Tien");
            txtReceivableAmount.Properties.Mask.EditMask = FormatString.GetReportFormat("Tien");
            txtReceivableAmount.Properties.EditFormat.FormatString = FormatString.GetReportFormat("Tien");

            txtPayableAmount.Properties.DisplayFormat.FormatString = FormatString.GetReportFormat("Tien");
            txtPayableAmount.Properties.Mask.EditMask = FormatString.GetReportFormat("Tien");
            txtPayableAmount.Properties.EditFormat.FormatString = FormatString.GetReportFormat("Tien");

            txtExperiedAmount.Properties.DisplayFormat.FormatString = FormatString.GetReportFormat("Tien");
            txtExperiedAmount.Properties.Mask.EditMask = FormatString.GetReportFormat("Tien");
            txtExperiedAmount.Properties.EditFormat.FormatString = FormatString.GetReportFormat("Tien");
        }

        /// <summary>
        /// CheckInput
        /// </summary>
        private bool CheckInput()
        {
            int flag = 0;
            if (rdgChonToKhai.SelectedIndex == 0 && cbKyToKhai.Text == string.Empty)
            {
                cbKyToKhai.ErrorText = "Không được phép để trống";
                flag++;
            }
            if (rdgChonToKhai.SelectedIndex == 1 && cbQuyToKhai.Text == string.Empty)
            {
                cbQuyToKhai.ErrorText = "Không được phép để trống";
                flag++;
            }
            if (chkIsExten.Checked && gleExtenID.Text == string.Empty)
            {
                gleExtenID.ErrorText = "Không được phép để trống";
                flag++;
            }
            if (flag != 0)
                return false;
            else
                return true;

        }

        /// <summary>
        /// Check tồn tại tờ khai
        /// </summary>
        private bool CheckExist()
        {
            int NamTaiChinh = Config.GetValue("NamLamViec") == null ? -1 : int.Parse(Config.GetValue("NamLamViec").ToString());
            string soLanIn = string.Empty;
            if (chkInLanDau.Checked)
                soLanIn = "NULL";
            else
                soLanIn = speSoLanIn.EditValue.ToString();
            string sqlCheck = string.Format(@"Select Top 1 1  From MToKhai 
                                Where NamToKhai = {0} and 
                                  (Case when {1} = 1 then KyToKhai end) = {2} or
                                  (Case when {1} = 2 then QuyToKhai end) = {2} and
                                  Solanin = {3}",NamTaiChinh, rdgChonToKhai.EditValue, rdgChonToKhai.SelectedIndex == 0 ? cbKyToKhai.Text : cbQuyToKhai.Text,
                                                soLanIn);
            if (_Database.GetValue(sqlCheck) != null)
                return true;
            return false;
        }

        /// <summary>
        /// Check đang sử dụng
        /// </summary>
        private bool CheckUsing()
        {
            string sqlCheck = string.Format(@"Declare @Ky int,
                                                @Nam int,
                                                @SoLanIn int
                                        Select @Ky = (Case when KyToKhai != 0 or DeclareType = 1 then KyToKhai else QuyToKhai end), @nam = NamToKhai, @SoLanIn = SoLanIn
                                        From MTokhai
                                        Where MToKhaiID = '{0}'
                                        Select Top 1 1
                                        From (
                                                Select MToKhaiID, KyToKhai, QuyToKhai, SoLanin, InLandau from MTokhai
                                                Where NamToKhai >= @Nam and (Case when KyToKhai != 0 or DeclareType = 1 then KyToKhai else QuyToKhai end) > @Ky
                                                Union all
                                                Select MToKhaiID, KyToKhai, QuyToKhai, SoLanin, InLandau from MTokhai
                                                Where NamToKhai >= @Nam and (Case when KyToKhai != 0 or DeclareType = 1 then KyToKhai else QuyToKhai end) = @Ky  and SoLanIn >@SoLanIn
                                                ) x", _MToKhaiID);
            if (_Database.GetValue(sqlCheck) != null)
                return true;
            return false;
        }

        /// <summary>
        /// Insert MToKhai
        /// </summary>
        private bool InsertMaster()
        {
            List<string> fieldName = new List<string>();
            List<string> Values = new List<string>();
            string pId = string.Empty;
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
                fieldName.Add("DeclareType");
                fieldName.Add("AmendedReturnDate");
                fieldName.Add("IsExten");
                fieldName.Add("IsInputAppendix");
                fieldName.Add("IsOutputAppendix");
                fieldName.Add("ExperiedDay");
                fieldName.Add("ExperiedAmount");
                fieldName.Add("PayableAmount");
                fieldName.Add("PayableCmt");
                fieldName.Add("PayableDate");
                fieldName.Add("ReceivableExperied");
                fieldName.Add("ReceivableAmount");
                fieldName.Add("ExperiedReason");
                fieldName.Add("ExtenID");
                fieldName.Add("VocationID");
                fieldName.Add("TaxDepartmentID");
                fieldName.Add("TaxDepartID");

                Values.Clear();
                Values.Add("convert( uniqueidentifier,'" + pId + "')");
                Values.Add("'" + (rdgChonToKhai.SelectedIndex == 0 ? cbKyToKhai.EditValue.ToString() : "0" ) + "'");

                int NamTaiChinh = Config.GetValue("NamLamViec") == null ? -1 : int.Parse(Config.GetValue("NamLamViec").ToString());
                Values.Add("'" + NamTaiChinh.ToString() + "'");
                Values.Add("cast('" + dtNgayToKhai.DateTime.ToShortDateString() + "' as datetime)");
                Values.Add("N'" + txtDienGiai.Text + "'");

                if (chkInLanDau.Checked)
                {
                    Values.Add("'1'");
                    Values.Add("NULL");
                    Values.Add("'" + (rdgChonToKhai.SelectedIndex == 1 ? cbQuyToKhai.EditValue.ToString() : "0") + "'");
                    Values.Add("'" + rdgChonToKhai.EditValue.ToString() + "'");
                    Values.Add("NULL");
                    Values.Add("'" + (chkIsExten.Checked ? "1" : "0") + "'");
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
                    if (chkIsExten.Checked)
                        Values.Add("'" + gleExtenID.EditValue.ToString() + "'");
                    else
                        Values.Add("NULL");

                    if(gleVocationID.Text == string.Empty)
                        Values.Add("NULL");
                    else
                        Values.Add("'" + gleVocationID.EditValue.ToString() + "'");
                    Values.Add("NULL");
                    Values.Add("NULL");
                }
                else
                {
                    Values.Add("'0'");
                    Values.Add("'" + speSoLanIn.EditValue.ToString() + "'");
                    Values.Add("'" + (rdgChonToKhai.SelectedIndex == 1 ? cbQuyToKhai.EditValue.ToString() : "0") + "'");
                    Values.Add("'" + rdgChonToKhai.EditValue.ToString() + "'");
                    Values.Add("cast('" + dtAmendedReturnDate.DateTime.ToShortDateString() + "' as datetime)");
                    Values.Add("'" + (chkIsExten.Checked ? "1" : "0") + "'");
                    Values.Add("NULL");
                    Values.Add("NULL");
                    Values.Add("'" + speExperiedDay.EditValue.ToString() + "'");

                    if (txtExperiedAmount.Text == string.Empty)
                        Values.Add("NULL");
                    else
                        Values.Add("'" + txtExperiedAmount.EditValue.ToString() + "'");

                    if(txtPayableAmount.Text == string.Empty)
                        Values.Add("NULL");
                    else
                        Values.Add("'" + txtPayableAmount.EditValue.ToString() + "'");

                    if(txtPayableCmt.Text == string.Empty)
                        Values.Add("NULL");
                    else
                        Values.Add("'" + txtPayableCmt.Text + "'");
                    Values.Add("cast('" + dtPayableDate.DateTime.ToShortDateString() + "' as datetime)");
                    Values.Add("'" + speReceivableExperied.EditValue.ToString() + "'");

                    if(txtReceivableAmount.Text == string.Empty)
                        Values.Add("NULL");
                    else
                        Values.Add("'" + txtReceivableAmount.EditValue.ToString() + "'");
                    Values.Add("'" + memoExperiedReason.Text + "'");

                    if (chkIsExten.Checked)
                        Values.Add("'" + gleExtenID.EditValue.ToString() + "'");
                    else
                        Values.Add("NULL");

                    if(gleVocationID.Text == string.Empty)
                        Values.Add("NULL");
                    else
                        Values.Add("'" + gleVocationID.EditValue.ToString() + "'");

                    if (gleTaxDepartmentID.Text == string.Empty)
                    {
                        Values.Add("NULL");
                        Values.Add("NULL");
                    }
                    else
                    {
                        Values.Add("'" + gleTaxDepartmentID.EditValue.ToString() + "'");
                        Values.Add("'" + gleTaxDepartID.EditValue.ToString() + "'");
                    }
                }

                //Values.Add("'" + (chkInLanDau.Checked ? 1 : 0) + "'");
                //Values.Add("'" + (chkInLanDau.Checked ? 0 : speSoLanIn.EditValue) + "'");
                //Values.Add("'" + (rdgChonToKhai.EditValue.Equals("0") ? cbQuyToKhai.EditValue.ToString() : "0") + "'");
                //Values.Add("'" + rdgChonToKhai.EditValue + "'");
                //Values.Add("cast('" + dtAmendedReturnDate.EditValue.ToString() + "' as datetime)");
                //Values.Add("'" + (chkIsExten.Checked ? 1 : 0) + "'");
                //Values.Add("'" + (chkIsInputAppendix.Checked ? 1 : 0) + "'");
                //Values.Add("'" + (chkIsOutputAppendix.Checked ? 1 : 0) + "'");
                //Values.Add("'" + txtPayableAmount.Text + "'");
                //Values.Add("'" + txtPayableCmt.Text + "'");
                return this._Database.insertRow("MToKhai", fieldName, Values);
            }
            catch (Exception ex)
            {

                XtraMessageBox.Show(ex.Message);
                return false;
            }
        }

        /// <summary>
        /// Update MToKhai
        /// </summary>
        private bool UpdateMaster()
        {
            bool result = false;
            string pId = string.Empty;
            StringBuilder strBuilder = new StringBuilder();
            if (CheckExist())
            {
                ShowASoftMsg("Đã tồn tại tờ khai thuế kỳ tiếp theo hoặc khai bổ sung. Bạn không được phép sửa/Xóa.");
                return false;
            }
            try
            {
                strBuilder.Append = string.Format(@"Update MToKhai set NgayToKhai = {0}, AmendedReturnDate = {1}, IsExten = {2},
                                                    ExtenID = {3}, DienGiai = {4}, VocationID = {5}, IsInputAppendix = {6}, IsOutputAppendix = {7}, ExperiedDay = {8},
                                                    ExperiedAmount = {9}, PayableAmount = {10}, PayableCmt = {11}, PayableDate = {12}, TaxDepartmentID = {13}, TaxDepartID = {14},
                                                    ReceivableExperied = {15}, ReceivableAmount = {16}, ExperiedReason = {17}",
                                                                                                                              dtNgayToKhai.EditValue, dtAmendedReturnDate.EditValue, chkIsExten.Checked == ? "1" : "0");
            }
            catch (Exception ex)
            {

                XtraMessageBox.Show(ex.Message);
                return false;
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
        /// <summary>
        /// Shows the A soft MSG.
        /// </summary>
        private void ShowASoftMsg(string pMsg)
        {
            if (Config.GetValue("Language").ToString() == "1")
                pMsg = UIDictionary.Translate(pMsg);
            XtraMessageBox.Show(pMsg);
        }
        /// <summary>
        /// Shows the A soft MSG.
        /// </summary>
        private DialogResult ShowASoftMsg(string pMsg, string pCaption)
        {

            if (Config.GetValue("Language").ToString() == "1")
                pMsg = UIDictionary.Translate(pMsg);
            return XtraMessageBox.Show(pMsg, pCaption, MessageBoxButtons.YesNo);
        }
        #endregion


        #region ----HandleEvents----
        /// <summary>
        /// Xử lý sự kiện FormLoad của CapNhatToKhai
        /// </summary>
        private void CapNhatToKhai_Load(object sender, EventArgs e)
        {
            rdgChonToKhai_SelectedIndexChanged(null, null);
            chkIsExten_CheckedChanged(null, null);
            chkInLanDau_CheckedChanged(null, null);

            FormatTextbox();
            LoadComboBox();
            FormatColumns();
            gvToKhai.OptionsBehavior.Editable = true;

            dtNgayToKhai.EditValue = DateTime.Now;
            dtAmendedReturnDate.EditValue = DateTime.Now;
            dtPayableDate.EditValue = DateTime.Now;
     
            if (Config.GetValue("Language").ToString() == "1")
            {
                FormFactory.DevLocalizer.Translate(this);
            }

            LoadToKhaiHienTai();
        }
        /// <summary>
        /// Xử lý sự kiện chọn radio tờ khai
        /// </summary>
        private void rdgChonToKhai_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdgChonToKhai.SelectedIndex == 0)
            {
                cbKyToKhai.Enabled = true;
                cbQuyToKhai.Enabled = false;
            }
            else
            {
                cbKyToKhai.Enabled = false;
                cbQuyToKhai.Enabled = true;
            }
        }

        /// <summary>
        /// Xử lý sự kiện check vào gia hạn
        /// </summary>
        private void chkIsExten_CheckedChanged(object sender, EventArgs e)
        {
            if (chkIsExten.Checked)
                gleExtenID.Enabled = true;
            else
                gleExtenID.Enabled = false;
        }
        /// <summary>
        /// Xử lý sự kiện ẩn hiện control
        /// </summary>
        private void chkInLanDau_CheckedChanged(object sender, EventArgs e)
        {
            if (chkInLanDau.Checked)
            {
                lciSoLanIn.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
                lciNgayLapKHBS.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
                lciTabPhuLuc.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Always;
                lciGrbChamNop.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
                lciGrbNoiDung.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
                lcibtnKHBS.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
                xtraTabControl1.TabPages[1].PageVisible = false;
            }
            else
            {
                lciSoLanIn.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Always;
                lciNgayLapKHBS.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Always;
                lciTabPhuLuc.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
                lciGrbChamNop.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Always;
                lciGrbNoiDung.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Always;
                lcibtnKHBS.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Always;
                xtraTabControl1.TabPages[1].PageVisible = true;
            }
        }
        /// <summary>
        /// Xử lý sự kiện chọn combobox cơ quan thuế cấp cục
        /// </summary>
        private void gleTaxDepartmentID_EditValueChanged(object sender, EventArgs e)
        {
            //Combobox TaxDepartID
            string sqlTaxDepartID = string.Format("Select * from DMThueCapQL Where TaxDepartmentID = '{0}'", gleTaxDepartmentID.EditValue);
            gleTaxDepartID.Properties.DataSource = _Database.GetDataTable(sqlTaxDepartID);
            gleTaxDepartID.Properties.ValueMember = "TaxDepartID";
            gleTaxDepartID.Properties.DisplayMember = "TaxDepartName";
            gleTaxDepartID.Properties.BestFitMode = DevExpress.XtraEditors.Controls.BestFitMode.BestFitResizePopup;
            gleTaxDepartID.Properties.View.OptionsView.ShowAutoFilterRow = true;
        }
        #endregion


        #region ----LoadGridView----

        #region ----Enums, Structs, Constants----
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

    
        #region ----Member Varribles----
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


        #region ----Properties----
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


        #region ----Private Methods----
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
                //colGTHHDV.RealColumnEdit.ParseEditValue += new DevExpress.XtraEditors.Controls.ConvertEditValueEventHandler(colGTHHDV_ParseEditValue);
            }

            colThueGTGT.DisplayFormat.FormatString = FormatString.GetReportFormat("Tien");
            if (colThueGTGT.RealColumnEdit != null)
            {
                colThueGTGT.RealColumnEdit.EditFormat.FormatString = colThueGTGT.DisplayFormat.FormatString;
                colThueGTGT.RealColumnEdit.EditFormat.FormatType = colThueGTGT.DisplayFormat.FormatType;
                //colThueGTGT.RealColumnEdit.ParseEditValue += new DevExpress.XtraEditors.Controls.ConvertEditValueEventHandler(colThueGTGT_ParseEditValue);
            }
        }

        /// <summary>
        /// LoadDataAddNew
        /// </summary>
        private void CalculateAmount()
        {
            if (this._Action == FormAction.AddNew)
            {
                int declareType = int.Parse(rdgChonToKhai.EditValue.ToString());

                int Ky = declareType == 1 ? int.Parse(cbKyToKhai.EditValue.ToString()) : int.Parse(cbKyToKhai.EditValue.ToString());

                int NamTaiChinh = Config.GetValue("NamLamViec") == null ? -1 : int.Parse(Config.GetValue("NamLamViec").ToString());

                int InLanDau = chkInLanDau.Checked ? 1 : 0;

                int SoLanIn = InLanDau == 1 ? -1 : int.Parse(speSoLanIn.Value.ToString());

                int IsInputAppendix = chkIsInputAppendix.Checked ? 1 : 0;

                int IsOutputAppendix = chkIsOutputAppendix.Checked ? 1 : 0;

                DataTable dt = null;

                string[] paranames = new string[] { "@DeclareType", "@Ky", "@Nam", "@InLanDau", "@SoLanIn", "@IsInputAppendix", "@IsOutputAppendix" };
                object[] paraValues = new object[] { declareType, Ky, NamTaiChinh, InLanDau, SoLanIn, IsInputAppendix, IsOutputAppendix };

                dt = _Database.GetDataSetByStore("LayDuLieuToKhaiGTGT", paranames, paraValues);
              

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
                //StoreCalculatedResult("CodeGT", "GTHHDV");
                //StoreCalculatedResult("CodeThue", "ThueGTGT");
            }
        }

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
        /// GetStandardData
        /// </summary>
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
        #endregion


        #region ----Handle Events----

        /// <summary>
        /// Thêm ô checkbox
        /// </summary>
        private void gvToKhai_CustomRowCellEdit(object sender, DevExpress.XtraGrid.Views.Grid.CustomRowCellEditEventArgs e)
        {
            object obj = gvToKhai.GetRowCellValue(e.RowHandle, "CodeGT");

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
        /// Sự kiện checkbox
        /// </summary>
        private void checkEdit_CheckedChanged(object sender, EventArgs e)
        {
            CheckEdit checkEdit = sender as CheckEdit;
            DataRow[] rows = _DataMain.Select(string.Format("CodeGT = '{0}'", CT21));
            if (rows.Length <= 0)
                return;

            if (checkEdit.Checked)
            {
                // Reset các số liệu hoạt động mua bán về 0
                if (this.ShowASoftMsg("Các số liệu đã có trong các chỉ tiêu phát sinh trong kỳ sẽ bị xóa bằng 0. Có đồng ý không?", "Thông báo") == DialogResult.Yes)
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
        /// Sự kiện btnGetData
        /// </summary>
        private void btnGetData_Click(object sender, EventArgs e)
        {
            if (this._Action == FormAction.AddNew)
            {
                _DataMain = this.GetStandardData();
            }
            else
            {
                //_DataMain = this.GetData();
            }

            if (_DataMain != null)
            {
                gcToKhai.DataSource = _DataMain;
            }

            CalculateAmount();
        }
        #endregion

        private void btnSave_Click(object sender, EventArgs e)
        {
            if (this._Action == FormAction.AddNew)
            {
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
                if (InsertMaster())
                {
                   ShowASoftMsg("Tờ khai thuế GTGT tạo thành công!");
                   this.Close();
                }
            }
        }

       

       

        #endregion

        private void CapNhatToKhai_KeyDown(object sender, KeyEventArgs e)
        {
            switch (e.KeyCode)
            {
                case Keys.Escape:
                    this.Close();
                    break;
                case Keys.F12:
                    btnSave.PerformClick();
                    break;
            }
        }

    }
}
