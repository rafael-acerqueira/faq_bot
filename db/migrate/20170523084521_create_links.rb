class CreateLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :links do |t|
      t.string :title
      t.string :url
      t.string :hashtag
    end
  end
end
