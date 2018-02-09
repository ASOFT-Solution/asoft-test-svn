var scheduler = null;
var dataSche = {};
var dateTimeAdd = {};
var isBoundFirst = true;

$(document).ready(function () { 
    scheduler = $("#scheduler").data("kendoScheduler");
    scheduler.element.height($("#contentMaster").height())
    $(".k-event-actions").unbind("click");
    $(".k-nav-today a").text($("#ToDay").val());
})

function dataBound_Calendar() {
    $(".k-event-delete").hide();
    var close = '<a href="#" onclick="removeMsg_Click(this)" class="k-link k-event-delete"><span class="k-icon k-si-close-custom"></span></a>';
    $(".k-event-delete").after(close);

    $(".k-scheduler-times-all-day").text($("#AllDay").val());
    $(".k-scheduler-fullday").parent().remove();
}

function change_Navigate(e) {
    var isDate;
    var tm;
    var ty;
    var date = e.date;
    var fromdate;
    var todate;

    if(e.view == "day")
    {
        isDate = 1;
        fromdate = date.getDate() + "/" + (date.getMonth() + 1) + "/" + date.getUTCFullYear();
        todate = date.getDate() + "/" + (date.getMonth() + 1) + "/" + date.getUTCFullYear();
    }
    if (e.view == "workWeek")
    {
        isDate = 2;
        
        var day = date.getDay(),
        diff = date.getDate() - day + (day == 0 ? -6 : 1); // adjust when day is sunday
        var fd = new Date(date.setDate(diff));
        var date1 = new Date(fd);
        var td = new Date(date1.setDate(date1.getDate() + 4));
        fromdate = fd.getDate() + "/" + (fd.getMonth() + 1) + "/" + fd.getUTCFullYear();
        todate = td.getDate() + "/" + (td.getMonth() + 1) + "/" + td.getUTCFullYear();
    }
    if (e.view == "week")
    {
        isDate = 2;
        var day = date.getDay(),
            diff = date.getDate() - day;
        var fd = new Date(date.setDate(diff));
        var date1 = new Date(fd);
        var td = new Date(date.setDate(date1.getDate() + 6));
        fromdate = fd.getDate() + "/" + (fd.getMonth() + 1) + "/" + fd.getUTCFullYear();
        todate = td.getDate() + "/" + (td.getMonth() + 1) + "/" + td.getUTCFullYear();
    }

    if (e.view == "month")
    {
        tm = date.getMonth() + 1;
        ty = date.getUTCFullYear();
        isDate = 3;
    }

    dataSche = {};
    dataSche.IsDate = isDate;
    dataSche.TranMonth = tm;
    dataSche.TranYear = ty;
    dataSche.FromDate = fromdate;
    dataSche.ToDate = todate;
    scheduler.dataSource.read();
}

function CalendarRead(e) {
    return dataSche;
}

function add_Event() {
    var urlLink = "/PopupLayout/Index/CRM/CRMF9005";
    ASOFT.asoftPopup.showIframe(urlLink, {});
}

function add_Task() {
    var urlLink = "/PopupLayout/Index/CRM/CRMF9004";
    ASOFT.asoftPopup.showIframe(urlLink, {});
}

function readCalendar() {
    scheduler.dataSource.read();
}

function popupClose() {
    ASOFT.asoftPopup.hideIframe();
};

//function getDateSuccess(result) {
//    result[0].Start = new Date("04-19-2017 09:30:30");
//    result[0].End = new Date("04-19-2017 10:30:30");

//    result[1].Start = new Date("04-18-2017 09:30:30");
//    result[1].End = new Date("04-18-2017 10:30:30");
//    if (result.length > 0) {
//        scheduler.dataSource.data(result);
//    }
//}

function add_Click(e) {
    if (e == null)
        return;
    e.preventDefault();
    dateTimeAdd = e.event;

    var urlLink = "/PopupLayout/Index/CRM/CRMF9005";
    ASOFT.asoftPopup.showIframe(urlLink, {});
}

function edit_Click(e) {
    if (e == null)
        return;
    e.preventDefault();
    var dataEdit = e.event;
    var urlLink = "/PopupLayout/Index/CRM/CRMF9005?EventID=" + dataEdit.ID;
    ASOFT.asoftPopup.showIframe(urlLink, {});
}

function returnDateTimeAdd() {
    return dateTimeAdd;
}

function setDateTimeAdd() {
    dateTimeAdd = null;
}

function MoveEnd_Click(e) {
    var data = e.event;
    data.start = e.start;
    data.end = e.end;

    ASOFT.helper.postTypeJson('/Calendar/UpdateEvent', e.event, readCalendar);
}

function resize_Click(e) {
    var data = e.event;
    data.start = e.start;
    data.end = e.end;

    ASOFT.helper.postTypeJson('/Calendar/UpdateEvent', e.event, readCalendar);
}

function removeMsg_Click(e) {
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        var data = scheduler.dataSource.data();
        var uid = e.parentElement.parentElement.attributes["data-uid"].value;
        var dataid = null;
        for (var i = 0; i < data.length; i++)
        {
            if (data[i].uid == uid)
            {
                dataid = data[i];
                break;
            }
        }
        if (dataid != null) {
            remove_Click(dataid);
        }
    });
}

function remove_Click(e) {
    ASOFT.helper.postTypeJson('/Calendar/DeleteEvent', e, deleteSuccess);
}

function deleteSuccess(result) {
    //var Message = result.MessageID;
    //ASOFT.form.displayMultiMessageBox('contentMaster', result.status, ASOFT.helper.getMessage(Message));
    ASOFT.helper.showErrorSeverOption(1, result, "contentMaster", function () {
        readCalendar();
    }, null, null, true, false, "contentMaster");
};