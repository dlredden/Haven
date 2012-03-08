require "net/sftp"
require File.join(File.expand_path(File.dirname(__FILE__)), "ftp_file")

class FTPWrapper
  attr_accessor :host, :user, :password
  
  ###############################################################################
  # Constructors and utility methods
  ###############################################################################
  def initialize(_host, _user, _password)
    @host = _host
    @user = _user
    @password = _password
  end
  
  def list(_name = ".")
    Net::SFTP.start(@host, @user, :password => @password) do |_sftp|
      _sftp.dir.foreach(_name) do | entry |
        puts entry.longname
      end
    end
  end
  
  ###############################################################################
  # Directory methods
  ###############################################################################
  
  # A RECURSIVE method that returns an array of FtpFile objects _depth directories
  # deep. Each FtpFile has an array named "files" that will be populated with the
  # directories files as long as it is within the specified _depth.
  def directory_tree_to_array(_path, _level, _depth = 0)
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
  
    Net::SFTP.start(@host, @user, :password => @password) do |_sftp|
      @files = build_array(_sftp, _path, _level, _depth, _sftp.dir.entries(_path))
    end
    @files
  end
  
  ###############################################################################
  # File methods
  ###############################################################################
  
  def open_file(_file)
    Net::SFTP.start(@host, @user, :password => @password) do |_sftp|
      
    end
  end
end