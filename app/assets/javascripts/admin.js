$(function(){
    $(".frm_company_copy_names").click(function(){
        $("#item_bill_name").val($("#item_name").val());
        $("#item_bill_tel").val($("#item_tel").val());
        $("#item_bill_fax").val($("#item_fax").val());
        $("#item_bill_address").val($("#item_address").val());
        return false;
    });
});