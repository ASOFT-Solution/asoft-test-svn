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

namespace ToKhaiThueGTGT
{
    public partial class TaoToKhai : DevExpress.XtraEditors.XtraForm
    {
        #region ---- Enums, Structs, Constants ----

        private enum ListType
        {
            Period = 0,
            Quarter = 1
        }

        #endregion

        #region ---- Member variables ----

        private CDTDatabase.Database _Database = null;
        private int _NamTaiChinh = -1;
        private string _MToKhaiID = string.Empty;

        #endregion

        #region ---- Constructors & Destructors ----

        public TaoToKhai()
        {
            InitializeComponent();
        }

        #endregion

        #region ---- Handle events ----

        private void TaoToKhai_Load(object sender, EventArgs e)
        {
            this._Database = Database.NewDataDatabase();

            this.dtmDatePost.DateTime = DateTime.Now;
            _NamTaiChinh = Config.GetValue("NamLamViec") == null ? -1 : int.Parse(Config.GetValue("NamLamViec").ToString());

            LoadPeriod();
            LoadQuarter();

            CheckRemoveStatus();
            checkComboStatus();

            if (Config.GetValue("Language").ToString() == "1")
            {
                FormFactory.DevLocalizer.Translate(this);
            }
        }

        private void btnClose_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btnNext_Click(object sender, EventArgs e)
        {
            int period = -1;

            if (!CheckInput())
                return;

            if (IsPeriod())
                period = int.Parse(cboPeriod.EditValue.ToString());
            else
                period = int.Parse(cboQuarter.EditValue.ToString());

            using (LaySoLieu laySoLieu = new LaySoLieu())
            {
                laySoLieu.Ky = period;
                laySoLieu.IsPeriod = this.IsPeriod();
                laySoLieu.NgapLap = this.dtmDatePost.DateTime;
                laySoLieu.DienGiai = this.txtDescription.Text.Trim();
                laySoLieu.InLanDau = this.chkIsFirstTime.Checked;
                laySoLieu.BoSungLan = (int)this.spAdditionalTimes.Value;
                laySoLieu.MToKhaiID = _MToKhaiID;
                if (this.btnRemove.Enabled)
                {
                    laySoLieu.Action = LaySoLieu.FormAction.Edit;
                }
                else
                {
                    laySoLieu.Action = LaySoLieu.FormAction.AddNew;
                }

                laySoLieu.ShowDialog();
            }
            CheckRemoveStatus();
            LoadDetail();
        }

        private void cboPeriod_SelectedIndexChanged(object sender, EventArgs e)
        {
            CheckRemoveStatus();

            LoadDetail();
        }

        private void btnRemove_Click(object sender, EventArgs e)
        {
            StringBuilder stringBuilder = new StringBuilder();
            int period = -1;

            try
            {
                if (showASoftMsg("Bạn có thật sự muốn xóa tờ khai không?", "Asoft Accounting") != DialogResult.Yes)
                    return;

                if (IsPeriod())
                    period = int.Parse(cboPeriod.EditValue.ToString());
                else
                    period = int.Parse(cboQuarter.EditValue.ToString());

                stringBuilder.Append("Declare @MToKhaiID as uniqueidentifier ");

                if (IsPeriod())
                    stringBuilder.Append(string.Format(" select @MToKhaiID = MToKhaiID from MToKhai where KyToKhai = {0} And NamToKhai = {1} ",
                    period, _NamTaiChinh));
                else
                    stringBuilder.Append(string.Format(" select @MToKhaiID = MToKhaiID from MToKhai where QuyToKhai = {0} And NamToKhai = {1} ",
                    period, _NamTaiChinh));

                stringBuilder.Append(" Delete from DToKhai where MToKhaiID = @MToKhaiID ");
                stringBuilder.Append(" Delete from MToKhai where MToKhaiID = @MToKhaiID ");

                if (_Database.UpdateByNonQuery(stringBuilder.ToString()))
                {
                    showASoftMsg("Tờ khai đã xóa thành công!");

                    ResetControls();
                }
                else
                {
                    showASoftMsg("Không thể xóa tờ khai!");
                }

                this.CheckRemoveStatus();
            }
            catch (Exception ex)
            {
                XtraMessageBox.Show(ex.Message);
            }
        }

