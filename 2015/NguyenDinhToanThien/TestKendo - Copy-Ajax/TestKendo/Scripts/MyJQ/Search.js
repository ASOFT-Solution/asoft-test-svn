$(document).ready(function () { 
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
    });
    $("#submit").click(function locdulieu() {
        var list = Array();
        list.push(document.getElementById("donvi").value);
        list.push(document.getElementById("mahoivien").value);
        list.push(document.getElementById("tenhoivien").value);
        list.push(document.getElementById("diachi").value);
        list.push(document.getElementById("cmnd").value);
        list.push(document.getElementById("sodienthoai").value);
        list.push(document.getElementById("dtdd").value);
        list.push(document.getElementById("fax").value);
        list.push(document.getElementById("email").value);

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