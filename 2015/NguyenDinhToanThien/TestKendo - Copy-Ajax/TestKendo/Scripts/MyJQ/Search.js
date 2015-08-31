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
    });
    $("#submit").click(function locdulieu() {
        var list = Array();
        list.push($("#donvi").attr("value"));
        list.push($("#mahoivien").attr("value"));
        list.push($("#tenhoivien").attr("value"));
        list.push($("#diachi").attr("value"));
        list.push($("#cmnd").attr("value"));
        list.push($("#sodienthoai").attr("value"));
        list.push($("#dtdd").attr("value"));
        list.push($("#fax").attr("value"));
        list.push($("#email").attr("value"));

        $.ajax({
            type: 'POST',
            url: '/asoft/gantempdata',
            traditional: true,
            dataType: "json",
            data: { dulieu: list, trang: 1 },
            success: function (data) {
                loadgrip(data);
            },
            error: function (args) {
                alert("Error on ajax post");
            }
        });
        trang = 1;
    });
});