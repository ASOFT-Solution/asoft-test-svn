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
using CDTDatabase;


namespace MTTDBOut
{
    public class MTTDBOut : ICControl
    {
        private DataCustomFormControl _data;
        private InfoCustomControl _info = new InfoCustomControl(IDataType.MasterDetailDt);
        private int _NamTaiChinh = -1;
        private Database _Database = Database.NewDataDatabase();
        private int NamTaiChinh()
        {
            return( Config.GetValue("NamLamViec") == null ? -1 : int.Parse(Config.GetValue("NamLamViec").ToString()));
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

            this._data.FrmMain.Load += new EventHandler(Frm_Load);
            radioEdit1.SelectedIndexChanged += new EventHandler(radioEdit1_SelectedIndexChanged);
            radioEdit1_SelectedIndexChanged(null, null);
            SpinEdit sepKy = _data.FrmMain.Controls.Find("KyBKBRTTDB", true)[0] as SpinEdit;
            DateEdit dtmInputDate = _data.FrmMain.Controls.Find("InputDate", true)[0] as DateEdit;
            sepKy.EditValueChanged += new EventHandler(sepKy_EditValueChanged);
            dtmInputDate.EditValueChanged += new EventHandler(dtmInputDate_EditValueChanged);
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


        protected void radioEdit1_SelectedIndexChanged(object sender, EventArgs e)
        {

            LayoutControl lcMain = _data.FrmMain.Controls.Find("lcMain", true)[0] as LayoutControl;
            RadioGroup radioEdit1 = _data.FrmMain.Controls.Find("radioEdit1", true)[0] as RadioGroup;

            DataRow drMaster = (_data.BsMain.Current as DataRowView).Row;

            if (drMaster == null) return;
            SpinEdit sepKy = _data.FrmMain.Controls.Find("KyBKBRTTDB", true)[0] as SpinEdit;
            DateEdit dtmInputDate = _data.FrmMain.Controls.Find("InputDate", true)[0] as DateEdit;
            SpinEdit sepDeclareType = _data.FrmMain.Controls.Find("DeclareType", true)[0] as SpinEdit;
            TextEdit txtDeclareTypeName = _data.FrmMain.Controls.Find("DeclareTypeName", true)[0] as TextEdit;

            if (radioEdit1.SelectedIndex == 0)
            {
                lcMain.GetControlByName("InputDate").Enabled = false;
                lcMain.GetControlByName("KyBKBRTTDB").Enabled = true;
                txtDeclareTypeName.EditValue = "Tháng";
                sepDeclareType.EditValue = 1;
            }
            else if (radioEdit1.SelectedIndex == 1)
            {
                lcMain.GetControlByName("KyBKBRTTDB").Enabled = false;
                lcMain.GetControlByName("InputDate").Enabled = true;
                txtDeclareTypeName.EditValue = "Lần phát sinh";
                sepDeclareType.EditValue = 2;
                sepKy.EditValue = 0;     
            }
            
        }
        private void dtmInputDate_EditValueChanged(object sender, EventArgs e)
        {
            DateEdit dtmInputDate = _data.FrmMain.Controls.Find("InputDate", true)[0] as DateEdit;
            SpinEdit sepDeclareType = _data.FrmMain.Controls.Find("DeclareType", true)[0] as SpinEdit;
            SpinEdit sepKy = _data.FrmMain.Controls.Find("KyBKBRTTDB", true)[0] as SpinEdit;
            LoadDataDetail(sepDeclareType.EditValue == null ? -1 : sepDeclareType.EditValue , sepKy.EditValue == null ? 0 : sepKy.EditValue, dtmInputDate.EditValue == null ? DateTime.Now.ToShortDateString() : dtmInputDate.DateTime.ToShortDateString());
        }
        private void sepKy_EditValueChanged(object sender, EventArgs e)
        {
            DateEdit dtmInputDate = _data.FrmMain.Controls.Find("InputDate", true)[0] as DateEdit;
            SpinEdit sepDeclareType = _data.FrmMain.Controls.Find("DeclareType", true)[0] as SpinEdit;
            SpinEdit sepKy = _data.FrmMain.Controls.Find("KyBKBRTTDB", true)[0] as SpinEdit;
            LoadDataDetail(sepDeclareType.EditValue == null ? -1 : sepDeclareType.EditValue, sepKy.EditValue == null ? 0 : sepKy.EditValue, dtmInputDate.EditValue == null ? DateTime.Now.ToShortDateString() : dtmInputDate.DateTime.ToShortDateString());
        }
        private void Frm_Load(object sender, EventArgs e)
        {
            BindingSource bindingSource = null;
            DataRow mtRowView = null;

            bindingSource = _data.BsMain as BindingSource;
            if (bindingSource == null || bindingSource.Current == null) return;

            mtRowView = (bindingSource.Current as DataRowView).Row;
            if (mtRowView == null || mtRowView.RowState == DataRowState.Deleted || mtRowView.RowState == DataRowState.Modified) return;
            if (mtRowView.RowState == DataRowState.Added)
            {
                SpinEdit spNam = _data.FrmMain.Controls.Find("NamBKBRTTDB", true)[0] as SpinEdit;
                spNam.EditValue = NamTaiChinh();
                LayoutControl lcMain = _data.FrmMain.Controls.Find("lcMain", true)[0] as LayoutControl;
                LayoutControlItem item1 = GetElementByName(lcMain, "NamBKBRTTDB");
                item1.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
                LayoutControlItem item2 = GetElementByName(lcMain, "DeclareTypeName");
                item2.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
                LayoutControlItem item3 = GetElementByName(lcMain, "DeclareType");
                item3.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
                mtRowView["DeclareTypeName"] = "Tháng";
                mtRowView["DeclareType"] = 1;
                mtRowView["NamBKBRTTDB"] = NamTaiChinh();
                RadioGroup radioEdit1 = _data.FrmMain.Controls.Find("radioEdit1", true)[0] as RadioGroup;
                radioEdit1.SelectedIndex = 0;
            }

        }
        private void LoadDataDetail(object declaretype, object declaretypeName1, object declaretypeName2)
        {
            string query = string.Format(@"select NgayHd as NgayHD, NgayCt, Sohoadon as SoHoaDon, SoSerie as SoSeries,TenKH, TenVT, SoLuong_TTDB as SoLuong, GiaNT_TTDB as GiaNT, Gia_TTDB as Gia, PSNT_TTDB as PsNT
                            , PS_TTDB as Ps, TienTTDBNT, TienTTDB, PS1NT_TTDB as Ps1NT, PS1_TTDB as Ps1 ,MaNhomTTDB, ThueSuatTTDB
                        from TTDBOut where year(NgayCt) = {0}
           and 
           (Case when {1} = 1 then month(NgayCt) end) = {2}
           or
           (Case when {1} = 2 then NgayCt end) = cast({3} as Datetime)", NamTaiChinh(), declaretype, declaretypeName1, declaretypeName2);

            DataTable table = _Database.GetDataTable(query);
            GridControl gcDetail = (_data.FrmMain.Controls.Find("gcMain", true)[0] as GridControl);
            GridView gvDetail = (_data.FrmMain.Controls.Find("gcMain", true)[0] as GridControl).MainView as GridView;
            if (table.Rows.Count > 0)
            {
                gcDetail.DataSource = table;
                gvDetail.ExpandAllGroups();
                gvDetail.BestFitColumns();
            }
           
        }

        
    }
}
