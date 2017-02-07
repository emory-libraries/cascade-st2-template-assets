$(document).ready(function(){
    console.log(reqISBNSArray.length);
    function outputBooks(){
        //Output from isbnsObj
        for (var i = 0; i < isbnsArray.length; i++){
            var isbn = isbnsArray[i];
            
            if (isbnsObj[isbn]['featured'] === 'Yes'){
                //Insert Featured Book
    
                //Insert cover
                $('#featured-book').prepend('<figure class="span2"><img class="cover" src="' + isbnsObj[isbn]['cover url'] + '"/><figcaption/>');
    
                //Insert authors
                $('#featured-book div').prepend('<p class="book-author">' + isbnsObj[isbn]['authors'] + '</p>');
    
                //Insert title
                $('#featured-book div').prepend('<h3>' + isbnsObj[isbn]['title'] + '</h3>');
    
    
                //Insert print copy link
                if(isbnsObj[isbn]['hardcopy link'] !== ''){
                    $('#featured-book div').append('<p><a href="' + isbnsObj[isbn]['hardcopy link'] + '">Print: ' + isbnsObj[isbn]['call number'] + '</a></p>');
                }
                
                //Insert ebook link
                if(isbnsObj[isbn]['ebook link'] !== ''){
                    $('#featured-book div').append('<p><a href="' + isbnsObj[isbn]['ebook link'] + '">Also available in ebook</a></p>');
                }
                
                //Insert preview url only if it is not empty. Check for Amazon link. Default to Google Books Preview button 
                if (isbnsObj[isbn]['preview link'] !== ''){
                    if(isbnsObj[isbn]['preview link'].indexOf('amazon.com') === -1){
    	                $('#featured-book figure figcaption').append('<a href="'+isbnsObj[isbn]['preview link']+'"><img class="gbooks" src="https://template.emory.edu/assets/wdg/clients/library/images/gbs_preview_button1.png" /></a>');
    	            } else {
    	                $('#featured-book figure figcaption').append('<a href="'+isbnsObj[isbn]['preview link']+'">Amazon Look Inside</a>');
    	            }
                } else{
                    $('#featured-book figure figcaption').append('No preview available');
    
                }
                
            } else {
                //Insert Row (section)
                
                if($('.book').length % 2 === 0){
                    sectionNum = ($('section.new-books').length + 1);
                    $('section.books ').append('<section class="new-books clearfix equal-row-height" id="section-'+sectionNum+'"/>');
                }
    
                //Insert Book (article) and details
                $('#section-' + sectionNum).append('<article class="equal-height span6 book clearfix" id="' + isbn + '"><figure class="span4"><img class="cover" src="' + isbnsObj[isbn]['cover url'] + '"/><figcaption/></figure><div class="span8"><h3>' + isbnsObj[isbn]['title'] + '</h3><p class="book-author" /></div></article>');
                
                //Insert authors
                $('#'+isbn + ' div p.book-author').append(isbnsObj[isbn]['authors']);
                
                //Insert printed copy link
                if(isbnsObj[isbn]['hardcopy link'] !== ''){
                    $('#' + isbn + ' div').append('<p><a href="' + isbnsObj[isbn]['hardcopy link'] + '">Print: ' + isbnsObj[isbn]['call number'] + '</a></p>');
                }
                
                //Insert ebook link
                if(isbnsObj[isbn]['ebook link'] !== ''){
                    $('#' + isbn + ' div').append('<p><a href="' + isbnsObj[isbn]['ebook link'] + '">Also available in ebook</a></p>');
                }
    
                //Insert preview url only if it is not empty. Check for Amazon link. Default to Google Books Preview button 
                if (isbnsObj[isbn]['preview link'] !== ''){
    	            if(isbnsObj[isbn]['preview link'].indexOf('amazon.com') === -1){
    	                $('#'+isbn).find('figcaption').append('<a href="'+isbnsObj[isbn]['preview link']+'"><img class="gbooks" src="https://template.emory.edu/assets/wdg/clients/library/images/gbs_preview_button1.png" /></a>');
    	            } else {
    	                $('#'+isbn).find('figcaption').append('<a href="'+isbnsObj[isbn]['preview link']+'">Amazon Look Inside</a>');
    	            }
                } else {
                	$('#'+isbn).find('figcaption').append('No preview available')
                }
            }
        }    
    }
    
    //Check to see if all books are manual entries; execute API call if there are some that are not manual
    if(reqISBNSArray.length > 0){
        var url = '//web.library.emory.edu/_includes/google-books/google-books-api.php';
    
        $.ajax({
          url: url,
          data: reqISBNS,
          dataType: 'json'
        }).done(function(data) {
        
            var previewURL, sectionNum, isbn_10, isbn_13, volume, access, isbnMatch, book, i, books = data;
        
            //book is isbn requested; isbnsObj is the original list of books; books is all returned data object
            for (book in books){
                //if requested item results isn't empty
                if (books[book].result.totalItems > 0){
        
                    //Get volume info
                    volume = books[book].result.items[0].volumeInfo;
        
                    //Get access info (preview links)
                    access = books[book].result.items[0].accessInfo;
        
                    //Get ISBN10 to add to Amazon preview link 
                    for ( i = 0; i < volume.industryIdentifiers.length; i++){
                        if (volume.industryIdentifiers[i].type === 'ISBN_10'){
                            isbn_10 = volume.industryIdentifiers[i].identifier;
                        }
                    }
        
                    //Get the book title
                    isbnsObj[book]['title'] = volume.title;
                    
                    //Check for manual entry of cover, otherwise grab it from the API or use a palceholder 
                    if (isbnsObj[book]['cover url'] === '/'){
                        if (volume.imageLinks === undefined ){
                            isbnsObj[book]['cover url'] = 'http://books.google.com/googlebooks/images/no_cover_thumb.gif';
                        } else {
                            isbnsObj[book]['cover url'] = volume.imageLinks.thumbnail;
                        }
                    }
                    
                    //Check for manual preview link, otherwise use a API link if available, otherwise use Amazon link based on ISBN10
                    if(isbnsObj[book]['preview link'] === ''){
        
        	            if (access.accessViewStatus !== "NONE"){
        	                isbnsObj[book]['preview link'] = volume.previewLink;
        	            } else {
        	                isbnsObj[book]['preview link'] = 'http://amazon.com/dp/'+isbn_10;
        	            }
        	        }
        
        	        //prep array of authors
                    var authorsArray = [];
                    //add each author to the array
                    for (author in volume.authors){
                        authorsArray.push(volume.authors[author]);
                    }
                    //stringify the authors
                    isbnsObj[book]['authors'] = authorsArray.join('; ');
        
                } else{
                    //console.log('not available on Google Books Search');
                    //Remove it from the array of ISBNS to output as it's likely bad data entry. 
                    isbnsArray.splice(isbnsArray.indexOf(book), 1); 
                }
            }
    
            outputBooks();        
        
        });
    } else {
        outputBooks();
    }
});