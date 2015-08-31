var trang = 1;
$(document).ready(function () {
    loaddefault();
});
function loaddefault() {
    $.ajax({
        type: 'POST',
        url: '/asoft/LoadDefault',
        traditional: true,
        dataType: "json",
        data: { trang: trang },
        success: function (data) {
            loadgrip(data);
        },
        error: function (args) {
            alert("Error on ajax post");
        }
    })
};
function checkall() {
    $("#ck").click(function () {
        var i = soluong;
        if ($(this).attr("checked")) {
            $("[name='clickone']").attr("checked", true);
        }
        else {
            $("[name='clickone']").attr("checked", false);
        }
    });

    $("[name='clickone']").click(function () {
        if (!$(this).attr("checked")) {
            $("#ck").attr("checked", false);
        }
    });
};
function loadgrip(data) {
    $("#grip").empty();
    var html = "<table  style='text-align:center'>" +
    "<tr><th><input id='ck' name='ck' type='checkbox'/></th><th>STT</th><th>" +
        "Đơn vị" +
    "</th><th>" +
        "Mã hội viên" +
    "</th><th>" +
        "Tên hội viên" +
    "</th><th>" +
        "Địa chỉ" +
    "</th><th>" +
        "Mã số thuế/CMND" +
    "</th><th>" +
        "Số điện thoại" +
    "</th><th>" +
        "ĐTDĐ" +
    "</th><th>" +
        "Fax" +
    "</th><th>" +
        "Email" +
    "</th><th>" +
        "Không kích hoạt" +
    "</th></tr>";

    var i = 1;
    $.each(data, function (entryIndex, entry) {
        if (entry["DivisionID"] == null) entry["DivisionID"] = "";
        if (entry["MemberID"] == null) entry["MemberID"] = "";
        if (entry["MemberName"] == null) entry["MemberName"] = "";
        if (entry["Address"] == null) entry["Address"] = "";
        if (entry["Identify"] == null) entry["Identify"] = "";
        if (entry["Phone"] == null) entry["Phone"] = "";
        if (entry["Tell"] == null) entry["Tell"] = "";
        if (entry["Fax"] == null) entry["Fax"] = "";
        if (entry["Email"] == null) entry["Email"] = "";
        if (entry["Disable"] == null) entry["Disable"] = "";
        html += "<td><input type='checkbox' name='clickone'value='" + entry["APK"] + "'/></td><td>" + i + "</td><td>" +
        entry["DivisionID"] +
    "</td><td>" +
        entry["MemberID"] +
    "</td><td>" +
        entry["MemberName"] +
    "</td><td>" +
        entry["Address"] +
    "</td><td>" +
        entry["Identify"] +
    "</td><td>" +
        entry["Phone"] +
    "</td><td>" +
        entry["Tell"] +
    "</td><td>" +
        entry["Fax"] +
    "</td><td>" +
        entry["Email"] +
    "</td><td>" +
        entry["Disable"] +
    "</td></tr>";
        i++;
    });
    html += "</table>";


    $.ajax({
        type: 'POST',
        url: '/asoft/TotalPage',
        success: function (sl) {
            for (k = 0; k < sl; k++) {
                t = k + 1;
                html += "<input name='phantrang' type='button' value='" + t + "'/>"
            }
            $("#grip").append(html);
            $("[name='phantrang']").click(function () {
                trang = this.value;
                loaddefault();
            });
            $("[name='phantrang']")[trang - 1].className = "tranghientai";
            checkall();
        },
        error: function (args) {
            alert("Error on ajax post");
        }
    });
};

function laysoluong() {
    var list = Array();
    $("[name='clickone']").each(function () {
        if ($(this).attr("checked")) {
            list.push($(this).attr("value"));
        }
    });
    return list;
};
   
