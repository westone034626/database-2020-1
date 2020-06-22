class BooksController < ApplicationController
    def new

    end


    def search
        if params[:ISBN].length == 13
            unless book = Book.find_by(ISBN: params[:ISBN]) #SELECT * FROM books WHERE ISBN = params[:ISBN]
                url = "http://www.kyobobook.co.kr/product/detailViewKor.laf?ejkGb=KOR&mallGb=KOR&barcode=" + params[:ISBN]
                require 'open-uri'
                
                doc = Nokogiri::HTML(open(url))
	  
	            book = Book.new
	            book.ISBN = params[:ISBN]
	            page = doc.css('.content_left .box_detail_content .table_opened tr td')
	            page = page[1].text
	            page = page.delete "쪽"
	            book.page = Integer(page)
	            genre = doc.css('.list_detail_category li[1] a[1]')
	            book.genre = genre[0].text.strip
	            book.title = doc.css('.box_detail_point h1.title').text
	            book.author = doc.css('.box_detail_point .author .name .detail_author').text
	            image = doc.css('.box_detail_info .box_detail_cover .cover').at("img[src]")
	            book.imageURL = image['src']
	            book.publisher = doc.css('.box_detail_point .author span[3] a').text
	  
	            book.save
            end
            @flag = 1
        else
            @flag = 2
        end
    end

    def create
        book = Book.find_by(ISBN:params[:ISBN])
        #SELECT * FROM books WHERE ISBN = params[:ISBN]

        if Read.find_by(book_id:book.id, user_id:current_user.id) 
            #SELECT * FROM reads WHERE book_id = book.id AND user_id = current_user.id
            redirect_to '/'
        else
            read = Read.new
            read.user_id = current_user.id
            read.book_id = book.id
            read.status = false
            read.save
            redirect_to '/'
            #INSERT INTO reads("user_id", "book_id", "status") VALUES (current_user.id, book_id, false)
        end
        
    end
end