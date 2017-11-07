using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using BaiTap.Models;
using Kendo.Mvc.Infrastructure;
using Kendo.Mvc.Extensions;
using Kendo.Mvc.UI;
using System.Data.SqlClient;



namespace BaiTap.Controllers
{
    public class HomeController : Controller
    {
        BaiTapKendoEntities db = new BaiTapKendoEntities();
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult Read_Hv([DataSourceRequest]DataSourceRequest request, HoiVien dtSearch)
        {
            //using (var northwind = new BaiTapKendoEntities())
            //{
            //    IQueryable<HoiVien> hoivien = northwind.HoiVien;

            //    DataSourceResult result = hoivien.ToDataSourceResult(request);

            //    return Json(result);

            //}
            using (var northwind = new BaiTapKendoEntities())
            {
                List<HoiVien> hoivien = northwind.HoiVien.ToList();
                if (dtSearch == null)
                {
                    DataSourceResult result = hoivien.ToDataSourceResult(request);
                    return Json(result);
                }
                else {
                    hoivien = hoivien.Where(x => x.DivisionID.Contains(dtSearch.DivisionID ?? string.Empty)).ToList();
                    hoivien = hoivien.Where(x => x.MemberID.Contains(dtSearch.MemberID ?? string.Empty)).ToList();
                    DataSourceResult result = hoivien.ToDataSourceResult(request);
                    return Json(result);
                }
            
            }
           // return Json(result);
    
        }
        //[HttpGet]
        //public ActionResult Add(HoiVien n_hv)
        //{

        //    n_hv.APK = Guid.NewGuid();

        //    try
        //    {
        //        string cnnString = System.Configuration.ConfigurationManager.ConnectionStrings["BaiTapKendoEntities"].ConnectionString;
        //        SqlConnection cnn = new SqlConnection(cnnString);
        //        SqlCommand cmd = new SqlCommand();
        //        cmd.Connection = cnn;
        //        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        //        cmd.CommandText = "ThemHoiVien";
        //        cnn.Open();
        //        object o = cmd.ExecuteScalar();
        //        cnn.Close();
        //    }
        //    catch {return View(); }
        //    
        //}
        //[HttpPost]
        //[ValidateInput(false)]
        //public ActionResult Add(HoiVien n_hv)
        //{
        //    //  string FirstNo = (n_hv["txtFirstNumber"]);
        //    n_hv.APK = Guid.NewGuid();


        //    if (ModelState.IsValid)
        //    {
        //        db.HoiVien.Add(n_hv);
        //        db.SaveChanges();
        //        return RedirectToAction("Index");
        //    }
        //    return View(n_hv);

        //}
        [HttpGet]
        public ActionResult Add()
        {

            return View();
        }
        
        //[ValidateInput(false)]
        //public ActionResult Add(HoiVien n_hv)
        //{
        //    try
        //    {
        //        n_hv.APK = Guid.NewGuid();
               
        //        if (ModelState.IsValid)
        //        {
        //            db.HoiVien.Add(n_hv);
        //            db.SaveChanges();
        //            return RedirectToAction("Index");
        //        }
        //    }
        //    catch { 
        //    }
        //    return View(n_hv);

        //}
        [HttpPost]
        public ActionResult AddData(HoiVien n_hv)
        {
            try
            {
                int i = -1;
                n_hv.APK = Guid.NewGuid();

                if (ModelState.IsValid)
                {
                    db.HoiVien.Add(n_hv);
                    i = db.SaveChanges();
                }
                return Json(i == 1); 
            }
            catch
            {
            }

            return Json(false);

        }

        [HttpPost]
        public ActionResult Update(string ID)
        {
            HoiVien n_hv = new HoiVien();
            if (ID != null)
            {
                using (var northwind = new BaiTapKendoEntities())
                {
                    List<HoiVien> hoivien = northwind.HoiVien.ToList();
                    n_hv = hoivien.Find(n => n.MemberID == ID) ?? new HoiVien();
                   
                }
                ViewBag.IsUpdate = true;
            }
            else
                ViewBag.IsUpdate = false;

            return View(n_hv);
        }
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult UpdateData(HoiVien n_hv)
        {
            try
            {
                int check = -1;
                if (ModelState.IsValid)
                {

                    db.Entry(n_hv).State = EntityState.Modified;
                    check = db.SaveChanges();
                }
                return Json(check == 1);
            }
            catch { 
            }
            return Json(false);
        }

        [HttpPost]
        public ActionResult Delete(List<string> data)
        {

            //foreach (string ID in data)
            //{
            //HoiVien n_hv = db.HoiVien.SingleOrDefault(n => n.MemberID == ID);
            //if (n_hv != null)
            //{
            //    db.HoiVien.Remove(n_hv);
            //}
            //}
            //db.SaveChanges();
            HoiVien n_hv = new HoiVien();          
            using (var northwind = new BaiTapKendoEntities())
            {
                List<HoiVien> hoivien = northwind.HoiVien.ToList();
                foreach (string ID in data)
                {
                    n_hv = hoivien.Find(n => n.MemberID == ID);
                    if (n_hv != null)
                    {
                        northwind.HoiVien.Remove(n_hv);
                    }
                }
                northwind.SaveChanges();

            }

            return Json(true);
        }
        //[HttpPost, ActionName("Delete")]
        //public ActionResult XacNhan(string ID)
        //{
        //    HoiVien n_hv = db.HoiVien.SingleOrDefault(n => n.MemberID == ID);
        //    if (n_hv == null)
        //    {
        //        Response.StatusCode = 404;
        //        return null;
        //    }

        //    db.HoiVien.Remove(n_hv);
        //    db.SaveChanges();

        //    return RedirectToAction("Index");
        //}
        [HttpPost]
        public ActionResult Disable_Update(List<string> data)
        {

            //foreach(string ID in data)
            //{
            //    HoiVien n_hv = db.HoiVien.SingleOrDefault(n => n.MemberID == ID);
            //    if (n_hv != null)
            //    {
            //        n_hv.Disabled = 0;
            
            //    }
            //    db.SaveChanges();
            //}
            //return Json(true);
            HoiVien n_hv = new HoiVien();
            using (var northwind = new BaiTapKendoEntities())
            {
                List<HoiVien> hoivien = northwind.HoiVien.ToList();
                foreach (string ID in data)
                {
                    n_hv = hoivien.Find(n => n.MemberID == ID);
                    if (n_hv != null)
                    {
                        n_hv.Disabled = 0;
                    }
                }
                northwind.SaveChanges();

            }

            return Json(true);
        }
        [HttpPost]
        public ActionResult Enable_Update(List<string> data)
        {

            HoiVien n_hv = new HoiVien();
            using (var northwind = new BaiTapKendoEntities())
            {
                List<HoiVien> hoivien = northwind.HoiVien.ToList();
                foreach (string ID in data)
                {
                    n_hv = hoivien.Find(n => n.MemberID == ID);
                    if (n_hv != null)
                    {
                        n_hv.Disabled = 1;
                    }
                }
                northwind.SaveChanges();

            }

            return Json(true);
        }
        [HttpPost]
        public JsonResult CheckID( string MemberID)
        {
            HoiVien n_hv = new HoiVien();
            using (var northwind = new BaiTapKendoEntities())
            {
            List<HoiVien> hoivien =  northwind.HoiVien.ToList();
               var ID = northwind.HoiVien.FirstOrDefault(n => n.MemberID == MemberID) ?? new HoiVien();
                if( ID!= null)
                {

                 return Json(false);
                }
                return Json(true);
            }
 
        }
  
  
    }

}   
    

