class ReadsController < ApplicationController
    before_action :authenticate_user!
    def index
        reads = User.find(current_user.id).reads.where(status: false)
        arr = Array.new()
        reads.each do |read|
            arr.push(read.book_id)
        end
        @books = Book.where(id:arr)

    end
    def create
        read = Read.find_by(book_id: params[:book_id], user_id: current_user.id)
        read.start = Time.now
        read.save
        redirect_to '/'
    end
    def delete
        Read.find_by(book_id: params[:book_id], user_id: current_user.id).destroy
        redirect_to '/'
    end
    def clear
        read = Read.find_by(book_id: params[:book_id], user_id: current_user.id)
        read.status = true
        read.finish = Time.now
        read.save
        redirect_to '/'
    end

    def show_complete_books
        reads = User.find(current_user.id).reads.where(status: true)        
        arr = Array.new()
        reads.each do |read|
            arr.push(read.book_id)
        end
        @books = Book.where(id: arr)

        hashes = @books.group(:genre).count

        def largest_hash_key(hash)
            hash.max_by{|k,v| v}
        end
        @favorite_genre = largest_hash_key(hashes)

=begin
        sql = ("
            SELECT books.genre, COUNT(books.genre)
            FROM books
            GROUP BY books.genre
            HAVING COUNT(books.genre) = (SELECT MAX(cnt_genre)
                                         FROM (SELECT COUNT(books.genre) cnt_genre
                                               FROM books
                                               GROUP BY books.genre))")

        result_array = ActiveRecord::Base.connection.exec_query(sql)
        @best_genre = result_array[0]["genre"]
        @best_genre_num = result_array[0]["COUNT(books.genre)"]
=end
    end

end