        /// <summary>
        /// chkIsFirstTime_CheckedChanged
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void chkIsFirstTime_CheckedChanged(object sender, EventArgs e)
        {
            if (this.chkIsFirstTime.Checked)
            {
                this.layoutAdditionalTimes.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
            }
            else
            {
                this.layoutAdditionalTimes.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Always;
            }
        }

        private void radType_SelectedIndexChanged(object sender, EventArgs e)
        {
            checkComboStatus();
            CheckRemoveStatus();
        }

        #endregion

        #region ---- Private methods ----

        /// <summary>
        /// Load 12 period
        /// </summary>
        private void LoadPeriod()
        {
            int defaultPeriod = 1;
            SysPackage sp = new SysPackage();
            DataTable dtData = sp.GetPeriodForAccounting();
            if (dtData == null) //neu khong phai la PMKT thi khong chay tiep
            {
                return;
            }

            foreach (DataRow dr in dtData.Rows)
            {
                this.cboPeriod.Properties.Items.Add(dr[0]);
            }

            // Load default period
            if (Config.GetValue("KyKeToan") != null)
            {
                defaultPeriod = int.Parse(Config.GetValue("KyKeToan").ToString());
                this.cboPeriod.EditValue = defaultPeriod;
            }
        }

        /// <summary>
        /// Load 4 quarter
        /// </summary>
        private void LoadQuarter()
        {
            int defaultPeriod = 1;
            SysPackage sp = new SysPackage();
            DataTable dtData = sp.GetQuarterForAccounting();
            if (dtData == null) //neu khong phai la PMKT thi khong chay tiep
            {
                return;
            }

            foreach (DataRow dr in dtData.Rows)
            {
                this.cboQuarter.Properties.Items.Add(dr[0]);
            }

            // Load default period
            if (Config.GetValue("KyKeToan") != null)
            {
                defaultPeriod = int.Parse(Config.GetValue("KyKeToan").ToString());
                this.cboQuarter.EditValue = (int)Math.Ceiling((decimal)defaultPeriod / 3);
            }
        }

        /// <summary>
        /// Test Input
        /// </summary>
        /// <returns></returns>
        private bool CheckInput()
        {
            // Theo Kỳ
            if (IsPeriod())
            {
                if (cboPeriod.EditValue == null || string.IsNullOrEmpty(cboPeriod.EditValue.ToString()))
                {
                    showASoftMsg("Vui lòng chọn kỳ lập tờ khai!");
                    this.cboPeriod.Focus();
                    return false;
                }
            }
            else // Theo Quý
            {
                if (cboQuarter.EditValue == null || string.IsNullOrEmpty(cboQuarter.EditValue.ToString()))
                {
                    showASoftMsg("Vui lòng chọn quý lập tờ khai!");
                    this.cboQuarter.Focus();
                    return false;
                }
            }

            return true;
        }

