$(document).ready(function () {
    var Param = window.location.search.substring(1).split("&");
    var StatusParam = Param[Param.length - 1].split("=")[1];

    var Level = $("#Level").val();
    var ApprovingLevel = $("#ApprovingLevel").val();
    var TranMonth = $("#TranMonth").val();
    var TranYear = $("#TranYear").val();
    var sysTranMonth = $("#SysTranMonth").val();
    var sysTranYear = $("#SysTranYear").val();
    var data = {steps:[]};
    //từ chối thì các bước còn lại màu đỏ
    var IsDeny=false;
    for (var i = 1; i <= Level; i++) {
        if (i < 10)
        {
            var PresonStatus =  $("#ApprovePerson0" + i + "Status").val();;
            var message;
            if (AsoftMessage != undefined && AsoftMessage["OOFML000013"] != undefined) {
                message = AsoftMessage["OOFML000013"]
            }
            else message = "Bước";
            
            if (PresonStatus == 0&&!IsDeny)
            {
                data.steps.push({ id: i, name: message+"0" + i, Class: "yellow" })
            }
            else if (PresonStatus == 1 && !IsDeny) {
                data.steps.push({ id: i, name: message + "0" + i, Class: "green" })
            }
            else if (PresonStatus == 2 || IsDeny)
            {
                IsDeny = true
                data.steps.push({ id: i, name: message + "0" + i, Class: "red" })
            }
        }
        else
        {
            var PresonStatus = $("#ApprovePerson" + i + "Status").val();
            if (PresonStatus == 0 && !IsDeny) {
                data.steps.push({ id: i, name: message +i, Class: "yellow" })
            }
            else if (PresonStatus == 1 && !IsDeny) {
                data.steps.push({ id: i, name: message + i, Class: "green" })
            }
            else if (PresonStatus == 2 || IsDeny) {
                IsDeny = true
                data.steps.push({ id: i, name: message + i, Class: "red" })
            }
        }
    }
    $("#OOF2002_SubTitle1-1").prepend("<div class='step-ext' id='step-viewer'></div>");
    render(data, '#step-viewer');
    //Ẩn nút sửa xóa khi không nằm trong kỳ kế toán hiện tại
    if ((TranYear * 100 + TranMonth) != (sysTranYear * 100 + sysTranMonth)) {
        $('#ViewMaster .asf-panel-master-header ').attr("ID", "disabledbutton")
    }

    //Ẩn nút sửa xóa khi dã duyệt và phải không phải là từ chối
    if (ApprovingLevel > 0 && !IsDeny) {
        $('#ViewMaster .asf-panel-master-header ').attr("ID", "disabledbutton")
        $('#viewdetail .asfbtn.asfbtn-right ').attr("ID", "disabledbutton")
        
    }

    //Ẩn nút sửa xóa khi từ màn hình duyệt qua xem chi tiết
    if (StatusParam == 1) {
        $('#ViewMaster .asf-panel-master-header ').attr("ID", "disabledbutton")
    }

    //nút delete ở grid detail
    $("#BtnDeleteDetail").unbind();
    $("#BtnDeleteDetail").kendoButton({
        "click": CustomBtnDeleteDetail_Click,
    });
});
var render = function (data, elementSelector) {
    var html = '<ul>';
    $.each(data.steps, function (index, object) {
        html += '<li id="' + object.id + '" class="'+object.Class+'" >' + object.name + '</li>';
        html += '<li class="arrow"><i class="fa fa-arrow-right"></i></li>'
    });
    html += '</ul>';

    $(elementSelector).html(html);
}

//sử lý nút delete ở grid detail 
function CustomBtnDeleteDetail_Click() {
    var urldeleteDetail = "/HRM/OOF2000/DeleteOOT2000";
    var GirdDetail = $("#Grid" + tbchild).data("kendoGrid");
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(GirdDetail);
    if (records.length == 0) return;
    var dataitem = [];
    records.forEach(function (key) {
        dataitem.push(key.APK);
    });
   
    //var APK = '';
    //var i = 0;
    //while (i < records.length) {
    //    if (records[i].APK) {
    //        APK += records[i].APK;
    //    }
    //    i++;
    //}

    var data = {
        apkList: dataitem,
        APKMaster: $("#PK").val()
    };

    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson(urldeleteDetail, data, CustomDeleteDetailSuccess);
    });
};

//khi delete 
function CustomDeleteDetailSuccess(result) {
    var formfilter = "mtf1042-viewmastercontent";
    ASOFT.helper.showErrorSeverOption(1, result, formfilter, function () {
        //Chuyển hướng hoặc refresh data
        refreshGrid(tbchild);
    }, function () { refreshGrid(tbchild); }, function () { refreshGrid(tbchild); }, true, false, formfilter);
};