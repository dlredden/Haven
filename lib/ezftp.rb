# Ezftp
# This class is designed to provide a simpler interface to the most common FTP
# usage scenarios. The desire was to be able to use a single class to perform
# common FTP actions using FTP or SFTP without having to know how to do the
# tasks with FTP or SFTP commands. Hopefully all who use this plugin will find it usefull.

class Ezftp
  attr_accessor :host, :user, :password, :sftp
  
  # Overload the 
  def sftp=(_value)
    write_attribute(:sftp, _value)
    load_library()
  end
  
  # Both of the files ftp_wrapper.rb and sftp_wrapper.rb contain identical
  # FTPWrapper classes, except one is built on FTP and the other on SFTP.
  # This allows the @@connection object to react exactly the
  # same way to requests without having know it we're using FTP or SFTP
  def load_library()
    if (@sftp)
      load File.join(File.expand_path(File.dirname(__FILE__)), "sftp_wrapper.rb")
    else
      load File.join(File.expand_path(File.dirname(__FILE__)), "ftp_wrapper.rb")
    end
  end
  
  ###############################################################################
  # Constructors and utility methods
  ###############################################################################
  
  def initialize(_host, _user, _password, _sftp = false)
    @host = _host
    @user = _user
    @password = _password
    @sftp = _sftp
    @connection = FTPWrapper.new(@host, @user, @password)
    self
  end
  
  ###############################################################################
  # Directory methods
  ###############################################################################
  
  # This method was written specifically so that a local representation of the remote
  # directory tree could be made without downloading the entire directory tree
  def directory_tree_to_array(_path)
     @connection.directory_tree_to_array(_path)
  end
  
  def download_directory(remote_directory, local_directory = remote_directory, recursive = false)
 #   @connection.download_directory(remote_directory, local_directory)
  end

  def upload_directory(local_directory, remote_directory = local_directory, recursive = false)
 #   @connection.upload_directory(local_directory, remote_directory)
  end
  
  def create_directory(name, path = nil)
    
  end
  
  def rename_directory(old_name, new_name, path = nil)
    
  end
  
  def delete_directory(name, path = nil)
    
  end
  
  def move_directory(name, old_path, new_path)
    
  end
  
  def copy_directory(base_name, base_path, new_name, new_path)
    
  end
  
  ###############################################################################
  # File methods
  ###############################################################################
  
  def upload_file(local_file, remote_file = local_file)
    @connection.upload_file(local_file, remote_file)
  end
  
  def download_file(remote_file, local_file = remote_file)
    @connection.download_file(remote_file, local_file)
  end

  def download_file_to_string(remote_file)
    @connection.download_file_to_string(remote_file)
  end

  def upload_file_from_string(local_string, remote_file)
    @connection.upload_file_from_string(local_string, remote_file)
  end
  
  def create_file(name, path = nil)
    
  end
  
  def rename_file(old_name, new_name, path = nil)
    
  end
  
  def delete_file(name, path = nil)
    
  end
  
  def move_file(name, old_path, new_path)
    
  end
  
  def copy_file(base_name, base_path, new_name, new_path)
    
  end
end