//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     25/06/2014      Thai Son        Tạo mới
//####################################################################

ASOFTCORE.create_module("printer-job", function (sb) {
    var input,
        log = ASOFTCORE.log;

    return {
        init: function () {
            sb.addEvent(button, "click", this.handleSearch);

            sb.listen({
                'choose-table': this.chooseTable
            });
        },
        destroy: function () {
            sb.removeEvent(button, "click", this.handleSearch);

            sb.ignore(['change-filter']);
        },
        func: function () {
            sb.notify({
                type: 'perform-search',
                data: query
            });

        },
    };
});
