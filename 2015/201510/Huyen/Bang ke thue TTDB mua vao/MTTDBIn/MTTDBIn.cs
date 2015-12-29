using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Plugins;
using DevExpress.XtraLayout;
using DevExpress.XtraEditors;
using DevExpress.XtraEditors.Controls;
using DevExpress.XtraLayout.Utils;
using System.Data;
using System.Windows.Forms;
using CDTLib;
using CDTDatabase;
using DevExpress.Utils;

namespace MTTDBIn
{
    class MTTDBIn : ICControl
    {
        private DataCustomFormControl _data;
        private InfoCustomControl _info = new InfoCustomControl(IDataType.MasterDetailDt);
        private Database _Database = Database.NewDataDatabase();
        private int NamTaiChinh()
        {
            return (Config.GetValue("NamLamViec") == null ? -1 : int.Parse(Config.GetValue("NamLamViec").ToString()));
        }

        #region ICControl Members

        public DataCustomFormControl Data
        {
            set { _data = value; }
        }
        InfoCustomControl ICControl.Info
        {
            get { return _info; }
        }

        #endregion ICControl Members

        public void AddEvent()
        {
            //create control radio group vào
            LayoutControl lcMain = _data.FrmMain.Controls.Find("lcMain", true)[0] as LayoutControl;
            RadioGroup radioEdit1 = new RadioGroup();
            object[] itemValues = new object[] { 0, 1 };
            string[] itemDescriptions = new string[] { "Theo tháng", "Theo lần phát sinh" };
            for (int i = 0; i < itemValues.Length; i++)
            {
                radioEdit1.Properties.Items.Add(new RadioGroupItem(itemValues[i], itemDescriptions[i]));
            }
            radioEdit1.BackColor = System.Drawing.Color.Transparent;
            radioEdit1.Properties.Columns = 1;
            radioEdit1.BorderStyle = BorderStyles.NoBorder;
            radioEdit1.Name = "radioEdit1";
            LayoutControlItem item6 = GetElementByName(lcMain, "InputDate");
            item6.TextVisible = false;
            LayoutControlItem item7 = GetElementByName(lcMain, "KyBKMVTTDB");
            item7.TextVisible = false;
            LayoutControlItem item5 = new LayoutControlItem(lcMain, radioEdit1);

            //Điều chỉnh vị trí của radiogroup vừa tạo trên LayoutControl
            item5.Parent = lcMain.Root;
            item5.Move(item7, InsertType.Left);
            item6.Move(item5, InsertType.Right);
            item7.Move(item6, InsertType.Top);
            item5.TextVisible = false;
            item5.Width = 120;
            item5.Height = 48;
            item5.Name = "radioEdit1";
            item5.AppearanceItemCaption.Options.UseBackColor = false;
            _data.FrmMain.Controls.Add(lcMain);
            item5 = lcMain.Root.AddItem();// add control radio vào LayoutMain
            this._data.FrmMain.Load += new EventHandler(Frm_Load);
            radioEdit1.SelectedIndexChanged += new EventHandler(radioEdit1_SelectedIndexChanged);
            radioEdit1_SelectedIndexChanged(null, null);
        }

        // Handling event radiogroup selectedIndexChanged
        protected void radioEdit1_SelectedIndexChanged(object sender, EventArgs e)
        {

            LayoutControl lcMain = _data.FrmMain.Controls.Find("lcMain", true)[0] as LayoutControl;
            RadioGroup radioEdit1 = _data.FrmMain.Controls.Find("radioEdit1", true)[0] as RadioGroup;
            DataRow drMaster = (_data.BsMain.Current as DataRowView).Row;

            if (drMaster == null) return;
            SpinEdit sepKy = _data.FrmMain.Controls.Find("KyBKMVTTDB", true)[0] as SpinEdit;
            DateEdit dtmInputDate = _data.FrmMain.Controls.Find("InputDate", true)[0] as DateEdit;
            SpinEdit sepDeclareType = _data.FrmMain.Controls.Find("DeclareType", true)[0] as SpinEdit;
            TextEdit txtDeclareTypeName = _data.FrmMain.Controls.Find("DeclareTypeName", true)[0] as TextEdit;

            if (radioEdit1.SelectedIndex == 0)
            {
                lcMain.GetControlByName("InputDate").Enabled = false;
                lcMain.GetControlByName("KyBKMVTTDB").Enabled = true;
                txtDeclareTypeName.EditValue = "Tháng";
                sepDeclareType.EditValue = 1;
                dtmInputDate.EditValue = null;
            }
            else if (radioEdit1.SelectedIndex == 1)
            {
                lcMain.GetControlByName("KyBKMVTTDB").Enabled = false;
                lcMain.GetControlByName("InputDate").Enabled = true;
                txtDeclareTypeName.EditValue = "Lần phát sinh";
                sepDeclareType.EditValue = 2;
                sepKy.EditValue = null;
            }
        }

