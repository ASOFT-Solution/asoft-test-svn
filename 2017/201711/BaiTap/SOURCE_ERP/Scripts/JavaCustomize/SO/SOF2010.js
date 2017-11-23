$(document).ready(function () {

    var VoucherNo = $(".VoucherNo");
    $(".VoucherNo").remove();
    $(".VoucherTypeID").before(VoucherNo);

    var ObjectName = $(".ObjectName");
    $(".ObjectName").remove();
    $(".OrderStatus").before(ObjectName);

    if ($("#AccountID").val() != null && $("#AccountID").val() != "")
    {
        $("#BtnFilter").trigger('click');
    }

    if ($('meta[name=customerIndex]').attr('content') != 57) {
        var btnAddCommit = '<li><a class="k-button k-button-icontext asf-button" id="BtnFilter" style="" data-role="button" role="button" aria-disabled="false" tabindex="0" onclick="btnAddCommit_Click()"><span class="asf-button-text">Giao hộ</span></a></li>';

        $(".asf-toolbar").append(btnAddCommit);
    }

    var dataFormFilter = sessionStorage.getItem('dataFormFilter');//localStorage.getItem('dataFormFilter');

    var dataFormFilters = JSON.parse(dataFormFilter);
    if (dataFormFilters) {
        $('#VoucherNo_SOF2010').val(dataFormFilters.VoucherNo_SOF2010);
        $('#VoucherTypeID_SOF2010').val(dataFormFilters.VoucherTypeID_SOF2010);
        $('#ObjectName_SOF2010').val(dataFormFilters.ObjectName_SOF2010);
        var cboOrderStatus = $('#OrderStatus_SOF2010').data("kendoComboBox");

        if (dataFormFilters.OrderStatus_SOF2010) {
            cboOrderStatus.select(parseInt(dataFormFilters.OrderStatus_SOF2010));
        }
       
        if (dataFormFilters.rdoFilter == 1) {
            

            $("#FromDatePeriodControl").data("kendoDatePicker").enable(true);
            $("#ToDatePeriodControl").data("kendoDatePicker").enable(true);
            $("#CheckListPeriodControl").data("kendoDropDownList").enable(false);

            $("#FromDatePeriodControl").data("kendoDatePicker").value(dataFormFilters.FromDatePeriodControl);
            $("#ToDatePeriodControl").data("kendoDatePicker").value(dataFormFilters.ToDatePeriodControl);
        } else {      
            $("#rdoFilterPeriod").prop('checked', 'checked')
            var isDateCheck = (dataFormFilters.rdoFilter == '1');
            $("#FromDatePeriodControl").data("kendoDatePicker").enable(isDateCheck);
            $("#ToDatePeriodControl").data("kendoDatePicker").enable(isDateCheck);

            var cboCheckListPeriodControl = $("#CheckListPeriodControl").data("kendoDropDownList");
            cboCheckListPeriodControl.enable(!isDateCheck);
            cboCheckListPeriodControl.text(dataFormFilters.CheckListPeriodControl.split(',').length + "Chọn");
            $("#CheckListPeriodControl").val(dataFormFilters.CheckListPeriodControl);
            if (isDateCheck) {
                $("#IsPeriod").val('0');
            }
            else {
                $("#IsPeriod").val('1');
            }
        }
        refreshGrid();
    }
})


function btnAddCommit_Click() {
    ASOFT.form.clearMessageBox();
    GridKendo = $('#GridOT2001').data('kendoGrid');
    var records = ASOFT.asoftGrid.selectedRecords(GridKendo);
    if (records.length == 0) return;
    if (records.length > 1)
    {
        ASOFT.dialog.messageDialog("Chỉ được chọn 1 đơn hàng");
        return;
    }
    ASOFT.asoftPopup.showIframe("/PopupMasterDetail/Index/SO/SOF2001?PK=" + records[0]["SOrderID"] + "&DivisionID=" + records[0]["DivisionID"], {});
}

function onAfterFilter() {
    var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
    //localStorage.setItem('dataFormFilter', JSON.stringify(datamaster));
    sessionStorage.setItem('dataFormFilter', JSON.stringify(datamaster));
}

function onAfterClearFilter() {
    $("#IsPeriod").val('0');
    $("#rdoFilterDate").val("1");
    $("#rdoFilterPeriod").val("0");
    $("#rdoFilterDate").prop('checked', 'checked');
    $("#FromDatePeriodControl").data("kendoDatePicker").enable(true);
    $("#ToDatePeriodControl").data("kendoDatePicker").enable(true);
    $("#CheckListPeriodControl").data("kendoDropDownList").enable(false);

    $("#FromDatePeriodControl").data("kendoDatePicker").value(new Date());
    $("#ToDatePeriodControl").data("kendoDatePicker").value(new Date());

    sessionStorage.removeItem('dataFormFilter');
    //sessionStorage.setItem('dataFormFilter', JSON.stringify(datamaster));
}

