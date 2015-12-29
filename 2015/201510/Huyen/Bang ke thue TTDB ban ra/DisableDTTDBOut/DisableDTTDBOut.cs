using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Plugins;
using DevExpress.XtraLayout;
using System.Windows.Forms;
using DevExpress.XtraBars;
using DevExpress.XtraEditors;

namespace DisableDTTDBOut
{
    class DisableDTTDBOut : ICControl
    {
        DataCustomFormControl _data;
        InfoCustomControl _info = new InfoCustomControl(IDataType.MasterDetail);

        public DataCustomFormControl Data
        {
            set { _data = value; }
        }
        InfoCustomControl ICControl.Info
        {
            get { return _info; }
        }
        // Lệ Huyền create ngày 25/12/2015
        //Ẩn button xóa
        public void AddEvent()
        {
            
            this._data.FrmMain.Load += new EventHandler(Frm_Load);

        }
        private void Frm_Load(object sender, EventArgs e)
        {
            LayoutControl lc = _data.FrmMain.Controls.Find("layoutControl2", true)[0] as LayoutControl;
            SimpleButton btEdit = _data.FrmMain.Controls.Find("simpleButtonEdit", true)[0] as SimpleButton;
            LayoutControlItem item = lc.GetItemByControl(btEdit);
            item.Visibility = DevExpress.XtraLayout.Utils.LayoutVisibility.Never;
        }
    }
}
