class File
	attr_accessor :size, :contents, :last_mod_datetime, :full_name, :is_dirty, :file_type
  attr_accessor :base_name, :line_count, :type, :path, :project_id, :dirty_indicator
  
  def after_initialize()
    self.file_type = FileType.find_by_extension(self.file_extension())
    
    if (!self.file_type)
      self.file_type.extention = self.file_extension()
      self.file_type.type_name = "Unspecified"
      self.file_type.image = "32x32_unknown_file_type.png"
    end
  end
  
  def file_extension()
    _file_parts = self.fullName.split('.')
    _file_parts[-1]
  end
  
  def save()
    
  end
  
  def store()
    
  end
  
  def delete()
    
  end
  
  
end