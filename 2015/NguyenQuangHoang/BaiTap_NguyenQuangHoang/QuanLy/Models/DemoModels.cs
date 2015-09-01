using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace QuanLy.Models
{
    public class DemoModels
    {
        public string APK { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập đợn vị!")] //Checkinput bắt buộc nhập đơn vị
        public string DivisionID { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập mã hội viên !")]//Checkinput bắt buộc nhập mã hội viên
        public string MemberID { get; set; }

        public string MemberName { get; set; }

        public string ShortName { get; set; }

        public string Address { get; set; }

        public string Identify { get; set; }

        public string Phone { get; set; }

        [RegularExpression(@"\b\d{6,11}", ErrorMessage = "Số điện thoại từ 6-11 ký tự !")]//Checkinput kiểm tra có phải số điện thoại từ 6 đên - 11 ký số không
        public string Tel { get; set; }

        public string Fax { get; set; }

        [RegularExpression(@"^([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)$",ErrorMessage = "Nhập đúng email !")] //Checkinput đã đúng định dạng email
        public String Email { get; set; }

        public DateTime Birthday { get; set; }

        public string Website { get; set; }

        public string Mailbox { get; set; }

        public string AreaName { get; set; }

        public string CityName { get; set; }

        public string CountryName { get; set; }

        public string WardName { get; set; }

        public string CountyName { get; set; }

        public bool Disable { get; set; }
    }
}