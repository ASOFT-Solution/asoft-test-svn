using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ASOFT.ERP.A00.Entities.Common;
using ASOFT.ERP.Controllers;

namespace ASOFT.ERP.OO.Controllers
{
    public class OOF2090Controller : ASOFTController
    {
        //
        // GET: /OOF2090/

        public ActionResult Index()
        {
            return View();
        }
        //public List<ASOFTSysFields> ChangeFieldsGridEditOOF2091_OOT2091(List<ASOFTSysFields> list, string id)
        //{
        //    list.Find(m => m.ColumnName.Equals("ProcessID")).GridVisible = 0;
            
        //    return list;
        //}
        
        public List<ASOFTSysFields> ChangeFieldsGridOOF2092_OOT2091(List<ASOFTSysFields> list, string id)
        {
           
            list.Find(m => m.ColumnName.Equals("StepID")).GridVisible = 1;
            list.Find(m => m.ColumnName.Equals("ProcessID")).GridVisible = 1;
            list.Find(m => m.ColumnName.Equals("StepName")).functionClientTemplate = String.Empty;
            list.Find(m => m.ColumnName.Equals("ProcessName")).GroupOnGrid = "#= value #";
            return list;
        } 
    }
}
