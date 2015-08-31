$(document).ready(function () {
    $("#clickall").change(function () {
        var check = this.checked;
        $(":checkbox[name='clickone']").attr("checked", check);
    });


    function laycheckbox() {
        var list = Array();
        $(":checkbox[name='clickone']").each(function () {
            if (this.checked)
                list.push(this.value);
        });
        return list;
    };
    $("#disable").click(function disable() {
        var list = laycheckbox();
        if (list.length == 0) {
            alert("Bạn chưa chọn dòng nào");
            return;
        }
        if (!confirm("Bạn có chắc chắn muốn khóa?")) {
            return;
        }
        var duongdan = 'bt/disable';
        try {
            guidulieuveserver(duongdan, list);
        }
        catch (e) {
            alert("Error on ajax post");
        };
    });

    $("#enable").click(function enable() {
        var list = laycheckbox();
        if (list.length == 0) {
            alert("Bạn chưa chọn dòng nào");
            return;
        }
        if (!confirm("Bạn có chắc chắn muốn kích hoạt?")) {
            return;
        }
        var duongdan = 'bt/enable';
        try {
            guidulieuveserver(duongdan, list);
        }
        catch (e) {
            alert("Error on ajax post");
        };
    });

    $("#xoa").click(function xoa() {
        var list = laycheckbox();
        if (list.length == 0) {
            alert("Bạn chưa chọn dòng nào");
            return;
        }
        if (!confirm("Bạn có chắc chắn muốn xóa?")) {
            return;
        }
        var duongdan = 'bt/xoa';
        try {
            guidulieuveserver(duongdan, list);
        }
        catch (e) {
            alert("Error on ajax post");
        };
    });

    
    

});

function CreateSTT() {
    var stt = $("[name='stt']").html(function (index) {
        this.innerHTML = index + 1;
    });

    $("[name='clickone']").click(function () {
        if (!$(this).attr("checked")) {
            $("#clickall").attr("checked", false);
        }
    });
};

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
                grid.dataSource.read();
                $("#clickall").get(0).checked = false;
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