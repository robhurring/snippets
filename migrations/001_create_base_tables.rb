class CreateBaseTables < ActiveRecord::Migration
  def self.up
		create_table :snippets, :force => true, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
		  t.string :title
		  t.integer :version, :default => 1
      t.text :data
      t.timestamps
    end
    
		create_table :revisions, :force => true, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer :snippet_id
      t.integer :version, :default => 1
		  t.text :data
		  t.timestamps
    end
    
    add_index :snippets, :title
    add_index :revisions, :version
  end
  
  def self.down
    drop_table :snippets
    drop_table :revisions
  end
end