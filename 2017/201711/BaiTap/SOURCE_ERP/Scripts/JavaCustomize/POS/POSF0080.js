"use strict";

(function ($, _as) {
    const btndelete = $("#btndelete").data("kendobutton") || $("#btndelete");

    if (btndelete) {
        btndelete.unbind("click").bind("click", customerdelete_click);
    }

}($, ASOFT))


function customerdelete_click() {
    const key = [],

        $urldeleteposf0080 = $("#deleteposf0080").val(),

        $gridposf0080 = $("#gridpost00801").data("kendogrid"),

        records = asoft.asoftgrid.selectedrecords($gridposf0080);

    asoft.form.clearmessagebox();

    if (records.length == 0) return false;

    var args = $.map(records, function (record) {
        if (typeof record.apk !== "undefined") {
            return record.apk;
        }
    });

    key.push(tablecontent, pk);

    asoft.dialog.confirmdialog(asoft.helper.getmessage('00ML000024'), function () {
        asoft.helper.posttypejson1("", key, args, deletesuccess);
    });
    return false;
}