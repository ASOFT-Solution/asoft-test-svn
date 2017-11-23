//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     25/08/2014      Đức Quý         Tạo mới
//####################################################################

$(document).ready(function () {
    CIF1041.CIF1041Grid = ASOFT.asoftGrid.castName('CIF1041Grid');
    CIF1041.comboEmailGroup = ASOFT.asoftComboBox.castName('EmailGroupID');
    CIF1041.comboDes = ASOFT.asoftComboBox.castName('ShowDescriptionID');
    CIF1041.editor = $('#EmailBody').data("kendoEditor");

    //if ($("#BtnSaveClose").data("kendoButton") != null) {
    //    $("#BtnSaveClose").data("kendoButton").enable(false);
    //}

    $('#rdHTML').change(function (e) {
        if ($(this).prop('checked')) {
            CIF1041.editor.options.encoded = true;
        }
    });

    $('#rdHTML').change(function (e) {
        if ($(this).prop('checked')) {
            CIF1041.editor.options.encoded = false;
        }
    });

    if (CIF1041.CIF1041Grid) {//Set STT on gridview
        CIF1041.CIF1041Grid.bind('dataBound', function () {
            //$("#BtnSaveClose").data("kendoButton").enable(true);
            CIF1041.rowNum = 0;
        });
    }
});

