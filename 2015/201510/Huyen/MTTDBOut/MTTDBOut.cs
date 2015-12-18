using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Plugins;
using DevExpress.Utils;
using DevExpress.XtraLayout;
using DevExpress.XtraEditors.Repository;
using DevExpress.XtraEditors;
using DevExpress.XtraEditors.Controls;
using System.Windows.Forms;
using DevExpress.XtraLayout.HitInfo;
using DevExpress.XtraLayout.Utils;
using CDTLib;
using System.Data;
using DevExpress.XtraGrid.Views.Grid;
using DevExpress.XtraGrid;


namespace MTTDBOut
{
    public class MTTDBOut : ICControl
    {
        private DataCustomFormControl _data;
        private InfoCustomControl _info = new InfoCustomControl(IDataType.MasterDetailDt);
        private int _NamTaiChinh = -1;
        public void SetNamTaiChinh()
        {
            _NamTaiChinh = Config.GetValue("NamLamViec") == null ? -1 : int.Parse(Config.GetValue("NamLamViec").ToString());
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
            radioEdit1.SelectedIndex = 0;
            radioEdit1.BorderStyle = BorderStyles.NoBorder;
            radioEdit1.Name = "radioEdit1";
            LayoutControlItem item6 = GetElementByName(lcMain, "InputDate");
            item6.TextVisible = false;
            LayoutControlItem item7 = GetElementByName(lcMain, "KyBKBRTTDB");
            item7.TextVisible = false;
            LayoutControlItem item5 = new LayoutControlItem(lcMain, radioEdit1);
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
            item5 = lcMain.Root.AddItem();

            radioEdit1.SelectedIndexChanged += new EventHandler(radioEdit1_SelectedIndexChanged);
            radioEdit1_SelectedIndexChanged(null, null);
            this._data.FrmMain.Load += new EventHandler(FrmMain_Load);


        }


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


        private void LoadData()
        {
            Control[] controls = null;
            controls = _data.FrmMain.Controls.Find("radioEdit1", true);
            Control[] controls1 = null;
            Control[] controls2 = null;
            Control[] controls3 = null;
            Control[] controls4 = null;
            controls1 = _data.FrmMain.Controls.Find("DeclareTypeName", true);
            controls2 = _data.FrmMain.Controls.Find("DeclareType", true);
            controls3 = _data.FrmMain.Controls.Find("KyBKBRTTDB", true);
            controls4 = _data.FrmMain.Controls.Find("InputDate", true);
            RadioGroup radioEdit1 = _data.FrmMain.Controls.Find("radioEdit1", true)[0] as RadioGroup;

            SpinEdit sepKy = controls3[0] as SpinEdit;
            DateEdit dtmInputDate = controls4[0] as DateEdit;

            if (radioEdit1.SelectedIndex == 0)
            {
                TextEdit txtDeclareTypeName = controls1[0] as TextEdit;
                txtDeclareTypeName.EditValue = "Tháng";

                SpinEdit sepDeclareType = controls2[0] as SpinEdit;
                sepDeclareType.EditValue = 1;
            }
            else if (radioEdit1.SelectedIndex == 1)
            {
                TextEdit txtDeclareName = controls1[0] as TextEdit;
                txtDeclareName.EditValue = "Lần phát sinh";

                SpinEdit sepDeclareType = controls2[0] as SpinEdit;
                sepDeclareType.EditValue = 2;

                sepKy.EditValue = 0;  
            }
            LoadDataDetail(radioEdit1.SelectedIndex,sepKy.EditValue,dtmInputDate.EditValue);
        }

