$(document).ready(function () {

    var pt = 1;

    function loadgrid1(data, dt) {

        $("#grid").empty();
        var grid = "";

        for (j = 0; j < dt; j++) {
            grid = grid + "<input  type = 'button' name = 'page1' value = '" + (j + 1) + "'/>";
        }

        var i = 1;
        grid = grid + "<table>" +
            "<tr><td><input type='checkbox' id='checkid' /></td>" +
                "<td>STT</td>" +
                "<td>Đơn vị</td>" +
                "<td>Mã hội viên</td>" +
                "<td>Tên hội viên</td>" +
                "<td>Địa chỉ</td>" +
                "<td>Mã thuê/Số CMND</td>" +
                "<td>Điện thoại di động</td>" +
                "<td>Số điện thoại</td>" +
                "<td>Fax</td>" +
                "<td>Email</td>" +
                "<td>Không kích hoạt</td>" +
            "</tr>";
        $.each(data, function (key, val) {
            if (val["DivisionID"] == null) { val["DivisionID"] = "" };
            if (val["MemberID"] == null) { val["MemberID"] = "" };
            if (val["MemberName"] == null) { val["MemberName"] = "" };
            if (val["Address"] == null) { val["Address"] = "" };
            if (val["Identify"] == null) { val["Identify"] = "" };
            if (val["Phone"] == null) { val["Phone"] = "" };
            if (val["Tel"] == null) { val["Tel"] = "" };
            if (val["Fax"] == null) { val["Fax"] = "" };
            if (val["Email"] == null) { val["Email"] = "" };
            grid = grid +
                "<tr><td><input type='checkbox' name='check' value='" + val['APK'] + "'/></td>" +
                "<td>" + i + "</td>" +
                "<td>" + val["DivisionID"] + "</td>" +
                "<td>" + val["MemberID"] + "</td>" +
                "<td>" + val["MemberName"] + "</td>" +
                "<td>" + val["Address"] + "</td>" +
                "<td>" + val["Identify"] + "</td>" +
                "<td>" + val["Phone"] + "</td>" +
                "<td>" + val["Tel"] + "</td>" +
                "<td>" + val["Fax"] + "</td>" +
                "<td>" + val["Email"] + "</td>" +
                "<td>" + val["Disable"] + "</td>" +
                "<tr>";
            i++;
        });
        grid = grid + "</table>";

        $("#grid").append(grid);

        $("#grid").find("td").css("background", "#FFC");

        $("#checkid").click(function () {
            var c = this.checked;
            $("[name = 'check']").prop('checked', c);
        });


        $("[name= 'page1']").click(function () {
            pt = this.value;
            search(2, this.value);
        });
    };

    function loadgrid(data, dt) {

        $("#grid").empty();
        var grid = "";

        for (j = 0; j < dt; j++) {
            grid = grid + "<input  type = 'button' name = 'page' value = '" + (j + 1) + "'/>";
        }

        var i = 1;
        grid = grid + "<table>" +
        "<tr><td><input type='checkbox' id='checkid' /></td>" +
            "<td>STT</td>" +
            "<td>Đơn vị</td>" +
            "<td>Mã hội viên</td>" +
            "<td>Tên hội viên</td>" +
            "<td>Địa chỉ</td>" +
            "<td>Mã thuê/Số CMND</td>" +
            "<td>Điện thoại di động</td>" +
            "<td>Số điện thoại</td>" +
            "<td>Fax</td>" +
            "<td>Email</td>" +
            "<td>Không kích hoạt</td>" +
        "</tr>";
        $.each(data, function (key, val) {
            if (val["DivisionID"] == null) { val["DivisionID"] = "" };
            if (val["MemberID"] == null) { val["MemberID"] = "" };
            if (val["MemberName"] == null) { val["MemberName"] = "" };
            if (val["Address"] == null) { val["Address"] = "" };
            if (val["Identify"] == null) { val["Identify"] = "" };
            if (val["Phone"] == null) { val["Phone"] = "" };
            if (val["Tel"] == null) { val["Tel"] = "" };
            if (val["Fax"] == null) { val["Fax"] = "" };
            if (val["Email"] == null) { val["Email"] = "" };
            grid = grid +
                "<tr><td><input type='checkbox' name='check' value='" + val['APK'] + "'/></td>" +
                "<td>" + i + "</td>" +
                "<td>" + val["DivisionID"] + "</td>" +
                "<td>" + val["MemberID"] + "</td>" +
                "<td>" + val["MemberName"] + "</td>" +
                "<td>" + val["Address"] + "</td>" +
                "<td>" + val["Identify"] + "</td>" +
                "<td>" + val["Phone"] + "</td>" +
                "<td>" + val["Tel"] + "</td>" +
                "<td>" + val["Fax"] + "</td>" +
                "<td>" + val["Email"] + "</td>" +
                "<td>" + val["Disable"] + "</td>" +
                "<tr>";
            i++;
        });
        grid = grid + "</table>";



        $("#grid").append(grid);

        $("#grid").find("td").css("background", "#FFC");

        $("#checkid").click(function () {
            var c = this.checked;
            $("[name = 'check']").prop('checked', c);
        });


        $("[name= 'page']").click(function () {
            pt = this.value;
            phantrang(1, this.value);
        });
    };

    function LoadPage(dk, dt) {
        $.ajax({
            type: "POST",
            url: "QuanLy/LoadPage",
            success: function (data) {
                if (dk == 1)
                    loadgrid(dt, data);
                else
                    loadgrid1(dt, data);
            },
            error: function (args) {
                return 0;
            }
        });
    }

    function phantrang(dk, pg) {
        $.ajax({
            type: "POST",
            url: "QuanLy/LoadGrid",
            data: { page: pg },
            success: function (data1) {
                LoadPage(dk, data1);
            },
            error: function (args) {
                alert("Error on ajax post");
            }
        });
    }

    $(function () {
        phantrang(1, 1);
    });


    $("#frLoc").submit(function () {
        search(2, 1);
    });

    function search(dk, ptr) {

        $.ajax({
            type: "POST",
            url: "QuanLy/srch",
            data: $("#frLoc").serialize() + "&page=" + ptr,
            success: function (data) {
                LoadPage(dk, data);
            },
            error: function (args) {
                alert(ptr);
            }
        })
    }

    $("#btlamlai").click(function () {
        $("#tb").find(":text").val(null);
    })

    $("#btxoa").click(function () {
        var list = $(":input[name = 'check']");
        var dtr = Array();
        list.each(function () {
            if (this.checked == true)
                dtr.push(this.value);
        })

        if (dtr.length == 0) {
            alert("Hãy Chọn Để Xóa");
            return;
        }
        if (!confirm("Bạn có muốn xóa không?"))
            return;

        $.ajax({
            type: 'POST',
            url: '/QuanLy/Destroy',
            traditional: true,
            dataType: "json",
            data: { destroy: dtr, page: pt },
            success: function (data) {
                LoadPage(1,data);
            },
            error: function (args) {
                alert("Error on ajax post");
            }
        });
    });

    $("#btdisable").click(function () {
        var list = $(":input[name = 'check']");
        var d = Array();
        list.each(function () {
            if (this.checked == true)
                d.push(this.value);
        })
        if (d.length == 0) {
            alert("Hãy Chọn");
            return;
        }

        $.ajax({
            type: 'POST',
            url: '/QuanLy/Disable',
            traditional: true,
            dataType: "json",
            data: { disable: d, page: pt },
            success: function (data) {
                LoadPage(1, data);
            },
            error: function (args) {
                alert("Error on ajax post");
            }
        });
    });

    $("#btupdate").click(function () {
        var list = $(":input[name = 'check']");
        var und = Array();
        list.each(function () {
            if (this.checked == true)
                und.push(this.value);
        })
        if (und.length == 0) {
            alert("Hãy Chọn");
            return;
        }

        $.ajax({
            type: 'POST',
            url: '/QuanLy/Undisable',
            traditional: true,
            dataType: "json",
            data: { undisable: und, page: pt },
            success: function (data) {
                LoadPage(1, data);
            },
            error: function (args) {
                alert("Error on ajax post");
            }
        });
    });

    $("#btthem").click(function (e) {
        $("#pp").data("kendoWindow").open();
    });

    $("#btdong").click(function (e) {
        temp = -1;
        $("#pp").data("kendoWindow").close();
    });

    var temp = -1;

    $("#btluu").click(function () {
        temp = 0;
    });

    $("#btluusc").click(function () {
        temp = 1;
    });

    $(function () {
        var validator = $("#ticketsForm").kendoValidator().data("kendoValidator")
        $("form").submit(function (event) {
            event.preventDefault();
            if (temp == -1)
                return;
            if (validator.validate()) {
                testkey();
            }
        });
    });

    function testkey() {
        var mdv = $("#ticketsForm").find("#DivisionID").val();
        var mhv = $("#ticketsForm").find("#MemberID").val();
        $.getJSON("QuanLy/Testkey", { ma: mdv, ten: mhv }, function (data) {
            if (data > 0) {
                $("#none").css("display", "inline");
            }
            else {
                $.ajax({
                    type: "POST",
                    url: $("#ticketsForm").attr("action"),
                    data: $("#ticketsForm").serialize(), // serializes the form's elements.
                    success: function (data) {
                        if (temp == 0)
                            $("#ticketsForm").find(":text[name != 'Birthday']").val(null);
                        LoadPage(1, data);
                        $("#none").css("display", "none");
                        alert("Thêm Thành Công");
                    },
                    error: function (args) {
                        alert("Thêm Thất Bại");
                    }
                });
            }
        })
    }

});