using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Plugins;

namespace ToKhaiTTDB
{
    class ToKhaiTTDB : IC
    {
        #region IC Members

        public void Execute(int menuID)
        {
            switch (menuID)
            {
                case 5812:
                    using ( DSToKhaiTTDB frmToKhaiThueTTDB = new DSToKhaiTTDB())
                    {
                        frmToKhaiThueTTDB.ShowDialog();
                    }

                    break;
            }
        }
        public List<InfoCustom> LstInfo
        {
            get { return _lstInfo; }
        }

        #endregion

        private List<InfoCustom> _lstInfo = new List<InfoCustom>();
         public ToKhaiTTDB()
        {
            InfoCustom ic1 = new InfoCustom(5812, "Tạo tờ khai thuế TTDB", "Thuế khác");
            _lstInfo.AddRange(new InfoCustom[] { ic1 });
        }
    }
}
