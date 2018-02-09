
$(document).ready(function () {
    CSMF1082.getmodelID();
    
});
var CSMF1082 = new function () {
    this.getmodelID = function (modelid) {
        modelid = $(".ModelID").text();
        return modelid;
    }
}

