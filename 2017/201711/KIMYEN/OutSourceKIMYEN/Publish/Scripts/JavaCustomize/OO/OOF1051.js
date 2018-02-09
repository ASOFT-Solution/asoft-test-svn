
$(document).ready(function () {
    if ($("#isUpdate") != true) {
        $("#EffectDate").data("kendoDatePicker").value(new Date());

        
        $("input[type=radio]:first").trigger('click');
    }

})