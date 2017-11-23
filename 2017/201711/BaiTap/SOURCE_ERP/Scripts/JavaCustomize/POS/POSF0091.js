"use strict";

(function ($, as) {
    if (typeof $ === "function" || typeof as === "object") {
        $(document).ready(() => {
            const listReadonly = ["VoucherNo", "VoucherDate", "EmployeeName", "SalesManName"];

            listReadonly.forEach((item, index, list) => {
                ExecuteReadonly(item);
            });
        })
    }

    function ExecuteReadonly(item) {
        if (item && document.getElementById(item)) {
            const itemDOM = document.getElementById(item);
            itemDOM.dataset.readonlyValue = "readonly";
            itemDOM.setAttribute("readonly", true);
            itemDOM.onfocus = function(e){
                this.blur();
            }
        }
    }
}($, ASOFT))