class CreateReads < ActiveRecord::Migration[6.0]
  def change
    create_table :reads do |t|
      t.integer     :user_id
      t.integer     :book_id
      t.boolean     :status, default: false
      t.date        :start
      t.date        :finish
      t.timestamps
    end
  end
end