        /// <summary>
        /// Check data exist in table MVATOut
        /// </summary>
        /// <param name="pPeriod"></param>
        /// <param name="pYear"></param>
        /// <returns></returns>
        private bool ExistVATReturnList(int pPeriod, int pYear, bool isPeriod)
        {
            object countRecord = null;
            int countRecordInt = 0;
            string sql = string.Empty;

            try
            {
                if (isPeriod)
                    sql = string.Format("select count(MToKhaiID) from MToKhai where KyToKhai = {0} and NamToKhai = {1}", pPeriod, pYear);
                else
                    sql = string.Format("select count(MToKhaiID) from MToKhai where QuyToKhai = {0} and NamToKhai = {1}", pPeriod, pYear);

                countRecord = _Database.GetValue(sql);
                if (countRecord != null)
                {
                    countRecordInt = int.Parse(countRecord.ToString());
                }

                // Exist
                if (countRecordInt > 0)
                {
                    return true;
                }

                return false;
            }
            catch (Exception ex)
            {
                XtraMessageBox.Show(ex.Message);
                return false;
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

        /// <summary>
        /// Check status of button remove
        /// </summary>
        private void CheckRemoveStatus()
        {
            // Theo kỳ
            if (IsPeriod())
            {
                if (cboPeriod.EditValue == null)
                {
                    this.btnRemove.Enabled = false;
                    return;
                }

                int period = int.Parse(cboPeriod.EditValue.ToString());

                if (this.ExistVATReturnList(period, _NamTaiChinh, true))
                {
                    this.btnRemove.Enabled = true;
                }
                else
                {
                    this.btnRemove.Enabled = false;
                }
            }
            else // Theo Quý
            {
                if (cboQuarter.EditValue == null)
                {
                    this.btnRemove.Enabled = false;
                    return;
                }

                int quarter = int.Parse(cboQuarter.EditValue.ToString());

                if (this.ExistVATReturnList(quarter, _NamTaiChinh, false))
                {
                    this.btnRemove.Enabled = true;
                }
                else
                {
                    this.btnRemove.Enabled = false;
                }
            }
        }

        /// <summary>
        /// Load detail data
        /// </summary>
        private void LoadDetail()
        {
            int period = -1;
            DataTable dt = null;

            if (IsPeriod())
            {
                if (cboPeriod.EditValue == null)
                {
                    return;
                }

                period = int.Parse(cboPeriod.EditValue.ToString());

                dt = _Database.GetDataTable(string.Format("select * from MToKhai where KyToKhai = {0} and NamToKhai = {1}",
                period,
                _NamTaiChinh));
            }
            else
            {
                if (cboQuarter.EditValue == null)
                {
                    return;
                }

                period = int.Parse(cboQuarter.EditValue.ToString());

                dt = _Database.GetDataTable(string.Format("select * from MToKhai where QuyToKhai = {0} and NamToKhai = {1}",
                period,
                _NamTaiChinh));
            }

            if (dt != null && dt.Rows.Count > 0)
            {
                DataRow dr = dt.Rows[0];

                if (dr != null)
                {
                    this.dtmDatePost.DateTime = dr["NgayToKhai"] == DBNull.Value ? DateTime.Now : (DateTime)dr["NgayToKhai"];
                    this.txtDescription.Text = dr["DienGiai"] == DBNull.Value ? string.Empty : dr["DienGiai"].ToString();
                    if (dr["InLanDau"] == DBNull.Value)
                    {
                        this.chkIsFirstTime.Checked = false;
                    }
                    else
                    {
                        this.chkIsFirstTime.Checked = bool.Parse(dr["InLanDau"].ToString());
                    }
                    this.spAdditionalTimes.Value = dr["SoLanIn"] == DBNull.Value ? 1 : int.Parse(dr["SoLanIn"].ToString());

                    if (this.chkIsFirstTime.Checked)
                    {
                        this.layoutAdditionalTimes.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
                    }
                    else
                    {
                        this.layoutAdditionalTimes.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Always;
                    }
                    _MToKhaiID = dr["MToKhaiID"].ToString();
                }
            }
            else
            {
                ResetControls();
            }
        }

        /// <summary>
        /// ResetControls
        /// </summary>
        private void ResetControls()
        {
            this.dtmDatePost.DateTime = DateTime.Now;
            this.txtDescription.Text = string.Empty;
            this.chkIsFirstTime.Checked = true;
            this.spAdditionalTimes.Value = 1;
            if (this.chkIsFirstTime.Checked)
            {
                this.layoutAdditionalTimes.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
            }
            else
            {
                this.layoutAdditionalTimes.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Always;
            }
        }

        private bool IsPeriod()
        {
            return Utils.parseInt(radType.EditValue).Equals((int)ListType.Period);
        }

        private void checkComboStatus()
        {
            if (IsPeriod())
            {
                cboQuarter.Enabled = false;
                cboPeriod.Enabled = true;
            }
            else
            {
                cboQuarter.Enabled = true;
                cboPeriod.Enabled = false;
            }
        }

        #endregion
    }
}
