class UsersController < ApplicationController
    def index
        @users = User.all.where.not(id: current_user.id)
    end

    def create
        user = User.find(params[:user_id])
        c_u = User.find(current_user.id)
        c_u.mentor = user
        c_u.save
        redirect_to '/users/index'
    end

    def delete
        c_u = User.find(current_user.id)
        c_u.mentor = nil
        c_u.save

        redirect_to '/users/index'
    end

    def show
        c_u = User.find(current_user.id)
        @m_u = c_u.mentor
        reads = c_u.mentor.reads.where(status: true)
        arr = Array.new()
        reads.each do |read|
            arr.push(read.book_id)
        end
        books = Book.where(id: arr)

        hashes = books.group(:genre).count

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
        result_array = ActiveRecord::Base.connection.execute(sql)
        @best_genre = result_array[0][0]
        @best_genre_num = result_array[0][1]
=end
    end

    def show_mentor_books
        reads = User.find(params[:user_id]).reads.where(status: true)
        arr = Array.new()
        reads.each do |read|
            arr.push(read.book_id)
        end
        @books = Book.where(id:arr)
        @m_u_id = params[:user_id]
    end

    def show_mentor_mentees
        @mentor = User.find(params[:user_id])
        @users = @mentor.mentees
    end

    def show_mentees
        @users = current_user.mentees
    end
end