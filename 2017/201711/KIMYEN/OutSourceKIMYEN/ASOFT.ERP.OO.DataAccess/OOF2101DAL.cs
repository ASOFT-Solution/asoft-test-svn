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
   public class OOF2101DAL : ASOFTBaseDAL
    {
       public OOF2101DAL() {}
       public OOF2101DAL(DbTransaction tran) : base(tran) { }
       private const string SQLINSERTDATA = @"If exists (Select top 1 1  From  OOT2091 A WITH (NOLOCK) LEFT JOIN 
(SELECT M.DivisionID, M.StepID, M.ProcessID, D.WorkID, D.WorkName, D.DescriptionW, D.ExecutionTime, D.Notes, D.Orders FROM OOT1030 M WITH (NOLOCK)
Inner join OOT1031 D WITH (NOLOCK) On  D.APKMaster = M.APK
WHERE M.Disabled = 0 )B On A.ProcessID = B.ProcessID and A.StepID = B.StepID
WHERE A.APKMaster = (Select APK From OOT2090 Where TaskSampleID =@TaskSampleID) and isnull(B.WorkID,'') !='')
Begin
INSERT INTO OOT2110 (DivisionID, ProcessID, StepID, WorkID, WorkName, PlanTime
, Description, Orders, CreateDate, CreateUserID, LastModifyDate, LastModifyUserID ,ProjectID)
Select 'KY', B.ProcessID, B.StepID, B.WorkID, B.WorkName,  B.ExecutionTime
, B.DescriptionW , B.Orders, GetDate(), @UserID, GetDate(), @UserID, @ProjectID 
from OOT2091 A WITH (NOLOCK) 
LEFT JOIN 
(SELECT M.DivisionID, M.StepID, M.ProcessID, D.WorkID, D.WorkName, D.DescriptionW, D.ExecutionTime, D.Notes, D.Orders FROM OOT1030 M WITH (NOLOCK)
Inner join OOT1031 D WITH (NOLOCK) On  D.APKMaster = M.APK
WHERE M.Disabled = 0 )B On A.ProcessID = B.ProcessID and A.StepID = B.StepID
WHERE A.APKMaster = (Select APK From OOT2090 Where TaskSampleID =@TaskSampleID and isnull(B.WorkID,'') !='')
END";
       public DataTable InsertData(string DivisionID, string TaskSampleID, string ProjectID)
       {
           DbCommand command = null;
            try
           {
               Dictionary<string, object> data = new Dictionary<string, object>();
               using (command = ASOFTDatabase.GetSqlStringCommand(SQLINSERTDATA))
               {
                   ASOFTDatabase.AddInParameter(command, "DivisionID", DbType.String, ASOFTEnvironment.DivisionID);
                   ASOFTDatabase.AddInParameter(command, "UserID", DbType.String, ASOFTEnvironment.UserID);
                   ASOFTDatabase.AddInParameter(command, "TaskSampleID", DbType.String, TaskSampleID);
                   ASOFTDatabase.AddInParameter(command, "ProjectID", DbType.String, ProjectID);
               
                   using (var result = ASOFTDatabase.ExecuteReader(command, this))
                   {
                       DataTable dt = new DataTable();
                       dt.Load(result);
                       return dt;
                   }
               }
           }
            catch (Exception ex)
            {
                throw ASOFTException.FromCommand(command, ex);
            }
       }

       private const string INSERTDATA_DEPARTMENT = @"Insert into OOT2101
(RelatedToTypeID, RelatedToID, DepartmentID)
Values 
(47,  @APKProject, @DepartmentID)";
       public DataTable InsertDepartment(string APKProject, string DepartmentID) {
           DbCommand command = null;
           try { 
                    Dictionary<string, object> data = new Dictionary<string,object>();
                    using (command = ASOFTDatabase.GetSqlStringCommand(INSERTDATA_DEPARTMENT))
                    {
                        ASOFTDatabase.AddInParameter(command, "APKProject", DbType.String, APKProject);
                        ASOFTDatabase.AddInParameter(command, "DepartmentID", DbType.String, DepartmentID);
                        using (var result = ASOFTDatabase.ExecuteReader(command, this))
                        {
                            DataTable dt = new DataTable();
                            dt.Load(result);
                            return dt;
                        }
                    }
           }
           catch (Exception ex)
           {
               throw ASOFTException.FromCommand(command, ex);
           }
       }
       private const string INSERT_ASSIGNEDTOUSERID = @"Insert into AT1103_REL
