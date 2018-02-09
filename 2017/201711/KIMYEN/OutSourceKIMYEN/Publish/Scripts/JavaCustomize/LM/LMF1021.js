$(document).ready(function () {
    LMF1021.LayoutControl();
    LMF1021.AddEventControl();
})

var LMF1021 = new function () {

    /**  
    * Layout control 
    *
    * [Kim Vu] Create New [05/12/2017]
    **/
    this.LayoutControl = function () {

        // Set width caption in table Notes
        $(".Note").parent().parent().find('td.asf-td-caption').css('width', '14%');

        // Default value for combo 
        var cbo = $("#Status").data('kendoComboBox');
        if (cbo) {
            cbo.select(0);
        }
        $(".Status").addClass('asf-disabled-li');
    };

    /**  
    * Event for control in form LMF1021
    *
    * [Kim Vu] Create New [05/12/2017]
    **/
    this.AddEventControl = function () {
        $("#LoanLimitRate").bind('change', LMF1021.Value_Change);
        $("#EvaluationValue").bind('change', LMF1021.Value_Change);
    }

    /**  
    * Function value change
    *
    * [Kim Vu] Create New [05/12/2017]
    **/
    this.Value_Change = function (e) {
        var rate = $("#LoanLimitRate").data('kendoNumericTextBox').value();
        var value = $("#EvaluationValue").data('kendoNumericTextBox').value();
        $("#LoanLimitAmount").data('kendoNumericTextBox').value((rate * value) / 100);
    }
}