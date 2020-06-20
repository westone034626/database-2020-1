class ReadsController < ApplicationController
    before_action :authenticate_user!
    def index
        reads = User.find(current_user.id).reads.where(status: false)
        arr = Array.new()
        reads.each do |read|
            arr.push(read.book_id)
        end
        @books = Book.where(id:arr)

        sql = "
        SELECT *
        FROM books
        WHERE id = (SELECT r.book_id
                    FROM users u, reads r
                    WHERE u.id = r.user_id
                    AND r.status = false
                    AND u.id = current_user.id)"

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


        reads = User.find(current_user.id).reads.where(status: true)        
        arr = Array.new()
        reads.each do |read|
            arr.push(read.book_id)
        end
        books = Book.where(id: arr)

        hashes = books.group(:genre).count

        sql = "
        SELECT genre, count(id)
        FROM (SELECT *
                FROM books
                WHERE id = (SELECT r.book_id
                            FROM users u, reads r
                            WHERE u.id = r.user_id
                            AND r.status = true
                            AND u.id = current_user.id)) AS s_books
        GROUP BY genre"
                    

        favorite_genre = hashes.max_by{|k,v| v}
        user = User.find(current_user.id)
        user.readVol += 1
        #UPDATE users SET readVol = readVol + 1 WHERE id = current_user.id

        unless favorite_genre.nil?
            user.favGenre = favorite_genre[0].strip
            user.favGenreVol = favorite_genre[1]
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
        reads = User.find(current_user.id).reads.where(status: true)        
        arr = Array.new()
        reads.each do |read|
            arr.push(read.book_id)
        end
        @books = Book.where(id: arr)

        sql = "
        SELECT *
        FROM books
        WHERE id = (SELECT r.book_id
                    FROM users u, reads r
                    WHERE u.id = r.user_id
                    AND r.status = true
                    AND u.id = current_user.id)"
    end

end
