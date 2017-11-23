//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     07/06/2016     Quang Chiến       Tạo mới
//####################################################################


$(document).ready(function () {
    $(".grid_6").addClass("form-content");
    $(".grid_6").removeClass();

    var date = new Date();
    var date1 = new Date();
    //var newdate = new Date(date);
    //newdate.setDate(newdate.getDate() - 7);
    
    var daynow = date.getDay();//curDate.getDay();
    var min = 1;
    var max = 5;

    if (0 < daynow < 6) {        
        var dayStart = new Date(date.setDate(date.getDate() - daynow + min));
        var dayfinish = new Date(date1.setDate(date1.getDate() - daynow + max));
    }
    

    var urlVATAccountID = "/Partial/Content1/KPI/EF1001";
    ASOFT.partialView.Load(urlVATAccountID, ".IsHours", 0);
    
    if ($('#isUpdate').val() == 'True') {
        $("#IsHours").kendoNumericTextBox({
            format: "0.00",
            min: 0,
            max: 12
        });

        $('#Date').kendoDatePicker({
            format: 'dd/MM/yyyy',
            max: dayfinish,//date,
            min: dayStart,//newdate
            value: new Date($('#Date1').val().split(' ')[0].split('/')[2], $('#Date1').val().split(' ')[0].split('/')[1] - 1, $('#Date1').val().split(' ')[0].split('/')[0])
        }).data("kendoDatePicker");

        if ($('#CheckConfirmUser').val() == '1') {
            $('#Date').prop("readonly", true);
            $("#ProjectID").data("kendoComboBox").readonly()
            $("#TypeEffort").data("kendoComboBox").readonly()
            $('#Date').data("kendoDatePicker").readonly()
            var isHours = $("#IsHours").data("kendoNumericTextBox");
            isHours.readonly();
            $('.TypeEffort').parent().append($('.IsHours'))
            $('.IsHours').parent().append($('.IsConfirm'))
        } else {            
            $('.TypeEffort').parent().append($('.UserConfirmID'))
            $('.UserConfirmID').parent().append($('.IsHours'))
        }
    } else {
        if ($('#isInherit').val() == 'False') {
            $('#Date').kendoDatePicker({
                format: 'dd/MM/yyyy',
                max: dayfinish,//date,
                min: dayStart//newdate
            }).data("kendoDatePicker");

            $("#IsHours").kendoNumericTextBox({
                format: "0.00",
                value: "0",
                min: 0,
                max: 12
            });

            $('.TypeEffort').parent().append($('.UserConfirmID'))
            $('.UserConfirmID').parent().append($('.IsHours'))
        } 
    }

    
})


function SaveUpdate_Click() {
    isUpdate = true;
    action = 3;
    checkunique = 1;
    if ($('#isInherit').val() == 'True') {
        save("/KPI/KPIF2000/UpdateAll")
    } else {
        save(urlupdate);
    }
}

function CustomSavePopupLayout() {
    var key1 = [];
    var value1 = [];
    if ($('#isInherit').val() == 'True') {
        var GridKendo = parent.GetDataGridParent("Effort");
        var records = ASOFT.asoftGrid.selectedRecords(GridKendo);
        if (records.length == 0)
            return;
        var custom = [];
        var data = null;

        var dataFormFilter = sessionStorage.getItem('dataFormFilter_KPIF2000');
        var dataFormFilters = JSON.parse(dataFormFilter);
        if (dataFormFilters) {
            data = dataFormFilters;
        } else {
            data = parent.GetDataFormFilter();
        }

        $.each(data, function (key, value) {
            if (key.indexOf("_input") == -1) {
                if (key != "item.TypeCheckBox" && key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key != "CheckInList") {
                    value1.push(value);
                    key1.push(key.split('_')[0]);
                }
            }
        })

        var numcheck = parent.GetCheckAll();
        value1.push(numcheck);
        key1.push("IsCheckALL");


        var valuepk = [];
        if (numcheck == 0) {
            for (var i = 0; i < records.length; i++) {
                valuepk.push(records[i]["EffortID"]);
            }
        }

        valuepk = valuepk.join(',');
        value1.push(valuepk);
        key1.push("EffortIDList");
        value1.push(parent.GetIsSearch());
        key1.push("IsSearch");

        var datapopup = ASOFT.helper.dataFormToJSON(id);

        value1.push(datapopup["IsConfirm"]);
        key1.push("IsSatusConfirm")

    } else {
        var data = ASOFT.helper.dataFormToJSON(id);
        data.Content = $('textarea#Content1').val() ? $('textarea#Content1').val() : '';

        $.each(data, function (key, value) {
            if (key != "item.TypeCheckBox" && key != "Unique") {
                if (key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key != "CheckInList") {
                    key1.push(key);
                    var vl = Array();
                    if (value == "false")
                        value = "0";
                    if (value == "true")
                        value = "1";
                    vl.push(data[key + "_Content_DataType"], value);
                    value1.push(vl);
                }
            }
        })
    }
    var data1 = [];
    data1.push(key1)
    data1.push(value1)
    return data1;
}

function CustomerCheck() {
    
    var Check = false;
    if ($('#CheckConfirmUser').val() != '1'){
        if ($('#CheckConfirmUser').val() != '2') {
            var data = {
                EffortID: $('#EffortID').val(),
                IsHours: $('#IsHours').val(),
                Date: $('#Date').val()
            };

            ASOFT.helper.postTypeJson("/KPI/KPIF2000/getTotalHours", data, function (result) {
                if (!result.check) {
                    ASOFT.form.displayMessageBox('#KPIF2001', [ASOFT.helper.getMessage('KPIFML000001').f(result.hours)], null);
                    Check = true;
                }
            })
        }
    }
    return Check;
}

function onAfterInsertSuccess(result, action1) {
    if (result.Status == 0) {
        if (action1 == 1) {
            var numerictextbox = $("#IsHours").data("kendoNumericTextBox");
            numerictextbox.value("0");
            $("textarea#Content1").val('');
        }
        if (action1 == 3) {
            window.parent.IsCheckExecute = true;
            content = ASOFT.form.createMessageBox([ASOFT.helper.getMessage(result.MessageID)], undefined, 'asf-panel-info');
            $(window.parent.FormFilter).prepend(content);
        }
    } else {
        if (action1 == 3) {
            window.parent.IsCheckExecute = true;
            content = ASOFT.form.createMessageBox([ASOFT.helper.getMessage(result.MessageID)]);
            $(window.parent.FormFilter).prepend(content);
        }
    }
}

function onAfterSave() {
    parent.refreshGrid();
    parent.popupClose();
}
