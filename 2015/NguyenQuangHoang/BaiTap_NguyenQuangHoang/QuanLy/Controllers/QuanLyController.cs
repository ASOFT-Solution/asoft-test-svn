using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using PetaPoco;
using Kendo.Mvc.UI;
using MyConnection;
using QuanLy.Models;
using Kendo.Mvc.Extensions;
using System.Collections;

namespace QuanLy.Controllers
{
    public class QuanLyController : Controller
    {
        //
        // GET: /QuanLy/

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Read([DataSourceRequest] DataSourceRequest request)
        {
            var ds = MyConnectionDB.GetInstance().Query<HoiVien>("select * from HoiVien");
            return Json(ds.ToDataSourceResult(request));
        }

        public void srch(HoiVien srch)
        {
            TempData["search"] = srch;
        }

        public ActionResult Search([DataSourceRequest] DataSourceRequest request)
        {
            string sql = "Select * from HoiVien";
            string temp = "";
            IEnumerable ds;
            HoiVien srch = (HoiVien)TempData["search"];
            if (srch == null)
            {
                ds = MyConnectionDB.GetInstance().Query<HoiVien>(sql);
            }
            else
            {
                if (srch.DivisionID != null)
                {
                    temp = temp + string.Format(" and DivisionID like N'%{0}%'", srch.DivisionID);
                }
                if (srch.MemberID != null)
                {
                    temp = temp + string.Format(" and MemberID like N'%{0}%'", srch.MemberID);
                }
                if (srch.MemberName != null)
                {
                    temp = temp + string.Format(" and MemberName like N'%{0}%'", srch.MemberName);
                }
                if (srch.Address != null)
                {
                    temp = temp + string.Format(" and Address like N'%{0}%'", srch.Address);
                }
                if (srch.Identify != null)
                {
                    temp = temp + string.Format(" and Identify like N'%{0}%'", srch.Identify);
                }
                if (srch.Phone != null)
                {
                    temp = temp + string.Format(" and Phone like N'%{0}%'", srch.Phone);
                }
                if (srch.Tel != null)
                {
                    temp = temp + string.Format(" and Tel like N'%{0}%'", srch.Tel);
                }
                if (srch.Fax != null)
                {
                    temp = temp + string.Format(" and Fax like N'%{0}%'", srch.Fax);
                }
                if (srch.Email != null)
                {
                    temp = temp + string.Format(" and Email like N'%{0}%'", srch.Email);
                }
                if (temp != null)
                {
                    sql = sql + " where 0=0" + temp;
                }
                ds = MyConnectionDB.GetInstance().Query<HoiVien>(sql);
      
            }
            return Json(ds.ToDataSourceResult(request));
        }

        public void Destroy(string[] destroy)
        {
            MyConnectionDB db = new MyConnectionDB();
            foreach (string dt in destroy)
            {
                string sql = string.Format("delete from hoivien where APK = '{0}'", dt);
                db.Execute(sql);
            }
        }

        public void Undisable(string[] undisable)
        {
            MyConnectionDB db = new MyConnectionDB();
            foreach (string dt in undisable)
            {
                string sql = string.Format("update HoiVien set Disable = 0 where APK = '{0}'", dt);
                db.Execute(sql);
            }
        }

        public void Disable(string[] disable)
        {
            MyConnectionDB db = new MyConnectionDB();
            foreach (string dt in disable)
            {
                string sql = string.Format("update HoiVien set Disable = 1 where APK = '{0}'", dt);
                db.Execute(sql);
            }
        }

        public ActionResult Testkey(string ma, string ten)
        {
            IEnumerable<HoiVien> test;
            string sql = string.Format("Select * from HoiVien where DivisionID = '{0}' and MemberID = '{1}'", ma,ten);
            test = MyConnectionDB.GetInstance().Query<HoiVien>(sql);
            int sl = test.Count();
            return Json(sl,JsonRequestBehavior.AllowGet);
        }

        public void Createmember(DemoModels create)
        {
            int disable = 0;
            if (create.Disable == true)
                disable = 1;
            string sql = "Insert into HoiVien (DivisionID,MemberID,MemberName,ShortName,Address,Identify,Phone,Tel,Fax,Email,Birthday,Website,Mailbox,AreaName,CityName,CountryName,WardName,CountyName,Disable) values ('" + create.DivisionID + "','" + create.MemberID + "','" + create.MemberName + "','" + create.ShortName + "','" + create.Address + "','" + create.Identify + "','" + create.Phone + "','" + create.Tel + "','" + create.Fax + "','" + create.Email + "','" + create.Birthday + "','" + create.Website + "','" + create.Mailbox + "','" + create.AreaName + "','" + create.CityName + "','" + create.CountryName + "','" + create.WardName + "','" + create.CountyName+ "','" + disable + "')";
            MyConnectionDB db = new MyConnectionDB();
            db.Execute(sql);
        }
    }
}
