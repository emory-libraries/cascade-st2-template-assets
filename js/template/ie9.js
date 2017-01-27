function thumbnailFix(){
    if($(".data-entry").hasClass("subject-libs")){ 
        $("td figure:first-child").remove();
    }
}

$(document).ready(function() {
       thumbnailFix();
});