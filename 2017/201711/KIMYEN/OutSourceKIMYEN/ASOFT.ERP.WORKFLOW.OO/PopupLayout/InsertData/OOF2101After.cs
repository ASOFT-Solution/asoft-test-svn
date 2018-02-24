using System;
using System.Activities;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ASOFT.ERP.A00.Core;
using ASOFT.ERP.OO.Business;

namespace ASOFT.ERP.WORKFLOW.OO.PopupLayout.InsertData
{
    public sealed class OOF2101After : CodeActivity
    {
        public InOutArgument<Dictionary<string, Object>> InOut { get; set; }
        public InOutArgument<string> Area { get; set; }
        public InOutArgument<string> ScreenID { get; set; }
        protected override void Execute(CodeActivityContext context)
        {
          
            Dictionary<string, Object> Output = InOut.Get(context);   
            string[] dt = (string[])Output["dt"];
            string[] cl = (string[])Output["cl"];
            List<string> list = new List<string>();
            OOF2101BL OOF2101bl = new OOF2101BL();
            string taskSample = ASOFTUtilities.GetDataByKey("TaskSampleID", dt, cl);
            string divisionID = ASOFTUtilities.GetDataByKey("DivisionID", dt, cl);
            string projectID = ASOFTUtilities.GetDataByKey("ProjectID", dt, cl);
            string department = ASOFTUtilities.GetDataByKey("DepartmentName", dt, cl);
            Guid apkProject = OOF2101bl.GetAPKProject(projectID, (DbTransaction)Output["tran"]);
            string assignedToUserID = ASOFTUtilities.GetDataByKey("AssignedToUserName", dt, cl);
            if (!string.IsNullOrEmpty(taskSample))
            {
                DataTable data = new DataTable();
                OOF2101BL oof2101bl = new OOF2101BL();
                data = oof2101bl.InsertData(divisionID, taskSample, projectID, (DbTransaction)Output["tran"]);
            }

            if (!string.IsNullOrEmpty(department))
            {
                DataTable data = new DataTable();
                if (apkProject != Guid.Empty)
                {
                   // string[] ArrDepartment = null;
                   // //string listDepartment = department.Split(",");
                   //char[] splitchar = { ',' };
                   // ArrDepartment = department.Split(splitchar);
                    string[] words = department.Split(',');
                    foreach (string word in words)
                    {
                        data = OOF2101bl.InsertDepartment(apkProject.ToString(), word, (DbTransaction)Output["tran"]);
                    }
                }
            }
            if (!string.IsNullOrEmpty(assignedToUserID))
            {
                OOF2101BL oof2101bl = new OOF2101BL();
                DataTable data = new DataTable();
                if (apkProject != Guid.Empty)
                {
                    string[] words = assignedToUserID.Split(',');
                    foreach (string word in words)
                    {
                        data = oof2101bl.Insert_AssignedToUserID(apkProject.ToString(), word, (DbTransaction)Output["tran"]);
                    }
                }
            }
            

            Output.Add("kq", true);
            InOut.Set(context, Output);
        }
    }
}
