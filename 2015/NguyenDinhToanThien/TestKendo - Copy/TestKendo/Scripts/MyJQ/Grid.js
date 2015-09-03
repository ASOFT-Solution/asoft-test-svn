$(document).ready(function () {
    //Check vao nut checkall tren grid
    $("#clickall").change(function () {
        var check = this.checked;
        $(":checkbox[name='clickone']").attr("checked", check);
    });

    //Lay gia tri trong cac textbox dang duoc check
    function laycheckbox() {
        var list = Array();
        $(":checkbox[name='clickone']").each(function () {
            if (this.checked)
                list.push(this.value);
        });
        return list;
    };

    //xu ly nut disable
    $("#disable").click(function disable() {
        var list = laycheckbox();//lay gia tri cua cac text duoc check
        if (list.length == 0) {
            alert("Bạn chưa chọn dòng nào");
            return;
        }
        if (!confirm("Bạn có chắc chắn muốn khóa?")) {
            return;
        }
        var duongdan = 'bt/disable';
        try {
            guidulieuveserver(duongdan, list);//Gui du lieu cho server xu ly
        }
        catch (e) {
            alert("Error on ajax post");
        };
    });

    //xu ly nut enable
    $("#enable").click(function enable() {
        var list = laycheckbox();//lay gia tri cua cac text duoc check
        if (list.length == 0) {
            alert("Bạn chưa chọn dòng nào");
            return;
        }
        if (!confirm("Bạn có chắc chắn muốn kích hoạt?")) {
            return;
        }
        var duongdan = 'bt/enable';
        try {
            guidulieuveserver(duongdan, list);//Gui du lieu cho server xu ly
        }
        catch (e) {
            alert("Error on ajax post");
        };
    });

    //xu ly nut xoa
    $("#xoa").click(function xoa() {
        var list = laycheckbox();//lay gia tri cua cac text duoc check
        if (list.length == 0) {
            alert("Bạn chưa chọn dòng nào");
            return;
        }
        if (!confirm("Bạn có chắc chắn muốn xóa?")) {
            return;
        }
        var duongdan = 'bt/xoa';
        try {
            guidulieuveserver(duongdan, list);//Gui du lieu cho server xu ly
        }
        catch (e) {
            alert("Error on ajax post");
        };
    });
});

//ham tao so thu tu tren grid
function CreateSTT() {
    var stt = $("[name='stt']").html(function (index) {
        this.innerHTML = index + 1;
    });

    //ham xoa dau check tai checkall khi bo check o mot textbox bat ki
    $("[name='clickone']").click(function () {
        if (!$(this).attr("checked")) {
            $("#clickall").attr("checked", false);
        }
    });
};

//Ham gui du lieu ve sever, nhan vao duong dan server và list du lieu
function guidulieuveserver(duongdan, list) {
    $.ajax({
        type: 'POST',
        url: duongdan,
        traditional: true,
        async: true,
        data: { dulieu: list },
        success: function (datareturn) {
            if (datareturn == "True") {
                var grid = $("#grid").data("kendoGrid");
                grid.dataSource.read();//Load lai gird de cap nhat du lieu
                $("#clickall").get(0).checked = false;//Xoa dau check tai checkall
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