CIF1041 = new function () {
    this.invalidGroup = false;
    this.formStatus = null;
    this.rowNum = 0;
    this.CIF1041Grid = null;
    this.isSaved = false;
    this.emailGroup = null;
    this.comboEmailGroup = null;
    this.comboDes = null;
    this.editor = null;
    this.comboNames = ['EmailGroupID'];

    this.renderNumber = function () {
        return ++CIF1041.rowNum;
    }

    // Close button events
    this.btnClose_Click = function () {
        // Hide Iframe
        CIF1041.closePopup();
    };

    //Get data form DRF1041
    this.getFormData = function () {
        var data = ASOFT.helper.dataFormToJSON('CIF1041', 'List', CIF1041.CIF1041Grid);
        for (var i = 0; i < data.List.length; i++)
        {
            data.List[i].OrderNo = i + 1;
        }
        return data;
    }

    //Post data and update data
    this.saveData = function () {//[a-zA-z0-9][a-zA-z0-9]
        var regex = new RegExp(/\#\w+/gi); //Regular expression for find params
        if (ASOFT.form.checkRequiredAndInList('CIF1041', CIF1041.comboNames)) {
            return;
        }

        //Remove message cảnh báo
        $('#CIF1041').removeClass('asf-focus-input-error');

        //Kiểm tra trùng GroupID
        if (CIF1041.invalidGroup) {
            var data = CIF1041.CIF1041Grid.dataSource.data();
            var groupIDList = CIF1041.groupBy_DataSource(data);
            var result = true;

            //Check GroupID
            $.each(groupIDList, function () {
                if (this.length > 1) {
                    msg = ASOFT.helper.getMessage('00ML000084');
                    ASOFT.form.displayError('#CIF1041', msg);
                    CIF1041.invalidGroup = true;
                    result = false;
                    return result;
                }
            })

            if (!result) return;//Không cho lưu
        }

        var data = CIF1041.getFormData();
        var arr = data.EmailBody.split("img");
        data.EmailBody = arr.join("img style=max-width:680px; min-width:680px; min-height:111px; max-height:111px");

        if (data.List.length == 1
            && (data.List[0].MethodID == null || data.List[0].MethodID == "")
            && (data.List[0].ShowDescriptionID == null || data.List[0].ShowDescriptionID == "")
            && (data.List[0].ShowDescriptionName == null || data.List[0].ShowDescriptionName == "")) { //Lưới địa chỉ rỗng => không post lên server
            data.List = null;
        }
        else {
            ////Count parameter
            //var params = CIF1041.searchParams(data.EmailBody, data.List); 

            ////Check parameter = parameter of content
            //if (data.List.length < Object.keys(params).length) {
            //    msg = ASOFT.helper.getMessage('DRFML000025');
            //    ASOFT.form.displayError('#CIF1041', msg);
            //    return;
            //}

            //Check required
            ASOFT.asoftGrid.editGridRemmoveValidate(CIF1041.CIF1041Grid);
            if (ASOFT.asoftGrid.editGridValidate(CIF1041.CIF1041Grid)) {
                msg = ASOFT.helper.getMessage('00ML000060');
                ASOFT.form.displayError('#CIF1041', msg);
                return;
            }
        }

        ASOFT.helper.postTypeJson(window.parent.CIF1040.urlUpdate, data, CIF1041.saveSuccess);
    }

    //Result sever return when save success
    this.saveSuccess = function (result) {
        CIF1041.rowNum = 0;
        window.parent.CIF1041.rowNum = 0;
        // Update Save status
        ASOFT.form.updateSaveStatus('CIF1041', result.Status, result.Data);
        ASOFT.helper.showErrorSeverOption(0, result, 'CIF1041', function () {
            // Chuyển hướng xử lý nghiệp vụ
            switch (CIF1041.actionSaveType) {
                case 1: // Trường hợp lưu & nhập tiếp
                    //$('form#CIF1041 input').val(null);
                    window.location.reload(true);
                    break;
                case 2: // Trường hợp lưu & sao chép
                    $('#CIF1041').find('input[type="text"], textarea').change(function () {
                        CIF1041.isSaved = false;
                    });
                    CIF1041.isSaved = true;
                    break;
                case 3: // Trường hợp lưu và đóng
                    if (window.parent.$('#viewPartial').length > 0) {
                        ASOFT.helper.post(window.parent.$('#UrlCIF1042M').val(),
                          { templateID: result.Data }, function (data) {
                              window.parent.$('#viewPartial').html(data);
                          });
                        window.parent.ASOFT.form.setSameWidth("asf-content-block");
                    }
                    else {
                        // Reload grid
                        window.parent.CIF1040.CIF1040Grid.dataSource.page(1);
                    }
                    ASOFT.asoftPopup.hideIframe(true);
                    break;
                default:
                    break;
            }

            // Refresh data
            if (window.parent.CIF1040.CIF1040Grid) {
                // Reload grid
                window.parent.CIF1040.CIF1040Grid.dataSource.page(1);
            } else {
                window.location.reload(true);
            }
        }, null, null, true);
    }

    // Save Copy button events
    this.btnSaveCopy_Click = function () {
        CIF1041.actionSaveType = 2;
        CIF1041.saveData();
    };

    // Save Next button events
    this.btnSaveNext_Click = function () {
        CIF1041.actionSaveType = 1;
        CIF1041.saveData();
    };

    // Save button events
    this.btnSave_Click = function () {
        CIF1041.actionSaveType = 3;
        CIF1041.saveData();
    };

    this.deleteParams = function (tag) {
        row = $(tag).parent();
        if (CIF1041.CIF1041Grid.dataSource.data().length == 1) {//Xét rỗng dòng hiện tại nếu lưới còn 1 dòng
            var data = CIF1041.CIF1041Grid.dataSource.data();
            var row = CIF1041.CIF1041Grid.dataSource.data()[0];
            row.set('MethodID', null);
            row.set('ShowDescriptionID', null);
            row.set('ShowDescriptionName', null);
            return;
        }
        ASOFT.asoftGrid.removeEditRow(row, CIF1041.CIF1041Grid, null);
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
        if (!ASOFT.form.formClosing('CIF1041') && !CIF1041.isSaved) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
                CIF1041.btnSave_Click, function () {
                    ASOFT.asoftPopup.hideIframe(true);
                });
        }
        else {
            ASOFT.asoftPopup.hideIframe(true);
        }
        CIF1041.rowNum = 0;
    };

    //Load data => Grid Detail
    this.gridSendData = function () {
        var data = {};
        data.TableID = $('#TableID').val() ? $('#TableID').val() : $('#TableID').text();
        data.ScreenID = $('#ScreenID').val() ? $('#ScreenID').val() : $('#ScreenID').text();
        data.TemplateID = $('#TemplateID').val() ? $('#TemplateID').val() : $('#TemplateID').text();
        data.EmailGroupID = $('#EmailGroupID').val() ? $('#EmailGroupID').val() : $('#EmailGroupID').text();
        return data;
    }

    //Combo CustomerID Changed
    this.emailGroup_Changed = function (e) {
        ASOFT.form.checkItemInListFor(this, 'CIF1041');
       
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        CIF1041.emailGroup = dataItem.ID;
        //$.each(CIF1041.CIF1041Grid.dataSource.data(), function () {
        //    this.set('ShowDescriptionID', null);
        //});
        CIF1041.CIF1041Grid.dataSource.data([]);
        CIF1041.CIF1041Grid.addRow();
    }

    this.check_ShowDesID = function (data, obj) {
        var groupIDList = CIF1041.groupBy_DataSource(data);

        if (groupIDList[obj.value()].length > 1) {
            msg = ASOFT.helper.getMessage('DRFML000026');
            ASOFT.form.displayError('#CIF1041', msg);
            $(obj.element).parent().addClass('asf-focus-input-error');
            $(obj.element).focus();
            CIF1041.invalidGroup = true;
            return;
        }
        else {
            ASOFT.form.clearMessageBox();
        }

        CIF1041.invalidGroup = false;
    }

    this.searchParams = function (content, data) {
        var regex = new RegExp(/\#\w+/gi); //Regular expression for find params
        var params = content.match(regex, 'g');
        var methodID = null;
        var methodIDList = {};
        for (var i = 0; i < params.length; i++) {
            methodID = params[i].slice(1);
            $.each(data, function () {
                if (this.MethodID === params[i]) {
                    if (typeof methodIDList[methodID] === 'undefined') {
                        methodIDList[methodID] = [];
                    }
                    methodIDList[methodID].push(i);
                    return;
                }
            });
        }
        return methodIDList;
    }

    //Group data source => ShowDescriptionID
    this.groupBy_DataSource = function (data) {
        var groupList = {};
        var temp = null;
        for (var i = 0; i < data.length; i++) {
            temp = data[i].ShowDescriptionName;
            if (typeof groupList[temp] === 'undefined') {
                groupList[temp] = [];
            }
            groupList[temp].push(i);
        }
        return groupList;
    }
}

