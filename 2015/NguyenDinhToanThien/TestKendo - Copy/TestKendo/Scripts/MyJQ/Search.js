$(document).ready(function () { 

$("#lamlai").click(function lamlai() {
    $("#donvi").val("");
    $("#diachi").val("");
    $("#sodienthoai").val("");
    $("#mahoivien").val("");
    $("#cmnd").val("");
    $("#fax").val("");
    $("#tenhoivien").val("");
    $("#dtdd").val("");
    $("#email").val("");
    $("#checkdisable").attr("checked",false);
});

$("#locdulieu").click(function locdulieu() {
    var duongdan = 'bt/gantempdata';
    var list = Array();
    list.push($("#donvi").attr("value"));
    list.push($("#diachi").attr("value"));
    list.push($("#sodienthoai").attr("value"));
    list.push($("#mahoivien").attr("value"));
    list.push($("#cmnd").attr("value"));
    list.push($("#fax").attr("value"));
    list.push($("#tenhoivien").attr("value"));
    list.push($("#dtdd").attr("value"));
    list.push($("#email").attr("value"));
    if ($("#checkdisable").attr("checked")) {
        list.push("true");
    }
    else {
        list.push("");
    }
    guidulieuveserver(duongdan, list);
});

});