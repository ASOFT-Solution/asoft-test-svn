//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     17/02/2014      Đức Quý      Tạo mới
//####################################################################

//Đóng gói các biến toàn cục => tránh tình trạng trùng biến giữa các màn hình
var MTF2010Param = new function () {

    //Biến toàn cục toàn bộ màn hình
    this.screenID = 'MTF2010';
    this.studentID = null;
    this.isClassChanged = false;
    this.classID = null;
    this.gridMaster = null;
    this.formStatus = null;
    this.isSearch = false;
    this.saveActionType = null;
    this.fromMonth = null;
    this.fromYear = null;
    this.toMonth = null;
    this.toYear = null;
    this.isDate = 1;
    this.FromDate = null;
    this.ToDate = null;
    this.FromPeriod = null;
    this.ToPeriod = null;
    this.comboNames = ['ClassID', 'CourseID',
        'StatusID', 'ReduceReasonID', 'ReturnReason',
        'Performance01', 'Performance02', 'Performance03', 'Performance04', 'Performance05', 'Performance06',
        'Result01', 'Result02', 'Result03', 'Result04', 'Result05', 'Result06', 'Result07', 'Result08', 'Result09', 'Result10', 'Result11',
        'EndPerformance01', 'EndPerformance02', 'EndPerformance03', 'EndPerformance04', 'EndPerformance05', 'EndPerformance06',
        'EndResult01', 'EndResult02', 'EndResult03', 'EndResult04', 'EndResult05', 'EndResult06', 'EndResult07', 'EndResult08', 'EndResult09', 'EndResult10', 'EndResult11'
    ];

    //Control Kendo
    this.MTF2011Popup = null;
    this.SchoolTimeFilter = null;
    this.CourseIDFilter = null;
    this.ClassIDFilter = null;
    this.LevelIDFilter = null;

    //SpinEdit giữa kỳ
    this.Listening = null;
    this.Speaking = null;
    this.Reading = null;
    this.Writing = null;
    this.MiddleTotal = null;

    //SpinEdit cuối kỳ
    this.EndListening = null;
    this.EndSpeaking = null;
    this.EndReading = null;
    this.EndWriting = null;
    this.EndTotal = null;

    //hiển thị popup
    this.showPopup = function (popup, urlContent, data) {
        ASOFT.form.clearMessageBox();
        ASOFT.asoftPopup.show(popup, urlContent, data);
    };

    //////////////////////////// Màn hình truy vấn MTF2010 ///////////////////////////
    // Grid filter
    this.filterData = function () {
        MTF2010Param.isSearch = true;
        ASOFT.form.clearMessageBox();
        if (MTF2010Param.gridMaster) {
            MTF2010Param.gridMaster.dataSource.page(1);
        }
    };

    // Grid sent filter
    this.sendFilter = function () {
        var datamaster = ASOFT.helper.dataFormToJSON('FormFilter');
        datamaster['IsSearch'] = MTF2010Param.isSearch;
        datamaster['IsDate'] = MTF2010Param.isDate;
        datamaster['FromMonth'] = MTF2010Param.fromMonth;
        datamaster['FromYear'] = MTF2010Param.fromYear;
        datamaster['ToMonth'] = MTF2010Param.toMonth;
        datamaster['ToYear'] = MTF2010Param.toYear;

        return datamaster;
    };

    // reset filter
    this.resetForm = function () {
        MTF2010Param.isSearch = false;
        MTF2010Param.isDate = 1;

        // reset form
        $('#FormFilter input[id=StudentIDFilter], input[id=StudentNameFilter],' +
            'input[id=StudentNameEFilter], input[id=AddressFilter]').val('');
        $("#rdoDate").attr("checked", "checked");
        MTF2010Param.SchoolTimeFilter.value('');
        MTF2010Param.CourseIDFilter.value('');
        MTF2010Param.ClassIDFilter.value('');
        MTF2010Param.LevelIDFilter.value('');
        MTF2010Param.FromDate.enable(true);
        MTF2010Param.ToDate.enable(true);
        MTF2010Param.FromPeriod.enable(false);
        MTF2010Param.ToPeriod.enable(false);
        MTF2010Param.fromMonth = null;
        MTF2010Param.fromYear = null;
        MTF2010Param.toMonth = null;
        MTF2010Param.toYear = null;

        ASOFT.form.clearMessageBox();
        // reload grid
        if (MTF2010Param.gridMaster) {
            MTF2010Param.gridMaster.dataSource.page(1);
        }
    };

    //Sự kiên selectedIndexChanged combo từ kì
    this.fromPeriodChange = function () {
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        // Lấy giá trị tranmonth, tranyear
        MTF2010Param.fromMonth = dataItem.TranMonth;
        MTF2010Param.fromYear = dataItem.TranYear;
    };

    //Sự kiên selectedIndexChanged combo đến kì
    this.toPeriodChange = function () {
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        // Lấy giá trị tranmonth, tranyear
        MTF2010Param.toMonth = dataItem.TranMonth;
        MTF2010Param.toYear = dataItem.TranYear;
    };

    this.courseFilter_Changed = function () {
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) {
            return;
        }

        // Call class back
        MTF2010Param.callClassBack(dataItem.CourseID, true);
    };

    // Thêm mới master
    this.doAddNewMTF2010 = function () {
        var popup = MTF2010Param.MTF2011Popup;
        MTF2010Param.formStatus = 1;

        var data = {
            FormStatus: MTF2010Param.formStatus,
            APK: null
        };

        // Show popup
        var postUrl = $('#UrlMTF2011').val();
        MTF2010Param.showPopup(popup, postUrl, data);
    };

    // Lưu sao chép
    this.doAddNewMTF2010Copy = function (savedKey) {
        var popup = MTF2010Param.MTF2011Popup;
        MTF2010Param.formStatus = 1;

        var data = {
            FormStatus: MTF2010Param.formStatus,
            APK: savedKey
        };

        // Show popup
        var postUrl = $('#UrlMTF2011').val();
        MTF2010Param.showPopup(popup, postUrl, data);
    };

    // click thêm mới master
    this.btnAddNew_Click = function () {

        // thêm mới
        MTF2010Param.doAddNewMTF2010();
    };

    //Xóa 
    this.btnDelete_Click = function () {

        var args = [];
        var data = {};

        if (MTF2010Param.gridMaster) { // Lấy danh sách các dòng đánh dấu
            var records = ASOFT.asoftGrid.selectedRecords(MTF2010Param.gridMaster, "FormFilter");
            if (records.length == 0) return;
            for (var i = 0; i < records.length; i++) {
                args.push(records[i].APK);
            }
        } else {
            // Lấy đối tượng hiện tại nếu đang ở màn hình details
            var apk = $("input[name='MTF2012APK']").val();
            args.push(apk);
        }

        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024' /*'A00ML000002'*/), function () {
            var urlDelete = $('#UrlMTF2010Delete').val();
            data['args'] = args;
            ASOFT.helper.postTypeJson(urlDelete, data, MTF2010Param.deleteSuccess);

        });
    };

    //Kết quả server trả về sau khi xóa
    this.deleteSuccess = function (result) {
        if (result) {
            var formId = null;
            var displayOnRedirecting = null;

            if (document.getElementById("FormFilter")) {
                formId = "FormFilter";
                displayOnRedirecting = false;
            } else if (document.getElementById("ViewMaster")) {
                formId = "ViewMaster";
                displayOnRedirecting = true;
            }

            // Display messages result
            ASOFT.helper.showErrorSeverOption(1, result, formId, function () {
                var redirectUrl = $('#UrlMTF2010').val();
                // Chuyển hướng hoặc refresh data
                if (redirectUrl != null) {
                    window.location.href = redirectUrl; // redirect index
                } else {
                    MTF2010Param.gridMaster.dataSource.page(1); // Refresh grid 
                }
            } /*Success*/, null /*Error*/, null /*Warning*/, true /*Show succeeded message*/, displayOnRedirecting, "FormFilter");

            // Reload grid
            if (MTF2010Param.gridMaster) {
                MTF2010Param.gridMaster.dataSource.page(1);
            }
        }

    };

    this.doEditMTF2011 = function () {
        var popup = MTF2010Param.MTF2011Popup;
        MTF2010Param.formStatus = 2;
        MTF2010Param.isClassChanged = true;

        // Lấy apk theo màn hình
        var apk = $("input[name='MTF2012APK']").val();
        var data = {
            FormStatus: MTF2010Param.formStatus,
            APK: apk
        };
        // Show popup
        var postUrl = $('#UrlMTF2011').val();

        ASOFT.helper.post($('#UrlCheckEdit').val(), { apk: apk }, function (result) {
            if (result.length == 0) {
                MTF2010Param.showPopup(popup, postUrl, data);
            }
            else {
                ASOFT.helper.showErrorSeverOption(0, result, 'ViewMaster');
            }
        });
    };

    this.btnEdit_Click = function () {
        MTF2010Param.doEditMTF2011();
    };

    // Xuất excel
    this.btnExport_Click = function () {
        var type = 1;
        if (MTF2010Param.gridMaster) {
            if ($("#chkAll").prop("checked")) {
                type = 2;
            }
            else {
                var records = ASOFT.asoftGrid.selectedRecords(MTF2010Param.gridMaster, "FormFilter");
                if (records.length == 0) {
                    return;
                }
            }
        }

        MTF2010Param.formStatus = 5;
        var data = {
            GroupID: 'G01',
            Type: type,
            FormStatus: MTF2010Param.formStatus
        };

        MTF0060.showMTF0060(data.GroupID, data.Type, data.FormStatus);
        ASOFT.helper.registerFunction('MTF2010Param.prePrintOrExport');
    };

    // In báo cáo
    this.btnPrint_Click = function () {
        var type = 1;
        if (MTF2010Param.gridMaster) {
            if ($("#chkAll").prop("checked")) {
                type = 2;
                return;
            }
            else {
                var records = ASOFT.asoftGrid.selectedRecords(MTF2010Param.gridMaster, "FormFilter");
                if (records.length == 0) {
                    return;
                }
            }
        }

        MTF2010Param.formStatus = 6;
        var data = {
            GroupID: 'G01',
            Type: type,
            FormStatus: MTF2010Param.formStatus
        };

        MTF0060.showMTF0060(data.GroupID, data.Type, data.FormStatus);
        ASOFT.helper.registerFunction('MTF2010Param.prePrintOrExport');

    };

    this.prePrintOrExport = function () {
        var args = [];
        var data = {};
        var type = 1;
        var obj = null;
        var postUrl = $('#UrlPrePrintOrExport').val();

        if (MTF2010Param.gridMaster) { // Lấy danh sách các dòng đánh dấu
            if ($("#chkAll").prop("checked")) {
                // Export dữ liệu ra excel
                postUrl = $('#UrlPreExportData').val();
                type = 2;
                obj = MTF2010Param.sendFilter();
            }
            else {
                var records = ASOFT.asoftGrid.selectedRecords(MTF2010Param.gridMaster, "FormFilter");
                for (var i = 0; i < records.length; i++) {
                    args.push(records[i].APK);
                }
            }

        } else {
            // Lấy đối tượng hiện tại nếu đang ở màn hình details
            var apk = $("input[name='MTF2012APK']").val();
            args.push(apk);
        }

        data['args'] = (type == 1) ? [args[0]] : obj;

        ASOFT.helper.postTypeJson(postUrl, data, MTF2010Param.doPrintOrExport);

    };

    this.doPrintOrExport = function (data) {
        var fullPath = null;
        var isPrint = (MTF2010Param.formStatus == 6);
        var postUrl = isPrint // màn hình in báo cáo
            ? $('#UrlMTF2012ReportViewer').val()
            : $('#UrlMTF2012ExportExcel').val();

        var viewer = isPrint ? '&viewer=pdf' : '';

        var reportData = ASOFT.helper.getObjectData();

        if (data) {
            var apk = data.apk;
            if ($("#chkAll").prop("checked")) {
                postUrl = $("#UrlExportData").val();
                fullPath = postUrl + '?id=' + apk + '&reportId=' + reportData.ReportID;
                window.location = fullPath;
                //if (isPrint) {
                //    window.open(fullPath, '_blank');
                //} else {
                //    window.location = fullPath;
                //}
            } else {
                fullPath = postUrl + '?id=' + apk + '&reportId=' + reportData.ReportID + viewer;
                if (isPrint) {
                    window.open(fullPath, '_blank');
                } else {
                    window.location = fullPath;
                }
            }

        }

    };

    this.btnSaveCopy_Click = function () {
        MTF2010Param.saveActionType = 2; // Lưu và sao chép
        MTF2010Param.saveData();
    };

    this.btnSaveNew_Click = function () {
        MTF2010Param.saveActionType = 1; // Lưu và nhập tiếp
        MTF2010Param.saveData();
    };

    this.btnSaveClose_Click = function () {
        MTF2010Param.saveActionType = 3; // Lưu và đóng
        MTF2010Param.saveData();
    };

    // Đóng màn hình MTF2011
    this.btnClose_Click = function () {
        MTF2010Param.saveActionType = 3;
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016' /*'A00ML000001'*/), MTF2010Param.saveData, function () {
            MTF2010Param.MTF2011Popup.close();
        });
    };

    this.isInvalidStudent = function () {
        var student = $('#StudentID').val();
        if (student == null || student == '') {
            var message = ASOFT.helper.getLabelText('StudentID', 'ASML000082');
            ASOFT.form.displayMessageBox('form#MTF2011', [message]);
            $('#StudentID').parent().attr("style", "border: 1px solid #ffcbcb !important;");
            return true;
        } else {
            $('#StudentID').parent().attr("style", null);
        }

        $('form#MTF2011 .asf-message').remove();
        return false;
    };

    this.saveData = function () {
        if (MTF2010Param.isInvalidStudent() || ASOFT.form.checkRequiredAndInList('MTF2011', MTF2010Param.comboNames)) {
            return;
        } else {
            //Lấy dữ liệu từ form post lên
            var data = ASOFT.helper.dataFormToJSON('MTF2011');
            data.IsChangeClass = $('#IsChangeClass').prop('checked');

            //Get control Kendo UI => disabled
            var kendoControl = ASOFT.helper.getAllKendoUI($('#MTF2011'));
            $.each(kendoControl, function () {
                var control = this;
                if ($(control.value.element).attr('data-role').indexOf('combobox') >= 0) {
                    if ($(control.value.element).prop('disabled')) {
                        data[control.name] = control.value.value();
                    }
                }
                if ($(control.value.element).attr('data-role').indexOf('numerictextbox') >= 0) {
                    if ($(control.value.element).prop('disabled')) {
                        data[control.name] = control.value.value();
                    }
                }
                if ($(control.value.element).attr('data-role').indexOf('datepicker') >= 0) {
                    if ($(control.value.element).prop('disabled')) {
                        data[control.name] = $(control.value.element).val();
                    }
                }
            });
            
            data.StudentID = $('#MTF2011StudentID').val();

            var urlUpdate = null;
            if (MTF2010Param.formStatus == 1) {
                urlUpdate = $('#UrlMTF2011Insert').val();
            }
            if (MTF2010Param.formStatus == 2) {
                urlUpdate = $('#UrlMTF2011Update').val();
            }

            //var studentId = $('#MTF2011StudentID').val();
            //data.unshift({ name: 'StudentID', value: studentId });

            ASOFT.helper.postTypeJson(urlUpdate, data, MTF2010Param.saveSuccess);
        }

    };

    this.saveSuccess = function (result) {

        ASOFT.form.updateSaveStatus("MTF2011", result.Status);
        if (result.Data && typeof (result.Data) === "object") {
            var sSector = "label[for|='{0}']".f("EduVoucherNo");
            var sName = $(sSector).html();
            result.Data = [sName, result.Data.EduVoucherNo, result.Data.VoucherNo];
        }
        ASOFT.helper.showErrorSeverOption(0 /*Save*/, result, "MTF2011", function () {
            switch (MTF2010Param.saveActionType) {
                case 1:
                    // Lưu và nhập tiếp
                    // chuyển sang thêm mới
                    MTF2010Param.doAddNewMTF2010();
                    break;
                case 2:
                    // Lưu và sao chép
                    MTF2010Param.doAddNewMTF2010Copy(result.Data);
                    break;
                default:
                    MTF2010Param.MTF2011Popup.close();
                    break;
            }

            if (MTF2010Param.gridMaster) {
                MTF2010Param.gridMaster.dataSource.page(1);
            } else {
                var data;
                var apk = $('#MTF2012APK').val();
                data = { id: apk };
                var postUrl = $('#UrlMTF2012M').val();
                ASOFT.helper.post(postUrl, data, function (html) {
                    $('#viewPartial').html(html);
                });
            }
        }, null, function (/* function for warning */) {
            var autoId = result.Data[2];
            $('#EduVoucherNo').val(autoId);
        }, true /*allow show succeeded message*/);
    };

    this.inheritSendFilter = function () {
        return {
            StudentID: $('#Shadow_StudentID').val(),
            ClassID: $('#Shadow_ClassID').val()
        };
    };

    this.checkInList = function () {
        ASOFT.form.checkItemInListFor(this, 'MTF2011');
    };

    this.courseFilter_Changed = function () {
        ASOFT.form.checkItemInListFor(this, 'MTF2011');
        var cboClassIDFilter = ASOFT.asoftComboBox.castName('ClassIDFilter');

        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) {
            return;
        }

        ASOFT.asoftComboBox.callBack(cboClassIDFilter, { CourseID: dataItem.CourseID });
        //MTF2010Param.callClassBack(dataItem.CourseID, true);
    };


    this.course_Changed = function () {
        ASOFT.form.checkItemInListFor(this, 'MTF2011');
        MTF2010Param.isClassChanged = false;

        var cboClassID = ASOFT.asoftComboBox.castName('ClassID');

        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) {
            return;
        }

        cboClassID.dataSource.read({ CourseID: dataItem.CourseID });
        cboClassID.input.val('');
        cboClassID.value(null);
        //cboClassID.selectedIndex = 0;
        //ASOFT.asoftComboBox.callBack(cboClassID, { CourseID: dataItem.CourseID });
        //MTF2010Param.callClassBack(dataItem.CourseID, false);
    };

    this.nextCourse_Changed = function () {
        ASOFT.form.checkItemInListFor(this, 'MTF2011');
        var cboNextClassID = ASOFT.asoftComboBox.castName('NextClassID');

        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) {
            return;
        }

        cboNextClassID.dataSource.read({ CourseID: dataItem.CourseID });
        //ASOFT.asoftComboBox.callBack(cboNextClassID, { CourseID: dataItem.CourseID });
        //MTF2010Param.callNextClassBack(dataItem.CourseID);
    };

    this.class_Changed = function (e) {
        ASOFT.form.checkItemInListFor(this, 'MTF2011');
        MTF2010Param.isClassChanged = true;

        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) {
            return;
        }

        // bind data to textbox
        MTF2010Param.bindBeginEnd(dataItem);
    };

    this.class_Bound = function (e) {
        ASOFT.asoftComboBox.dataBound(e);
        var dataItem = this.dataItem(this.selectedIndex);

        if (this.dataSource._total == 0) {
            this.input.val('');
            return;
        }

        // bind data to textbox
        if (!MTF2010Param.isClassChanged) {
            MTF2010Param.bindBeginEnd(dataItem);
        }
    };

    this.callClassBack = function (courseId, filter) {
        var cboClass = filter
            ? ASOFT.asoftComboBox.castName("ClassIDFilter")
            : ASOFT.asoftComboBox.castName("ClassID");

        cboClass.value(null);
        cboClass.dataSource.read({ CourseID: courseId });

        // Xóa dữ liệu nếu dataSource rỗng
        if (cboClass.dataSource._total == 0) {
            cboClass.input.val('');
        }

        cboClass.selectedIndex = 0;
    };

    this.callNextClassBack = function (courseId) {
        var cboNextClass = ASOFT.asoftComboBox.castName("NextClassID");

        cboNextClass.value(null);
        cboNextClass.dataSource.read({ CourseID: courseId });

        // Xóa dữ liệu nếu dataSource rỗng
        if (cboNextClass.dataSource._total == 0) {
            cboNextClass.input.val('');
        }

        cboNextClass.selectedIndex = 0;
    };

    // Bind begin date - end date
    this.bindBeginEnd = function (dataItem) {

        // Lấy giá trị begindate, enddate
        var beginDate = dataItem.BeginDate;
        var endDate = dataItem.EndDate;

        MTF2010Param.setDateEditValue('BeginDate', beginDate);
        MTF2010Param.setDateEditValue('EndDate', endDate);
    };

    this.setDateEditValue = function (itemName, value) {
        var dateFormated = kendo.toString(value, 'MM/dd/yyyy');
        $('#' + itemName).data('kendoDatePicker').value(dateFormated);
    };

    this.btnChoose_Click = function () {
        var objectType = 'Student';
        MTF0080.showPopup(objectType);

        ASOFT.helper.registerFunction('MTF2010Param.bindStudentInfo');
    };

    this.bindStudentInfo = function () {
        var data = ASOFT.helper.getObjectData();
        if (data) {
            $('#MTF2011StudentID').val(data.ObjectID);
            $('#StudentID').val(data.ObjectID);
            $('#StudentName').val(data.ObjectName);
        }
    };

    this.stopReason_Click = function (url) {
        MTF2020Param.formStatus = 4;
        var studentId = $('#MTF2012StudentID').val();
        var studentName = $('#MTF2012StudentName').val();
        MTF2010Param.classID = $('#MTF2012ClassID').val();
        var data = {
            FormStatus: MTF2020Param.formStatus,
            StudentID: studentId,
            StudentName: studentName,
            ClassID: MTF2010Param.classID
        };

        MTF2010Param.showPopup(MTF2020Param.MTF2021Popup, url, data);
    };

    this.nextClass_Bound = function () {
        if (this.dataSource._total == 0) {
            this.input.val('');
            return;
        }
    };

    // class filter send data
    this.classFilterSendData = function () {
        var cboCourseId = ASOFT.asoftComboBox.castName("CourseIDFilter");
        var item = cboCourseId.value();

        var data = {
            CourseID: item
        };

        return data;
    };

    // class send data
    this.classSendData = function () {
        var cboCourseId = ASOFT.asoftComboBox.castName("CourseID");
        var item = cboCourseId.value();

        var data = {
            CourseID: item
        };

        return data;
    };

    // class send data
    this.nextClassSendData = function (e) {
        var cboNextCourseId = ASOFT.asoftComboBox.castName("NextCourseID");
        var item = cboNextCourseId.value();

        var data = {
            CourseID: item
        };

        return data;
    };

    //Tính tổng điểm kỹ năng
    this.countEndTotal = function () {
        var listen = MTF2010Param.EndListening.value();
        var speak = MTF2010Param.EndSpeaking.value();
        var read = MTF2010Param.EndReading.value();
        var write = MTF2010Param.EndWriting.value();
        var total = listen + speak + read + write;

        MTF2010Param.EndTotal.value(total);
    };

    //Tính tổng điểm kỹ năng
    this.countMiddleTotal = function () {
        var listen = MTF2010Param.Listening.value();
        var speak = MTF2010Param.Speaking.value();
        var read = MTF2010Param.Reading.value();
        var write = MTF2010Param.Writing.value();
        var total = listen + speak + read + write;

        MTF2010Param.MiddleTotal.value(total);
    };
};

