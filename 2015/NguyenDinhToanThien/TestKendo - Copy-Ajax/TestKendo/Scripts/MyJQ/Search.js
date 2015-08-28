$(document).ready(function () { 

    function guidulieuveserver(duongdan, list) {
        $.ajax({
            type: 'POST',
            url: duongdan,
            traditional: true,
            async: true,
            data: { dulieu: list },
            success: function (datareturn) {
                if (datareturn) {
                    var grid = $("#grid").data("kendoGrid");
                    grid.dataSource.read();
                    document.getElementById("clickall").checked = false;
                    alert("success");
                } else {
                    alert("Lỗi tại server, vui lòng liên hệ nhóm phát triển");
                }
            },
            error: function (args) {
                alert("Error on ajax post");
            }
        });
    };

    $("#lamlai").click(function lamlai() {
        document.getElementById("donvi").value = "";
        document.getElementById("diachi").value = "";
        document.getElementById("sodienthoai").value = "";
        document.getElementById("mahoivien").value = "";
        document.getElementById("cmnd").value = "";
        document.getElementById("fax").value = "";
        document.getElementById("tenhoivien").value = "";
        document.getElementById("dtdd").value = "";
        document.getElementById("email").value = "";
        document.getElementById("checkdisable").checked = false;
    });

    $("#locdulieu").click(function locdulieu() {
        var duongdan = 'bt/gantempdata';
        var list = Array();
        list.push(document.getElementById("donvi").value);
        list.push(document.getElementById("diachi").value);
        list.push(document.getElementById("sodienthoai").value);
        list.push(document.getElementById("mahoivien").value);
        list.push(document.getElementById("cmnd").value);
        list.push(document.getElementById("fax").value);
        list.push(document.getElementById("tenhoivien").value);
        list.push(document.getElementById("dtdd").value);
        list.push(document.getElementById("email").value);
        list.push(document.getElementById("checkdisable").checked);
        guidulieuveserver(duongdan, list);
    });

});