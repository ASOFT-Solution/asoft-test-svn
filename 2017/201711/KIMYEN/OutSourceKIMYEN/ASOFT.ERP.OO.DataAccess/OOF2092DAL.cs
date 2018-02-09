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
   public class OOF2092DAL: ASOFTBaseDAL
    {
       public OOF2092DAL() { }
       private const string SQLGRIDDETAIL2 = @"Select ROW_NUMBER() OVER (ORDER BY  A.Orders) AS RowNum, COUNT(*) OVER () AS TotalRow,
A.Orders, A.ProcessID, B.ProcessName, A.StepID, C.StepName, A.APK
FROM OOT2091 A WITH (NOLOCK)
inner JOIN OOT1020 B  WITH (NOLOCK) On A.ProcessID =B.ProcessID
inner JOIN OOT1030 C  WITH (NOLOCK) On A.StepID =C.StepID and C.ProcessID = A.ProcessID
Where A.APKMaster =@APK
Order By A.Orders
OFFSET  (@PageNumber-1) * @PageSize ROWS
FETCH NEXT @PageSize ROWS ONLY";
       public DataTable LoadData(Guid? APK, int PageNumber, int PageSize)
       {
           DbCommand command = null;
           try
           {
               using (command = ASOFTDatabase.GetSqlStringCommand(SQLGRIDDETAIL2))
               {
                   ASOFTDatabase.StringParseParameter(command, "APK", DbType.String, APK.ToString());
                   ASOFTDatabase.AddInParameter(command, "PageNumber", DbType.Int32, PageNumber);
                   ASOFTDatabase.AddInParameter(command, "PageSize", DbType.Int32, PageSize);
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
