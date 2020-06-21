class ReadsController < ApplicationController
    before_action :authenticate_user!
    def index
        sql = "
        SELECT b.id as id, b.title as title, b.author as author, b.genre as genre, b.page as page, r.start as start
        FROM books b, users u, reads r
        WHERE u.id = '#{current_user.id}'
        AND u.id = r.user_id
        AND r.book_id = b.id
        AND r.status = false"
        @books = Book.find_by_sql(sql)

    end
    def create
        read = Read.find_by(book_id: params[:book_id], user_id: current_user.id)
        read.start = Time.now
        read.save 
        #UPDATE reads SET start = Time.now WHERE book_id = book.id AND user_id = current_user.id

        redirect_to '/'
    end
    def delete
        Read.find_by(book_id: params[:book_id], user_id: current_user.id).destroy
        #DELETE FROM reads WHERE book_id = params[:book_id] AND user_id = current_user.id
        
        redirect_to '/'
    end

    def clear
        read = Read.find_by(book_id: params[:book_id], user_id: current_user.id)
        read.status = true
        read.finish = Time.now
        read.save
        #UPDATE reads SET finish = Time.now, status = true WHERE book_id = book.id AND user_id = current_user.id
        
        sql = "
            SELECT b.favGenre as fv, MAX(b.favGenreVol) as fv_max
            FROM (SELECT b.genre as favGenre, count(b.genre) as favGenreVol
                    FROM users u, books b, reads r
                    WHERE u.id = '#{current_user.id}'
                    AND u.id = r.user_id
                    AND b.id = r.book_id
                    AND r.status = true
                    GROUP BY b.genre) AS b"
                    
        favorite_genre = Book.find_by_sql(sql)[0]
        user = User.find(current_user.id)
        user.readVol += 1
        #UPDATE users SET readVol = readVol + 1 WHERE id = current_user.id

        unless favorite_genre.nil?
            user.favGenre = favorite_genre.fv.strip
            user.favGenreVol = favorite_genre.fv_max
        end
        user.save
        #UPDATE users SET favGenre = favorite_genre[0].strip, favGenreVol = favorite_genre[1] WHERE id = current_user.id


        book = Book.find(params[:book_id])
        book.reader += 1
        book.save
        #UPDATE books SET reader = reader + 1 WHERE id = params[:book_id]
    
        redirect_to '/'
    end

    def show_complete_books
        sql = "
        SELECT b.title as title, b.author as author, b.page as page, b.genre as genre, (r.finish - r.start) as ct
        FROM users u, books b, reads r
        WHERE u.id = '#{current_user.id}'
        AND u.id = r.user_id
        AND b.id = r.book_id
        AND r.status = true"
        @books = Book.find_by_sql(sql)
    end

end
