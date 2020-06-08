class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.string      :ISBN
      t.integer     :page
      t.string      :genre
      t.string      :title
      t.string      :author
      t.string      :imageURL
      t.string      :publisher
      t.timestamps
    end
  end
end