(RelatedToTypeID, RelatedToID, UserID)
Values 
(47,  @APKProject, @AssignedToUserID)";
       public DataTable Insert_AssignedToUserID(string APKProject, string AssignedToUserID)
       {
           DbCommand command = null;
           try {
               //Dictionary<string, object> data = new Dictionary<string, object>();
               using (command = ASOFTDatabase.GetSqlStringCommand(INSERT_ASSIGNEDTOUSERID))
               {
                   ASOFTDatabase.AddInParameter(command, "APKProject", DbType.String, APKProject);
                   ASOFTDatabase.AddInParameter(command, "AssignedToUserID", DbType.String, AssignedToUserID);
                   using (var result = ASOFTDatabase.ExecuteReader(command, this))
                   {
                       DataTable dt = new DataTable();
                       dt.Load(result);
                       return dt;
                   }
               }

           
           }
           catch (Exception ex)
           {
               throw ASOFTException.FromCommand(command, ex);
           }

       }
       private const string EXIST_PROJECTID = @"Select Top 1 1  From OOT2110 WHERE DivisionID =@DivisionID and ProjectID = @ProjectID ";
       public bool Exist(string ProjectID)
       {
           DbCommand command = null;
           try {
               using (command = ASOFTDatabase.GetSqlStringCommand(EXIST_PROJECTID)) 
               {
                   ASOFTDatabase.AddInParameter(command, "DivisionID", DbType.String, ASOFTEnvironment.DivisionID);
                   ASOFTDatabase.AddInParameter(command, "ProjectID", DbType.String, ProjectID);

                   using (var result = ASOFTDatabase.ExecuteReader(command, this))
                   {
                       if (result.Read())
                           return false;
                   }
               }

           }
           catch (Exception ex)
           {
               throw ASOFTException.FromCommand(command, ex);
           }
           return true;
       }

       private const string EXIST_CHANGESAMPLE = @"Select Top 1 1  From OOT2100 WHERE  TaskSampleID = @TaskSampleID and ProjectID = @ProjectID ";
       public bool ChangeSample(string ProjectID, string TaskSampleID)
       {
           DbCommand command = null;
           try
           {
               using (command = ASOFTDatabase.GetSqlStringCommand(EXIST_CHANGESAMPLE))
               {
                   ASOFTDatabase.AddInParameter(command, "DivisionID", DbType.String, ASOFTEnvironment.DivisionID);
                   ASOFTDatabase.AddInParameter(command, "TaskSampleID", DbType.String, TaskSampleID);
                   ASOFTDatabase.AddInParameter(command, "ProjectID", DbType.String, ProjectID);

                   using (var result = ASOFTDatabase.ExecuteReader(command, this))
                   {
                       if (result.Read())
                           return false;
                   }
               }

           }
           catch (Exception ex)
           {
               throw ASOFTException.FromCommand(command, ex);
           }
           return true;
       }

       private const string DELETE_PROJECTID = @"DELETE FROM OOT2110 WHERE DivisionID =@DivisionID and ProjectID = @ProjectID";
       public bool Delete_ProjectID(string ProjectID) {
           DbCommand command = null;
           try {
               using (command = ASOFTDatabase.GetSqlStringCommand(DELETE_PROJECTID))
               {
                   ASOFTDatabase.AddInParameter(command, "DivisionID", DbType.String, ASOFTEnvironment.DivisionID);
                   ASOFTDatabase.AddInParameter(command, "ProjectID", DbType.String, ProjectID);
                   if (ASOFTDatabase.ExecuteNonQuery(command, this) <= 0)
                       return false;
               }
           }
           catch (Exception ex)
           {
               throw ASOFTException.FromCommand(command, ex);
           }
           return true;
       }

       private const string GETAPKPROJECTID = @"Select Top 1 APK  From OOT2100 WHERE ProjectID = @ProjectID ";
       public Guid GetAPKProject(string ProjectID)
       {
           DbCommand command = null;
           try
           {
               Guid APK = Guid.Empty;
               using (command = ASOFTDatabase.GetSqlStringCommand(GETAPKPROJECTID))
               {
                   ASOFTDatabase.AddInParameter(command, "ProjectID", DbType.String, ProjectID);

                   using (var result = ASOFTDatabase.ExecuteReader(command, this))
                   {
                       while (result.Read())
                       {
                           return Guid.Parse(result.GetValue(0).ToString());
                       }
                   }
               }
               return APK;
           }
           catch (Exception ex)
           {
               throw ASOFTException.FromCommand(command, ex);
           }
       }
    }
}
