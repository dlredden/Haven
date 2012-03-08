require "net/ftp"
require File.join(File.expand_path(File.dirname(__FILE__)), "ezftp_file")

class FTPWrapper
  @@my_connection = Net::FTP.new()
  @@is_connected = false
  
  ###############################################################################
  # Constructors and utility methods
  ###############################################################################
  
  def initialize(host_name, user_name, password)
    @@my_connection.connect(host_name)
    @@my_connection.login(user_name, password)
    @@is_connected = true
  end
  
  def close()
    @@my_connection.close()
  end

  def closed?()
    @@my_connection.closed?
  end
  
  def list(name = ".")
    @@my_connection.list(name)
  end
  
  def system()
    @@my_connection.system()
  end
  
  ###############################################################################
  # Directory methods
  ###############################################################################
  
  def directory_tree_to_array(name)
    # At this point I'm only supporting FTP to a Unix based file system
    raise "Unsupported OS '#{@@my_connection.system().chomp()}'" if (@@my_connection.system() !~ /UNIX/)
    list_directory_recursively(name)
  end
  
  def download_directory(remote_directory, local_directory = remote_directory)
    @@my_connection.download_directory(remote_directory, local_directory)
  end

  def upload_directory(local_directory, remote_directory = local_directory)
    @@my_connection.upload_directory(local_directory, remote_directory)
  end
  
  ###############################################################################
  # File methods
  ###############################################################################
  
  def upload_file(local_file, remote_file = local_file)
    @@my_connection.putbinaryfile(local_file, remote_file)
  end
  
  def download_file(remote_file, local_file = remote_file)
    @@my_connection.getbinaryfile(remote_file, local_file)
  end

  def download_file_to_string(remote_file)
    @return_string = ""
    @@my_connection.getbinaryfile(remote_file, "\dev\null") { |data|
      @return_string += data
    }
    @return_string
  end

  def upload_file_from_string(local_string, remote_file)
    @@my_connection.upload_file_from_string(local_string, remote_file)
  end
  
  private
  
  def list_directory_recursively(path, level = 0, return_object = [])
    @files = @@my_connection.list(path).sort { |x,y|
      if ((y =~ /^d/ && x =~ /^d/) || (y !~ /^d/ && x !~ /^d/))
        y.split(/\s+/)[-1].downcase <=> x.split(/\s+/)[-1].downcase
      elsif (x =~ /^d/)
        1
      else
        -1
      end
    }
  
    @files.reverse.each { |file|
      @attributes = file.split(/\s+/)
      @this_file = EzftpFile.new()

      if (file =~ /^d/)
        @this_file.dir = true
        @this_file.level = level
        @this_file.file_name = @attributes[-1]
        @this_file.path = path
        return_object.push(@this_file)
        
        list_directory_recursively("#{path}/#{@attributes[-1]}", level + 1, return_object)
      else
        @this_file.dir = false
        @this_file.level = level
        @this_file.file_name = @attributes[-1]
        @this_file.path = path
        return_object.push(@this_file)
      end
    }
    
    return_object
  end
end