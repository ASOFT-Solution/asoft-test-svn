//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     17/02/2014      Đức Quý      Tạo mới
//####################################################################

//var gridMaster = null;
//var MTF2021Popup = null;
//var formStatus = null;
//var isSearch = null;
//var saveActionType = null;
//var isDate = 1;
//var studentID = null;
//var fromMonth, fromYear, toMonth, toYear = null;
//var FromDate, ToDate, FromPeriod, ToPeriod = null;

//Khai báo biến toàn cục
var MTF2020Param = new function() {
    this.gridMaster = null;
    this.MTF2021Popup = null;
    this.formStatus = null;
    this.isSearch = false;
    this.saveActionType = null;
    this.isDate = 1;
    this.studentID = null;
    this.fromMonth = null;
    this.fromYear = null;
    this.toMonth = null;
    this.toYear = null;
    this.FromDate = null;
    this.ToDate = null;
    this.FromPeriod = null;
    this.ToPeriod = null;

    //hiển thị popup
    this.showPopup = function (popup, urlContent, data) {
        ASOFT.form.clearMessageBox();
        ASOFT.asoftPopup.show(popup, urlContent, data);
    };

    //Sự kiên selectedIndexChanged combo từ kì
    this.fromPeriodChange = function() {
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        // Lấy giá trị tranmonth, tranyear
        MTF2020Param.fromMonth = dataItem.TranMonth;
        MTF2020Param.fromYear = dataItem.TranYear;
    };

    //Sự kiên selectedIndexChanged combo đến kì
    this.toPeriodChange = function() {
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        // Lấy giá trị tranmonth, tranyear
        MTF2020Param.toMonth = dataItem.TranMonth;
        MTF2020Param.toYear = dataItem.TranYear;
    };
    
    // Grid filter
    this.filterData = function() {
        MTF2020Param.isSearch = true;
        ASOFT.form.clearMessageBox();
        if (MTF2020Param.gridMaster) {
            MTF2020Param.gridMaster.dataSource.page(1);
        }
    };

    // Grid sent filter
    this.sentFilter = function() {
        var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
        datamaster['IsSearch'] = MTF2020Param.isSearch;
        datamaster['IsDate'] = MTF2020Param.isDate;
        datamaster['FromMonth'] = MTF2020Param.fromMonth;
        datamaster['FromYear'] = MTF2020Param.fromYear;
        datamaster['ToMonth'] = MTF2020Param.toMonth;
        datamaster['ToYear'] = MTF2020Param.toYear;

        return datamaster;
    };

    // reset filter
    this.resetForm = function() {
        MTF2020Param.isSearch = false;
        MTF2020Param.isDate = 1;

        // reset form
        $('#FormFilter input[id=StudentIDFilter], input[id=StudentNameFilter]').val('');
        $("#rdoDate").attr("checked", "checked");
        StopReasonIDFilter.value('');
        MTF2020Param.FromDate.enable(true);
        MTF2020Param.ToDate.enable(true);
        MTF2020Param.FromPeriod.enable(false);
        MTF2020Param.ToPeriod.enable(false);
        MTF2020Param.fromMonth = null;
        MTF2020Param.fromYear = null;
        MTF2020Param.toMonth = null;
        MTF2020Param.toYear = null;

        ASOFT.form.clearMessageBox();
        
        // reload grid
        if (MTF2020Param.gridMaster) {
            MTF2020Param.gridMaster.dataSource.page(1);
        }
    };

    
    // Xuất dữ liệu excel
    this.btnExportMaster_Click = function () {
        var data = { };
        var args = MTF2020Param.sentFilter();
        var postUrl = $("#UrlPreExportData").val();
        data['args'] = args;
        
        ASOFT.helper.postTypeJson(postUrl, data, MTF2020Param.preExportSuccess);
    };

    // Export action
    this.preExportSuccess = function(data) {
        if(data) {
            var key = data.apk;
            var reportId = "MTR2029";
            var postUrl = $("#UrlExportData").val();
            
            var fullPath = postUrl + '?id=' + key + '&reportId=' + reportId;
            window.location = fullPath;
        }
    };
    
    this.btnDeleteMaster_Click = function() {

        var args = [];
        var data = { };

        if (MTF2020Param.gridMaster) { // Lấy danh sách các dòng đánh dấu
            var records = ASOFT.asoftGrid.selectedRecords(MTF2020Param.gridMaster, "FormFilter");
            if (records.length == 0) return;
            for (var i = 0; i < records.length; i++) {
                args.push(records[i].APK);
            }
        } else {
            // Lấy đối tượng hiện tại nếu đang ở màn hình details
            var apk = $('input[name="MTF2022APK"]').val();
            args.push(apk);
        }

        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024' /*'A00ML000002'*/), function() {
            var urlDelete = $('#UrlMTF2020Delete').val();
            data['args'] = args;
            ASOFT.helper.postTypeJson(urlDelete, data, MTF2020Param.deleteSuccess);

        });
    };

    //Kết quả server trả về sau khi xóa
    this.deleteSuccess = function (result) {
        var formId = null;
        var displayOnRedirecting = null;

        if (document.getElementById("FormFilter")) {
            formId = "FormFilter";
            displayOnRedirecting = false;
        } else if (document.getElementById("ViewMaster")) {
            formId = "ViewMaster";
            displayOnRedirecting = true;
        }
        ASOFT.helper.showErrorSeverOption(1, result, formId, function() {
            var redirectUrl = $('#UrlMTF2020').val();
            // Chuyển hướng hoặc refresh data
            if (redirectUrl != null) {
                window.location.href = redirectUrl; // redirect index
            } else {
                MTF2020Param.gridMaster.dataSource.page(1); // Refresh grid 
            }
        }/*Success*/, null /*Error*/, null /*Warning*/, true /*Show succeeded message*/, displayOnRedirecting, "FormFilter");
        
        if (MTF2020Param.gridMaster) {
            MTF2020Param.gridMaster.dataSource.page(1);
        }
    };
    
    this.doAddNewMaster = function() {
        var popup = MTF2020Param.MTF2021Popup;
        MTF2020Param.formStatus = 1;
        var postUrl = $('#UrlMTF2021').val();
        var data = {
            FormStatus: MTF2020Param.formStatus,
            APK: null
        };
        MTF2020Param.showPopup(popup, postUrl, data);
    };
    
    this.doAddNewMasterCopy = function (savedKey) {
        var popup = MTF2020Param.MTF2021Popup;
        var postUrl = $('#UrlMTF2021').val();
        MTF2020Param.formStatus = 1;
        var data = {
            FormStatus: MTF2020Param.formStatus,
            APK: savedKey
        };
        MTF2020Param.showPopup(popup, postUrl, data);
    };

    this.doEditMaster = function() {
        var popup = MTF2020Param.MTF2021Popup;
        var postUrl = $('#UrlMTF2021').val();
        MTF2020Param.formStatus = 2;
        var apk = $("#MTF2022APK").val();
        var data = {
            FormStatus: MTF2020Param.formStatus,
            APK: apk
        };
        MTF2020Param.showPopup(popup, postUrl, data);
    };
    
    this.btnAddNewMaster_Click = function() {
        MTF2020Param.doAddNewMaster();
    };

    this.btnEditMaster_Click = function() {
        MTF2020Param.doEditMaster();
    };

    this.btnChoose_Click = function() {
        var objectType = "Student";
        MTF0080.showPopup(objectType);

        ASOFT.helper.registerFunction("MTF2020Param.bindStudentInfo");
    };

    this.bindStudentInfo = function() {
        var data = ASOFT.helper.getObjectData();
        if (data) {
            $("#MTF2011StudentID").val(data.ObjectID);
            $("#StudentID").val(data.ObjectID);
            $("#StudentName").val(data.ObjectName);

            MTF2020Param.studentID = data.ObjectID;
            MTF2020Param.filterClass();
        }
    };

    this.class_PostData = function() {
        return {
            StudentID: $("#StudentID").val()
        };
    };
    
    this.filterClass = function() {
        var cboClass = ASOFT.asoftComboBox.castName("ClassID");
        cboClass.value(null);
        cboClass.dataSource.read({ StudentID: MTF2020Param.studentID });
        cboClass.selectedIndex = 0;
    };

    this.btnSaveCopy_Click = function() {
        MTF2020Param.saveActionType = 2; // Lưu và sao chép
        MTF2020Param.saveData();
    };

    this.btnSaveNext_Click = function() {
        MTF2020Param.saveActionType = 1; // Lưu và nhập tiếp
        MTF2020Param.saveData();
    };

    this.btnSaveClose_Click = function() {
        MTF2020Param.saveActionType = 3; // Lưu và đóng
        MTF2020Param.saveData();
    };

    this.btnSave_Click = function() {
        MTF2020Param.saveActionType = 3; // Lưu và đóng
        MTF2020Param.saveData();
    };

    this.checkInList = function() {
        ASOFT.form.checkItemInListFor(this, "MTF2021");
    };

    this.btnClose_Click = function() {
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016' /*'A00ML000001'*/), MTF2020Param.btnSave_Click, function() {
            MTF2020Param.MTF2021Popup.close();
        });
    };

    this.isInvalidStudent = function() {
        var student = $("#StudentID").val();
        if (student == null || student == "") {
            var message = ASOFT.helper.getLabelText("StudentID", "ASML000082");
            ASOFT.form.displayMessageBox("form#MTF2021", [message]);
            $('#StudentID').parent().attr("style", "border: 1px solid #ffcbcb !important;");
            return true;
        } else {
            $('#StudentID').parent().attr("style", null);
        }

        $("form#MTF2021 .asf-message").remove();
        return false;
    };

    this.saveData = function() {
        if (MTF2020Param.isInvalidStudent() || ASOFT.form.checkRequiredAndInList("MTF2021", ["ClassID", "StopReasonID"])) {
            return;
        }

        //Lấy dữ liệu từ form post lên
        var data = ASOFT.helper.getFormData(null, "MTF2021");

        var urlUpdate = null;
        if (MTF2020Param.formStatus == 1) {
            urlUpdate = $('#UrlMTF2021Insert').val();
            data.unshift({ name: "APK", value: $('#MTF2021APK').val() });
        }
        if (MTF2020Param.formStatus == 4) {
            if (MTF2010Param !== undefined) { //Trường hợp gọi từ màn hình quá trình học tập
                urlUpdate = '/MT/MTF2020/DoInsert';
                data.unshift({ name: 'ClassID', value: MTF2010Param.classID });
            }
        }
        if (MTF2020Param.formStatus == 2) {
            urlUpdate = $('#UrlMTF2021Update').val();
            var studentId = $('#MTF2021StudentID').val();
            var classId = $('#MTF2021ClassID').val();
            var apk = $('#MTF2022APK').val();

            data.unshift({ name: "StudentID", value: studentId });
            data.unshift({ name: "ClassID", value: classId });
            data.unshift({ name: "APK", value: apk });
        }

        ASOFT.helper.post(urlUpdate, data, MTF2020Param.saveSuccess);
    };
    
    this.saveSuccess = function (result) {
        // Lưu tình trạng
        ASOFT.form.updateSaveStatus('MTF2021', result.Status);

        if (result.Data && typeof (result.Data) === "object") { // override object
            var sSector = "label[for|='{0}']".f("StopVoucherNo");
            var sName = $(sSector).html();
            result.Data = [sName, result.Data.StopVoucherNo, result.Data.VoucherNo];
        }

        ASOFT.helper.showErrorSeverOption(0, result, "MTF2021", function() {
            switch (MTF2020Param.saveActionType) {
            case 1:
                // Lưu và nhập tiếp
                    // chuyển sang thêm mới
                MTF2020Param.doAddNewMaster();
                break;
            case 2:
                // Lưu và sao chép
                    // chuyển trạng thái sang thêm mới
                    // lưu lại các giá trị cũ
                MTF2020Param.doAddNewMasterCopy(result.Data);
                break;
            default:
                MTF2020Param.MTF2021Popup.close();
                break;
            }

            if (MTF2020Param.gridMaster) {
                MTF2020Param.gridMaster.dataSource.page(1);
            } else {
                if (typeof MTF2010Param !== 'undefined') { //Trường hợp gọi từ màn hình quá trình học tập, load lại màn hình chi tiết quá trình học tập
                    window.location.reload(true);
                    return;
                }

                var data;
                var apk = $('#MTF2022APK').val();
                data = { id: apk };
                var postUrl = $('#UrlMTF2022M').val();
                ASOFT.helper.post(postUrl, data, function(html) {
                    $('#viewPartial').html(html);
                });
            }
        }, null, function (/* function for warning */) {
            var autoId = result.Data[2];
            $('#StopVoucherNo').val(autoId);
        }, true /*allow show succeeded message*/);
    };

    this.btnPrintMaster_Click = function() {
    };

    this.btnExportDetails_Click = function() {
    };

    this.btnPrintDetails_Click = function() {
    };
};

