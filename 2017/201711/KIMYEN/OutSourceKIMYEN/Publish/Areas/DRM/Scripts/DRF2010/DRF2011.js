//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     25/08/2014      Đức Quý         Tạo mới
//####################################################################
var IsDRT2011 = false;
var OldDebtorID = "";
$(document).ready(function () {
    DRF2011.DRF2011Grid = ASOFT.asoftGrid.castName('DRF2011Grid');
    DRF2011.btnSave = $('#BtnSaveClose').data('kendoButton');
    DRF2011.DRF2012Grid = ASOFT.asoftGrid.castName('DRF2012Grid');
    DRF2011.DRF2073GridDocument = ASOFT.asoftGrid.castName('DRF2073GridDocument');
    DRF2011.DRF2074GridCloseResume = ASOFT.asoftGrid.castName('DRF2074GridCloseResume');
    if (DRF2011.DRF2011Grid) {
        DRF2011.DRF2011Grid.bind('dataBound', function () {
            DRF2011.rowNum = 0;
        });
        $('#DRF2011Grid').on("click", function (event) {
            var str = $("#DRF2011Grid").data("kendoGrid").select().find("Input#Address").val();
            if (str != undefined) {
                $("#DRF2011Grid").data("kendoGrid").select().find("Input#Address").css("text-transform", "uppercase");
                $("#DRF2011Grid").data("kendoGrid").select().find("Input#Address").parent().css("text-transform", "uppercase");
            }
        });
    }

    btnSendXR = $('#btnSendXR').data('kendoButton');
    btnSendVPL = $('#btnSendVPL').data('kendoButton');
    btnClose = $('#btnClose').data('kendoButton');

    var isSendXR = $('#IsSendXR').val();
    var isSendVPL = $('#IsSendVPL').val();
    var isClose = $('#IsClose').val();
    var isClosed = $('#IsClosed').val();
    if (btnSendXR && btnSendVPL && btnClose) {
        if (!(isSendXR == 0
                || isSendXR == 3
                || isSendXR == 5
                || isSendXR == 7
                || (isSendXR == null || isSendXR == ''))
            || (isClosed == 1
                || isClosed == 2
                || isClosed == 4
                || isClosed == 6)
            || $('#IsBankClose').val() == 1) {
            btnSendXR.enable(false);
        }

        if (!(isSendVPL == 0
                || isSendVPL == 3
                || isSendVPL == 5
                || isSendVPL == 7
                || (isSendVPL == null || isSendVPL == ''))
            || (isClosed == 1
                || isClosed == 2
                || isClosed == 4
                || isClosed == 6)
            || $('#IsBankClose').val() == 1) {
            btnSendVPL.enable(false);
        }

        if (!(isClose == 0
                || isClose == 3
                || isClose == 5
                || isClose == 7
                || (isClose == null || isClose == ''))
            || (isClosed == 1
                || isClosed == 2
                || isClosed == 4
                || isClosed == 6)
            || $('#IsBankClose').val() == 1) {
            btnClose.enable(false);
        }
    }

    btnTeamLeaderConfirm = $('#BtnTeamLeaderConfirm').data('kendoButton');
    btnTeamLeaderNotConfirm = $('#BtnTeamLeaderNotConfirm').data('kendoButton');
    btnTeamLeaderCancelConfirm = $('#BtnTeamLeaderCancelConfirm').data('kendoButton');
    btnManagerConfirm = $('#BtnManagerConfirm').data('kendoButton');
    btnManagerNotConfirm = $('#BtnManagerNotConfirm').data('kendoButton');
    btnManagerCancelConfirm = $('#BtnManagerCancelConfirm').data('kendoButton');
    btnInfoRoomConfirm = $('#BtnInfoRoomConfirm').data('kendoButton');
    btnInfoRoomNotConfirm = $('#BtnInfoRoomNotConfirm').data('kendoButton');
    btnInfoRoomCancelConfirm = $('#BtnInfoRoomCancelConfirm').data('kendoButton');

    btnCloseTeamLeaderConfirm = $('#BtnCloseTeamLeaderConfirm').data('kendoButton');
    btnCloseTeamLeaderNotConfirm = $('#BtnCloseTeamLeaderNotConfirm').data('kendoButton');
    btnCloseTeamLeaderCancelConfirm = $('#BtnCloseTeamLeaderCancelConfirm').data('kendoButton');
    btnCloseManagerConfirm = $('#BtnCloseManagerConfirm').data('kendoButton');
    btnCloseManagerNotConfirm = $('#BtnCloseManagerNotConfirm').data('kendoButton');
    btnCloseManagerCancelConfirm = $('#BtnCloseManagerCancelConfirm').data('kendoButton');
    btnCloseInfoRoomConfirm = $('#BtnCloseInfoRoomConfirm').data('kendoButton');
    btnCloseInfoRoomNotConfirm = $('#BtnCloseInfoRoomNotConfirm').data('kendoButton');
    btnCloseInfoRoomCancelConfirm = $('#BtnCloseInfoRoomCancelConfirm').data('kendoButton');


    btnSendDoc = $('#btnSendDoc').data('kendoButton');
    btnCloseDoc = $('#btnCloseDoc').data('kendoButton');

    var tabStrip = $("#DRF2011Tab").kendoTabStrip().data("kendoTabStrip");
    if (tabStrip) {
        //Lock tab gửi công văn  và tab đóng hồ sơ
        var isSendXR1 = $('#IsSendXR1').val();
        var isSendVPL1 = $('#IsSendVPL1').val();
        var isClose1 = $('#IsClose1').val();
        if (!(isClose1 == 2 || isClose1 == 4 || isClose1 == 6)) {
            $("#DRF2011Tab-9").css({ "pointer-events": "none", "opacity": "0.8" });
        }
        if (!(isSendXR1 == 2 || isSendXR1 == 4 || isSendXR1 == 6) && !(isSendVPL1 == 2 || isSendVPL1 == 4 || isSendVPL1 == 6)) {
            $("#DRF2011Tab-8").css({ "pointer-events": "none", "opacity": "0.8" });
        }
        //if (isSendXR1 == 1) {
        //    $("#DRF2011Tab-8").css({ "pointer-events": "", "opacity": "" });
        //    if (!(isSendVPL1 == 2 || isSendVPL1 == 4 || isSendVPL1 == 6)) {
        //        $("#DRF2011Tab-8").css({ "pointer-events": "none", "opacity": "0.8" });
        //    }
        //}

        //Lock từng button của tab gửi công văn  và tab đóng hồ sơ
        btnSendDoc.enable(false);
        btnCloseDoc.enable(false);

        if ($('#InfoSendDispath').val() == 'True') {
            if (isSendXR1 == 6 || isSendVPL1 == 6) {
                btnInfoRoomConfirm.enable(true);
                btnInfoRoomNotConfirm.enable(true);
                btnInfoRoomCancelConfirm.enable(true);
                btnSendDoc.enable(true);
            }
        }
        if ($('#ManagerSendDispath').val() == 'True') {
            if (isSendXR1 == 4 || isSendVPL1 == 4) {
                btnManagerConfirm.enable(true);
                btnManagerNotConfirm.enable(true);
                btnManagerCancelConfirm.enable(true);
                btnSendDoc.enable(true);
            }
        }
        if ($('#LeaderSendDispath').val() == 'True') {
            if (isSendXR1 == 2 || isSendVPL1 == 2) {
                btnTeamLeaderConfirm.enable(true);
                btnTeamLeaderNotConfirm.enable(true);
                btnTeamLeaderCancelConfirm.enable(true);
                btnSendDoc.enable(true);
            }
        }

        if ($('#InfoCloseContract').val() == 'True') {
            if (isClose1 == 6) {
                btnCloseInfoRoomConfirm.enable(true);
                btnCloseInfoRoomNotConfirm.enable(true);
                btnCloseInfoRoomCancelConfirm.enable(true);
                btnCloseDoc.enable(true);
            }
        }
        if ($('#ManagerCloseContract').val() == 'True') {
            if (isClose1 == 4) {
                btnCloseManagerConfirm.enable(true);
                btnCloseManagerNotConfirm.enable(true);
                btnCloseManagerCancelConfirm.enable(true);
                btnCloseDoc.enable(true);
            }
        }
        if ($('#LeaderCloseContract').val() == 'True') {
            if (isClose1 == 2) {
                btnCloseTeamLeaderConfirm.enable(true);
                btnCloseTeamLeaderNotConfirm.enable(true);
                btnCloseTeamLeaderCancelConfirm.enable(true);
                btnCloseDoc.enable(true);
            }
        }

    }

    // Keep data OldDebtorID
    OldDebtorID = $("#DebtorID").val();
});

