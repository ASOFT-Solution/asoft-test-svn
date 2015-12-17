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


namespace MTTDBOut
{
    public class MTTDBOut : ICControl
    {
        private DataCustomFormControl _data;
        private InfoCustomControl _info = new InfoCustomControl(IDataType.MasterDetailDt);

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
            //LayoutControlItem item = null;
            LayoutControl lcMain = _data.FrmMain.Controls.Find("lcMain", true)[0] as LayoutControl;
            LayoutControlItem item1 = GetElementByName(lcMain, "NamBKBRTTDB");
            item1.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
            lcMain.GetControlByName("NamBKBRTTDB").Enabled = false;
            LayoutControlItem item2 = GetElementByName(lcMain, "DeclareTypeName");
            item2.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
            lcMain.GetControlByName("DeclareTypeName").Enabled = false;
            LayoutControlItem item3 = GetElementByName(lcMain, "DeclareType");
            item3.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
            lcMain.GetControlByName("DeclareType").Enabled = false;

            LayoutControlItem item6 = GetElementByName(lcMain, "InputDate");
            item6.TextVisible = false;
            LayoutControlItem item7 = GetElementByName(lcMain, "KyBKBRTTDB");
            item7.TextVisible = false;
            
            RadioGroup radioEdit1 = new RadioGroup();
            object[] itemValues = new object[] {0, 1};
            string [] itemDescriptions = new string [] {"Theo tháng", "Theo lần phát sinh"};
            for (int i = 0; i < itemValues.Length; i++)
            {
                radioEdit1.Properties.Items.Add(new RadioGroupItem(itemValues[i], itemDescriptions[i]));     
            }
            radioEdit1.BackColor = System.Drawing.Color.Transparent;
            radioEdit1.Properties.Columns = 1;
            radioEdit1.SelectedIndex = 0;
            radioEdit1.BorderStyle = BorderStyles.NoBorder;
            radioEdit1.Name = "radioEdit1";

            radioEdit1.SelectedIndexChanged += new EventHandler(radioEdit1_SelectedIndexChanged);
            
            LayoutControlItem item5 = new LayoutControlItem(lcMain, radioEdit1);
            item5.Parent = lcMain.Root;
            item5.Move(item7, InsertType.Left);
            item6.Move(item5, InsertType.Right);
            item7.Move(item6,InsertType.Top);
            item5.TextVisible = false;
            item5.Width = 120;
            item5.Height = 48;
            item5.Name = "radioEdit1";
            item5.AppearanceItemCaption.Options.UseBackColor = false;
            _data.FrmMain.Controls.Add(lcMain);
            item5 = lcMain.Root.AddItem();

            radioEdit1_SelectedIndexChanged(null, null);
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
            if (radioEdit1.SelectedIndex == 0)
            {
                lcMain.GetControlByName("InputDate").Enabled = false;
                lcMain.GetControlByName("KyBKBRTTDB").Enabled = true;
            }
            else if (radioEdit1.SelectedIndex == 1)
            {
                lcMain.GetControlByName("KyBKBRTTDB").Enabled = false;
                lcMain.GetControlByName("InputDate").Enabled = true;
            }
        }
    }
}
