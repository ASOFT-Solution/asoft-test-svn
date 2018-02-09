var GridHRMFT2093 = null;
var GridHRMFT20931 = null;

$(document).ready(function () {
    GridHRMFT2093 = $("#GridHRMFT2103").data('kendoGrid');
    GridHRMFT20931 = $("#GridHRMFT21031").data('kendoGrid');
    LoadPartialView();

    // Bind event grid
    $("#GridHRMFT2103").data('kendoGrid').bind('dataBound', dataBound_GridMaster);
    $("#btnChoose").unbind('click');
    $("#btnChoose").bind('click', btnChoose_Click);
});

//Load partialView Filter
function LoadPartialView() {
    $.ajax({
        url: '/HRM/HRMF2103/PartialViewFilter',
        success: function (result) {
            $("#FormFilter .asf-quick-search-container").before(result);
            $("#FormFilter .asf-quick-search-container").remove();
            var ip = $(":input[type='checkbox']");
            $(ip).each(function () {
                $(this).attr("name", this.id);
            });

            //  
            var cbo = $("#TrainingFieldID").data("kendoComboBox");
            var value = window.parent.document.getElementById('TrainingFieldID').value;
            var index = 0;
            var i = 0;
            cbo.dataSource._data.forEach(function (dataRow) {
                if (dataRow.TrainingFieldID == value) {
                    index = i;
                }
                i++;
            });
            cbo.select(index);


            $($("#IsAll").parent()).find('label').remove();
            $($(":input[name='TypeCheckBox']")).remove();
            ip = $(":input[type='text']");
            $(ip).each(function () {
                $(this).attr("name", this.id);
            });
            BtnFilter_Click();
            $("#IsAll").bind('click', IsAll_CheckedChange);
        }
    });
}

function IsAll_CheckedChange(e) {
    if ($("#IsAll").prop('checked')) {
        $($("#DeparmentID_Filter").parent().parent()).addClass('asf-disabled-li');
        $("#IsAllValue").val('1');
        $("#GridHRMFT2103 input#chkAll").addClass('asf-disabled-li');
        $("#GridHRMFT21031").css('display', 'none');
        $("#DeparmentID_Filter").data('kendoComboBox').select(0);
    } else {
        $("#IsAllValue").val('0');
        $($("#DeparmentID_Filter").parent().parent()).removeClass('asf-disabled-li');
        $("#GridHRMFT2103 input#chkAll").removeClass('asf-disabled-li');
        $("#GridHRMFT21031").css('display', 'block');
    }
}

function dataBound_GridMaster(e) {
    GridHRMFT2093.tbody.find('.asoftcheckbox').unbind("click");
    $('#GridHRMFT2103 input[type="checkbox"]').click(function (e) {        
        if (!$("#IsAll").prop('checked')) {
            GridHRMFT20931.dataSource.page(1);
        } else {
            $('#GridHRMFT2103 input[type="checkbox"]').not($(this)).prop('checked', false);
        }
    });
}

function BtnFilter_Click() {
    GridHRMFT2093.dataSource.page(1);
}

function BtnClearFilter_Click() {
    $("#FormFilter")[0].reset();
    $("#FromDate").data("kendoDatePicker").value('');
    $("#ToDate").data("kendoDatePicker").value('');
    GridHRMFT2093.dataSource.page(1);
}
// Event btnChoose
function btnChoose_Click(e) {
    var GridKendo = null;
    if (!$("#IsAll").prop('checked')) {
        GridKendo = GridHRMFT20931;
    } else {
        GridKendo = GridHRMFT2093;
    }
    var records = ASOFT.asoftGrid.selectedRecords(GridKendo);
    if (records.length == 0)
        return false;    
    window.parent.receiveResult(records, $("#IsAllValue").val());
    ASOFT.asoftPopup.closeOnly();
}