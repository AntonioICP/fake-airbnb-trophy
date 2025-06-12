class AddImageUrlToFlats < ActiveRecord::Migration[7.1]
  def change
    add_column :flats, :image_url, :string
  end
end
