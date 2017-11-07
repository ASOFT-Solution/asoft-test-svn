using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace BaiTap.Models
{

    public partial class HoiVien
    {
        public bool Discontinued;
        public string Action;

        [MetadataTypeAttribute(typeof(HoiVienMetadata))]


        internal sealed class HoiVienMetadata
        {

            public System.Guid APK { get; set; }
            [DisplayName("Mã đơn vị")]
            [Required(ErrorMessage = "Bạn chưa nhập mã đơn vị")]
            public string DivisionID { get; set; }

            [DisplayName("Mã hội viên")]
            [Required(ErrorMessage = "Bạn chưa nhập mã hội viên")]
            [Remote("MemberID","CheckID", HttpMethod="POST" , ErrorMessage="ID này đã bị trùng")]
            public string MemberID { get; set; }
            [DisplayName("Tên hội viên")]
            [Required(ErrorMessage = "Bạn chưa nhập tên")]
            public string MemberName { get; set; }
            public string ShortName { get; set; }
            [DisplayName("Địa chỉ")]

            public string Address { get; set; }
            public string Identify { get; set; }
            [DisplayName("Số điện thoại")]
            [StringLength(10, MinimumLength = 3, ErrorMessage = "Telephone should not be longer than 20 characters.")]
            public string Phone { get; set; }
            [DisplayName("Điện thoại")]
            [StringLength(10, MinimumLength = 3, ErrorMessage = "Telephone should not be longer than 20 characters.")]
            public string Tel { get; set; }
            [DisplayName("Fax")]
            public string Fax { get; set; }
            [DisplayName("Email")]
            [RegularExpression(@"\A(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?)\Z",
            ErrorMessage = "Please enter correct email address")]
            public string Email { get; set; }
            public Nullable<System.DateTime> Birthday { get; set; }
            [DisplayName("Website")]
            public string Website { get; set; }
            public string Mailbox { get; set; }
            public string AreaName { get; set; }
            public string CityName { get; set; }
            public string CountryName { get; set; }
            public string WardName { get; set; }
            public Nullable<System.DateTime> CreatDate { get; set; }
            public string CreateUserID { get; set; }
            public Nullable<System.DateTime> LastModifyDate { get; set; }
            public string LastModifyUserID { get; set; }
            public byte Disabled { get; set; }
        }
        //public class BaiTapKendoEntities : DbContext
        //{
        //    public DbSet<HoiVien> HoiVien { get; set; }
        //}
        //IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
        //{
        //    BaiTapKendoEntities db = new BaiTapKendoEntities();
        //    List<ValidationResult> validationResult = new List<ValidationResult>();
        //    var validateID = db.HoiVien.FirstOrDefault(x => x.MemberID == MemberID);
        //    if (validateID != null)
        //    {
        //        ValidationResult errorMessage = new ValidationResult("Mã này đã tồn tại!", new[] { "MemberID" });
        //        validationResult.Add(errorMessage);
        //    }

        //    return validationResult;
        //}

    }
}