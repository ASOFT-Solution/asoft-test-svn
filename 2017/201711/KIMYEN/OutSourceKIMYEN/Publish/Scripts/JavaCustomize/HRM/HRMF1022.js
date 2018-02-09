var DivTag2block = "<div id='divFromToDate'>" +
        "<div class='block-left'>" +
            "<div class='asf-filter-label'></div>" +
            "<div class='asf-filter-input'></div>" +
        "</div>" +
        "<div class='block-right'>" +
            "<div class='asf-filter-label'></div>" +
            "<div class='asf-filter-input'></div>" +
        "</div>" +
    "</div>";

$(document).ready(function () {
    $("#HRMF1022_TabInfo-1 .asf-master-content .last").prepend(DivTag2block);
    var divFromDate = $("#HRMF1022_TabInfo-1 .asf-master-content .last table tbody tr").first().find('td');
    $("#divFromToDate .block-left .asf-filter-label").append(divFromDate[0].innerText + ' :');
    $("#divFromToDate .block-left .asf-filter-input").append(divFromDate[2].innerText);
    $("#HRMF1022_TabInfo-1 .asf-master-content .last table tbody tr").first().css('display', 'none');

    var divToDate = $("#HRMF1022_TabInfo-1 .asf-master-content .first table tbody tr").last().find('td');
    $("#divFromToDate .block-right .asf-filter-label").append(divToDate[0].innerText + ' :');
    $("#divFromToDate .block-right .asf-filter-input").append(divToDate[2].innerText);
    $("#HRMF1022_TabInfo-1 .asf-master-content .first table tbody tr").last().css('display', 'none');
    $("#divFromToDate .asf-filter-input").addClass('asf-filter-label');
    $("#divFromToDate .asf-filter-input").removeClass('asf-filter-input');

    var btnDelete = $("#BtnDelete").data("kendoButton") || $("#BtnDelete");
    if (btnDelete)
        btnDelete.unbind("click").bind("click", customerDelete_Click);
    CheckCanEdit();
    $(".DepartmentID").parent().css('display', 'none');
});

function customerDelete_Click() {
    var args = [];
    var list = [];
    ASOFT.form.clearMessageBox();
    pk = $(".DepartmentID.content-text").html() + ',' + $(".BoundaryID.content-text").html();
    args.push(pk);
    list.push(table, key);
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson1(urldel, list, args, deleteSuccess);
    });
}

function CheckCanEdit() {
    var url = new URL(window.location.href);
    var pk = url.searchParams.get("PK");
    $.ajax({
        url: '/HRM/HRMF1020/CheckUpdateData?BoundaryID=' + pk + "&DepartmentID=" + $(".DepartmentID.content-text").html() + "&Mode=0",
        success: function (result) {
            if (result.CanEdit == 0) {
                $("#BtnEdit").parent().addClass('asf-disabled-li');
            }
        }
    });
}