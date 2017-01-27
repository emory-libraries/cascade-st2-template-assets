function sectionChildren() {
    $('.people.general li:nth-child(2n+1)').addClass('odd');
    $('.col2col3 .span9 .pages .span3:nth-child(3n+1)').addClass('three_n');
    $('.col2col3 .span9 .pages .span3:nth-child(4n+1)').addClass('four_n');
}

function applyTableStripes(){
    if($('.table-striped').length>0){
        $(".table-striped tbody > tr:nth-child(odd) > td, .table-striped tbody > tr:nth-child(odd) > th").css({'background-color': '#F2F5F7'});
    }
}

function lastChildStyles(){
    $("nav#main-nav ul li:last-child, .footer-hat .component:last-child, .items li.item:last-child a, .pages .subpages li:last-child a").css({
        'border-right':'none'
    });

}

function thumbnailFix(){
if($(".data-entry").hasClass("subject-libs")){ 
        $("td .thumbnail").each(function(){
            var $this = $(this),
                wrapping_link = $this.parents("a").attr('href'),
                bio_at = $(this).parents("td").find(".bio-attachments").html();

                if(bio_at==''||bio_at==undefined){
                    bio_at='';
                }

            $this.parents("td").html("<a class='figure' href='"+wrapping_link+"'>"+$this.html()+"</a>"+bio_at);
        });
    }
}