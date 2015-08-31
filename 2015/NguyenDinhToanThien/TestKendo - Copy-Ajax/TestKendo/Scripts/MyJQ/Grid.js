
$(document).ready(function () {
    $("#xoa").click(function xoa() {
        var list = laysoluong();
        if (list.length == 0) {
            alert("Bạn chưa chọn dòng nào");
            return;
        }
        if (!confirm("Bạn có chắc chắn muốn xóa?")) {
            return;
        }

        $.ajax({
            type: 'POST',
            url: '/asoft/xoa',
            traditional: true,
            dataType: "json",
            data: { dulieu: list },
            success: function (data) {
                alert("success");
                loadgrip(data);
            },
            error: function (args) {

                alert("Error on ajax post");
            }
        });

    });
    $("#disable").click(function disable() {
        var list = laysoluong();
        if (list.length == 0) {
            alert("Bạn chưa chọn dòng nào");
            return;
        }
        if (!confirm("Bạn có chắc chắn muốn xóa?")) {
            return;
        }

        $.ajax({
            type: 'POST',
            url: '/asoft/disable',
            traditional: true,
            dataType: "json",
            data: { dulieu: list, trang: trang },
            success: function (data) {
                alert("success");
                loadgrip(data);
            },
            error: function (args) {
                alert("Error on ajax post");
            }
        });

    });

    $("#enable").click(function enable() {
        var list = laysoluong();
        if (list.length == 0) {
            alert("Bạn chưa chọn dòng nào");
            return;
        }
        if (!confirm("Bạn có chắc chắn muốn xóa?")) {
            return;
        }

        $.ajax({
            type: 'POST',
            url: '/asoft/enable',
            traditional: true,
            dataType: "json",
            data: { dulieu: list, trang: trang },
            success: function (data) {
                alert("success");
                loadgrip(data);
            },
            error: function (args) {

                alert("Error on ajax post");
            }
        });
    });
});