$(document).ready(function() {
    MTF2020Param.gridMaster = $("#MTF2020GridMaster").data("kendoGrid");
    MTF2020Param.MTF2021Popup = ASOFT.asoftPopup.castName("MTF2021Popup");
    MTF2020Param.FromPeriod = ASOFT.asoftComboBox.castName("FromPeriod");
    MTF2020Param.ToPeriod = ASOFT.asoftComboBox.castName("ToPeriod");
    MTF2020Param.FromDate = ASOFT.asoftDateEdit.castName("FromDate");
    MTF2020Param.ToDate = ASOFT.asoftDateEdit.castName("ToDate");
    StopReasonIDFilter = ASOFT.asoftComboBox.castName("StopReasonIDFilter");

    // Display message from cache
    ASOFT.helper.showErrorSeverOptionFromRedirecting();

    $(window).resize(function () {
        if (MTF2020Param.gridMaster) { // Resize grid master
            ASOFT.asoftGrid.setHeight(MTF2020Param.gridMaster);
        }
    });
    
    //Sự kiện cho radio button kì kế toán và ngày
    $("form#FormFilter #rdoPeriod").change(function () {
        if ($(this).prop('checked')) {
            MTF2020Param.isDate = 0;
            MTF2020Param.FromPeriod.enable(true);
            MTF2020Param.ToPeriod.enable(true);
            MTF2020Param.FromDate.enable(false);
            MTF2020Param.ToDate.enable(false);

            //Lấy TranMonth, TranYear từ combo từ kỳ đến kỳ
            MTF2020Param.FromPeriod.refresh();
            MTF2020Param.ToPeriod.refresh();

            var dataItemFromPeriod = MTF2020Param.FromPeriod.dataItem(MTF2020Param.FromPeriod.selectedIndex);
            var dataItemToPeriod = MTF2020Param.ToPeriod.dataItem(MTF2020Param.ToPeriod.selectedIndex);

            if (dataItemFromPeriod && dataItemToPeriod) {
                MTF2020Param.fromMonth = dataItemFromPeriod.TranMonth;
                MTF2020Param.fromYear = dataItemFromPeriod.TranYear;
                MTF2020Param.toMonth = dataItemToPeriod.TranMonth;
                MTF2020Param.toYear = dataItemToPeriod.TranYear;
            }
        }
    });

    $("form#FormFilter #rdoDate").change(function () {
        if ($(this).prop('checked')) {
            MTF2020Param.isDate = 1;
            MTF2020Param.FromPeriod.enable(false);
            MTF2020Param.ToPeriod.enable(false);
            MTF2020Param.FromDate.enable(true);
            MTF2020Param.ToDate.enable(true);
        }
    });
});

