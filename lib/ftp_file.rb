class FtpFile
  attr_accessor :name, :path, :is_dir, :size, :level, :link_path, :files
  
  def link?()
    (@link_path == nil) ? false : true
  end
  
  def dir?()
    @is_dir
  end
end
