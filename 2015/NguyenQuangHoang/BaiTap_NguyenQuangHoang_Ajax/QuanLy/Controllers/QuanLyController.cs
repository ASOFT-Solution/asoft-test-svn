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

        public Page<HoiVien> Search1(int page)
        {
            MyConnectionDB db = new MyConnectionDB();
            string sql = "Select * from HoiVien";
            Page<HoiVien> ds;
            HoiVien srch = (HoiVien)TempData["search"];
            string temp = "";
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
            ds = db.Page<HoiVien>(page, 10, sql);
            return ds;
        }

        public ActionResult srch(HoiVien srch, int page)
        {
            TempData["search"] = srch;
            var s = Search1(page);
            Session["page"] = s.TotalPages;
            return Json(s.Items);
        }

        public Page<HoiVien> Search(int page)
        {
            MyConnectionDB db = new MyConnectionDB();
            string sql = "Select * from HoiVien";
            Page<HoiVien> ds;    
            ds = db.Page<HoiVien>(page,10,sql);
            Session["page"] = ds.TotalPages;
            return ds;
        }

        public ActionResult LoadGrid(int page)
        {
            Page<HoiVien> ds = Search(page); 
            return Json(ds.Items);
        }

        public ActionResult LoadPage()
        {
            return Json(Session["page"]);
        }

        public ActionResult Destroy(string[] destroy, int page)
        {
            MyConnectionDB db = new MyConnectionDB();
            foreach (string dt in destroy)
            {
                string sql = string.Format("delete from hoivien where APK = '{0}'", dt);
                db.Execute(sql);
            }
            var dele = Search(page);
            return Json(dele.Items);
        }

        public ActionResult Undisable(string[] undisable, int page)
        {
            MyConnectionDB db = new MyConnectionDB();
            foreach (string dt in undisable)
            {
                string sql = string.Format("update HoiVien set Disable = 0 where APK = '{0}'", dt);
                db.Execute(sql);
            }
            var undis = Search(page);
            return Json(undis.Items);
        }

        public ActionResult Disable(string[] disable, int page)
        {
            MyConnectionDB db = new MyConnectionDB();
            foreach (string dt in disable)
            {
                string sql = string.Format("update HoiVien set Disable = 1 where APK = '{0}'", dt);
                db.Execute(sql);
            }
            var dis = Search(page);
            return Json(dis.Items);
        }

        public ActionResult Testkey(string ma, string ten)
        {
            IEnumerable<HoiVien> test;
            string sql = string.Format("Select * from HoiVien where DivisionID = '{0}' and MemberID = '{1}'", ma, ten);
            test = MyConnectionDB.GetInstance().Query<HoiVien>(sql);
            int sl = test.Count();
            return Json(sl, JsonRequestBehavior.AllowGet);
        }

        public ActionResult Createmember(DemoModels create)
        {
            int disable = 0;
            if (create.Disable == true)
                disable = 1;
            string sql = "Insert into HoiVien (DivisionID,MemberID,MemberName,ShortName,Address,Identify,Phone,Tel,Fax,Email,Birthday,Website,Mailbox,AreaName,CityName,CountryName,WardName,CountyName,Disable) values ('" + create.DivisionID + "','" + create.MemberID + "','" + create.MemberName + "','" + create.ShortName + "','" + create.Address + "','" + create.Identify + "','" + create.Phone + "','" + create.Tel + "','" + create.Fax + "','" + create.Email + "','" + create.Birthday + "','" + create.Website + "','" + create.Mailbox + "','" + create.AreaName + "','" + create.CityName + "','" + create.CountryName + "','" + create.WardName + "','" + create.CountyName + "','" + disable + "')";
            MyConnectionDB db = new MyConnectionDB();
            db.Execute(sql);

            var cr = Search(1);
            return Json(cr.Items);
        }
    }
}
