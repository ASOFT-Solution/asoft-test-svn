//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     25/08/2014      Đức Quý         Tạo mới
//####################################################################

$(document).ready(function () {
    comboActionAddr = ASOFT.asoftComboBox.castName('ActionAddressID');
    comboNextActionID = ASOFT.asoftComboBox.castName('NextActionID');
    comboNextActionAddr = ASOFT.asoftComboBox.castName('NextActionAddressID');
    comboNextActionAddr2 = ASOFT.asoftComboBox.castName('NextActionAddressID2');
    comboNextActionAddr3 = ASOFT.asoftComboBox.castName('NextActionAddressID3');
    comboActionEmp = ASOFT.asoftComboBox.castName('ActionEmployeeID');
    comboActionEmp2 = ASOFT.asoftComboBox.castName('ActionEmployeeID2');
    comboActionEmp3 = ASOFT.asoftComboBox.castName('ActionEmployeeID3');
    DRF2021.btnSave = $('#BtnSaveClose').data('kendoButton');
    console.log('init page');
    if ($("#IsCheckedNextActionID").val() == 1) {
        $("#NextActionID").data("kendoComboBox").readonly()
    }

    if ($('#IsCall').val() == 0) {
        $('#ContractNo').change(function () {
            if (DRF2021.checkContractNo()) {
                DRF2021.getVoucherNo($(this).val());
                console.log('end check voucherno');
                //$(this).focus();
            }
        });
    }

    btnSendXR = $('#btnSendXR').data('kendoButton');
    btnSendVPL = $('#btnSendVPL').data('kendoButton');
    btnClose = $('#btnClose').data('kendoButton');

    var isSendXR = window.parent.$('#IsSendXR') ? window.parent.$('#IsSendXR').val() : $('#IsSendXR').val();
    var isSendVPL = window.parent.$('#IsSendVPL') ? window.parent.$('#IsSendVPL').val() : $('#IsSendVPL').val();
    var isClose = window.parent.$('#IsClose') ? window.parent.$('#IsClose').val() : $('#IsClose').val();
    var isClosed = window.parent.$('#IsClosed') ? window.parent.$('#IsClosed').val() : $('#IsClosed').val();

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
            || window.parent.$('#IsBankClose').val() == 1) {
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
            || window.parent.$('#IsBankClose').val() == 1) {
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
            || window.parent.$('#IsBankClose').val() == 1) {
            btnClose.enable(false);
        }
    }

    var nextActionID = $('#IsCheckedNextActionID').val();
    if (nextActionID == "1") {
        btnSendXR.enable(false);
        btnSendVPL.enable(false);
        btnClose.enable(false);
    }



    if ($('#IsUpdate').val() == 'True') {

        //Ngày hành động theo ngày hiện tại không chỉnh sửa thành ngày khác
        $('#ActionDate').kendoDatePicker({
            format: 'dd/MM/yyyy',
            value: new Date()
        }).data("kendoDatePicker");

        var dpActionDate = $('#ActionDate').data("kendoDatePicker");
        if (dpActionDate) {
            dpActionDate.readonly();
        }

        //var dpNextActionDate = $('#NextActionDate').val().split('/');
        var dpNextActionDate = kendo.parseInt(kendo.toString(kendo.parseDate($('#NextActionDate').val(), "dd/MM/yyyy"), "yyyyMMdd"));
        var dpActionDate = kendo.parseInt(kendo.toString(kendo.parseDate($('#ActionDate').val(), "dd/MM/yyyy"), "yyyyMMdd"));
        if (dpActionDate > dpNextActionDate) {
            //Ngày hẹn làm việc(không được lùi lại ngày trước ngày hệ thống)
            $('#NextActionDate').kendoDatePicker({
                format: 'dd/MM/yyyy',
                min: new Date(),//dpNextActionDate[2], dpNextActionDate[1] - 1, dpNextActionDate[0])
                value: new Date()
            }).data("kendoDatePicker");
        } else {
            $('#NextActionDate').kendoDatePicker({
                format: 'dd/MM/yyyy',
                min: new Date()//dpNextActionDate[2], dpNextActionDate[1] - 1, dpNextActionDate[0])
            }).data("kendoDatePicker");
        }
    } else {
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

    }


});

