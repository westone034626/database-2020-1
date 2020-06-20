class UsersController < ApplicationController
    def index
        if params[:ord] == 'readVol'
            @users = User.where.not(id: current_user.id).order(readVol: :DESC)
        elsif params[:ord] == 'menteeNum'
            @users = User.where.not(id: current_user.id).order(menteeNum: :DESC)
        elsif params[:ord] == 'favGenre'
            @users = User.where.not(id: current_user.id).order(favGenre: :ASC, favGenreVol: :DESC)
        else
            @users = User.where.not(id: current_user.id)
        end
    end

    def create
        if current_user.mentor.nil?
            user = User.find(params[:user_id])
            c_u = User.find(current_user.id)
            c_u.mentor = user
            c_u.save

            user.menteeNum += 1
            user.save
        end
        redirect_to '/users/index/0'
    end

    def delete
        c_u = User.find(current_user.id)
        m_u = User.find(c_u.mentor.id)
        m_u.menteeNum -= 1
        m_u.save
        c_u.mentor = nil
        c_u.save

        
        redirect_to '/users/index/0'
    end

    def show
        c_u = User.find(current_user.id)
        @m_u = c_u.mentor

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

    def analizePerGenre
        reads = User.find(current_user.id).reads.where(status: true)
        arr = Array.new()
        reads.each do |read|
            arr.push(read.book_id)
        end
        books = Book.where(id:arr)
        @genres = books.group(:genre).count
    end

    def analizePerGenreUsers

        sql = "
        SELECT sum(reader) as sr, genre
        FROM books
        GROUP BY genre
        "
        
        @books = Book.find_by_sql(sql)

    end

    def analizePerBookUsers
        sql = "
        SELECT title, reader
        FROM books
        "

        @books = Book.find_by_sql(sql)
    end
end