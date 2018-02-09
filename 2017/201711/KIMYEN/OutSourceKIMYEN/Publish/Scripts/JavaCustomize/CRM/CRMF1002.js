
$(document).ready(function () {
    $("#GR_LichSu").remove();
    $("#GR_DinhKem").remove();
    var BirthDate = $(".BirthDate").text();
    BirthDate = BirthDate.split(' ')[0];
    $(".BirthDate").text(BirthDate)
    $("#refLinkCRMT90031").val("NotesSubject");
})

function DeleteViewNoDetail(pk) {
    var divisionID = $(".DivisionID").text();
    return pk + "," + divisionID;
}