using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BaiTap.Models
{
    public class Search
    {
        private BaiTapKendoEntities db = new BaiTapKendoEntities();
        public List<string> Search_hv(string dtSearch)
        {
            IQueryable<HoiVien> model = db.HoiVien;
            return model.Where(x => x.DivisionID.Contains(dtSearch)).Select(x => x.DivisionID).ToList();
        }
    }
}