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
    public class OOF2101BL : ASOFTBaseBL
    {
        public DataTable InsertData(string DivisionID, string TaskSampleID, string ProjectID, DbTransaction tran = null)
        {
            DbCommand command = null;
            try
            {
                OOF2101DAL oof2101dal = new OOF2101DAL(tran);
                DataTable result = oof2101dal.InsertData(DivisionID,TaskSampleID,ProjectID);
                return result;
            }
            catch (Exception ex)
            {
                throw ASOFTException.FromCommand(command, ex);
            }
        }
        public DataTable InsertDepartment(string APKProject, string DepartmentID, DbTransaction tran = null)
        {
           // DbCommand command = null;
            try {
                OOF2101DAL oof2101dal = new OOF2101DAL(tran);
                DataTable result = oof2101dal.InsertDepartment(APKProject, DepartmentID);
                return result;
            }
            catch (Exception ex)
            {
                throw new ASOFTException(ASOFTLayer.Business, ex.Message, ex);
            }
        }
        public DataTable Insert_AssignedToUserID(string APKProject, string AssignedToUserID, DbTransaction tran = null)
        {
            //DbCommand command = null;
            try
            {
                OOF2101DAL oof2101dal = new OOF2101DAL(tran);
                DataTable result = oof2101dal.Insert_AssignedToUserID(APKProject, AssignedToUserID);
                return result;
            }
            catch (Exception ex)
            {
                throw new ASOFTException(ASOFTLayer.Business, ex.Message, ex);
            }
        }
        public bool Exist(string ProjectID, DbTransaction tran = null)
        {
            try
            {
                OOF2101DAL oof2101dal = new OOF2101DAL(tran);
                var result = oof2101dal.Exist(ProjectID);
                return result;
            }            
            catch (Exception ex)
            {
                throw new ASOFTException(ASOFTLayer.Business, ex.Message, ex);
            }
        }
        public bool ChangeSample(string ProjectID, string TaskSampleID, DbTransaction tran = null)
        {
            try {
                OOF2101DAL oof2101dal = new OOF2101DAL(tran);
                var result = oof2101dal.ChangeSample(ProjectID, TaskSampleID);
                return result;
            }
            catch (Exception ex)
            {
                throw new ASOFTException(ASOFTLayer.Business, ex.Message, ex);
            }
        }
        public bool Delete(string ProjectID, DbTransaction tran = null)
        {
            try
            {
                OOF2101DAL oof2101dal = new OOF2101DAL(tran);
                var result = oof2101dal.Delete_ProjectID(ProjectID);
                return result;
            }
            catch (Exception ex)
            {
                throw new ASOFTException(ASOFTLayer.Business, ex.Message, ex);
            }
        }

        public Guid GetAPKProject(string ProjectID, DbTransaction tran = null)
        {
            try
            {
                OOF2101DAL oof2101dal = new OOF2101DAL(tran);
                var result = oof2101dal.GetAPKProject(ProjectID);
                return result;
            }
            catch (Exception ex)
            {
                throw new ASOFTException(ASOFTLayer.Business, ex.Message, ex);
            }
        }
    }
}
