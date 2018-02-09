using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ASOFT.ERP.A00.Business;
using ASOFT.ERP.A00.Core;
using ASOFT.ERP.OO.DataAccess;

namespace ASOFT.ERP.OO.Business
{
   public class OOF2092BL : ASOFTBaseBL
    {
       public DataTable LoadData(Guid? APK, int PageSize, int PageNumber)
        {
            try
            {
                OOF2092DAL OOOF2092dal = new OOF2092DAL();
                DataTable result = OOOF2092dal.LoadData(APK, PageNumber, PageSize);
                return result;
            }
            catch (ASOFTException)
            {
                throw;
            }
            catch (Exception ex)
            {
                throw new ASOFTException(ASOFTLayer.Business, ex.Message, ex);
            }
        } 

    }
}
