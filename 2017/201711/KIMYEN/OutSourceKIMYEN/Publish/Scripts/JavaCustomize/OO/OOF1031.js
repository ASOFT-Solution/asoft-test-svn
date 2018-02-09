var GridOOT1031 = null;
$(document).ready(function () {
    GridOOT1031 = $("#GridEditOOT1031").data("kendoGrid")
    $(GridOOT1031.tbody).on("change", "td", function (e) {
        var column = e.target.id;
        var selectitem = GridOOT1031.dataItem(e.currentTarget.parentElement); // lấy dòng dữ liệu trên lưới hiện tại đang choknj
        if (column == "cbbWorkID")
        {
            var cbbWorkID = $("#cbbWorkID").data("kendoComboBox"); //lấy combobox trên lưới
            var data = cbbWorkID.dataItem(cbbWorkID.select()); // lấy dòng dữ liệu được chọn trong combobox
            selectitem.set("WorkID", data.WorkID);
            selectitem.set("WorkName", data.WorkName);
        }
    })
})