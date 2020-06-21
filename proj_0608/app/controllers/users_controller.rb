class UsersController < ApplicationController
    def index
        if params[:ord] == 'readVol'
            @users = User.where.not(id: current_user.id).order(readVol: :DESC)
            sql = "
            SELECT *
            FROM users
            WHERE id <> current_user.id
            ORDER BY readVol DESC"
        elsif params[:ord] == 'menteeNum'
            @users = User.where.not(id: current_user.id).order(menteeNum: :DESC)
            sql = "
            SELECT *
            FROM users
            WHERE id <> current_user.id
            ORDER BY menteeNum DESC"
        elsif params[:ord] == 'favGenre'
            @users = User.where.not(id: current_user.id).order(favGenre: :ASC, favGenreVol: :DESC)
            sql = "
            SELECT *
            FROM users
            WHERE id <> current_user.id
            ORDER BY favGenre ASC, favGenreVol DESC"
        else
            @users = User.where.not(id: current_user.id)
            sql = "
            SELECT *
            FROM users
            WHERE id <> current_user.id"
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
            #UPDATE users SET mentor_id = user WHERE id = current_user.id
            #UPDATE users SET menteeNum = menteeNum + 1 WHERE id = params[:user_id]
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

        #UPDATE users SET mentor_id = nil WHERE id = current_user.id
        #UPDATE users SET menteeNum = menteeNum - 1 WHERE id = c_u.mentor.id

        
        redirect_to '/users/index/0'
    end

    def show        
        sql = "
        SELECT id, email, name, created_at, readVol, menteeNum, favGenre, favGenreVol 
        FROM users
        WHERE id = (SELECT mentor_id
                    FROM users
                    WHERE id = '#{current_user.id}')"
        m_u = User.find_by_sql(sql)
        @m_u = m_u[0]
    end

    def show_mentor_books
        sql = "
        SELECT b.title as title, b.author as author, b.page as page, b.genre as genre, (r.finish - r.start) as ct
        FROM users u, books b, reads r
        WHERE u.id = r.user_id
        AND r.book_id = b.id
        AND r.status = true
        AND u.id = '#{params[:user_id]}'"
        @books = Book.find_by_sql(sql)
    end

    def show_mentor_mentees
        @mentor = User.find(params[:user_id])
        #SELECT * FROM users Where id = params[:user_id]

        sql = "
        SELECT *
        FROM users
        WHERE mentor_id = '#{params[:user_id]}'"
        @users = User.find_by_sql(sql)
    end

    def show_mentees
        sql = "
        SELECT *
        FROM users
        WHERE mentor_id = '#{current_user.id}'"
        @users = User.find_by_sql(sql)
    end

    def analizePerGenre
        sql = "
        SELECT b.genre as bg, count(b.id) as sr, AVG(r.finish - r.start) as af, SUM(b.page) as sp
        FROM users u, reads r, books b
        WHERE u.id = r.user_id
        AND r.book_id = b.id
        AND r.status = true
        AND u.id = '#{current_user.id}'
        GROUP BY b.genre
        ORDER BY count(b.id) DESC, b.genre ASC
        "
        
        @genres = Read.find_by_sql(sql)
        
    end

    def analizePerGenreUsers

        sql = "
        SELECT sum(reader) as sr, genre
        FROM books
        GROUP BY genre
        ORDER BY sum(reader) DESC, genre ASC
        "
        
        @books = Book.find_by_sql(sql)

    end

    def analizePerBookUsers
        sql = "
        SELECT title, reader
        FROM books
        ORDER BY reader DESC, title ASC
        "

        @books = Book.find_by_sql(sql)
    end
end