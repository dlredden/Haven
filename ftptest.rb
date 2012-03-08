require 'net/sftp'
require File.join(File.expand_path(File.dirname(__FILE__)), '/lib/ftp_file')

def get_remote_file_listing(_path, _level, _depth = 1)
  def build_array(_sftp, _path, _level, _depth, _entries)
    _file_array = []
    
    # Turn a path of '.' or '..' into the real path name
    if (_path =~ /^\./o)
      _path = _sftp.realpath!(_path).name
    end
    
    _entries.each do |_file|
      # Skip all hidden files, i.e. files that start with a period like .profile
      next if (_file.name =~ /^\./o)
      
      _ftp_file = FtpFile.new()
      _ftp_file.name = _file.name
      _ftp_file.path = _path
      _ftp_file.size = _file.attributes.size
      _ftp_file.level = _level
      
      if (_file.file?)
        _ftp_file.is_dir = false
      elsif (_file.directory?)
        _ftp_file.is_dir = true
        if (_depth > 0)
          _ftp_file.files = build_array(_sftp, "#{_path}/#{_file.name}", _level + 1, _depth - 1, _sftp.dir.entries("#{_path}/#{_file.name}"))
        end
      elsif (_file.symlink?)
        _ftp_file.link_path = _sftp.readlink!("#{_path}/#{_file.name}").name
        begin
          _tmpentries = _sftp.dir.entries("#{_path}/#{_file.name}")
          _ftp_file.is_dir = true
          if (_depth > 0)
            _ftp_file.files = build_array(_sftp, "#{_path}/#{_file.name}", _level + 1, _depth - 1, _tmpentries)
          end
        rescue Exception => ex
          p ex  
          _ftp_file.is_dir = false
        end
      end
      
      _file_array.push(_ftp_file)
    end
    _file_array
  end

  Net::SFTP.start('wikidlabs.com', 'yoda', :password => 's3cr3ty0da') do |_sftp|
    @files = build_array(_sftp, _path, _level, _depth, _sftp.dir.entries(_path))
  end
  p @files
end

get_remote_file_listing(".", 0, 1)