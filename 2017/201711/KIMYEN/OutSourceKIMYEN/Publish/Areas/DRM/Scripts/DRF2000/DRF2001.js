//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     25/08/2014      Đức Quý         Tạo mới
//####################################################################
var IsDRT2011 = false;
var IsDRT2004 = false;
$(document).ready(function () {
    DRF2001.DRF2001Grid = ASOFT.asoftGrid.castName('DRF2001Grid');
    DRF2001.btnSave = $('#BtnSaveClose').data('kendoButton');
    DRF2001.DRF2004Grid1 = ASOFT.asoftGrid.castName('DRF2004Grid1');
    DRF2001.DRF2002Grid = ASOFT.asoftGrid.castName('DRF2002Grid');
    DRF2001.DRF2073GridDocument = ASOFT.asoftGrid.castName('DRF2073GridDocument');
    DRF2001.DRF2074GridCloseResume = ASOFT.asoftGrid.castName('DRF2074GridCloseResume');
    $('#IsCheckedEveryday').parent().find('.asf-form-container').css('pointer-events', 'none');

    if (DRF2001.DRF2001Grid) {
        DRF2001.DRF2001Grid.bind('dataBound', function () {
            DRF2001.rowNum = 0;
        });
        $('#DRF2001Grid').on("click", function (event) {
            var str = $("#DRF2001Grid").data("kendoGrid").select().find("Input#Address").val();
            if (str != undefined) {
                $("#DRF2001Grid").data("kendoGrid").select().find("Input#Address").css("text-transform", "uppercase");
                $("#DRF2001Grid").data("kendoGrid").select().find("Input#Address").parent().css("text-transform", "uppercase");
            }
        });
    }

    DRF2001.DRF2001EmployeeGrid = ASOFT.asoftGrid.castName('DRF2001EmployeeGrid');

    if (DRF2001.DRF2001EmployeeGrid) {
        DRF2001.DRF2001EmployeeGrid.bind('dataBound', function () {
            DRF2001.rowNumEmp = 0;
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
    DRF2001.comboCity = ASOFT.asoftComboBox.castName('ComboBoxCityID');

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

    var tabStrip = $("#DRF2001Tab").kendoTabStrip().data("kendoTabStrip");
    if (tabStrip) {
        //Lock tab gửi công văn  và tab đóng hồ sơ
        var isSendXR1 = $('#IsSendXR1').val();
        var isSendVPL1 = $('#IsSendVPL1').val();
        var isClose1 = $('#IsClose1').val();
            if (!(isClose1 == 2 || isClose1 == 4 || isClose1 == 6)) {
                $("#DRF2001Tab-10").css({ "pointer-events": "none", "opacity": "0.8" });
            }
            if (!(isSendXR1 == 2 || isSendXR1 == 4 || isSendXR1 == 6) && !(isSendVPL1 == 2 || isSendVPL1 == 4 || isSendVPL1 == 6)) {
                $("#DRF2001Tab-9").css({ "pointer-events": "none", "opacity": "0.8" });
            }
            //if (isSendXR1 == 1) {
            //    $("#DRF2001Tab-9").css({ "pointer-events": "", "opacity": "" });
            //    if (!(isSendVPL1 == 2 || isSendVPL1 == 4 || isSendVPL1 == 6)) {
            //        $("#DRF2001Tab-9").css({ "pointer-events": "none", "opacity": "0.8" });
            //    }
            //}
        }
    //Lock từng button của tab gửi công văn  và tab đóng hồ sơ
    if (btnSendDoc)
        btnSendDoc.enable(false);
    if (btnCloseDoc)
        btnCloseDoc.enable(false);

    if ($('#InfoSendDispath').val() == 'True') {
        if (isSendXR1 == 6 || isSendVPL1 == 6) {
            btnInfoRoomConfirm.enable(true)
            btnInfoRoomNotConfirm.enable(true)
            btnInfoRoomCancelConfirm.enable(true)
            btnSendDoc.enable(true)
        }
    }
    if ($('#ManagerSendDispath').val() == 'True') {
        if (isSendXR1 == 4 || isSendVPL1 == 4) {
            btnManagerConfirm.enable(true)
            btnManagerNotConfirm.enable(true)
            btnManagerCancelConfirm.enable(true)
            btnSendDoc.enable(true)
        }
    }
    if ($('#LeaderSendDispath').val() == 'True') {
        if (isSendXR1 == 2 || isSendVPL1 == 2) {
            btnTeamLeaderConfirm.enable(true)
            btnTeamLeaderNotConfirm.enable(true)
            btnTeamLeaderCancelConfirm.enable(true)
            btnSendDoc.enable(true)
        }
    }

    if ($('#InfoCloseContract').val() == 'True') {
        if (isClose1 == 6) {
            btnCloseInfoRoomConfirm.enable(true)
            btnCloseInfoRoomNotConfirm.enable(true)
            btnCloseInfoRoomCancelConfirm.enable(true)
            btnCloseDoc.enable(true)
        }
    }
    if ($('#ManagerCloseContract').val() == 'True') {
        if (isClose1 == 4) {
            btnCloseManagerConfirm.enable(true)
            btnCloseManagerNotConfirm.enable(true)
            btnCloseManagerCancelConfirm.enable(true)
            btnCloseDoc.enable(true)
        }
    }
    if ($('#LeaderCloseContract').val() == 'True') {
        if (isClose1 == 2) {
            btnCloseTeamLeaderConfirm.enable(true)
            btnCloseTeamLeaderNotConfirm.enable(true)
            btnCloseTeamLeaderCancelConfirm.enable(true)
            btnCloseDoc.enable(true)
        }
    }

});
var GetCityNameById = function (City)
{
    alert(City);
    alert(DRF2001.comboCity);
    return $.grep(DRF2001.comboCity, function (e) {
        return e.CityID = City;
    })[0].CityName;
};
DRF2001 = new function () {
    this.formStatus = null;
    this.comboCity = null;
    this.rowNum = 0;
    this.rowNumEmp = 0;
    this.DRF2001Grid = null;
    this.DRF2002Grid = null;
    this.DRF2073GridDocument = null;
    this.DRF2074GridCloseResume = null;
    this.DRF2001EmployeeGrid = null;
    this.btnSave = null;
    this.isSaved = false;
    this.isEndRequest = false;
    this.countCombo = 0;
    this.comboNames = ['TeamID', 'CustomerID', 'ContractGroupID', 'Manager'];
    
    var checkFlag = false;

    this.renderNumber = function () {
        return ++DRF2001.rowNum;
    }

    this.renderNumberEmp = function () {
        return ++DRF2001.rowNumEmp;
    }

  
   
    // Close button events
    this.btnClose_Click = function () {
        // Hide Iframe
        DRF2001.closePopup();
    };

    //Get data form DRF2041
    this.getFormData = function () {
        var data = {};
        data = ASOFT.helper.dataFormToJSON('DRF2001', 'List', DRF2001.DRF2001Grid);
        data.ListEmployee = DRF2001.DRF2001EmployeeGrid.dataSource.data();

        //Get control Kendo UI => disabled
        var kendoControl = ASOFT.helper.getAllKendoUI($('#DRF2001'));
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

        data.IsNTDMethod = $('#IsNTDMethod').prop('checked');

        //return false;
        return data;
    }

    //Post data and update data
    this.saveData = function () {
        if (ASOFT.form.checkRequiredAndInList('DRF2001', DRF2001.comboNames)) {
            return;
        }
        //kiểm tra thêm dữ liệu trên lưới địa chỉ mà không nhập dữ liệu
        var grid = $("#DRF2001Grid").data('kendoGrid');
        $("#DRF2001Grid").removeClass('asf-focus-input-error');
        ASOFT.asoftGrid.editGridRemmoveValidate(grid);

        var gridemp = $("#DRF2001EmployeeGrid").data('kendoGrid');
        $("#DRF2001EmployeeGrid").removeClass('asf-focus-input-error');
        ASOFT.asoftGrid.editGridRemmoveValidate(gridemp);
        var listRequired = ['Address', 'Ward', 'DistrictName', 'District', 'City', 'CityName', 'Note', 'IsSend', 'APK'];

        if (ASOFT.asoftGrid.editGridValidateNoEdit(grid, listRequired)) {
            var msg = ASOFT.helper.getMessage("00ML000060");
            ASOFT.form.displayError("#DRF2001", msg);
            return
        }
        var data = DRF2001.getFormData();
        if ($('#IsCheckedEveryday').is(':checked')) {
            if (ASOFT.form.checkDateInPeriod('DRF2001', data.BeginDate, data.EndDate, ['ActionDate'])) {
                return;
            }

            //Check NextActionDate < ActionDate thì báo lỗi
            var NextActionDate = kendo.parseInt(kendo.toString(kendo.parseDate(data.NextActionDate, "dd/MM/yyyy"), "yyyyMMdd"));
            var ActionDate = kendo.parseInt(kendo.toString(kendo.parseDate(data.ActionDate, "dd/MM/yyyy"), "yyyyMMdd"));
            $('#NextActionDate').removeClass('asf-focus-input-error')
            if (ActionDate > NextActionDate) {
                $('#NextActionDate').addClass('asf-focus-input-error');
                ASOFT.form.displayMessageBox("#" + 'DRF2001', [ASOFT.helper.getMessage('DRFML000044')], null);
                return;
            }
        }
        if (data) {
            data.TeamID = data.TeamID[0];
            data.APKDRT4444 = $('#APKDRT4444').val();
            data.LastKey = $('#LastKey').val();
            data.IsCheckedEveryday = $('#IsCheckedEveryday').is(':checked');
            data.IsSendXR1 = $('#IsSendXR1').val();
            data.IsSendVPL1 = $('#IsSendVPL1').val();
            data.IsClose1 = $('#IsClose1').val();
            data.TableID = 'DRT2000';

            if (grid.tbody.find('.k-state-selected').closest('tr').length > 0) {
                data.IsDRT2011 = true;
            }
            if (gridemp.tbody.find('.k-state-selected').closest('tr').length > 0) {
                data.IsDRT2004 = true;
            }
            if (IsDRT2011) {
                data.IsDRT2011 = true;
            }
            if (IsDRT2004) {
                data.IsDRT2004 = true;
            }
        }

        if (!DRF2001.checkNextAction(data)) {
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

        // Remove dữ liệu rỗng
        if (data.ListEmployee) {
            data.ListEmployee.forEach(function (e, i) {
                if (e.EmployeeID == null) {
                    data.ListEmployee.remove(e);
                }
            });

            //Kiểm tra trùng Employee
            var empList = DRF2001.groupBy_DataSource(data.ListEmployee);
            var result = true;

            //Check GroupID
            $.each(empList, function () {
                if (this.length > 1) {
                    msg = ASOFT.helper.getMessage('DRFML000030');
                    ASOFT.form.displayError('#DRF2001', msg);
                    DRF2001.DRF2001EmployeeGrid.focus(DRF2001.DRF2001EmployeeGrid.dataSource.indexOf(this[0]));
                    DRF2001.invalidGroup = true;
                    result = false;
                    return;
                }
            })

            if (!result) return;//Không cho lưu
        }
        ASOFT.asoftLoadingPanel.panelText = AsoftMessage['DRFML000045'];
        ASOFT.helper.postTypeJsonXR(window.parent.DRF2000.urlUpdate, data, DRF2001.saveSuccess);       
    }

    //Result sever return when save success
    this.saveSuccess = function (result) {
        // Update Save status
            ASOFT.form.updateSaveStatus('DRF2001', result.Status, result.Data);
      
        ASOFT.helper.showErrorSeverOption(0, result, 'DRF2001', function () {
            // Chuyển hướng xử lý nghiệp vụ
            switch (DRF2001.actionSaveType) {
                case 1: // Trường hợp lưu & nhập tiếp
                    //$('form#DRF2001 input').val(null);
                    window.location.reload(true);
                    break;
                case 2: // Trường hợp lưu & sao chép
                    $('#DRF2001').find('input[type="text"], textarea').change(function () {
                        DRF2001.isSaved = false;
                    });
                    DRF2001.isSaved = true;
                    break;
                case 3: // Trường hợp lưu và đóng
                    if (window.parent.$('#viewPartial').length > 0) {
                        ASOFT.helper.post(window.parent.$('#UrlDRF2002M').val(),
                          { apk: result.Data }, function (data) {
                              window.parent.$('#viewPartial').html(data);
                          });                       
                        
                        window.parent.DRF2001.DRF2001Grid.dataSource.read();
                        //window.parent.location.reload()
                        window.parent.ASOFT.form.setSameWidth("asf-content-block");                        
                    }
                    else {
                        // Reload grid
                        window.parent.DRF2000.DRF2000Grid.dataSource.page(1);
                    }
                    ASOFT.asoftPopup.hideIframe(true);
                    break;
                default:
                    break;
            }

            // Refresh data
            if (window.parent.DRF2000.DRF2000Grid) {
                // Reload grid
                window.parent.DRF2000.DRF2000Grid.dataSource.page(1);
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
        DRF2001.actionSaveType = 2;
        DRF2001.saveData();
    };

    // Save Next button events
    this.btnSaveNext_Click = function () {
        DRF2001.actionSaveType = 1;
        DRF2001.saveData();
    };

    // Save button events
    this.btnSave_Click = function () {
        DRF2001.actionSaveType = 3;
        DRF2001.saveData();
    };

    this.deleteAddress = function (tag) {
        row = $(tag).parent();
        IsDRT2011 = true;
        if (DRF2001.DRF2001Grid.dataSource.data().length == 1) {//Xét rỗng dòng hiện tại nếu lưới còn 1 dòng
            var data = DRF2001.DRF2001Grid.dataSource.data();
            var row = DRF2001.DRF2001Grid.dataSource.data()[0];
            row.set('AddressID', null);
            row.set('Address', null);
            row.set('Ward', null);
            row.set('District', null);
            row.set('City', null);
            row.set('AddNote', null);
            return;
        }
        ASOFT.asoftGrid.removeEditRow(row, DRF2001.DRF2001Grid, null);
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
        if (!ASOFT.form.formClosing('DRF2001') && !DRF2001.isSaved) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
                DRF2001.btnSave_Click, function () {
                    ASOFT.asoftPopup.hideIframe(true);
                });
        }
        else {
            ASOFT.asoftPopup.hideIframe(true);
        }
        DRF2001.rowNum = 0;
    };

    //Load data => Grid Address, EveryDay, Payment
    this.drf2002GridSendData = function () {
        var data = {};
        data.ContractNo = $('td#ContractNo').text();
        data.FromPeriodID = $('table tr td input[id=FromPeriodID]').val();
        data.ToPeriodID = $('table tr td input[id=ToPeriodID]').val();
        if (!$('td#ContractNo').text()) {
            data.ContractNo = window.parent.$('td#ContractNo').text();
            data.FromPeriodID = $('table tr td input[id=FromPeriodID]').val();
            data.ToPeriodID = $('table tr td input[id=ToPeriodID]').val();
        }       
        
        return data;
    }

    //Event change form-to
    this.LoadDRF2002Grid = function (e) {
        var FromPeriodID = $('table tr td input[id=FromPeriodID]').val();
        var ToPeriodID = $('table tr td input[id=ToPeriodID]').val();
        
        var date1 = parseDate("1/" + FromPeriodID).getTime();
        var date2 = parseDate("1/" + ToPeriodID).getTime();
        if (date1 > date2) {
            ASOFT.dialog.showMessage('DRFML000037');
            return;
        }

        DRF2001.DRF2002Grid.dataSource.read();
        this.refresh();
    }

    //Combo CustomerID Changed
    this.combo_Changed = function (e) {
        ASOFT.form.checkItemInListFor(this, 'DRF2001');

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

    //Group data source => GroupID
    this.groupBy_DataSource = function (data) {
        var groupIDList = {};
        var temp = null;
        for (var i = 0; i < data.length; i++) {
            temp = data[i].EmployeeID;
            if (typeof groupIDList[temp] === 'undefined') {
                groupIDList[temp] = [];
            }
            groupIDList[temp].push(data[i]);
        }
        return groupIDList;
    }

    this.check_employeeID = function (data, obj) {
        var groupIDList = DRF2001.groupBy_DataSource(data);

        if (groupIDList[obj.value()].length > 1) {
            msg = ASOFT.helper.getMessage('DRFML000030');
            ASOFT.form.displayError('#DRF2001', msg);
            $(obj.element).parent().addClass('asf-focus-input-error');
            $(obj.element).focus();
            DRF2001.invalidGroup = true;
            return;
        }
        else {
            ASOFT.form.clearMessageBox();
        }

        DRF2001.invalidGroup = false;
    }

    this.deleteEmployee = function (tag) {
        row = $(tag).parent();
        IsDRT2004 = true;
        if (DRF2001.DRF2001EmployeeGrid.dataSource.data().length == 1) {//Xét rỗng dòng hiện tại nếu lưới còn 1 dòng
            var data = DRF2001.DRF2001EmployeeGrid.dataSource.data();
            var row = DRF2001.DRF2001EmployeeGrid.dataSource.data()[0];
            row.set('EmployeeID', null);
            row.set('EmployeePercent', 0);
            row.set('ContractNo', null);
            return;
        }
        ASOFT.asoftGrid.removeEditRow(row, DRF2001.DRF2001EmployeeGrid, null);
    }

    //Combox loaded data
    this.comboBox_RequestEnd = function (e) {
        DRF2001.countCombo++;
        if (DRF2001.countCombo == DRF2001.comboNames.length) {
            DRF2001.isEndRequest = true;
            DRF2001.btnSave.enable(true);
        }
    }
   

    //Combox loaded data
    this.comboBoxManager_Post = function () {
        return {
            employeeGroup: $("#TeamID").val()
        }
    }

    var num = 1;//dung cho nut next, prev
    this.BtnPrev_Click = function () {
        var tabStrip = $('#DRF2001Tab').data("kendoTabStrip");
        var ul = $('#DRF2001Tab').data("kendoTabStrip").wrapper.children(".k-tabstrip-items");
        var DRF2001Tab = "DRF2001Tab-";
        var count = $("ul li.k-tabstrip-items").length + 1;;


        var li_list = ul.find($("li[style!='display:none']"));
        
        for (var i = count; i > 0; i--) {
            var tab = DRF2001Tab + i.toString();
            var num_width = li_list.filter("[aria-controls='" + tab + "']").width();
            if (num_width <= 0) {
                break;
            }
        }
        if (i == 0 || i == 1) {
            $(tabStrip.items()[i]).attr("style", "")
            $(tabStrip.items()[i - 1]).attr("style", "")
            $('#BtnPrev').attr("style", "display:none")
            $('#BtnNext').attr("style", "height: 30px;width: 35px; position: absolute; z-index: 1;left: 969px;")
            num = 1;
        } else {
            $(tabStrip.items()[i]).attr("style", "")
            $(tabStrip.items()[i - 1]).attr("style", "margin-left:35px")
            $('#BtnNext').attr("style", "height: 30px;width: 35px; position: absolute; z-index: 1;left: 969px;")
            num = num - 1;
        }
    }


    this.BtnNext_Click = function () {
        var tabStrip = $('#DRF2001Tab').data("kendoTabStrip");
        var ul = $('#DRF2001Tab').data("kendoTabStrip").wrapper.children(".k-tabstrip-items");

        var count = $("ul li.k-tabstrip-items").length + 1;

        var total = 0;
        var DRF2001Tab = "DRF2001Tab-";
        var li_list = ul.find($("li[style!='display:none']"));

        var i = 0;
        for (i = num; i <= count; i++) {
            var tab = DRF2001Tab + i.toString();
            var num_width = li_list.filter("[aria-controls='" + tab + "']").width();
            total += num_width;
            if (ul.width() < total) {
                break;
            }

        }

        if (i == count) {
            $(tabStrip.items()[num - 1]).attr("style", "display:none");
            $('#BtnPrev').attr("style", "height: 30px;width: 35px; position: absolute; z-index: 1;");
            $('#BtnNext').attr("style", "display:none");
        } else {

            $(tabStrip.items()[num - 1]).attr("style", "display:none");
            $(tabStrip.items()[num]).attr("style", "margin-left:35px");
            $('#BtnPrev').attr("style", "height: 30px;width: 35px; position: absolute; z-index: 1;");
            num = num + 1;
        }
    }



    this.openProcessing = function (apk) {
        var url = $('#UrlDRF2022').val();
        //var child = e.parentElement.parentElement.lastElementChild.textContent;
        var fullPath = url + "?apk=" + apk;
        window.open(fullPath,'_blank');
    }

    this.openDRF2061 = function (apk, dispathTypeID) {
        ASOFT.form.clearMessageBox();
        var data = {};
        data.apk = apk;
        data.dispathTypeID = dispathTypeID;

        // Url load dữ liệu lên form
        var postUrl = $("#UrlDRF2061").val();

        // [4] Hiển thị popup
        DRF2001.showPopup(postUrl, data);
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
        DRF2001.showPopup(postUrl, data);
    }

    this.checkBox_Changed = function (tag) {
       
        var row = $(tag).parent().closest('tr');
        var currentRecord = DRF2001.DRF2001Grid.dataItem(DRF2001.DRF2001Grid.select());

        var id = null;
        if (Number($(row.children()[0]).text()) < 10) {
            id = $('#AD0' + Number($(row.children()[0]).text())).val();
        }
        else {
            id = $('#AD' + $(row.children()[0]).text()).val();
        }

        if (id.indexOf('1') == -1) {
            $(tag).prop('checked', $(tag).prop('checked') ? false : true);
        } else {
            currentRecord[tag.id] = $(tag).prop('checked') ? 1 : 0;
        }
    }

    //load panel lịch sử
    this.expandPanel = function (e) {
        if (e.item.children[1].id == "panelbar-10") {
            ASOFT.helper.post($('#UrlHistory').val(),
                          null, function (data) {
                              $('#panelbar-10').html(data);
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

            ASOFT.form.displayMessageBox("#" + 'DRF2001', [ASOFT.helper.getMessage('DRFML000038')], null);
            flag = false;
        }
        if (($('#SuggesstType').val() == "1" && NextActionval != "CVXR") || ($('#SuggesstType').val() == "2" && NextActionval != "CVVPL") || ($('#SuggesstType').val() == "3" && NextActionval != "DND")) {
            ASOFT.form.displayMessageBox("#" + 'DRF2001', [ASOFT.helper.getMessage('DRFML000038')], null);
            flag = false;
        }
        if (NextActionval == "DKT" && (NextPaidAmount == null || NextPaidAmount == "0")) {
            ASOFT.form.displayMessageBox("#" + 'DRF2001', [ASOFT.helper.getMessage('DRFML000043')], null);
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

            $($('#btnSendXR').children()).css('border', '')
            $($('#btnSendVPL').children()).css('border', '1px solid black')
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
               
                $($('#btnSendXR').children()).css('border', '')
                $($('#btnSendVPL').children()).css('border', '')
                $($('#btnClose').children()).css('border', '1px solid black')                
            } else {
                checkFlag = false;
                $('#SuggesstType').val("0");
                //$('#IsClose1').val("0");
                $($('#btnSendXR').children()).css('border', '')
                $($('#btnSendVPL').children()).css('border', '')
                $($('#btnClose').children()).css('border', '')
            }
    }

    this.comboBox_Changed = function () {
        ASOFT.form.checkItemInListFor(this, 'DRF2001');
        console.log('combo ' + $(this.element).attr('id') + 'change');
    }

    this.comboBox_Open = function () {
        var cvXR = $('#btnSendXR');
        var cvVPL = $('#btnSendVPL');
        var dCV = $('#btnClose');
        var item = [cvXR, cvVPL, dCV];

        DRF2001.loadDataComboBox(this, item);
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
            ASOFT.helper.post($('#UrlDRF2001EveryDay').val(),
                          data, function (data1) {
                              $('div#ViewEveryday').html(data1);
                          });
            DRF2001.comboNames = ['TeamID', 'CustomerID', 'ContractGroupID', 'Manager', 'ActionID', 'ActionObjectID',
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
            DRF2001.comboNames = ['TeamID', 'CustomerID', 'ContractGroupID', 'Manager'];
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
        //var IsID=null;
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

        var value = data.sender.element.context.text;
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
        if ($('#IsSendXR1').val() == 2 || $('#IsSendXR1').val() == 4 || $('#IsSendXR1').val() == 6 || $('#IsSendXR1').val() == 7 ) {
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

function employee_Changed() {
    ASOFT.asoftGrid.setValueTextbox(//fix trường hợp  [object object]
            "DRF2001EmployeeGrid",
            DRF2001.DRF2001EmployeeGrid,
            ASOFT.asoftGrid.currentCell,
            ASOFT.asoftGrid.currentRow
        );

    var data = DRF2001.DRF2001EmployeeGrid.dataSource.data();
    DRF2001.check_employeeID(data, this);
}

function employee_Post() {
    return {
        employeeGroup: $("#TeamID").val()
    }
}

function parseDate(str) {
    var mdy = str.split('/');
    return new Date(mdy[2], mdy[1], mdy[0]);
}

