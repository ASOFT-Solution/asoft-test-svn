﻿//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace BaiTap.Models
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    
    public partial class BaiTapKendoEntities : DbContext
    {
        public BaiTapKendoEntities()
            : base("name=BaiTapKendoEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public DbSet<HoiVien> HoiVien { get; set; }
        public DbSet<Menu1> Menu1 { get; set; }
        public DbSet<MenuChild1> MenuChild1 { get; set; }
        public DbSet<MenuChild2> MenuChild2 { get; set; }
    }
}
