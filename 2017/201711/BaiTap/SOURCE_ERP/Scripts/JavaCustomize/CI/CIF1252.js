$(document).ready(function () {
    $("#GR_LichSu").remove();
    $("#GR_DinhKem").remove();
});

function DeleteViewMasterDetail(pk) {
    pk = $(".ID").text();
    return pk;
}

function CustomDeleteDetail(records) {
    var args = [];
    for (var i = 0; i < records.length; i++) {
        var valuepk = records[i]["InventoryID"] + "," + records[i]["ID"];
        args.push(valuepk);
    }
    return args;
}

function getID() {
    return $(".ID").text();
}


function CustomRead() {
    var ct = [];
    ct.push($(".ID").text());
    return ct;
}
