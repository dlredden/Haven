class CreateFilesystems < ActiveRecord::Migration
  def self.up
#    create_table :filesystems do |t|
#			t.column :name, :string
#			t.column :is_directory, :string, :limit => 1
#			t.column :parent_id, :integer, :default => 0, :null => false
#      t.timestamps
#    end
    require 'find'
		dirs = ['/s3/123456/project2']
		#Excludes = []			# No excludes yet, but will add dot files eventually
		root = Filesystem.new(:name=>"project_root", :is_directory=>'f')
		root.save
		for dir in dirs
			#pathsplit = dir.split('/')
			#shortname = pathsplit[pathsplit.length - 1]
			#basepath = dir[0,dir.rindex('/')]
			parent = Filesystem.new(:name=>dir, :is_directory=>'t', :parent_id=>root.id)
			parent.save
			iterations = 0
  		Find.find(dir) do |path|
  		p dir
  		p path
  		if iterations != 0
    		if FileTest.directory?(path) # path is a directory
      		basepath = path[0,path.rindex('/')]
      		p basepath
      		query = "select id from filesystems where name = '" + basepath + "' AND is_directory = 't'"
					p query
					parent = Filesystem.find_by_sql(query)
					p parent
					Filesystem.create(:name=>path, :is_directory=>'t', :parent_id=>parent[0].id)
    		else
    			basepath = path[0,path.rindex('/')]
    			query = "select id from filesystems where name = '" + basepath + "' AND is_directory = 't'"
					p query
					parent = Filesystem.find_by_sql(query)
					p parent
    			Filesystem.create(:name=>path, :is_directory=>'f', :parent_id=>parent[0].id)
    		end
    	end
    	iterations += 1
    	end
  	end
  end

  def self.down
    drop_table :filesystems
  end
end
