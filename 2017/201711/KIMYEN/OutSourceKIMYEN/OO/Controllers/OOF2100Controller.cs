using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ASOFT.ERP.A00.Entities.Common;
using ASOFT.ERP.Controllers;

namespace ASOFT.ERP.OO.Controllers
{
    public class OOF2100Controller : ASOFTController
    {
        public List<ASOFTSysFields> ChangeListFields(List<ASOFTSysFields> list, string id)
        {
            list.Find(m => m.ColumnName.Equals("ContractID")).Type = 3;
            list.Find(m => m.ColumnName.Equals("DepartmentID")).Type = 3;
            list.Find(m => m.ColumnName.Equals("LeaderID")).Type = 3;
            list.Find(m => m.ColumnName.Equals("AssignedToUserID")).Type = 1;
            list.Find(m => m.ColumnName.Equals("DepartmentName")).GridVisible = 0;
            list.Find(m => m.ColumnName.Equals("DivisionID")).GroupOnGrid = String.Empty;
            return list;
        } 

    }
}