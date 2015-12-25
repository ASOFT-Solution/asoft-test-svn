using System;
using System.Collections.Generic;
using System.Text;
using Plugins;

namespace ToKhaiThueGTGT
{
    class ToKhaiThueGTGT : IC
    {
        #region IC Members

        public void Execute(int menuID)
        {
            switch (menuID)
            {
                case 7001:
                    using (DSToKhai frmDSToKhai = new DSToKhai())
                    {
                        frmDSToKhai.ShowDialog();
                    }

                    break;
            }
        }

        public List<InfoCustom> LstInfo
        {
            get
            {
                return _lstInfo;
            }
        }

        #endregion

        private List<InfoCustom> _lstInfo = new List<InfoCustom>();
        public ToKhaiThueGTGT()
        {
            InfoCustom ic1 = new InfoCustom(7001, "Tạo tờ khai thuế GTGT", "Thuế GTGT");
            _lstInfo.AddRange(new InfoCustom[] { ic1 });
        }
    }
}
