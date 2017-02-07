var i, isbn, reqISBNS, batchNum = 0, batches = {};

//build batches of books
for(i = 0; i < isbnsArray.length; i++){
    isbn = isbnsArray[i];

    if(batches[batchNum] === undefined && batchNum === 0) {
        //Create first batch as an array
        batches[batchNum] = [];
        //Push the isbn to the array
        batches[batchNum].push(isbn);
    } else if (batches[batchNum] !== undefined && batches[batchNum].length < batch_length){
        //Push the isbn into the current batch
        batches[batchNum].push(isbn);
    } else if (batches[batchNum] !== undefined && batches[batchNum].length === batch_length){
        //Increment batchNum and create a new batch as an array
        batchNum++;
        batches[batchNum] = [];
        //Push the isbn into the array
        batches[batchNum].push(isbn);
    } else {
        //console.log("Ruh-roh, Raggy!");
    }
}

//reset batchNum to 0 and request batch first batch on load
batchNum = 0;
reqBatch(batchNum);

//#load-more button click event listener
$('#load-more').click(function(){
    batchNum++;
    reqBatch(batchNum);
    if(batches[batchNum + 1] === undefined) {
        $('#load-more').remove();
    }
});


//TODO: Determine if batchNum should be managed via this script or passed in as a parameter to reqBatch.
function reqBatch(batchNum){
    //Create or clear reqISBNSArray
    reqISBNSArray = [];
    var i, isbn;
    for(i = 0; i < batches[batchNum].length; i++){
        isbn = batches[batchNum][i];
        if(isbnsObj[isbn]['data source'] === 'API'){
            reqISBNSArray.push(isbn);            
        }
    }
    
    //This will be sent to PHP Cache
    reqISBNS = {isbns:reqISBNSArray.join(',')};
    reqBooks(reqISBNS);
}


//Ajax Call
function reqBooks(reqISBNS){
    var url = '//web.library.emory.edu/_includes/google-books/google-books-api.php';
    $.support.cors = true;
    $.ajax({
        crossDomain: true,
        url: url,
        data: reqISBNS,
        dataType: 'json'
    }).done(function(data) {
        var previewURL, sectionNum, isbn_10, isbn_13, volume, access, isbnMatch, book, i, books = data, batch;

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

        //Output from isbnsObj
        for (i = 0; i < isbnsArray.length; i++){
            var isbn = isbnsArray[i];
            //console.log(isbnsArray);
            //console.log((i+1)+' of ' + isbnsArray.length);
            //console.log (isbn);

            batch = batches[batchNum];

            if (batch.indexOf(isbn) !== -1){

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
    })
    .fail(function(data, textStatus, errorThrown) {
        console.dir(errorThrown);
    }); 
}