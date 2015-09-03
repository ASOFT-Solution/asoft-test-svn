$(document).ready(function () { 
    var form = $("#FormId");

    $("#DivisionID").click(function () {
        thongbaoloi("");
    });
    $("#MemberID").click(function () {
        thongbaoloi("");
    });
//Tao hieu ung thong bao loi khi them du lieu (xu ly thua)
function thongbaoloi(tb) {
    var tbl = $("#thongbaoloi");
    tbl.html(tb);
    /*var t = 90;
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
    }, t);*/
};

 //Button luu va nhap tiep
$("#Create1").click( function luuxoa() {
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
                $("#FormId")[0].reset();//Xoa trang form sau khi them thanh cong
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

//button them sao chep
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
            if (data == "ok") {//Xu ly thong bao cua server tra ve
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

//Thay doi value check textbox disable
$("#Disable").click(function () {
    if (this.checked == true) {
        $("#Disable").attr("value", 1);
    }
    else {
        $("#Disable").attr("value", 0);
    }
});
//Khoi tao mac dinh value cho check disable
$("#Disable").attr("value", 0);

//Validation form bang kendo
$(function () {
    $("#FormId").kendoValidator();
});

//xu ly khi dong popup them
function onClose() {
    $("#window").data("kendoWindow").close();//dong popup
    var grid = $("#grid").data("kendoGrid");
    grid.dataSource.page(1);//tai lai grid de cap nhat du lieu
}

$("#Dong").click( function DongCuaSo() {
    $("#FormId")[0].reset();//Xoa trang form truoc khi dong
    thongbaoloi("");//Xoa trang thong bao loi
    $(".field-validation-valid").remove("");//Xoa trang validation
    onClose();//Goi ham dong popup
});
});