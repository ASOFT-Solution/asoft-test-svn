using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ASOFT.ERP.A00.Entities.Common;

namespace ASOFT.ERP.OO.Controllers
{
    public class OOF2103Controller : Controller
    {
        //
        // GET: /OOF2103/

        public ActionResult Index()
        {
            return View();
        }
        public List<ASOFTSysFields> ChangeFieldsGridOOF2103_OOT2100(List<ASOFTSysFields> list, string id)
        {
            list.Find(m => m.ColumnName.Equals("DepartmentName")).GridVisible = 1;
            list.Find(m => m.ColumnName.Equals("ProjectID")).GridVisible = 0;
            list.Find(m => m.ColumnName.Equals("ProjectName")).GridVisible = 0;
            list.Find(m => m.ColumnName.Equals("StartDate")).GridVisible = 0;
            list.Find(m => m.ColumnName.Equals("EndDate")).GridVisible = 0;
            list.Find(m => m.ColumnName.Equals("LeaderID")).GridVisible = 0;
            list.Find(m => m.ColumnName.Equals("ContractID")).GridVisible = 0;
            list.Find(m => m.ColumnName.Equals("StatusID")).GridVisible = 0;
            list.Find(m => m.ColumnName.Equals("AssignedToUserID")).GridVisible = 0;
            list.Find(m => m.ColumnName.Equals("ContractName")).GridVisible = 0;

            return list;
        } 

    }
}
