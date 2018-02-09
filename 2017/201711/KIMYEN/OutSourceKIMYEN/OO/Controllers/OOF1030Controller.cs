using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ASOFT.ERP.A00.Entities.Common;
using ASOFT.ERP.Controllers;

namespace ASOFT.ERP.OO.Controllers
{
    public class OOF1030Controller : ASOFTController
    {
        //
        // GET: /OOF1030/

        public ActionResult Index()
        {
            return View();
        }
        public List<ASOFTSysFields> ChangeListFieldsPopupMaster(List<ASOFTSysFields> list, string id)
        {
            list.Find(m => m.ColumnName.Equals("ProcessID")).Type = 3;

            return list;
        }

        public List<ASOFTSysFields> ChangeFieldsGridOOF1032_OOT1031 (List<ASOFTSysFields> list, string id)
        {
            //Code ở đây, tham khảo các file class khác 
            list.Find(m => m.ColumnName.Equals("APK")).GridVisible = 0;
            return list;
        } 

    }
    
}
