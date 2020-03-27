class AddPlaylistsSize < ActiveRecord::Migration[6.0]
  def change
    add_column :playlists, :size, :integer
  end
end