$(document).ready(function () {
    ASOFT.form.setSameHeight('asf-filter-content-block');
    ASOFT.form.setSameWidth('asf-filter-content-block');
    MTF2010Param.gridMaster = $('#MTF2010GridMaster').data('kendoGrid');
    MTF2010Param.MTF2011Popup = ASOFT.asoftPopup.castName('MTF2011Popup');
    //MTF2021Popup = ASOFT.asoftPopup.castName('MTF2021Popup');
    MTF2010Param.FromPeriod = ASOFT.asoftComboBox.castName('FromPeriod');
    MTF2010Param.ToPeriod = ASOFT.asoftComboBox.castName('ToPeriod');
    MTF2010Param.FromDate = ASOFT.asoftDateEdit.castName('FromDate');
    MTF2010Param.ToDate = ASOFT.asoftDateEdit.castName('ToDate');
    MTF2010Param.SchoolTimeFilter = ASOFT.asoftComboBox.castName('SchoolTimeIDFilter');
    MTF2010Param.CourseIDFilter = ASOFT.asoftComboBox.castName('CourseIDFilter');
    MTF2010Param.ClassIDFilter = ASOFT.asoftComboBox.castName('ClassIDFilter');
    MTF2010Param.LevelIDFilter = ASOFT.asoftComboBox.castName('LevelIDFilter');

    // Display message from cache
    ASOFT.helper.showErrorSeverOptionFromRedirecting();
    
    //Sự kiện cho radio button kì kế toán và ngày
    $('form#FormFilter #rdoPeriod').change(function () {
        if ($(this).prop('checked')) {
            MTF2010Param.isDate = 0;
            MTF2010Param.FromPeriod.enable(true);
            MTF2010Param.ToPeriod.enable(true);
            MTF2010Param.FromDate.enable(false);
            MTF2010Param.ToDate.enable(false);

            //Lấy TranMonth, TranYear từ combo từ kỳ đến kỳ
            MTF2010Param.FromPeriod.refresh();
            MTF2010Param.ToPeriod.refresh();

            var dataItemFromPeriod = MTF2010Param.FromPeriod.dataItem(MTF2010Param.FromPeriod.selectedIndex);
            var dataItemToPeriod = MTF2010Param.ToPeriod.dataItem(MTF2010Param.ToPeriod.selectedIndex);

            if (dataItemFromPeriod && dataItemToPeriod) {
                MTF2010Param.fromMonth = dataItemFromPeriod.TranMonth;
                MTF2010Param.fromYear = dataItemFromPeriod.TranYear;
                MTF2010Param.toMonth = dataItemToPeriod.TranMonth;
                MTF2010Param.toYear = dataItemToPeriod.TranYear;
            }
        }
    });

    $('form#FormFilter #rdoDate').change(function () {
        if ($(this).prop('checked')) {
            MTF2010Param.isDate = 1;
            MTF2010Param.FromPeriod.enable(false);
            MTF2010Param.ToPeriod.enable(false);
            MTF2010Param.FromDate.enable(true);
            MTF2010Param.ToDate.enable(true);
        }
    });

    //Bắt sự kiện khi popup đã hiện lên tất cả nội dung
    MTF2010Param.MTF2011Popup.bind("refresh", function () {

        ASOFT.asoftDateEdit.castName('ReturnDate').value(null);

        //SpinEdit theo kĩ năng
        MTF2010Param.Listening = ASOFT.asoftSpinEdit.castName("Listening");
        MTF2010Param.Speaking = ASOFT.asoftSpinEdit.castName("Speaking");
        MTF2010Param.Reading = ASOFT.asoftSpinEdit.castName("Reading");
        MTF2010Param.Writing = ASOFT.asoftSpinEdit.castName("Writing");
        MTF2010Param.MiddleTotal = ASOFT.asoftSpinEdit.castName("MiddleTotal");

        //SpinEdit theo phần thi
        MTF2010Param.EndListening = ASOFT.asoftSpinEdit.castName("EndListening");
        MTF2010Param.EndSpeaking = ASOFT.asoftSpinEdit.castName("EndSpeaking");
        MTF2010Param.EndReading = ASOFT.asoftSpinEdit.castName("EndReading");
        MTF2010Param.EndWriting = ASOFT.asoftSpinEdit.castName("EndWriting");
        MTF2010Param.EndTotal = ASOFT.asoftSpinEdit.castName("EndTotal");
    });
});

$(window).resize(function () {
    if (MTF2010Param.gridMaster) { // Resize grid master
        ASOFT.asoftGrid.setHeight(MTF2010Param.gridMaster);
    }
});