function description_Changed(e) {
    ASOFT.asoftGrid.setValueTextbox(//fix trường hợp  [object object]
            "CIF1041Grid",
            CIF1041.CIF1041Grid,
            ASOFT.asoftGrid.currentCell,
            ASOFT.asoftGrid.currentRow
        );
    var row = $(e.sender.wrapper.parent().parent().children()[0]).text();
    var dtRow = CIF1041.CIF1041Grid.dataSource._data[row - 1];
    var dtCbNow = e.sender.dataSource._data[e.sender.selectedIndex];
    dtRow.ShowDescriptionID = dtCbNow.ShowDescriptionID;
    dtRow.TableID = dtCbNow.TableID;
    dtRow.ScreenID = dtCbNow.ScreenID;
    //Kiểm tra không cho trùng
    var data = CIF1041.CIF1041Grid.dataSource.data();
    CIF1041.check_ShowDesID(data, this);
    
}

function description_SendData() {
    var data = {};
    var dataItem = CIF1041.comboEmailGroup.dataItem(CIF1041.comboEmailGroup.selectedIndex)
    data.emailGroup = dataItem ? dataItem.ID : '';
    data.tableID = dataItem ? dataItem.TableID : '';
    data.screenID = dataItem ? dataItem.ScreenID : '';
    return data;
}