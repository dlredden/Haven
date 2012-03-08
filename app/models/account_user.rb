class AccountUser < ActiveRecord::Base
  belongs_to :account
  belongs_to :user, :dependent => :destroy
  has_many :active_files, :dependent => :destroy
  
  MAX_NUM_FILES = 10
  
  def is_admin()
    (self.role == "Admin") ? true : false
  end
  
  def get_active_files_by_project(_id)
    self.active_files.find_all_by_project_id(_id)
  end
  
  # Cleanup the recent files list so that it doesn't get too long
  def cleanup_open_files()
    if (self.active_files.length > MAX_NUM_FILES)
      _counter = 0
      
      self.active_files.each { |_file|
        _counter += 1
      
        if (_counter > MAX_NUM_FILES && _file.is_saved)
          _file.destroy()
        end
      }
    end
  end
end