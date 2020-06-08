class ReadsController < ApplicationController
    before_action :authenticate_user!
    def index
        @books = User.find(current_user.id).books
    end
    def create
        read = Read.find_by(book_id: params[:book_id], user_id: current_user.id)
        if read.timeRecord == nil
            read.timeRecord = Time.now.to_s
        else
            read.timeRecord = (read.timeRecord) + ', ' + (Time.now.to_s)
        end
        read.save
        redirect_to '/'
    end
    def delete
        read = Read.find_by(book_id: params[:book_id], user_id: current_user.id)
        read.destroy
        redirect_to '/'
    end

end