DRF2011 = new function () {
    this.formStatus = null;
    this.rowNum = 0;
    this.DRF2011Grid = null;
    this.DRF2012Grid = null;
    this.DRF2073GridDocument = null;
    this.DRF2074GridCloseResume = null;
    this.btnSave = null;
    this.isEndRequest = false;
    this.countCombo = 0;
    this.isSaved = false;
    this.comboNames = ['TeamID', 'CustomerID', 'ContractGroupID'];

    var checkFlag = false;

    this.renderNumber = function () {
        return ++DRF2011.rowNum;
    }

    // Close button events
    this.btnClose_Click = function () {
        // Hide Iframe
        DRF2011.closePopup();
    };

    //Get data form DRF2041
    this.getFormData = function () {
        var data = {};
        data = ASOFT.helper.dataFormToJSON('DRF2011', 'List', DRF2011.DRF2011Grid);

        //Get control Kendo UI => disabled
        var kendoControl = ASOFT.helper.getAllKendoUI($('#DRF2011'));
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

        return data;
    }

    //Post data and update data
    this.saveData = function () {
        if (ASOFT.form.checkRequiredAndInList('DRF2011', DRF2011.comboNames)) {
            return;
        }
        //kiểm tra thêm dữ liệu trên lưới địa chỉ mà không nhập dữ liệu
        var grid = $("#DRF2011Grid").data('kendoGrid');
        $("#DRF2011Grid").removeClass('asf-focus-input-error');
        ASOFT.asoftGrid.editGridRemmoveValidate(grid);

        var listRequired = ['Address', 'Ward', 'DistrictName', 'District', 'City', 'CityName', 'Note', 'IsSend', 'APK'];

        if (ASOFT.asoftGrid.editGridValidateNoEdit(grid, listRequired)) {
            var msg = ASOFT.helper.getMessage("00ML000060");
            ASOFT.form.displayError("#DRF2011", msg);
            return
        }

        var data = DRF2011.getFormData();
        if ($('#IsCheckedEveryday').is(':checked')) {
            if (ASOFT.form.checkDateInPeriod('DRF2011', data.BeginDate, data.EndDate, ['ActionDate'])) {
                return;
            }

            //Check NextActionDate < ActionDate thì báo lỗi
            var NextActionDate = kendo.parseInt(kendo.toString(kendo.parseDate(data.NextActionDate, "dd/MM/yyyy"), "yyyyMMdd"));
            var ActionDate = kendo.parseInt(kendo.toString(kendo.parseDate(data.ActionDate, "dd/MM/yyyy"), "yyyyMMdd"));
            $('#NextActionDate').removeClass('asf-focus-input-error')
            if (ActionDate > NextActionDate) {
                $('#NextActionDate').addClass('asf-focus-input-error');
                ASOFT.form.displayMessageBox("#" + 'DRF2011', [ASOFT.helper.getMessage('DRFML000044')], null);
                return;
            }
        }
        if (data) {
            data.APKDRT4444 = $('#APKDRT4444').val();
            data.LastKey = $('#LastKey').val();
            data.IsCheckedEveryday = $('#IsCheckedEveryday').is(':checked');
            data.IsSendXR1 = $('#IsSendXR1').val();
            data.IsSendVPL1 = $('#IsSendVPL1').val();
            data.IsClose1 = $('#IsClose1').val();
            data.TableID = 'DRT2010';
            data.OldDebtorID = OldDebtorID;

            if (grid.tbody.find('.k-state-selected').closest('tr').length > 0) {
                data.IsDRT2011 = true;
            }
            if (IsDRT2011) {
                data.IsDRT2011 = true;
            }
        }

        if (!DRF2011.checkNextAction(data)) {
            return;
        }

        if (data.List.length == 1
            && data.List[0].Address == null
            && data.List[0].AddressID == null
            && data.List[0].Ward == null
            && data.List[0].District == null
            && data.List[0].City == null
            && data.List[0].AddNote == null) { //Lưới địa chỉ rỗng => không post lên server
            data.List = null;
        }
        ASOFT.asoftLoadingPanel.panelText = AsoftMessage['DRFML000045'];
        ASOFT.helper.postTypeJsonXR(window.parent.DRF2010.urlUpdate, data, DRF2011.saveSuccess);
    }

    //Result sever return when save success
    this.saveSuccess = function (result) {
        //alert(result.Data);
        // Update Save status
        ASOFT.form.updateSaveStatus('DRF2011', result.Status, result.Data);
        ASOFT.helper.showErrorSeverOption(0, result, 'DRF2011', function () {
            // Chuyển hướng xử lý nghiệp vụ
            switch (DRF2011.actionSaveType) {
                case 1: // Trường hợp lưu & nhập tiếp
                    //$('form#DRF2011 input').val(null);
                    window.location.reload(true);
                    break;
                case 2: // Trường hợp lưu & sao chép
                    $('#DRF2011').find('input[type="text"], textarea').change(function () {
                        DRF2011.isSaved = false;
                    });
                    DRF2011.isSaved = true;
                    break;
                case 3: // Trường hợp lưu và đóng
                    if (window.parent.$('#viewPartial').length > 0) {
                        ASOFT.helper.post(window.parent.$('#UrlDRF2012M').val(),
                          { apk: result.Data }, function (data) {
                              window.parent.$('#viewPartial').html(data);
                          });
                        window.parent.DRF2011.DRF2011Grid.dataSource.read();
                        window.parent.ASOFT.form.setSameWidth("asf-content-block");
                    }
                    else {
                        // Reload grid
                        window.parent.DRF2010.DRF2010Grid.dataSource.page(1);
                    }
                    ASOFT.asoftPopup.hideIframe(true);
                    break;
                default:
                    break;
            }

            // Refresh data
            if (window.parent.DRF2010.DRF2010Grid) {
                // Reload grid
                window.parent.DRF2010.DRF2010Grid.dataSource.page(1);
            } else {
                window.location.reload(true);
            }
        }, null, null, true);

        if (result.Status == 1 && result.MessageID == 'DRFML000017') {
            $('#ProcessingID').val(result.Data.VoucherNo);
            $('#LastKey').val(result.Data.LastKey);
            $('#APKDRT4444').val(result.Data.LastKeyAPK);
        }
        ASOFT.asoftLoadingPanel.panelText = 'Loading.....';
    }

    // Save Copy button events
    this.btnSaveCopy_Click = function () {
        DRF2011.actionSaveType = 2;
        DRF2011.saveData();

    };

    // Save Next button events
    this.btnSaveNext_Click = function () {
        DRF2011.actionSaveType = 1;
        DRF2011.saveData();
    };

    // Save button events
    this.btnSave_Click = function () {
        DRF2011.actionSaveType = 3;
        DRF2011.saveData();
    };

    this.deleteAddress = function (tag) {
        row = $(tag).parent();
        IsDRT2011 = true;
        if (DRF2011.DRF2011Grid.dataSource.data().length == 1) {//Xét rỗng dòng hiện tại nếu lưới còn 1 dòng
            var data = DRF2011.DRF2011Grid.dataSource.data();
            var row = DRF2011.DRF2011Grid.dataSource.data()[0];
            row.set('AddressID', null);
            row.set('Address', null);
            row.set('Ward', null);
            row.set('District', null);
            row.set('City', null);
            row.set('AddNote', null);
            return;
        }
        ASOFT.asoftGrid.removeEditRow(row, DRF2011.DRF2011Grid, null);
    }

    // show popup
    this.showPopup = function (url, data) {
        // [1] Format url with object data
        var postUrl = ASOFT.helper.renderUrl(url, data);

        // [2] Render iframe
        ASOFT.asoftPopup.showIframe(postUrl, {});
    };

    // Hide Iframes
    this.closePopup = function () {
        if (!ASOFT.form.formClosing('DRF2011') && !DRF2011.isSaved) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
                DRF2011.btnSave_Click, function () {
                    ASOFT.asoftPopup.hideIframe(true);
                });
        }
        else {
            ASOFT.asoftPopup.hideIframe(true);
        }
        DRF2011.rowNum = 0;
    };

    //Load data => Grid Address, EveryDay, Payment
    this.drf2012GridSendData = function () {
        var data = {};
        data.ContractNo = $('td#ContractNo').text();
        data.FromPeriodID = $('table tr td input[id=FromPeriodID]').val();
        data.ToPeriodID = $('table tr td input[id=ToPeriodID]').val();
        if (!$('td#ContractNo').text()) {
            data.ContractNo = window.parent.$('td#ContractNo').text();
            data.FromPeriodID = $('table tr td input[id=FromPeriodID]').val();
            data.ToPeriodID = $('table tr td input[id=ToPeriodID]').val();
        }
        data.DebtorID = $("input[name='DebtorID']").val();

        if ($("#ScreenID").val() == "DRF2012" && (data.DebtorID == undefined || data.DebtorID == "")) {
            data.DebtorID = $("label[for='DebtorID']").parent().parent().children()[2].innerText;
        }

        return data;
    }

    //Event change form-to
    this.LoadDRF2012Grid = function (e) {
        var FromPeriodID = $('table tr td input[id=FromPeriodID]').val();
        var ToPeriodID = $('table tr td input[id=ToPeriodID]').val();

        var date1 = parseDate("1/" + FromPeriodID).getTime();
        var date2 = parseDate("1/" + ToPeriodID).getTime();
        if (date1 > date2) {
            ASOFT.dialog.showMessage('DRFML000037');
            return;
        }

        DRF2011.DRF2012Grid.dataSource.read();
        this.refresh();
    }

    //Combo CustomerID Changed
    this.combo_Changed = function (e) {
        ASOFT.form.checkItemInListFor(this, 'DRF2011');

        if ($(this.element).attr('id') == 'CustomerID') {
            var dataItem = this.dataItem(this.selectedIndex);

            if (dataItem == null) return;

            $('#CustomerName').val(dataItem.CustomerName);
        }
    }

    //Combo CustomerID_DataBound
    this.customerID_DataBound = function (e) {
        ASOFT.asoftComboBox.dataBound(e);
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        $('#CustomerName').attr('initValue', dataItem.CustomerName);
        $('#CustomerName').val(dataItem.CustomerName);
    }

    //Combox loaded data
    this.comboBox_RequestEnd = function (e) {
        DRF2011.countCombo++;
        if (DRF2011.countCombo == DRF2011.comboNames.length) {
            DRF2011.isEndRequest = true;
            DRF2011.btnSave.enable(true);
        }
    }

    this.openProcessing = function (apk) {
        var url = $('#UrlDRF2022').val();
        //var child = e.parentElement.parentElement.lastElementChild.textContent;
        var fullPath = url + "?apk=" + apk;
        window.open(fullPath, '_blank');
    }

    this.openDRF2061 = function (apk, dispathTypeID) {
        ASOFT.form.clearMessageBox();
        var data = {};
        data.apk = apk;
        data.dispathTypeID = dispathTypeID;

        // Url load dữ liệu lên form
        var postUrl = $("#UrlDRF2061").val();

        // [4] Hiển thị popup
        DRF2011.showPopup(postUrl, data);
    }

    this.openDRF2051 = function (apk) {
        ASOFT.form.clearMessageBox();
        //Url load dữ liệu lên form
        var postUrl = $("#UrlDRF2051").val();

        //Data load dữ liệu lên form
        var data = {
            apk: apk
        };

        //Hiển thị popup
        DRF2011.showPopup(postUrl, data);
    }

    this.checkBox_Changed = function (tag) {
        var row = $(tag).parent().closest('tr');
        var currentRecord = ASOFT.asoftGrid.selectedRecord(DRF2011.DRF2011Grid);
        var id = null;
        if (Number($(row.children()[0]).text()) < 10) {
            id = $('#AD0' + Number($(row.children()[0]).text())).val();
        }
        else {
            id = $('#AD' + $(row.children()[0]).text()).val();
        }
        if (id.indexOf('1') == -1) {
            $(tag).prop('checked', false);
        } else {
            if ($("#" + currentRecord["AddressID"]).val() == "False") {
                $(tag).prop('checked') ? $(tag).prop('checked', false) : $(tag).prop('checked', true);
                currentRecord[tag.id] = $(tag).prop('checked') ? true : false;
            } else {

                currentRecord[tag.id] = $(tag).prop('checked') ? true : false;
            }
        }
    }

    //load panel lịch sử
    this.expandPanel = function (e) {
        if (e.item.children[1].id == "panelbar-9") {
            ASOFT.helper.post($('#UrlHistory').val(),
                          null, function (data) {
                              $('#panelbar-9').html(data);
                          });
        }
    }

    // check gui de nghi cho hanh dong tiep theo
    this.checkNextAction = function (data) {
        var NextActionval = data.NextActionID;
        var NextPaidAmount = data.NextPaidAmount;

        var flag = true;
        var cvXR = $('#btnSendXR').attr('aria-disabled');
        var cvVPL = $('#btnSendVPL').attr('aria-disabled');
        var dCV = $('#btnClose').attr('aria-disabled');

        if (((NextActionval == "CVXR" && cvXR == "false") || (NextActionval == "CVVPL" && cvVPL == "false") || (NextActionval == "DND" && dCV == "false")) && !checkFlag) {

            ASOFT.form.displayMessageBox("#" + 'DRF2011', [ASOFT.helper.getMessage('DRFML000038')], null);
            flag = false;
        }
        if (($('#SuggesstType').val() == "1" && NextActionval != "CVXR") || ($('#SuggesstType').val() == "2" && NextActionval != "CVVPL") || ($('#SuggesstType').val() == "3" && NextActionval != "DND")) {
            ASOFT.form.displayMessageBox("#" + 'DRF2011', [ASOFT.helper.getMessage('DRFML000038')], null);
            flag = false;
        }
        if (NextActionval == "DKT" && (NextPaidAmount == null || NextPaidAmount == "0")) {
            ASOFT.form.displayMessageBox("#" + 'DRF2011', [ASOFT.helper.getMessage('DRFML000043')], null);
            flag = false;
        }
        return flag;
    }

    //Phải click vào nút công văn Xương Rồng khi chọn hành động tiếp theo là CVXR
    this.btnSendDocXR_Click = function () {
        if ($('#IsSendXR1').val() != 1) {
            checkFlag = true;
            $('#SuggesstType').val("1");
            //$('#IsSendXR1').val("2");
            $($('#btnSendXR').children()).css('border', '1px solid black')
            $($('#btnSendVPL').children()).css('border', '')
            $($('#btnClose').children()).css('border', '')
        } else {
            checkFlag = false;
            $('#SuggesstType').val("0");
            //$('#IsSendXR1').val("0");
            $($('#btnSendXR').children()).css('border', '')
            $($('#btnSendVPL').children()).css('border', '')
            $($('#btnClose').children()).css('border', '')
        }
    }
    //Phải click vào nút công văn Văn Phòng Luật khi chọn hành động tiếp theo là CVVPL
    this.btnSendDocVPL_Click = function () {
        if ($('#IsSendVPL1').val() != 1) {
            checkFlag = true;
            $('#SuggesstType').val("2");
            //$('#IsSendVPL1').val("2");

            $($('#btnSendVPL').children()).css('border', '1px solid black')
            $($('#btnSendXR').children()).css('border', '')
            $($('#btnClose').children()).css('border', '')
        }
        else {
            checkFlag = false;
            $('#SuggesstType').val("0");
            //$('#IsSendVPL1').val("0");
            $($('#btnSendXR').children()).css('border', '')
            $($('#btnSendVPL').children()).css('border', '')
            $($('#btnClose').children()).css('border', '')
        }
    }
    //Phải click vào nút đóng hồ sơ khi chọn hành động tiếp theo là DND
    this.btnCloseDoc_Click = function () {
        if ($('#IsClose1').val() != 1) {
            checkFlag = true;
            $('#SuggesstType').val("3");
            //$('#IsClose1').val("2");
            $($('#btnClose').children()).css('border', '1px solid black')
            $($('#btnSendXR').children()).css('border', '')
            $($('#btnSendVPL').children()).css('border', '')
        } else {
            checkFlag = false;
            $('#SuggesstType').val("0");
            // $('#IsClose1').val("0");
            $($('#btnSendXR').children()).css('border', '')
            $($('#btnSendVPL').children()).css('border', '')
            $($('#btnClose').children()).css('border', '')
        }
    }

    this.comboBox_Changed = function () {
        ASOFT.form.checkItemInListFor(this, 'DRF2011');
        console.log('combo ' + $(this.element).attr('id') + 'change');
    }

    this.comboBox_Open = function () {
        var cvXR = $('#btnSendXR');
        var cvVPL = $('#btnSendVPL');
        var dCV = $('#btnClose');
        var item = [cvXR, cvVPL, dCV];

        DRF2011.loadDataComboBox(this, item);
    }

    this.loadDataComboBox = function (e, item) {

        var data = [];
        data = e.dataSource._data;

        for (var j = 0; j < item.length; j++) {
            var flag = item[j].attr('aria-disabled');
            if (flag == "true") {
                if (item[j].attr('id') == "btnSendXR") {
                    for (var i = 0; i < data.length; i++) {
                        if (data[i].InfoID == "CVXR") {
                            data.splice(i, 1);
                        };
                    }

                }
                else if (item[j].attr('id') == "btnSendVPL") {
                    for (var i = 0; i < data.length; i++) {
                        if (data[i].InfoID == "CVVPL") {
                            data.splice(i, 1);
                        };
                    }
                }
                else if (item[j].attr('id') == "btnClose") {
                    for (var i = 0; i < data.length; i++) {
                        if (data[i].InfoID == "DND") {
                            data.splice(i, 1);
                        };
                    }
                }
            }
        }
        return data;
    }

    this.actAddr_SendData = function () {
        var data = {
            contractNo: $('#ContractNo').val()
        }

        console.log('next action address send data');
        return data;
    }

    this.actEmp_SendData = function () {
        var data = {
            contractNo: $('#ContractNo').val()
        }
        return data;
    }

    //Khi checked được phép sửa thông tin tab xử lý hằng ngày
    this.chkEveryday_Click = function (e) {
        if (e.checked) {
            $('#IsCheckedEveryday').parent().find('.asf-form-container').css('pointer-events', '');
            var data = {
                ContractNo: $('#ContractNo').val(),
                DebtorName: $('#DebtorName').val()
            }
            ASOFT.helper.post($('#UrlDRF2011EveryDay').val(),
                          data, function (data1) {
                              $('div#ViewEveryday').html(data1);
                          });

            DRF2011.comboNames = ['TeamID', 'CustomerID', 'ContractGroupID', 'ActionID', 'ActionObjectID',
                       'ActionPlaceID', 'ResultID', 'AssetStatus', 'ActionAddressID', 'ActionEmployeeID',
                       'ReasonID', 'NextActionID', 'NextActionAddressID', 'NextActionAddressID2', 'NextActionAddressID3'];

            btnSendXR = $('#btnSendXR').data('kendoButton');
            btnSendVPL = $('#btnSendVPL').data('kendoButton');
            btnClose = $('#btnClose').data('kendoButton');

            var isSendXR = $('#IsSendXR').val();
            var isSendVPL = $('#IsSendVPL').val();
            var isClose = $('#IsClose').val();
            var isClosed = $('#IsClosed').val();
            if (btnSendXR && btnSendVPL && btnClose) {
                if (!(isSendXR == 0
                        || isSendXR == 3
                        || isSendXR == 5
                        || isSendXR == 7
                        || (isSendXR == null || isSendXR == ''))
                    || (isClosed == 1
                        || isClosed == 2
                        || isClosed == 4
                        || isClosed == 6)
                    || $('#IsBankClose').val() == 1) {
                    btnSendXR.enable(false);
                }

                if (!(isSendVPL == 0
                        || isSendVPL == 3
                        || isSendVPL == 5
                        || isSendVPL == 7
                        || (isSendVPL == null || isSendVPL == ''))
                    || (isClosed == 1
                        || isClosed == 2
                        || isClosed == 4
                        || isClosed == 6)
                    || $('#IsBankClose').val() == 1) {
                    btnSendVPL.enable(false);
                }

                if (!(isClose == 0
                        || isClose == 3
                        || isClose == 5
                        || isClose == 7
                        || (isClose == null || isClose == ''))
                    || (isClosed == 1
                        || isClosed == 2
                        || isClosed == 4
                        || isClosed == 6)
                    || $('#IsBankClose').val() == 1) {
                    btnClose.enable(false);
                }
            }

            //Ngày hành động theo ngày hiện tại không chỉnh sửa thành ngày khác
            var dpActionDate = $('#ActionDate').data("kendoDatePicker");
            if (dpActionDate) {
                dpActionDate.readonly();
            }

            //Ngày hẹn làm việc(không được lùi lại ngày trước ngày hệ thống)
            $('#NextActionDate').kendoDatePicker({
                format: 'dd/MM/yyyy',
                min: new Date()
            }).data("kendoDatePicker");
        } else {
            $('#IsCheckedEveryday').parent().find('.asf-form-container').css('pointer-events', 'none');
            $('div#ViewEveryday').text('');

            if ($('#IsClose1').val() == 2 && $('#SuggesstType').val() == 3) {
                $('#IsClose1').val("0");
                $('#SuggesstType').val("0");
            }
            if ($('#IsSendVPL1').val() == 2 && $('#SuggesstType').val() == 2) {
                $('#IsSendVPL1').val("0");
                $('#SuggesstType').val("0");
            }
            if ($('#IsSendXR1').val() == 2 && $('#SuggesstType').val() == 3) {
                $('#IsSendXR1').val("0");
                $('#SuggesstType').val("0");
            }

            DRF2011.comboNames = ['TeamID', 'CustomerID', 'ContractGroupID'];
        }


    }

    //-------Button xác nhận, từ chối trong tab gửi công văn------
    var IsID = null;
    //Duyệt nhanh gửi công văn
    this.btnSendDoc_Click = function (data) {
        //var IsID = null;
        if (!IsID) {
            if ($('#IsSendXR1').val() == 2 || $('#IsSendXR1').val() == 4 || $('#IsSendXR1').val() == 6) {
                IsID = $('#IsSendXR1');
            }
            else if ($('#IsSendVPL1').val() == 2 || $('#IsSendVPL1').val() == 4 || $('#IsSendVPL1').val() == 6) {
                IsID = $('#IsSendVPL1');
            }
        }

        //var value = data.sender.element.context.title;

        if ($('#LeaderSendDispath').val() == 'True') {
            $('#LblTeamLeaderConfirm').text('Xác nhận');
            IsID.val("4");
            btnTeamLeaderConfirm.enable(true);
            btnTeamLeaderNotConfirm.enable(true);
            btnTeamLeaderCancelConfirm.enable(true);
        }
        if ($('#ManagerSendDispath').val() == 'True') {
            $('#LblManagerConfirm').text('Xác nhận');
            IsID.val("6");
            btnManagerConfirm.enable(true);
            btnManagerNotConfirm.enable(true);
            btnManagerCancelConfirm.enable(true);
            btnTeamLeaderConfirm.enable(false);
            btnTeamLeaderNotConfirm.enable(false);
            btnTeamLeaderCancelConfirm.enable(false);
        }
        if ($('#InfoSendDispath').val() == 'True') {
            $('#LblInfoRoomConfirm').text('Xác nhận');
            IsID.val("1");
            btnInfoRoomConfirm.enable(true);
            btnInfoRoomNotConfirm.enable(true);
            btnInfoRoomCancelConfirm.enable(true);
            btnManagerConfirm.enable(false);
            btnManagerNotConfirm.enable(false);
            btnManagerCancelConfirm.enable(false);
        }
    }

    //Trưởng phòng chưa xác nhận
    this.btnTeamLeaderNotConfirm_Click = function (data) {
        //var IsID = null;
        if ($('#IsSendXR1').val() == 2 || $('#IsSendXR1').val() == 4 || $('#IsSendXR1').val() == 6 || $('#IsSendXR1').val() == 3) {
            IsID = $('#IsSendXR1');
        }
        else if ($('#IsSendVPL1').val() == 2 || $('#IsSendVPL1').val() == 4 || $('#IsSendVPL1').val() == 6 || $('#IsSendVPL1').val() == 3) {
            IsID = $('#IsSendVPL1');
        }
        IsID.val('2');

        var value = data.sender.element.context.text;
        $('#LblTeamLeaderConfirm').text(value);
        $('#LblManagerConfirm').text('');
    }

    //Trưởng phòng xác nhận
    this.btnTeamLeaderConfirm_Click = function (data) {
        //var IsID = null;
        if ($('#IsSendXR1').val() == 2 || $('#IsSendXR1').val() == 4 || $('#IsSendXR1').val() == 6 || $('#IsSendXR1').val() == 3) {
            IsID = $('#IsSendXR1');
        }
        else if ($('#IsSendVPL1').val() == 2 || $('#IsSendVPL1').val() == 4 || $('#IsSendVPL1').val() == 6 || $('#IsSendVPL1').val() == 3) {
            IsID = $('#IsSendVPL1');
        }
        IsID.val('4');

        var value = data.sender.element.context.innerText;
        $('#LblTeamLeaderConfirm').text(value);
        $('#LblManagerConfirm').text('');

        if ($('#ManagerSendDispath').val() == 'True') {
            btnManagerConfirm.enable(true);
            btnManagerNotConfirm.enable(true);
            btnManagerCancelConfirm.enable(true);
            btnTeamLeaderConfirm.enable(false);
            btnTeamLeaderNotConfirm.enable(false);
            btnTeamLeaderCancelConfirm.enable(false);
        }
    }

    //Trưởng phòng từ chối
    this.btnTeamLeaderCancelConfirm_Click = function (data) {
        //var IsID = null;
        if ($('#IsSendXR1').val() == 2 || $('#IsSendXR1').val() == 4 || $('#IsSendXR1').val() == 6 || $('#IsSendXR1').val() == 3) {
            IsID = $('#IsSendXR1');
        }
        else if ($('#IsSendVPL1').val() == 2 || $('#IsSendVPL1').val() == 4 || $('#IsSendVPL1').val() == 6 || $('#IsSendVPL1').val() == 3) {
            IsID = $('#IsSendVPL1');
        }
        IsID.val('3');

        var value = data.sender.element.context.text;
        $('#LblTeamLeaderConfirm').text(value);
        $('#LblManagerConfirm').text('');
    }

    //Quản lý chưa xác nhận
    this.btnManagerNotConfirm_Click = function (data) {
        //var IsID = null;
        if ($('#IsSendXR1').val() == 2 || $('#IsSendXR1').val() == 4 || $('#IsSendXR1').val() == 6 || $('#IsSendXR1').val() == 5) {
            IsID = $('#IsSendXR1');
        }
        else if ($('#IsSendVPL1').val() == 2 || $('#IsSendVPL1').val() == 4 || $('#IsSendVPL1').val() == 6 || $('#IsSendVPL1').val() == 5) {
            IsID = $('#IsSendVPL1');
        }
        IsID.val('4');

        var value = data.sender.element.context.text;
        $('#LblManagerConfirm').text(value);
        $('#LblInfoRoomConfirm').text('');

        if ($('#LeaderSendDispath').val() == 'True') {
            btnTeamLeaderConfirm.enable(true);
            btnTeamLeaderNotConfirm.enable(true);
            btnTeamLeaderCancelConfirm.enable(true);
            btnManagerConfirm.enable(false);
            btnManagerNotConfirm.enable(false);
            btnManagerCancelConfirm.enable(false);
        }
    }

    //Quản lý xác nhận
    this.btnManagerConfirm_Click = function (data) {
        //var IsID = null;
        if ($('#IsSendXR1').val() == 2 || $('#IsSendXR1').val() == 4 || $('#IsSendXR1').val() == 6 || $('#IsSendXR1').val() == 5) {
            IsID = $('#IsSendXR1');
        }
        else if ($('#IsSendVPL1').val() == 2 || $('#IsSendVPL1').val() == 4 || $('#IsSendVPL1').val() == 6 || $('#IsSendVPL1').val() == 5) {
            IsID = $('#IsSendVPL1');
        }
        IsID.val('6');

        var value = data.sender.element.context.text;
        $('#LblManagerConfirm').text(value);
        $('#LblInfoRoomConfirm').text('');

        if ($('#InfoSendDispath').val() == 'True') {
            btnInfoRoomConfirm.enable(true);
            btnInfoRoomNotConfirm.enable(true);
            btnInfoRoomCancelConfirm.enable(true);
            btnManagerConfirm.enable(false);
            btnManagerNotConfirm.enable(false);
            btnManagerCancelConfirm.enable(false);
        }
    }

    //Quản lý từ chối
    this.btnManagerCancelConfirm_Click = function (data) {
        //var IsID = null;
        if ($('#IsSendXR1').val() == 2 || $('#IsSendXR1').val() == 4 || $('#IsSendXR1').val() == 6 || $('#IsSendXR1').val() == 5) {
            IsID = $('#IsSendXR1');
        }
        else if ($('#IsSendVPL1').val() == 2 || $('#IsSendVPL1').val() == 4 || $('#IsSendVPL1').val() == 6 || $('#IsSendVPL1').val() == 5) {
            IsID = $('#IsSendVPL1');
        }
        IsID.val('5');

        var value = data.sender.element.context.text;
        $('#LblManagerConfirm').text(value);
        $('#LblInfoRoomConfirm').text('');


    }

    //Phòng Thông tin chưa xác nhận
    this.btnInfoRoomNotConfirm_Click = function (data) {
        //var IsID = null;
        if ($('#IsSendXR1').val() == 2 || $('#IsSendXR1').val() == 4 || $('#IsSendXR1').val() == 6 || $('#IsSendXR1').val() == 7 || $('#IsSendXR1').val() == 1) {
            IsID = $('#IsSendXR1');
        }
        else if ($('#IsSendVPL1').val() == 2 || $('#IsSendVPL1').val() == 4 || $('#IsSendVPL1').val() == 6 || $('#IsSendVPL1').val() == 7 || $('#IsSendVPL1').val() == 1) {
            IsID = $('#IsSendVPL1');
        }
        IsID.val('6');

        var value = data.sender.element.context.text;
        $('#LblInfoRoomConfirm').text(value);

        if ($('#ManagerSendDispath').val() == 'True') {
            btnManagerConfirm.enable(true);
            btnManagerNotConfirm.enable(true);
            btnManagerCancelConfirm.enable(true);
            btnInfoRoomConfirm.enable(false);
            btnInfoRoomNotConfirm.enable(false);
            btnInfoRoomCancelConfirm.enable(false);
        }
    }

    //Phòng Thông tin xác nhận
    this.btnInfoRoomConfirm_Click = function (data) {
        //var IsID = null;
        if ($('#IsSendXR1').val() == 2 || $('#IsSendXR1').val() == 4 || $('#IsSendXR1').val() == 6 || $('#IsSendXR1').val() == 7
            ) {
            IsID = $('#IsSendXR1');
        }
        else if ($('#IsSendVPL1').val() == 2 || $('#IsSendVPL1').val() == 4 || $('#IsSendVPL1').val() == 6 || $('#IsSendVPL1').val() == 7 || $('#IsSendVPL1').val() == 1) {
            IsID = $('#IsSendVPL1');
        }
        IsID.val('1');

        var value = data.sender.element.context.text;
        $('#LblInfoRoomConfirm').text(value);
    }

    //Phòng Thông tin từ chối
    this.btnInfoRoomCancelConfirm_Click = function (data) {
        //var IsID = null;
        if ($('#IsSendXR1').val() == 2 || $('#IsSendXR1').val() == 4 || $('#IsSendXR1').val() == 6 || $('#IsSendXR1').val() == 7 || $('#IsSendXR1').val() == 1) {
            IsID = $('#IsSendXR1');
        }
        else if ($('#IsSendVPL1').val() == 2 || $('#IsSendVPL1').val() == 4 || $('#IsSendVPL1').val() == 6 || $('#IsSendVPL1').val() == 7 || $('#IsSendVPL1').val() == 1) {
            IsID = $('#IsSendVPL1');
        }
        IsID.val('7');

        var value = data.sender.element.context.text;
        $('#LblInfoRoomConfirm').text(value);

    }

    //--------------

    //-------button xác nhận, từ chối trong tab đóng công văn------

    this.btnCloseDocument_Click = function (data) {
        var IsID = null;
        if ($('#IsClose1').val() == 2 || $('#IsClose1').val() == 4 || $('#IsClose1').val() == 6 || $('#IsClose1').val() == 3 || $('#IsClose1').val() == 5 || $('#IsClose1').val() == 7) {
            IsID = $('#IsClose1');
        }
        //var value = data.sender.element.context.title;

        if ($('#LeaderCloseContract').val() == 'True') {
            $('#LblCloseTeamLeaderConfirm').text('Xác nhận');
            IsID.val("4");
            btnCloseTeamLeaderConfirm.enable(true);
            btnCloseTeamLeaderNotConfirm.enable(true);
            btnCloseTeamLeaderCancelConfirm.enable(true);
        }
        if ($('#ManagerCloseContract').val() == 'True') {
            $('#LblCloseManagerConfirm').text('Xác nhận');
            IsID.val("6");
            btnCloseManagerConfirm.enable(true);
            btnCloseManagerNotConfirm.enable(true);
            btnCloseManagerCancelConfirm.enable(true);
            btnCloseTeamLeaderConfirm.enable(false);
            btnCloseTeamLeaderNotConfirm.enable(false);
            btnCloseTeamLeaderCancelConfirm.enable(false);
        }
        if ($('#InfoCloseContract').val() == 'True') {
            $('#LblCloseInfoRoomConfirm').text('Xác nhận');
            IsID.val("1");
            btnCloseInfoRoomConfirm.enable(true);
            btnCloseInfoRoomNotConfirm.enable(true);
            btnCloseInfoRoomCancelConfirm.enable(true);
            btnCloseManagerConfirm.enable(false);
            btnCloseManagerNotConfirm.enable(false);
            btnCloseManagerCancelConfirm.enable(false);
        }
    }

    //Trưởng phòng chưa xác nhận
    this.btnCloseTeamLeaderNotConfirm_Click = function (data) {
        var IsID = null;
        if ($('#IsClose1').val() == 2 || $('#IsClose1').val() == 4 || $('#IsClose1').val() == 6 || $('#IsClose1').val() == 3) {
            IsID = $('#IsClose1');
        }
        IsID.val("2");

        var value = data.sender.element.context.text;
        $('#LblCloseTeamLeaderConfirm').text(value);
        $('#LblCloseManagerConfirm').text('');
    }

    //Trưởng phòng xác nhận
    this.btnCloseTeamLeaderConfirm_Click = function (data) {
        var IsID = null;
        if ($('#IsClose1').val() == 2 || $('#IsClose1').val() == 4 || $('#IsClose1').val() == 6 || $('#IsClose1').val() == 3) {
            IsID = $('#IsClose1');
        }
        IsID.val("4");

        var value = data.sender.element.context.text;
        $('#LblCloseTeamLeaderConfirm').text(value);
        $('#LblCloseManagerConfirm').text('');

        if ($('#ManagerCloseContract').val() == 'True') {
            btnCloseManagerConfirm.enable(true);
            btnCloseManagerNotConfirm.enable(true);
            btnCloseManagerCancelConfirm.enable(true);
            btnCloseTeamLeaderConfirm.enable(false);
            btnCloseTeamLeaderNotConfirm.enable(false);
            btnCloseTeamLeaderCancelConfirm.enable(false);
        }
    }

    //Trưởng phòng từ chối
    this.btnCloseTeamLeaderCancelConfirm_Click = function (data) {
        var IsID = null;
        if ($('#IsClose1').val() == 2 || $('#IsClose1').val() == 4 || $('#IsClose1').val() == 6 || $('#IsClose1').val() == 3) {
            IsID = $('#IsClose1');
        }
        IsID.val("3");

        var value = data.sender.element.context.text;
        $('#LblCloseTeamLeaderConfirm').text(value);
        $('#LblCloseManagerConfirm').text('');
    }

    //Quản lý chưa xác nhận
    this.btnCloseManagerNotConfirm_Click = function (data) {
        var IsID = null;
        if ($('#IsClose1').val() == 2 || $('#IsClose1').val() == 4 || $('#IsClose1').val() == 6 || $('#IsClose1').val() == 5) {
            IsID = $('#IsClose1');
        }
        IsID.val("4");

        var value = data.sender.element.context.text;
        $('#LblCloseManagerConfirm').text(value);
        $('#LblCloseInfoRoomConfirm').text('');

        if ($('#LeaderCloseContract').val() == 'True') {
            btnCloseTeamLeaderConfirm.enable(true);
            btnCloseTeamLeaderNotConfirm.enable(true);
            btnCloseTeamLeaderCancelConfirm.enable(true);
            btnCloseManagerConfirm.enable(false);
            btnCloseManagerNotConfirm.enable(false);
            btnCloseManagerCancelConfirm.enable(false);
        }
    }

    //Quản lý xác nhận
    this.btnCloseManagerConfirm_Click = function (data) {
        var IsID = null;
        if ($('#IsClose1').val() == 2 || $('#IsClose1').val() == 4 || $('#IsClose1').val() == 6 || $('#IsClose1').val() == 5) {
            IsID = $('#IsClose1');
        }
        IsID.val("6");

        var value = data.sender.element.context.text;
        $('#LblCloseManagerConfirm').text(value);
        $('#LblCloseInfoRoomConfirm').text('')

        if ($('#InfoCloseContract').val() == 'True') {
            btnCloseInfoRoomConfirm.enable(true);
            btnCloseInfoRoomNotConfirm.enable(true);
            btnCloseInfoRoomCancelConfirm.enable(true);
            btnCloseManagerConfirm.enable(false);
            btnCloseManagerNotConfirm.enable(false);
            btnCloseManagerCancelConfirm.enable(false);
        }
    }

    //Quản lý từ chối
    this.btnCloseManagerCancelConfirm_Click = function (data) {
        var IsID = null;
        if ($('#IsClose1').val() == 2 || $('#IsClose1').val() == 4 || $('#IsClose1').val() == 6 || $('#IsClose1').val() == 5) {
            IsID = $('#IsClose1');
        }
        IsID.val("5");

        var value = data.sender.element.context.text;
        $('#LblCloseManagerConfirm').text(value);
        $('#LblCloseInfoRoomConfirm').text('');
    }

    //Phòng Thông tin chưa xác nhận
    this.btnCloseInfoRoomNotConfirm_Click = function (data) {
        var IsID = null;
        if ($('#IsClose1').val() == 2 || $('#IsClose1').val() == 4 || $('#IsClose1').val() == 6 || $('#IsClose1').val() == 7 || $('#IsClose1').val() == 1) {
            IsID = $('#IsClose1');
        }
        IsID.val("6");

        var value = data.sender.element.context.text;
        $('#LblCloseInfoRoomConfirm').text(value);

        if ($('#ManagerCloseContract').val() == 'True') {
            btnCloseManagerConfirm.enable(true);
            btnCloseManagerNotConfirm.enable(true);
            btnCloseManagerCancelConfirm.enable(true);
            btnCloseInfoRoomConfirm.enable(false);
            btnCloseInfoRoomNotConfirm.enable(false);
            btnCloseInfoRoomCancelConfirm.enable(false);
        }
    }

    //Phòng Thông tin xác nhận
    this.btnCloseInfoRoomConfirm_Click = function (data) {
        var IsID = null;
        if ($('#IsClose1').val() == 2 || $('#IsClose1').val() == 4 || $('#IsClose1').val() == 6 || $('#IsClose1').val() == 7 || $('#IsClose1').val() == 1) {
            IsID = $('#IsClose1');
        }
        IsID.val("1");

        var value = data.sender.element.context.text;
        $('#LblCloseInfoRoomConfirm').text(value);
    }

    //Phòng Thông tin từ chối
    this.btnCloseInfoRoomCancelConfirm_Click = function (data) {
        var IsID = null;
        if ($('#IsClose1').val() == 2 || $('#IsClose1').val() == 4 || $('#IsClose1').val() == 6 || $('#IsClose1').val() == 7 || $('#IsClose1').val() == 1) {
            IsID = $('#IsClose1');
        }
        IsID.val("7");

        var value = data.sender.element.context.text;
        $('#LblCloseInfoRoomConfirm').text(value);
    }

    //------------------
}
function parseDate(str) {
    var mdy = str.split('/');
    return new Date(mdy[2], mdy[1], mdy[0]);
}