DRF2021 = new function () {

    var checkFlag = false;
    this.isCall = false;
    this.formStatus = null;
    this.actionSaveType = 0;
    this.isSaved = false;
    this.isEndRequest = false;
    this.countCombo = 0;
    this.btnSave = null;
    this.debtorName = null;
    this.comboNames = ['ActionID', 'ActionObjectID',
       'ActionPlaceID', 'ResultID', 'AssetStatus',
       'ActionAddressID', 'ActionEmployeeID', 'ReasonID', 'NextActionID', 'NextActionAddressID', 'NextActionAddressID2', 'NextActionAddressID3'];

    this.btnChoose_Click = function () {
        var data = {};
        var postUrl = $('#DRF2006Url').val();
        DRF2006.showPopup(postUrl, data);

        ASOFT.helper.registerFunction('window.parent.DRF2021.getVoucherNo');
        console.log('choose click');
    };

    // Close button events
    this.btnClose_Click = function () {
        // Hide Iframe
        DRF2021.closePopup();
        console.log('close click');
    };

    //Get data form DRF2041
    this.getFormData = function () {
        var data = ASOFT.helper.getFormData(null, 'DRF2021');
        return data;

        console.log('get form data');
    }

    //Post data and update data
    this.saveData = function () {

        if (ASOFT.form.checkRequiredAndInList('DRF2021', DRF2021.comboNames)) {
            return;
        }

        var dataJSON = ASOFT.helper.dataFormToJSON('DRF2021');

        //Check NextActionDate < ActionDate thì báo lỗi
        var NextActionDate = kendo.parseInt(kendo.toString(kendo.parseDate(dataJSON.NextActionDate, "dd/MM/yyyy"), "yyyyMMdd"));
        var ActionDate = kendo.parseInt(kendo.toString(kendo.parseDate(dataJSON.ActionDate, "dd/MM/yyyy"), "yyyyMMdd"));
        $('#NextActionDate').removeClass('asf-focus-input-error')
        if (ActionDate > NextActionDate) {
            $('#NextActionDate').addClass('asf-focus-input-error');
            ASOFT.form.displayMessageBox("#" + 'DRF2021', [ASOFT.helper.getMessage('DRFML000044')], null);
            return;
        }

        if (ASOFT.form.checkDateInPeriod('DRF2021', dataJSON.BeginDate, dataJSON.EndDate, ['ActionDate'])) {
            return;
        }

        if (window.parent.DRF2020.formStatus === 1) {
            if (!DRF2021.checkContractNo()) {
                console.log('voucher no is valid');
                return;
            }
        }

        //if (!checkFlag) {
        //    ASOFT.form.displayMessageBox("#" + 'DRF2021', [ASOFT.helper.getMessage('DRFML000038')], null);
        //    return;
        //}
        var data = DRF2021.getFormData();

        // check gui de nghi cho hanh dong tiep theo
        if (!DRF2021.checkNextAction(data)) {
            return;
        }

        //! DebtorIDGot được điều chỉnh lại lấy từ trên Controller - Business
        //var checkScreen = window.parent.document.getElementById("ScreenID").value;
        //if (checkScreen == "DRF2012" && data != undefined && data != null) {
        //    var DebtorIDGot = JSON.parse(
        //            window.parent.document.getElementById("initData").value)
        //        .DebtorID;
        //    data.push({ name: "DebtorIDGot", value: DebtorIDGot });
        //}

        data.push({ name: "DebtorIDGot", value: "" });

        ASOFT.asoftLoadingPanel.panelText = AsoftMessage['DRFML000045'];
        ASOFT.helper.postXR(window.parent.DRF2020.urlUpdate, data, DRF2021.saveSuccess);
        console.log('Save data');
    }

    // check gui de nghi cho hanh dong tiep theo
    this.checkNextAction = function (data) {
        var NextActionval;
        var NextPaidAmount;

        $.each(data, function (key, value) {
            if (value.name == "NextActionID") {
                NextActionval = value.value;
            }
            if (value.name == "NextPaidAmount") {
                NextPaidAmount = value.value;
            }
        })

        var flag = true;
        var cvXR = $('#btnSendXR').attr('aria-disabled');
        var cvVPL = $('#btnSendVPL').attr('aria-disabled');
        var dCV = $('#btnClose').attr('aria-disabled');

        if (((NextActionval == "CVXR" && cvXR == "false") || (NextActionval == "CVVPL" && cvVPL == "false") || (NextActionval == "DND" && dCV == "false")) && !checkFlag) {

            ASOFT.form.displayMessageBox("#" + 'DRF2021', [ASOFT.helper.getMessage('DRFML000038')], null);
            flag = false;
        }
        if (($('#SuggesstType').val() == "1" && NextActionval != "CVXR") || ($('#SuggesstType').val() == "2" && NextActionval != "CVVPL") || ($('#SuggesstType').val() == "3" && NextActionval != "DND")) {
            ASOFT.form.displayMessageBox("#" + 'DRF2021', [ASOFT.helper.getMessage('DRFML000038')], null);
            flag = false;
        }
        if (NextActionval == "DKT" && (NextPaidAmount == null || NextPaidAmount == "0")) {
            ASOFT.form.displayMessageBox("#" + 'DRF2021', [ASOFT.helper.getMessage('DRFML000043')], null);
            flag = false;
        }
        return flag;
    }

    //Phải click vào nút công văn Xương Rồng khi chọn hành động tiếp theo là CVXR
    this.btnSendXR_Click = function () {
        if ($('#SuggesstType').val() != 1 || $('#SuggesstType').val() == 0) {
            checkFlag = true;
            $('#SuggesstType').val("1");
            //$('#IsSendXR').val("2");
            $($('#btnSendXR').children()).css('border', '1px solid black')
            $($('#btnSendVPL').children()).css('border', '')
            $($('#btnClose').children()).css('border', '')
        } else {
            checkFlag = false;
            $('#SuggesstType').val("0");
            //$('#IsSendXR').val("0");
            $($('#btnSendXR').children()).css('border', '')
            $($('#btnSendVPL').children()).css('border', '')
            $($('#btnClose').children()).css('border', '')
        }
        //checkFlag = true;
        //$('#SuggesstType').val("1");
    }
    //Phải click vào nút công văn Văn Phòng Luật khi chọn hành động tiếp theo là CVVPL
    this.btnSendVPL_Click = function () {
        if ($('#SuggesstType').val() != 2 || $('#SuggesstType').val() == 0) {
            checkFlag = true;
            $('#SuggesstType').val("2");
            // $('#IsSendVPL').val("2");
            $($('#btnSendXR').children()).css('border', '')
            $($('#btnSendVPL').children()).css('border', '1px solid black')
            $($('#btnClose').children()).css('border', '')
        }
        else {
            checkFlag = false;
            $('#SuggesstType').val("0");
            //$('#IsSendVPL').val("0");
            $($('#btnSendXR').children()).css('border', '')
            $($('#btnSendVPL').children()).css('border', '')
            $($('#btnClose').children()).css('border', '')
        }
        //checkFlag = true;
        //$('#SuggesstType').val("2");
    }
    //Phải click vào nút đóng hồ sơ khi chọn hành động tiếp theo là DND
    this.btnClose = function () {
        if ($('#SuggesstType').val() != 3 || $('#SuggesstType').val() == 0) {
            checkFlag = true;
            $('#SuggesstType').val("3");
            //$('#IsClose').val("2");
            $($('#btnSendXR').children()).css('border', '')
            $($('#btnSendVPL').children()).css('border', '')
            $($('#btnClose').children()).css('border', '1px solid black')
        } else {
            checkFlag = false;
            $('#SuggesstType').val("0");
            //$('#IsClose').val("0");
            $($('#btnSendXR').children()).css('border', '')
            $($('#btnSendVPL').children()).css('border', '')
            $($('#btnClose').children()).css('border', '')
        }
        //checkFlag = true;
        //$('#SuggesstType').val("3");
    }

    //Result sever return when save success
    // Cho phép lưu nhập tiếp và lưu sao chép ở màn hình hồ sơ nợ thương mại và nợ tiêu dùng
    this.saveSuccess = function (result) {
        // Update Save status
        ASOFT.form.updateSaveStatus('DRF2021', result.Status, result.Data);
        ASOFT.helper.showErrorSeverOption(0, result, 'DRF2021', function () {
            // Chuyển hướng xử lý nghiệp vụ
            switch (DRF2021.actionSaveType) {
                case 1: // Trường hợp lưu & nhập tiếp
                    //$('form#DRF2021 input').val(null);
                    window.location.reload(true);
                    if (window.parent.DRF2020.formStatus == 4) {
                        if (window.parent.$('#viewPartial').length > 0) {
                            var urlpost = window.parent.$('#UrlDRF2012M').val();
                            if (!urlpost) urlpost = window.parent.$('#UrlDRF2002M').val();
                            ASOFT.helper.post(urlpost,
                              { apk: window.parent.$('#APK').val() }, function (data) {
                                  window.parent.$('#viewPartial').html(data);
                              });

                            //window.parent.location.reload()
                            window.parent.ASOFT.form.setSameWidth("asf-content-block");
                        }
                    }
                    break;
                case 2: // Trường hợp lưu & sao chép
                    DRF2021.debtorName = $('#DebtorName').val();
                    DRF2021.getVoucherNo(result.Data, 2);
                    $('#DRF2021').find('input[type="text"], textarea').change(function () {
                        DRF2021.isSaved = false;
                    });
                    DRF2021.isSaved = true;
                    if (window.parent.DRF2020.formStatus == 4) {
                        if (window.parent.$('#viewPartial').length > 0) {
                            var urlpost = window.parent.$('#UrlDRF2012M').val();
                            if (!urlpost) urlpost = window.parent.$('#UrlDRF2002M').val();
                            ASOFT.helper.post(urlpost,
                              { apk: window.parent.$('#APK').val() }, function (data) {
                                  window.parent.$('#viewPartial').html(data);
                              });

                            //window.parent.location.reload()
                            window.parent.ASOFT.form.setSameWidth("asf-content-block");
                        }
                    }
                    console.log('save copy success');
                    break;
                case 3: // Trường hợp lưu và đóng
                    if ($('#IsCall').val() == 1) {
                        //Load grid call
                        var grids = ASOFT.helper.getKendoUI($(window.parent.$('#contentMaster')), 'grid');
                        $.each(grids, function () {
                            this.value.dataSource.read();
                        });

                        //console.log('IsCall: Save success');
                        //ASOFT.asoftPopup.hideIframe(true);
                    }

                    if (window.parent.$('#viewPartial').length > 0) {
                        var urlpost = window.parent.$('#UrlDRF2022M').val();
                        if (!urlpost) {
                            urlpost = window.parent.$('#UrlDRF2012M').val() ? window.parent.$('#UrlDRF2012M').val() : window.parent.$('#UrlDRF2002M').val();
                            ASOFT.helper.post(urlpost,
                             { apk: window.parent.$('#APK').val() }, function (data) {
                                 window.parent.$('#viewPartial').html(data);
                             });
                        } else {
                            ASOFT.helper.post(urlpost,
                              { apk: result[0].Data }, function (data) {
                                  window.parent.$('#viewPartial').html(data);
                              });
                            window.parent.location.reload()
                        }
                    }
                    else {
                        // Reload grid
                        window.parent.DRF2020.DRF2020Grid.dataSource.page(1);
                    }
                    console.log('Save success');
                    ASOFT.asoftPopup.hideIframe(true);
                    break;
                default:
                    break;
            }

            if ($('#IsCall').val() == 1) {

                if ($(window.parent.$('#contentMaster')).length > 0) {
                    //Load grid call
                    var grids = ASOFT.helper.getKendoUI($(window.parent.$('#contentMaster')), 'grid');
                    $.each(grids, function () {
                        this.value.dataSource.read();
                    });
                }
                else {
                    if ($('#TableID').val() == "DRT2000") {
                        window.parent.DRF2000.DRF2004Grid1.dataSource.read();
                        window.parent.parent.DRF2000.DRF2004Grid.dataSource.read();
                    }
                    if ($('#TableID').val() == "DRT2010") {
                        window.parent.DRF2010.DRF2014Grid1.dataSource.read();
                        window.parent.parent.DRF2010.DRF2014Grid.dataSource.read();
                    }

                }

            }
            else {
                // Refresh data
                if (window.parent.DRF2020.DRF2020Grid) {
                    // Reload grid
                    window.parent.DRMPeriodFilter.isDate = 0
                    window.parent.DRF2020.DRF2020Grid.dataSource.page(1);
                } else {
                    window.location.reload(true);
                }
            }
        }, null, null, true);

        if (result.Status == 1 && result.MessageID == 'DRFML000017') {
            $('#ProcessingID').val(result.Data.VoucherNo);
            $('#LastKey').val(result.Data.LastKey);
            $('#APKDRT4444').val(result.Data.LastKeyAPK);
        }
        //if ($('#SuggesstType').val() != 0) {
        //    var urlGetCV = $('#UrlGetDataCV').val();
        //    var data = {
        //        ContractNo: $('#ContractNo').val(),
        //        TableName: $('#TableID').val()
        //    }
        //    ASOFT.helper.postTypeJson(urlGetCV, data, DRF2021.saveSuccess2);

        //    if ($('#TableID').val() == "DRT2000") {
        //        window.parent.DRF2001.DRF2073GridDocument.dataSource.read();
        //        window.parent.DRF2001.DRF2074GridCloseResume.dataSource.read();
        //    }
        //    else if ($('#TableID').val() == "DRT2010") {
        //        window.parent.DRF2011.DRF2073GridDocument.dataSource.read();
        //        window.parent.DRF2011.DRF2074GridCloseResume.dataSource.read();
        //    }
        //}

        ASOFT.asoftLoadingPanel.panelText = 'Loading.....';
    }

    this.saveSuccess2 = function (data) {
        if (data != null) {
            btnSendXRchild = $('#btnSendXR').data('kendoButton');
            btnSendVPLchild = $('#btnSendVPL').data('kendoButton');
            btnClosechild = $('#btnClose').data('kendoButton');

            btnSendXR = window.parent.$('#btnSendXR').data('kendoButton');
            btnSendVPL = window.parent.$('#btnSendVPL').data('kendoButton');
            btnClose = window.parent.$('#btnClose').data('kendoButton');

            btnSendXRparent = window.parent.parent.$('#btnSendXR').data('kendoButton');
            btnSendVPLparent = window.parent.parent.$('#btnSendVPL').data('kendoButton');
            btnCloseparent = window.parent.parent.$('#btnClose').data('kendoButton');

            btnSendXR.enable(true);
            btnSendXRparent.enable(true);
            btnSendXRchild.enable(true);

            btnSendVPL.enable(true);
            btnSendVPLparent.enable(true);
            btnSendVPLchild.enable(true);

            btnClose.enable(true);
            btnCloseparent.enable(true);
            btnClosechild.enable(true);

            var isSendXR = data.IsXR;
            var isSendVPL = data.IsVPL;
            var isClose = data.IsClose;
            var isClosed = data.IsClosed;

            if (btnSendXR && btnSendVPL && btnClose && btnSendXRparent && btnSendVPLparent && btnCloseparent) {
                if (!(isSendXR == 0
                    || isSendXR == 3
                    || isSendXR == 5
                    || isSendXR == 7
                    || (isSendXR == null || isSendXR == ''))
                    || isClosed == 1) {
                    btnSendXR.enable(false);
                    btnSendXRparent.enable(false);
                }

                if (!(isSendVPL == 0
                    || isSendVPL == 3
                    || isSendVPL == 5
                    || isSendVPL == 7
                    || (isSendVPL == null || isSendVPL == ''))
                    || isClosed == 1) {
                    btnSendVPL.enable(false);
                    btnSendVPLparent.enable(false);
                }

                if (!(isClose == 0
                    || isClose == 3
                    || isClose == 5
                    || isClose == 7
                    || (isClose == null || isClose == ''))
                    || isClosed == 1) {
                    btnClose.enable(false);
                    btnCloseparent.enable(false);
                }
            }



            $('#IsSendXR').val(isSendXR);
            $('#IsSendVPL').val(isSendVPL);
            $('#IsClose').val(isClose);
            $('#IsClosed').val(isClosed);

            window.parent.$('#IsSendXR').val(isSendXR);
            window.parent.$('#IsSendVPL').val(isSendVPL);
            window.parent.$('#IsClose').val(isClose);
            window.parent.$('#IsClosed').val(isClosed);

            window.parent.parent.$('#IsSendXR').val(isSendXR);
            window.parent.parent.$('#IsSendVPL').val(isSendVPL);
            window.parent.parent.$('#IsClose').val(isClose);
            window.parent.parent.$('#IsClosed').val(isClosed);
        }
    }

    // Save Copy button events
    this.btnSaveCopy_Click = function () {
        DRF2021.actionSaveType = 2;
        DRF2021.saveData();
    };

    // Save Next button events
    this.btnSaveNext_Click = function () {
        DRF2021.actionSaveType = 1;
        DRF2021.saveData();
    };

    // Save button events
    this.btnSave_Click = function () {
        DRF2021.actionSaveType = 3;
        DRF2021.saveData();
    };

    // show popup
    this.showPopup = function (url, data) {
        // [1] Format url with object data
        var postUrl = ASOFT.helper.renderUrl(url, data);

        // [2] Render iframe
        ASOFT.asoftPopup.showIframe(postUrl, {});
    };

    // Hide Iframes
    this.closePopup = function () {
        if (!ASOFT.form.formClosing('DRF2021') && !DRF2021.isSaved) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
                DRF2021.btnSave_Click, function () {
                    ASOFT.asoftPopup.hideIframe(true);
                });
        }
        else {
            ASOFT.asoftPopup.hideIframe(true);
        }
        console.log('close popup');
    };

    this.contractNo_Changed = function (e) {
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        DRF2021.getVoucherNo();
        console.log('contract no change');
    };

    this.getVoucherNo = function (contractNo, action) {
        var dataItem = ASOFT.helper.getObjectData();

        if (contractNo && !dataItem) {
            var data = [];
            data.push(contractNo)
            ASOFT.helper.postTypeJson("/DRM/DRF2020/GetVoucherNo", data, function (result) {
                dataItem = result[0];
            });
        }
        var debtorName = dataItem ? dataItem.DebtorName : DRF2021.debtorName;

        //if (contractNo && !dataItem) {
        //    dataItem = {
        //        ContractNo: contractNo
        //    };
        //}
        var data = {
            contractNo: dataItem ? dataItem.ContractNo : '',
            voucherTypeID: 'ProcessingID'
        }
        ASOFT.helper.post(window.parent.$('#UrlCreateProcessingID').val(), data, function (result) {
            $('#ProcessingID').val(result.VoucherNo);
            $('#APKDRT4444').val(result.LastKeyAPK);
            $('#LastKey').val(result.LastKey);
        });

        $('#TeamID').val(dataItem.TeamID);
        $('#APK').val(dataItem.APK);
        $('#ContractNo').val(dataItem.ContractNo);
        $('#DebtorName').val(debtorName);
        $('#TableID').val(dataItem.TableID);
        comboActionEmp.value($("#UserID").val());
        btnSendXR = $('#btnSendXR').data('kendoButton');
        btnSendVPL = $('#btnSendVPL').data('kendoButton');
        btnClose = $('#btnClose').data('kendoButton');

        btnSendXR.enable(true);
        btnSendVPL.enable(true);
        btnClose.enable(true);

        var isSendXR = $('#IsSendXR').val(dataItem.IsSendXR).val();
        var isSendVPL = $('#IsSendVPL').val(dataItem.IsSendVPL).val();
        var isClose = $('#IsClose').val(dataItem.IsClose).val();
        var isClosed = $('#IsClosed').val(dataItem.IsClosed).val();

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
                || dataItem.IsBankClose == 1) {
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
                || dataItem.IsBankClose == 1) {
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
                || dataItem.IsBankClose == 1) {
                btnClose.enable(false);
            }
        }

        //Load combo
        comboActionAddr.dataSource.read();
        comboNextActionAddr.dataSource.read();
        comboNextActionAddr2.dataSource.read();
        comboNextActionAddr3.dataSource.read();
        comboActionEmp.dataSource.read();
        comboActionEmp2.dataSource.read();
        comboActionEmp3.dataSource.read();
        comboNextActionID.dataSource.read();

        $($('#btnSendXR').children()).css('border', '')
        $($('#btnSendVPL').children()).css('border', '')
        $($('#btnClose').children()).css('border', '')
        console.log('get voucher no');
    }

    this.checkContractNo = function () {
        var inValid = true;
        var data = {
            contractNo: $('#ContractNo').val()
        };
        ASOFT.helper.post(window.parent.$('#UrlCheckContractNo').val(), data, function (result) {
            ASOFT.form.clearMessageBox();
            DRF2021.debtorName = result.Data.debtorName;
            if (result.Status == 2) {
                ASOFT.form.displayMessageBox('#DRF2021', [ASOFT.helper.getMessage(result.MessageID)]);
                inValid = false;
            }
        });

        console.log('check voucher no');
        return inValid;
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
            contractNo: $('#ContractNo').val(),
            formStatus: window.parent.DRF2020.formStatus
        }
        return data;
    }

    this.comboBox_Changed = function () {
        ASOFT.form.checkItemInListFor(this, 'DRF2021');
        console.log('combo ' + $(this.element).attr('id') + 'change');
    }

    //Combox loaded data
    this.comboBox_RequestEnd = function (e) {
        DRF2021.countCombo++;
        if (DRF2021.countCombo == DRF2021.comboNames.length) {
            DRF2021.isEndRequest = true;
            DRF2021.btnSave.enable(true);
        }

        console.log('combo ' + $(this.element).attr('id') + 'end request');
    }

    this.comboBox_Open = function () {
        var cvXR = $('#btnSendXR');
        var cvVPL = $('#btnSendVPL');
        var dCV = $('#btnClose');
        var item = [cvXR, cvVPL, dCV];

        DRF2021.loadDataComboBox(this, item);
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

    //load panel lịch sử
    this.expandPanel = function (e) {
        if (e.item.children[1].id == "panelbar-3") {
            ASOFT.helper.post($('#UrlHistory').val(),
                              null, function (data) {
                                  $('#panelbar-3').html(data);
                              });
        }
    }
}