        // Get index layoutcontrolItem
        private LayoutControlItem GetElementByName(LayoutControl lcMain, string name)
        {
            foreach (BaseLayoutItem lci in lcMain.Items)
            {
                if (lci.GetType() == typeof(LayoutControlItem))
                {
                    if (lci.Name.ToUpper().EndsWith(name.ToUpper()))
                    {
                        return (LayoutControlItem)lci;
                    }
                }
            }
            return null;
        }

        private void Frm_Load(object sender, EventArgs e)
        {
            BindingSource bindingSource = null;
            DataRow mtRowView = null;

            bindingSource = _data.BsMain as BindingSource;
            if (bindingSource == null || bindingSource.Current == null) return;
            mtRowView = (bindingSource.Current as DataRowView).Row;

            RadioGroup radioEdit1 = _data.FrmMain.Controls.Find("radioEdit1", true)[0] as RadioGroup;
            LayoutControl lcMain = _data.FrmMain.Controls.Find("lcMain", true)[0] as LayoutControl;
            LayoutControlItem item2 = GetElementByName(lcMain, "DeclareTypeName");
            LayoutControlItem item3 = GetElementByName(lcMain, "DeclareType");
            //Ẩn các control không cần thiết
            item2.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
            item3.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
            DateEdit dtmInputDate = _data.FrmMain.Controls.Find("InputDate", true)[0] as DateEdit;
            dtmInputDate.Properties.Mask.Culture = new System.Globalization.CultureInfo("en-US");
            dtmInputDate.Properties.Mask.EditMask = "MM/dd/yyyy";
            dtmInputDate.Properties.Mask.UseMaskAsDisplayFormat = true;
            dtmInputDate.Properties.CharacterCasing = CharacterCasing.Upper;
            SpinEdit sepDeclareType = _data.FrmMain.Controls.Find("DeclareType", true)[0] as SpinEdit;
            SpinEdit sepKy = _data.FrmMain.Controls.Find("KyBKMVTTDB", true)[0] as SpinEdit;

            if (mtRowView == null || mtRowView.RowState == DataRowState.Deleted) return;
            if (mtRowView.RowState == DataRowState.Added)
            {
                SpinEdit spNam = _data.FrmMain.Controls.Find("NamBKMVTTDB", true)[0] as SpinEdit;
                spNam.EditValue = NamTaiChinh(); // lấy default năm lập bảng kê là năm làm việc
                //Set value cho các control lúc mới load lên
                lcMain.GetControlByName("radioEdit1").Enabled = true;
                mtRowView["DeclareTypeName"] = "Tháng";
                mtRowView["DeclareType"] = "1";
                mtRowView["NamBKMVTTDB"] = NamTaiChinh();
                radioEdit1.SelectedIndex = 0;
            }
            else if (mtRowView.RowState == DataRowState.Unchanged)
            {
                string type = mtRowView["DeclareType"].ToString();
                if (type == "1")
                {
                    radioEdit1.SelectedIndex = 0;
                }
                else if (type == "2")
                {
                    radioEdit1.SelectedIndex = 1;
                }
                string query = string.Format(@"select  Top 1 1  from  MToKhaiTTDB
                        where IsInputAppendix = 1 and
                        (Case when {0} = 1 then KyToKhaiTTDB end) = {1}  or
                        (Case when {0} = 2 then InputDate end) = cast({2} as datetime)
                        and NamToKhaiTTDB = {3}", sepDeclareType.EditValue == null ? -1 : sepDeclareType.EditValue, sepKy.EditValue == null ? "NULL" : sepKy.EditValue, dtmInputDate.EditValue == null ? DateTime.Now.ToShortDateString() : dtmInputDate.DateTime.ToShortDateString(), NamTaiChinh());
                if (_Database.GetValue(query) != null)
                {
                    lcMain.GetControlByName("radioEdit1").Enabled = false;
                    lcMain.GetControlByName("KyBKMVTTDB").Enabled = false;
                    lcMain.GetControlByName("InputDate").Enabled = false;
                }
            }
        }

    }
}
