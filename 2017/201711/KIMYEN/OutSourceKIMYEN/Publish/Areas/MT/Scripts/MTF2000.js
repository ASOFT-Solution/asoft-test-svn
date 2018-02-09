//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     17/02/2014      Đức Quý         Tạo mới
//#     02/04/2014      Trí Thiện       Format code JS to namespace function
//####################################################################

$(document).ready(function () {
    //Set auto width for form filter
    MTF2000.MTF2001Popup = ASOFT.asoftPopup.castName("MTF2001Popup");
    MTF2000.MTF2000Grid = ASOFT.asoftGrid.castName("MTF2000Grid");
    MTF2000.FromPeriod = ASOFT.asoftComboBox.castName("FromPeriod");
    MTF2000.ToPeriod = ASOFT.asoftComboBox.castName("ToPeriod");
    MTF2000.FromDate = ASOFT.asoftDateEdit.castName("FromDate");
    MTF2000.ToDate = ASOFT.asoftDateEdit.castName("ToDate");

    // Display message from cache
    ASOFT.helper.showErrorSeverOptionFromRedirecting();

    //Sự kiện cho radio button kì kế toán và ngày
    $("form#FormFilter #rdoPeriod").change(function () {
        if ($(this).prop('checked')) {
            MTF2000.isDate = 0;
            MTF2000.FromPeriod.enable(true);
            MTF2000.ToPeriod.enable(true);
            MTF2000.FromDate.enable(false);
            MTF2000.ToDate.enable(false);

            //Lấy TranMonth, TranYear từ combo từ kỳ đến kỳ
            MTF2000.FromPeriod.refresh();
            MTF2000.ToPeriod.refresh();
            var dataItemFromPeriod = MTF2000.FromPeriod.dataItem(MTF2000.FromPeriod.selectedIndex);
            var dataItemToPeriod = MTF2000.ToPeriod.dataItem(MTF2000.ToPeriod.selectedIndex);

            if (dataItemFromPeriod && dataItemToPeriod) {
                MTF2000.fromMonth = dataItemFromPeriod.TranMonth;
                MTF2000.fromYear = dataItemFromPeriod.TranYear;
                MTF2000.toMonth = dataItemToPeriod.TranMonth;
                MTF2000.toYear = dataItemToPeriod.TranYear;
            }
        }
    });

    $("form#FormFilter #rdoDate").change(function () {
        if ($(this).prop('checked')) {

            MTF2000.isDate = 1;
            MTF2000.FromPeriod.enable(false);
            MTF2000.ToPeriod.enable(false);
            MTF2000.FromDate.enable(true);
            MTF2000.ToDate.enable(true);
        }
    });

    //Bắt sự kiện khi popup đã hiện lên tất cả nội dung
    MTF2000.MTF2001Popup.bind("refresh", function () {
        $("#StudentID").bind('keypress', ASOFTTextBox.escapeSpecialCharacter);

        //SpinEdit theo kĩ năng
        MTF2000.Listening = ASOFT.asoftSpinEdit.castName("Listening");
        MTF2000.Speaking = ASOFT.asoftSpinEdit.castName("Speaking");
        MTF2000.Reading = ASOFT.asoftSpinEdit.castName("Reading");
        MTF2000.Writing = ASOFT.asoftSpinEdit.castName("Writing");
        MTF2000.Total = ASOFT.asoftSpinEdit.castName("Total");

        //SpinEdit theo phần thi
        MTF2000.Part1 = ASOFT.asoftSpinEdit.castName("Part1");
        MTF2000.Part2 = ASOFT.asoftSpinEdit.castName("Part2");
        MTF2000.Part3 = ASOFT.asoftSpinEdit.castName("Part3");
        MTF2000.Part4 = ASOFT.asoftSpinEdit.castName("Part4");
        MTF2000.PartTotal = ASOFT.asoftSpinEdit.castName("PartTotal");
    });
});

$(window).resize(function () {
    if (MTF2000.MTF2000Grid) {
        ASOFT.asoftGrid.setHeight(MTF2000.MTF2000Grid);
    }
})

