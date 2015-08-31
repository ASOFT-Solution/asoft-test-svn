$(document).ready(function () {
    $(document).ready(function () {
        $("#them").click(function () {
            $("#window").data("kendoWindow").open();
            $("#window").data("kendoWindow").focus;
        });

        var form = $("#FormId");
        function thongbaoloi(tb) {
            var t = 90;
            var tbl = $("#thongbaoloi");
            tbl.html(tb);
            setTimeout(function () {
                tbl.css("backgroundColor", "blue");
                setTimeout(function () {
                    tbl.css("backgroundColor", "yellow");
                    setTimeout(function () {
                        tbl.css("backgroundColor", "aqua");
                        setTimeout(function () {
                            tbl.css("background-color", "white");
                        }, t);
                    }, t);
                }, t);
            }, t);
        };

        $("#Create1").click(function luuxoa() {
            if (!form.kendoValidator().data("kendoValidator").validate()) {
                return;
            }
            $.ajax({
                cache: false,
                async: true,
                type: "POST",
                url: form.attr("action"),
                data: form.serialize(),
                success: function (data) {
                    if (data == "ok") {
                        alert("Bạn đã thêm thành công");
                        $("#FormId")[0].reset();
                        thongbaoloi("");
                    }
                    else if (data == "pk") {
                        thongbaoloi("Trùng khóa chính");
                    }
                    else {
                        thongbaoloi("Lỗi tại server, xin vui lòng liên hệ nhóm phát triển");
                    };
                },
                error: function () {
                    thongbaoloi("Lỗi truyền dữ liệu, vui lòng thử lại sau");
                }
            });
        });
        $("#Create2").click(function luusaochep() {
            if (!form.kendoValidator().data("kendoValidator").validate()) {
                return;
            }
            $.ajax({
                cache: false,
                async: true,
                type: "POST",
                url: form.attr("action"),
                data: form.serialize(),
                success: function (data) {
                    if (data == "ok") {
                        alert("Bạn đã thêm thành công");
                        thongbaoloi("");
                    }
                    else if (data == "pk") {
                        thongbaoloi("Trùng khóa chính");
                    }
                    else {
                        thongbaoloi("Lỗi tại server, xin vui lòng liên hệ nhóm phát triển");
                    };
                },
                error: function () {
                    thongbaoloi("Lỗi truyền dữ liệu, vui lòng thử lại sau");
                }
            });
        });


        $("#Disable").click(function () {
            if (this.checked == true) {
                $("#Disable").attr("value", 1);
            }
            else {
                $("#Disable").attr("value", 0);
            }
        });

        $("#Disable").attr("value", 0);

        $(function () {
            $("#FormId").kendoValidator();
        });

        function onClose() {
            $("#window").data("kendoWindow").close();
            loaddefault();
        }

        $("#Dong").click(function DongCuaSo() {
            $("#FormId")[0].reset();
            thongbaoloi("");
            $(".field-validation-valid").remove("");
            onClose();
        });
    });
});