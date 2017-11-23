$(document).ready(function () {
    $("#GR_LichSu").remove();
    $("#GR_DinhKem").remove();
    var GridPartialAT1312 = "/Partial/GridPartialAccountIDCIF1172/CI/CIF1172";
    ASOFT.partialView.Load(GridPartialAT1312, "#CIF1172_ThongTinTaiKhoanTonKhoDoanhThu-1 .asf-master-content", 3);
    var GridPartialAT1314 = "/Partial/GridPartialWareHouseCIF1172/CI/CIF1172";
    ASOFT.partialView.Load(GridPartialAT1314, "#CIF1172_ThongTinDinhMucTonKho-1 .asf-master-content", 2);
    var GridPartialAvatar = "/Partial/GetAvatarAT1302/CI/CIF1172?InventoryID=" + $(".InventoryID").text();
    ASOFT.partialView.Load(GridPartialAvatar, "#CIF1172_ThongTinKhac-1 .last .asf-table-view", 3);

    var trMiddle = $("#CIF1172_ThongTinKhac-1 .middle .asf-table-view").find('tr');
    var trLast = $("#CIF1172_ThongTinKhac-1 .last .asf-table-view").find('tr');
    for (i = 0; i < 2; i++) {
        $("#CIF1172_ThongTinKhac-1 .first .asf-table-view").append(trMiddle[i]);
        $("#CIF1172_ThongTinKhac-1 .middle .asf-table-view").append(trLast[i]);
    }
    $("#CIF1172_ThongTinKhac-1 .middle .asf-table-view").append(trLast[3]);
    $("#CIF1172_ThongTinKhac-1 .middle .asf-table-view").append(trLast[4]);
});
//function DeleteViewNoDetail(pk) {
//    pk = pk + "," + $(".DivisionID").text() + "," + $(".AreaID").text();
//    return pk;
//}

function sendData() {
    var data = {};
    data["InventoryID"] = $(".InventoryID").text();
    return data;
}

function getDivisionID() {
    return $(".DivisionID").text();
}

function getInventoryID() {
    return $(".InventoryID").text();
}


function sendDataWareHouse() {
    var data = {};
    data["InventoryID"] = $(".InventoryID").text();
    return data;
}

function EditCIF1173_Click() {
    ASOFT.form.clearMessageBox();
    var url = "/PopupMasterDetail/Index/CI/CIF1173?PK=" +  $(".InventoryID").text() + "&key=InventoryID" + "&Table=AT1302";

    ASOFT.asoftPopup.showIframe(url, {});
};

//function EditCIF1174_Click() {
//    ASOFT.form.clearMessageBox();
//    var url = "/PopupLayout/Index/CI/CIF1174?PK=" + $(".InventoryID").text() + "&key=InventoryID" + "&Table=AT1302";

//    ASOFT.asoftPopup.showIframe(url, {});
//};

function EditCIF1175_Click() {
    ASOFT.form.clearMessageBox();
    var url = "/PopupMasterDetail/Index/CI/CIF1175?PK=" + $(".InventoryID").text() + "&key=InventoryID" + "&Table=AT1302";

    ASOFT.asoftPopup.showIframe(url, {});
};
