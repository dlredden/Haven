class ActiveFile < ActiveRecord::Base
  belongs_to :project
  belongs_to :account_user
  
  attr_accessor :file_type
  
  validates_uniqueness_of(:name, :scope => [:path, :account_user_id, :project_id])
  
  def after_initialize()
    self.file_type = FileType.find_by_extension(self.file_extension())
    
    if (!self.file_type)
      self.file_type = FileType.new()
      self.file_type.extension = self.file_extension()
      self.file_type.type_name = "Unspecified"
      self.file_type.image = "file_icons/32x32_unknown_file_type.png"
    end
  end
  
  def full_name()
    return self.path + "/" + self.name
  end
  
  def file_extension()
    _file_parts = self.name.split('.')
    _file_parts[-1]
  end
end