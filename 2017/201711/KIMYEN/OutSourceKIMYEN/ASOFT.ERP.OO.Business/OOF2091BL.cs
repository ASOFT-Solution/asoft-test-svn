using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ASOFT.ERP.A00.Business;
using ASOFT.ERP.A00.Core;
using ASOFT.ERP.OO.DataAccess;

namespace ASOFT.ERP.OO.Business
{
   public class OOF2091BL : ASOFTBaseBL
    {
       public DataTable LoadData(string apk)
       {
           DbCommand command = null;
           try
           {
               OOF2091DAL dal = new OOF2091DAL();
               DataTable result = dal.LoadData(apk);
               return result;
           }
           catch (ASOFTException) { throw; }
           catch (Exception ex)
           {
               throw ASOFTException.FromCommand(command, ex);
           }
       }
    }
}
