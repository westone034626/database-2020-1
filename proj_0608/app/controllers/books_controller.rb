class BooksController < ApplicationController
    def new
        
    end

    def create
        if params[:ISBN] == ''
            redirect_to '/'
        else
            if  book = Book.find_by(ISBN: params[:ISBN])
                if Read.find_by(book_id:book.id, user_id:current_user.id)
                    redirect_to '/'
                else
                    read = Read.new
                    read.user_id = current_user.id
                    read.book_id = book.id
                    read.status = false
                    read.save
                    redirect_to '/'
                end
            else
                book = Book.new
                book.ISBN = params[:ISBN]
                book.page = params[:page]
                book.genre = params[:genre]
                book.title = params[:title]
                book.author = params[:author]
                book.publisher = params[:publisher]
                book.save
    
                read = Read.new
                read.user_id = current_user.id
                read.book_id = book.id
                read.status = false
                read.save
    
                redirect_to '/'
            end
        end
    end
end

book = Book.new