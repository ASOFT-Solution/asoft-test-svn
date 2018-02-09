using System;
using System.Activities;
using System.Collections.Generic;
using System.Data;
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
            string taskSample = ASOFTUtilities.GetDataByKey("TaskSampleID", dt, cl);
            string divisionID = ASOFTUtilities.GetDataByKey("DivisionID", dt, cl);
            string projectID = ASOFTUtilities.GetDataByKey("ProjectID", dt, cl);
            string department = ASOFTUtilities.GetDataByKey("DepartmentName", dt, cl);
            Guid apkProject;
            
            if (!string.IsNullOrEmpty(taskSample))
            {
                DataTable data = new DataTable();
                OOF2101BL oof2101bl = new OOF2101BL();
                data = oof2101bl.InsertData(divisionID, taskSample, projectID);
            }

            if (!string.IsNullOrEmpty(department)&&Guid.TryParse(list[0], out apkProject))
            {
                DataTable data = new DataTable();
                OOF2101BL oof2101bl = new OOF2101BL();
                data = oof2101bl.InsertDepartment(apkProject,department);
            }

            Output.Add("kq", true);
            InOut.Set(context, Output);
        }
    }
}