        protected void radioEdit1_SelectedIndexChanged(object sender, EventArgs e)
        {

            LayoutControl lcMain = _data.FrmMain.Controls.Find("lcMain", true)[0] as LayoutControl;
            RadioGroup radioEdit1 = _data.FrmMain.Controls.Find("radioEdit1", true)[0] as RadioGroup;

            DataRow drMaster = (_data.BsMain.Current as DataRowView).Row;

            if (drMaster == null) return;
            Control[] controls1 = null;
            Control[] controls2 = null;
            Control[] controls3 = null;
            controls1 = _data.FrmMain.Controls.Find("DeclareTypeName", true);
            controls2 = _data.FrmMain.Controls.Find("DeclareType", true);
            controls3 = _data.FrmMain.Controls.Find("KyBKBRTTDB", true);
            if (radioEdit1.SelectedIndex == 0)
            {
                lcMain.GetControlByName("InputDate").Enabled = false;
                lcMain.GetControlByName("KyBKBRTTDB").Enabled = true;

                TextEdit txtDeclareTypeName = controls1[0] as TextEdit;
                txtDeclareTypeName.EditValue = "Tháng";

                SpinEdit sepDeclareType = controls2[0] as SpinEdit;
                sepDeclareType.EditValue = 1;
            }
            else if (radioEdit1.SelectedIndex == 1)
            {
                lcMain.GetControlByName("KyBKBRTTDB").Enabled = false;
                lcMain.GetControlByName("InputDate").Enabled = true;

                TextEdit txtDeclareName = controls1[0] as TextEdit;
                txtDeclareName.EditValue = "Lần phát sinh";

                SpinEdit sepDeclareType = controls2[0] as SpinEdit;
                sepDeclareType.EditValue = 2;

                SpinEdit sepKy = controls3[0] as SpinEdit;
                sepKy.EditValue = 0;
            }
        }

        protected void FrmMain_Load(object sender, EventArgs e)
        {
            BindingSource bindingSource = null;
            DataRow mtRowView = null;

            bindingSource = _data.BsMain as BindingSource;
            if (bindingSource == null || bindingSource.Current == null) return;

            mtRowView = (bindingSource.Current as DataRowView).Row;
            if (mtRowView == null || mtRowView.RowState == DataRowState.Deleted) return;
            SetNamTaiChinh();
            Control[] controls = null;
            controls = _data.FrmMain.Controls.Find("NamBKBRTTDB", true);
            if (controls.Length > 0)
            {
                SpinEdit spNam = controls[0] as SpinEdit;
                spNam.EditValue = _NamTaiChinh;
            }
            LayoutControl lcMain = _data.FrmMain.Controls.Find("lcMain", true)[0] as LayoutControl;
            LayoutControlItem item1 = GetElementByName(lcMain, "NamBKBRTTDB");
            item1.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
            LayoutControlItem item2 = GetElementByName(lcMain, "DeclareTypeName");
            item2.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
            LayoutControlItem item3 = GetElementByName(lcMain, "DeclareType");
            item3.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
            LayoutControlItem item6 = GetElementByName(lcMain, "InputDate");
            item6.TextVisible = false;
            LayoutControlItem item7 = GetElementByName(lcMain, "KyBKBRTTDB");
            item7.TextVisible = false;
            LoadData();
            
            
        }

        private void LoadDataDetail(object declaretype, object declaretypeName1, object declaretypeName2)
        {
            string query = string.Format(@"select NgayHd, NgayCt, Sohoadon, SoSerie, TenKH, TenVT, SoLuong_TTDB, GiaNT_TTDB, Gia_TTDB, PSNT_TTDB
                            , PS_TTDB, MaNhomTTDB, ThueSuatTTDB, TienTTDBNT, TienTTDB, PS1NT_TTDB, PS1_TTDB 
                        from TTDBOut where year(NgayCt) = {0}
           and 
           (Case when {1} = 1 then month(NgayCt) end) = {2}
           or
           (Case when {1} = 2 then NgayCt end) = cast({3} as datetime)", _NamTaiChinh,declaretype,declaretypeName1 == null? 0: declaretypeName1,declaretypeName2 );

            GridView gvDetail = (_data.FrmMain.Controls.Find("gcMain", true)[0] as GridControl).MainView as GridView;
           
        }

        
    }
}
