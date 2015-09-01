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
        //Index của bài tập
        public ActionResult Index()
        {
            return View();
        }

        //Partial popop thêm
        public ActionResult Insert()
        {
            return View();
        }

        //Partial grid kendo
        public ActionResult Grid()
        {
            return View();
        }

        //Xư lý lấy thông tin lọc dữ liệu từ view
        public void srch(HoiVien srch)
        {
            TempData["search"] = srch;//Gán thông tin để lọc dữ liệu vào tempData chờ xử lý
        }

        //Load Grid trong view đồng thời là hàm lọc dữ liẹu
        public ActionResult Search([DataSourceRequest] DataSourceRequest request)
        {
            string sql = "Select * from HoiVien";
            string temp = "";
            IEnumerable ds;
            HoiVien srch = (HoiVien)TempData["search"];//lây thông tin lọc dữ liệu
            if (srch == null)//Không có trả về danh sách ban đầu
            {
                ds = MyConnectionDB.GetInstance().Query<HoiVien>(sql);
            }
            else
            {
                //kiểm tra các thông tin lọc dữ liệu nếu có thì ghép câu sql để tìm kiếm 
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
                    sql = sql + " where 0=0" + temp;// câu SQL cuối cùng
                }
                ds = MyConnectionDB.GetInstance().Query<HoiVien>(sql);//Tìm kiếm trả về kết quả
      
            }
            return Json(ds.ToDataSourceResult(request));//Trả về kết quả cho View thông qua JSon
        }

        //Delete dữ liệu
        public void Destroy(string[] destroy)
        {
            MyConnectionDB db = new MyConnectionDB();
            foreach (string dt in destroy)
            {
                string sql = string.Format("delete from hoivien where APK = '{0}'", dt);
                db.Execute(sql);
            }
        }

        //Update trường disable
        public void Undisable(string[] undisable)
        {
            MyConnectionDB db = new MyConnectionDB();
            foreach (string dt in undisable)
            {
                string sql = string.Format("update HoiVien set Disable = 0 where APK = '{0}'", dt);
                db.Execute(sql);
            }
        }

        //Đánh trường disable
        public void Disable(string[] disable)
        {
            MyConnectionDB db = new MyConnectionDB();
            foreach (string dt in disable)
            {
                string sql = string.Format("update HoiVien set Disable = 1 where APK = '{0}'", dt);
                db.Execute(sql);
            }
        }

        //Kiểm tra dữ liệu thêm có trùng khóa chính trong sql không
        public ActionResult Testkey(string ma, string ten)
        {
            IEnumerable<HoiVien> test;
            string sql = string.Format("Select * from HoiVien where DivisionID = '{0}' and MemberID = '{1}'", ma,ten);
            test = MyConnectionDB.GetInstance().Query<HoiVien>(sql);
            int sl = test.Count();
            return Json(sl,JsonRequestBehavior.AllowGet);
        }

        //Thêm dữ liệu vào sql
        public void Createmember(DemoModels create)
        {
            int disable = 0;
            if (create.Disable == true)
                disable = 1;
            HoiVien create1 = new HoiVien();
            create1.DivisionID = create.DivisionID;
            create1.MemberID = create.MemberID;
            create1.MemberName = create.MemberName;
            create1.ShortName = create.ShortName;
            create1.Address = create.Address;
            create1.Identify = create.Identify;
            create1.Phone = create.Phone;
            create1.Tel = create.Tel;
            create1.Fax = create.Fax;
            create1.Email = create.Email;
            create1.Birthday = create.Birthday;
            create1.Website = create.Website;
            create1.Mailbox = create.Mailbox;
            create1.AreaName = create.AreaName;
            create1.CityName = create.CityName;
            create1.CountryName = create.CountryName;
            create1.WardName = create.WardName;
            create1.CountyName = create.CountyName;
            create1.Disable = Convert.ToByte(disable);       
            MyConnectionDB.GetInstance().Insert(create1);
        }
    }
}
