var GridHRMFT2093 = null;

$(document).ready(function () {
    GridHRMFT2093 = $("#GridHRMFT2093").data('kendoGrid');
    LoadPartialView();
    GridHRMFT2093.bind('dataBound', dataBound_Grid);

    // Change DepartmentID
    var DepartmentID = $("#DepartmentID").data("kendoComboBox");
    if (DepartmentID) {
        DepartmentID.bind('change', function () {
            $("#ModeID").data("kendoComboBox").select(2);
            $("#ModeID").parent().addClass('asf-disabled-li');
        });
    }
})

//Load partialView Filter
function LoadPartialView() {
    $.ajax({
        url: '/HRM/HRMF2093/PartialViewFilter',
        success: function (result) {
            $("#FormFilter .asf-quick-search-container").before(result);
            $("#FormFilter .asf-quick-search-container").remove();
            var ip = $(":input[type='text']");
            $(ip).each(function () {
                $(this).attr("name", this.id);
            });

            var cbo = $("#DeparmentID_Filter").data("kendoComboBox");
            var value = window.parent.document.getElementById('DepartmentID').value;
            var index = 0;
            var i = 0;
            cbo.dataSource._data.forEach(function (dataRow) {
                if (dataRow.DepartmentID == value) {
                    index = i;
                }
                i++;
            });
            cbo.select(index);
            cboDepartmentID_Change();
            BtnFilter_Click();
        }
    });
}

function BtnFilter_Click() {
    GridHRMFT2093.dataSource.page(1);
}

// Show Event
function cboModeID_Change(e) {
    var dataItem = $("#ModeID").data('kendoComboBox').dataItem();
    if (dataItem.ID == 2) {
        $("#GridHRMFT2093 input#chkAll").addClass('asf-disabled-li');
        $("#Filter1").addClass('asf-disabled-li');
        $("#FromDate").val("");
        $("#ToDate").val("");
    } else {
        $("#GridHRMFT2093 input#chkAll").removeClass('asf-disabled-li');
        $("#Filter1").removeClass('asf-disabled-li');
        $("#FromDate").val(getCurrentDate());
        $("#ToDate").val(getCurrentDate());
    }
    GridHRMFT2093.dataSource.data([]);
}

function cboDepartmentID_Change(e) {
    var dataItem = $("#DeparmentID_Filter").data('kendoComboBox').dataItem();
    if (dataItem.DepartmentID == "%") {
        $("#ModeID").data('kendoComboBox').select(2);
        $("#ModeID").parent().addClass('asf-disabled-li');
    }
    else {
        $("#ModeID").data('kendoComboBox').value("0");
        $("#ModeID").parent().removeClass('asf-disabled-li');
    }
    cboModeID_Change();
}
// Event databound Grid
function dataBound_Grid(e) {
    $('#GridHRMFT2093 input[type="checkbox"]').click(function (e) {
        if ($("#ModeID").val() == 2) {
            $('#GridHRMFT2093 input[type="checkbox"]').not($(this)).prop('checked', false);
        }
    });
}

// Event btnChoose
function btnChoose_Click(e) {
    var records = ASOFT.asoftGrid.selectedRecords(GridHRMFT2093);
    if (records.length == 0)
        return false;
    window.parent.receiveResult(records, $("#DeparmentID_Filter").val());
    ASOFT.asoftPopup.closeOnly();
}

function getCurrentDate() {
    var today = new Date();
    var dd = today.getDate();
    var mm = today.getMonth() + 1; //January is 0!

    var yyyy = today.getFullYear();
    if (dd < 10) {
        dd = '0' + dd;
    }
    if (mm < 10) {
        mm = '0' + mm;
    }
    var today = dd + '/' + mm + '/' + yyyy;
    return today;
}