MTF2000 = new function() {

    // Properties
    this.isValid = false;
    this.isSearch = false;
    this.isDate = 1;
    this.saveType = 1;
    this.formStatus = 1;
    this.urlUpdate = null;
    this.fromMonth = null;
    this.fromYear = null;
    this.toMonth = null;
    this.toYear = null;

    this.MTF2001Popup = null;
    this.MTF2000Grid = null;
    this.FromPeriod = null;
    this.ToPeriod = null;
    this.FromDate = null;
    this.ToDate = null;
    
    //SpinEdit theo kĩ năng
    this.Listening = null;
    this.Speaking = null;
    this.Reading = null;
    this.Writing = null;
    this.Total = null;

    //SpinEdit theo phần thi
    this.Part1 = null;
    this.Part2 = null;
    this.Part3 = null;
    this.Part4 = null;
    this.PartTotal = null;
    
    // Save previous prefix
    this.previousPrefix = null;
    
    //Sự kiên selectedIndexChanged combo từ kì
    this.fromPeriodChange = function(e) {
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        // Lấy giá trị tranmonth, tranyear
        MTF2000.fromMonth = dataItem.TranMonth;
        MTF2000.fromYear = dataItem.TranYear;
    };

    //Sự kiên selectedIndexChanged combo đến kì
    this.toPeriodChange = function(e) {
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        // Lấy giá trị tranmonth, tranyear
        MTF2000.toMonth = dataItem.TranMonth;
        MTF2000.toYear = dataItem.TranYear;
    };

    //Sự kiên data bound combo từ kì
    this.fromPeriodDataBound = function (e) {
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        // Lấy giá trị tranmonth, tranyear
        MTF2000.fromMonth = dataItem.TranMonth;
        MTF2000.fromYear = dataItem.TranYear;
    };

    //Sự kiên data bound combo đến kì
    this.toPeriodDataBound = function (e) {
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        // Lấy giá trị tranmonth, tranyear
        MTF2000.toMonth = dataItem.TranMonth;
        MTF2000.toYear = dataItem.TranYear;
    };

    //hiển thị popup
    this.showPopup = function (popup, urlContent, data) {
        ASOFT.form.clearMessageBox();
        ASOFT.asoftPopup.show(popup, urlContent, data);
    };
    
    //=============================================================================
    // Màn hình quản lí học viên - MTF2000
    //=============================================================================

    //Lọc dữ liệu
    this.filterData = function() {
        MTF2000.isSearch = true;
        MTF2000.MTF2000Grid.dataSource.page(1);
    };

    //Load lại toàn bộ lưới
    this.btnClearFilter = function() {
        //var newDate = kendo.toString(new Date(), 'dd/MM/yyyy');
        $('#FormFilter input[id=StudentIDFilter], input[id=StudentNameFilter],' +
            'input[id=StudentNameEFilter], input[id=AddressFilter]').val('');
        $("#rdoDate").attr("checked", "checked");

        MTF2000.isSearch = false;
        MTF2000.isDate = 1;
        
        MTF2000.FromDate.enable(true);
        MTF2000.ToDate.enable(true);
        MTF2000.FromPeriod.enable(false);
        MTF2000.ToPeriod.enable(false);

        MTF2000.fromMonth = null;
        MTF2000.fromYear = null;
        MTF2000.toMonth = null;
        MTF2000.toYear = null;

        MTF2000.MTF2000Grid.dataSource.page(1);
    };

    // Xuất dữ liệu excel
    this.btnExport_Click = function () {
        var data = {};
        var reportId = "MTR2009";
        var args = MTF2000.sendData();
        var postUrl = $("#UrlExportData").val();
        //data['args'] = args;
        args['ReportID'] = reportId;
        
        var fullPath = postUrl + '?reportId=' + reportId + '&args=' + data;
        url = ASOFT.helper.renderUrl(postUrl, args);
        window.location = url;
        //ASOFT.helper.postTypeJson(postUrl, data, MTF2000.preExportSuccess);
    };

    // Export action
    this.preExportSuccess = function(data) {
        if(data) {
            var key = data.apk;
            var reportId = "MTR2009";
            var postUrl = $("#UrlExportData").val();
            
            var fullPath = postUrl + '?id=' + key + '&reportId=' + reportId;
            window.location = fullPath;
        }
    };

    //Xóa học viên
    this.deleted = function() {
        var urlDelete = $('#UrlDelete').val();
        var args = [];
        var data = { };
        if (MTF2000.MTF2000Grid) { // Lấy danh sách các dòng đánh dấu
            var records = ASOFT.asoftGrid.selectedRecords(MTF2000.MTF2000Grid, 'FormFilter');
            if (records.length == 0) return;
            for (var i = 0; i < records.length; i++) {
                args.push(records[i].StudentID);
            }
        } else {
            // Lấy đối tượng hiện tại nếu đang ở màn hình details
            var studentId = $('#student').val();
            args.push(studentId);
        }

        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024' /*'A00ML000002'*/), function() {
            data['args'] = args;
            ASOFT.helper.postTypeJson(urlDelete, data, MTF2000.deleteSuccess);
        });
    };

    //Kết quả server trả về sau khi xóa
    this.deleteSuccess = function (result) {
        var formId = null;
        //var displayOnRedirecting = null;
        
        if (document.getElementById("FormFilter")) {
            formId = "FormFilter";
            //displayOnRedirecting = false;
        } else if (document.getElementById("ViewMaster")) {
            formId = "ViewMaster";
            //displayOnRedirecting = true;
        }
        
        ASOFT.helper.showErrorSeverOption(1, result, formId, function () {
            if (!MTF2000.MTF2000Grid) {
                window.location.href = $('#UrlMTF2000').val();
            } else {
                MTF2000.MTF2000Grid.dataSource.page(1);
            }
        }, null, null, true);//, null, null, true, displayOnRedirecting, "FormFilter"); // Display succeeded message on redirecting
       
        if (MTF2000.MTF2000Grid) {
            MTF2000.MTF2000Grid.dataSource.page(1);
        }
    };

    //Load dữ liệu khi lưới callback
    this.sendData = function() {
        var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");

        datamaster['IsSearch'] = MTF2000.isSearch;
        datamaster['IsDate'] = MTF2000.isDate;
        datamaster['FromMonth'] = MTF2000.fromMonth;
        datamaster['FromYear'] = MTF2000.fromYear;
        datamaster['ToMonth'] = MTF2000.toMonth;
        datamaster['ToYear'] = MTF2000.toYear;
        return datamaster;
    };

    //=============================================================================
    // Màn hình cập nhật học viên - MTF2001
    //=============================================================================
    // check in list combobox
    this.sourceChange = function() {
        ASOFT.form.checkItemInListFor(this, "MTF2001");
    };

    // Filter S
    this.s_PostData = function () {
        return {
            FromS: 'H1',
            ToS: 'H9'
        };
    };

    // Combobox phân loại changed
    this.s_Changed = function() {
        ASOFT.form.checkItemInListFor(this, "MTF2001");

        var dataItem = this.dataItem(this.selectedIndex);
        if (dataItem == null) {
            MTF2000.previousPrefix = null;
            return;
        }

        // Append contents
        var prefix = dataItem.S;
        var input = $('input#StudentID');
        if (input.val() == null || input.val() == "") {
            input.val(prefix);
        } else {
            input.val(input.val().replace(MTF2000.previousPrefix, prefix));
        }

        // Save prefix
        MTF2000.previousPrefix = prefix;

        // bind prefix
        MTF2000.bindPrefixClass(prefix);
    };

    // add prefix to textbox class
    this.bindPrefixClass = function(prefix) {
        var input = $('input#StudentID');

        // update events blur to check input
        input.unbind("blur");
        input.blur(function() {
            // Check match prefix
            if (!(this.value.match('^' + prefix))) {
                this.value = prefix + this.value;
            }
        });
    };
    
    //Thêm mới
    this.addNew = function() {
        MTF2000.formStatus = 1;
        //data.push({ name: "List", value: MTF2000Grid.dataSource.data() });

        var data = { FormStatus: MTF2000.formStatus };
        MTF2000.urlUpdate = $('#UrlInsert').val();
        var postUrl = $('#UrlMTF2001').val();
        MTF2000.showPopup(MTF2000.MTF2001Popup, postUrl, data);
    };

    // Thêm mơi và sao chép
    this.addNewCopy = function(savedKey) {
        MTF2000.formStatus = 1;

        var data = {
            FormStatus: MTF2000.formStatus,
            StudentID: savedKey
        };
        MTF2000.urlUpdate = $('#UrlInsert').val();
        var postUrl = $('#UrlMTF2001').val();
        MTF2000.showPopup(MTF2000.MTF2001Popup, postUrl, data);
    };
    
    //Sửa master
    this.edit = function() {
        MTF2000.urlUpdate = $('#UrlUpdate').val();
        MTF2000.formStatus = 2;
        var postUrl = $('#UrlMTF2001').val();
        var studentId = $('#student').val();
        var data = {
            FormStatus: MTF2000.formStatus,
            StudentID: studentId
        };

        ASOFT.helper.post($('#UrlCheckEdit').val(), { studentID: studentId }, function (result) {
            if (result.length == 0) {
                MTF2000.showPopup(MTF2000.MTF2001Popup, postUrl, data);
            }
            else {
                ASOFT.helper.showErrorSeverOption(0, result, 'ViewMaster', function () {});
            }
        });
    };
    
    //Lấy dữ liệu từ form
    this.postDataMTF2001 = function() {
        //Lấy dữ liệu từ form post lên
        var data = ASOFT.helper.dataFormToJSON("MTF2001");
        var cboSClassify = ASOFT.asoftComboBox.castName("S");
        if (cboSClassify) {
            data.S = cboSClassify.value();
            //data.unshift({ name: "S", value: cboSClassify.value() });
        }

        return data;
    };
    
    //Tính tổng điểm kỹ năng
    this.countTotalSkill = function() {
        var listen = MTF2000.Listening.value();
        var speak = MTF2000.Speaking.value();
        var read = MTF2000.Reading.value();
        var write = MTF2000.Writing.value();
        var total = listen + speak + read + write;

        MTF2000.Total.value(total);
    };

    //Tính tổng điểm kỹ năng
    this.countTotalNotSkill = function() {
        var part1 = MTF2000.Part1.value();
        var part2 = MTF2000.Part2.value();
        var part3 = MTF2000.Part3.value();
        var part4 = MTF2000.Part4.value();
        var total = part1 + part2 + part3 + part4;

        MTF2000.PartTotal.value(total);
    };

    //Lưu dữ liệu
    this.saveData = function() {
        if (ASOFT.form.checkRequiredAndInList("MTF2001", ["Source1", "Source2", "Source3"])) {
            MTF2000.isValid = false;
            return;
        }

        MTF2000.isValid = true;
        var data = MTF2000.postDataMTF2001();

        //Get control Kendo UI => disabled
        var kendoControl = ASOFT.helper.getAllKendoUI($('#MTF2001'));
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

        ASOFT.helper.postTypeJson(MTF2000.urlUpdate, data, MTF2000.saveSuccess);
        //var data = ASOFT.helper.dataFormToJSON("List", "MTF2001", MTF2000Grid);
        //ASOFT.helper.postTypeJson(urlUpdate, data, saveSuccess);
    };

    //Lưu và nhập tiếp
    this.mtf2001BtnSaveClick = function() {
        MTF2000.saveType = 1;
        MTF2000.saveData();
    };

    //Lưu và sao chép
    this.mtf2001BtnSaveMDClick = function() {
        MTF2000.saveType = 2;
        MTF2000.saveData();
    };

    //Lưu và đóng
    this.mtf2001BtnSavecloseClick = function() {
        MTF2000.saveType = 3;
        MTF2000.saveData();
    };
    
    //Server trả về kết quả cho trường hợp lưu và nhập tiếp
    this.saveSuccess = function(result) {

        // Update status
        ASOFT.form.updateSaveStatus('MTF2001', result.Status, result.Data);
        ASOFT.helper.showErrorSeverOption(0, result, "MTF2001", function () {
            switch (MTF2000.saveType) {
                case 1:
                    MTF2000.addNew();
                    break;
                case 2:
                    MTF2000.addNewCopy(result.Data);
                    break;
                case 3:
                    //formStatus = 2;
                    MTF2000.MTF2001Popup.close();
                    break;
            }

            if (MTF2000.MTF2000Grid) {
                MTF2000.MTF2000Grid.dataSource.page(1);
            }
            else {
                var data;
                var studentID = $('#student').val();
                data = { id: studentID };
                var postUrl = $('#UrlMTF2002MPartial').val();
                ASOFT.helper.post(postUrl, data, function (html) {
                    $('#viewPartial').html(html);
                });
            }

        }, function () {
            MTF2000.isValid = false;
        });
    };

    this.btnCloseClick = function() {
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016' /*'A00ML000001'*/),
            function() {
                MTF2000.mtf2001BtnSaveClick();
                if (!MTF2000.isValid) {
                    return;
                }
                MTF2000.MTF2001Popup.close();
            }, function() {
                MTF2000.MTF2001Popup.close();
            });
    };
    
    //=============================================================================
    // Màn hình chi tiết học viên - MTF2002
    //=============================================================================

    this.mtf2002GridData = function() {
        var data = { };
        data['studentId'] = $('#student').val();
        return data;
    };
};
