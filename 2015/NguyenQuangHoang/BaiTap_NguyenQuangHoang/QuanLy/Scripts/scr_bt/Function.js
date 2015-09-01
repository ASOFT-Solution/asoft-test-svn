$(document).ready(function () {

    $("#checkid").click(function () {
        var c = this.checked;
        $(":input[name = 'check']").prop('checked', c); //Xử lý check all
    });
    $("#frLoc").submit(function () {//Xử lý tìm kiếm

        $.ajax({
            type: "POST",
            url: $("#frLoc").attr("action"),
            data: $("#frLoc").serialize(), 
            success: function (data) {
                $('#grid').data('kendoGrid').dataSource.read();//Trả về kết quả về Grid
            },
            error: function (args) {
                alert("Error on ajax post");
            }
        });

    });
    $("#btlamlai").click(function () {//button làm lại: xóa trắng các button trong dãy lọc
        $("#tb").find(":text").val(null);
    })
    $("#btxoa").click(function () {//Xóa 1 hoặc nhiều dòng dữ liệu đc check trong Grid
        var list = $(":input[name = 'check']");
        var dtr = Array();
        list.each(function () {
            if (this.checked == true) //Đêm nhưng dòng được check
                dtr.push(this.value);
        })
        if (dtr.length == 0) {
            alert("Hãy Chọn Để Xóa");
            return;
        }
        if (!confirm("Bạn có muốn xóa không?"))
            return

        $.ajax({
            type: 'POST',
            url: '/QuanLy/Destroy',
            traditional: true,
            dataType: "json",
            data: { destroy: dtr },
            success: function (data) {
                $('#grid').data('kendoGrid').dataSource.read();//Trả về dữ liệu sau khi xóa
            },
            error: function (args) {
                alert("Error on ajax post");
            }
        });
    });
    $("#btdisable").click(function () {//Disable: Đánh disable cho dữ liệu được check trong grid
        var list = $(":input[name = 'check']");
        var d = Array();
        list.each(function () {
            if (this.checked == true)//Đêm nhưng dòng được check
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
            data: { disable: d },
            success: function (data) {
                $('#grid').data('kendoGrid').dataSource.read();//Trả về dữ liệu sau khi disable
            },
            error: function (args) {
                alert("Error on ajax post");
            }
        });
    });
    $("#btupdate").click(function () {// Update trường disable được check trong grid
        var list = $(":input[name = 'check']");
        var und = Array();
        list.each(function () {
            if (this.checked == true)//Đêm nhưng dòng được check
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
            data: { undisable: und },
            success: function (data) {
                $('#grid').data('kendoGrid').dataSource.read();//Trả kết quả sau khi update
            },
            error: function (args) {
                alert("Error on ajax post");
            }
        });
    });

    $("#btthem").click(function (e) {// Mở popup thêm
        $("#pp").data("kendoWindow").open();
    });

    $("#btdong").click(function (e) {//Đóng popup thêm
        temp = -1;
        $("#pp").data("kendoWindow").close();
    });

    var temp = -1;//Biên temp dùng để tránh tình trang click button đóng dữ liệu vẫn được thêm

    $("#btluu").click(function () {//temp = 0 ==> Lưu và nhập tiếp
        temp = 0;
    });

    $("#btluusc").click(function () {//tem[ = 1 ==> Lưu sao chép
        temp = 1;
    });



    $(function () {
        if (temp == -1)//temp = -1 => đã đóng popup
            return;
            testkey();
        });
    });

    function testkey() {
        var mdv = $("#ticketsForm").find("#DivisionID").val(); //lấy giá trị mã đơn vị
        var mhv = $("#ticketsForm").find("#MemberID").val();//lấy giá trị mã hôi viên
        $.getJSON("QuanLy/Testkey", { ma: mdv, ten: mhv }, function (data) { // Kiểm tra trùng khóa chính => trùng: data > 0
            if (data > 0) {
                $("#none").css("display", "inline");
            }
            else {//Không trùng thực hiện thêm
                $.ajax({
                    type: "POST",
                    url: $("#ticketsForm").attr("action"),
                    data: $("#ticketsForm").serialize(), // data =  dữ liệu đã nhập trong popup
                    success: function (data) {
                        if (temp == 0)
                            $("#ticketsForm").find(":text[name != 'Birthday']").val(null);
                        $('#grid').data('kendoGrid').dataSource.read();
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