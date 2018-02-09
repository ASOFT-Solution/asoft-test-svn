using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ASOFT.ERP.A00.Core;
using ASOFT.ERP.A00.DataAccess;

namespace ASOFT.ERP.OO.DataAccess
{
   public class OOF2091DAL : ASOFTBaseDAL
    {
       public OOF2091DAL() { }

       private const string SQLLOADGRIDDETAIL = @"Select Distinct A.Orders, A.ProcessID, A.ProcessID + ' - ' + A.ProcessName as ProcessName, A.StepID, A.StepName, A.ChooseID, A.APK, A.APKMaster
From
(Select A.Orders, A.ProcessID, A.ProcessName, C.StepID, C.StepName, 0 as ChooseID, null as APK, null as APKMaster
FROM OOT1020 A  WITH (NOLOCK)
LEFT JOIN OOT1030 C  WITH (NOLOCK) On A.ProcessID =C.ProcessID
WHere (A.ProcessID not in (Select ProcessID From OOT2091 Where APKMaster =@APK) 
Or isnull(C.StepID, '')  not in (Select StepID From OOT2091 Where APKMaster = @APK))
and A.DivisionID = @DivisionID
Union all
Select A.Orders, A.ProcessID, B.ProcessName, A.StepID, C.StepName, 1 as ChooseID, A.APK, A.APKMaster
FROM OOT2091 A WITH (NOLOCK)
inner JOIN OOT1020 B  WITH (NOLOCK) On A.ProcessID =B.ProcessID
inner JOIN OOT1030 C  WITH (NOLOCK) On A.StepID =C.StepID and C.ProcessID = A.ProcessID
Where A.APKMaster =@APK)A
Order by A.Orders";

       public DataTable LoadData(string APK)
       {
           DbCommand command = null;
           try
           {
               using (command = ASOFTDatabase.GetSqlStringCommand(SQLLOADGRIDDETAIL))
               {
                   ASOFTDatabase.StringParseParameter(command, "APK", DbType.String, APK);
                   using (var reader = ASOFTDatabase.ExecuteReader(command, this))
                   {
                       DataTable dt = new DataTable();
                       dt.Load(reader);
                       return dt;
                   }
               }
           }
           catch (Exception ex)
           {
               throw ASOFTException.FromCommand(command, ex);
           }
       }
    }
}
