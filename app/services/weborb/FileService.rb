#!/usr/bin/ruby
require 'weborb/context'
require 'rbconfig'
require File.dirname(__FILE__) + '/../../models/filevo'

class FileService
	def openFile(filename)
		print filename + "\n"
		thisFile = FileVO.new
		f = File.open(filename, 'r')

		thisFile.isDirty = false
		thisFile.dirtyIndicator = "*"
		thisFile.fullName = filename;
		thisFile.baseName = File.basename(filename)
		thisFile.type = File.extname(filename).gsub(/^\./, '')

		if (thisFile.type == "")
			thisFile.type = nil
		end

		thisFile.lastModDatetime = f.mtime
		thisFile.path = File.dirname(filename)
		thisFile.size = f.stat.size
		textArray = f.readlines
		thisFile.lineCount = textArray.length
		thisFile.text = textArray.join
		return thisFile
	end
	
	def saveFile(filename = nil, text = nil)
		f = File.open(filename, 'w')
		f.write(text)
		f.close
		system("../odeit/remove_ctrl-m.sh #{filename}")
		file = openFile(filename);
		return file
	end
end

if __FILE__ == $0
	fileService = FileService.new
	filestuff = fileService.openFile("/s3/123456/1/wikidcode/app/controllers/clients_controller.rb")

	puts "Full Name: #{filestuff.fullName}"
	puts "File Name: #{filestuff.baseName}"
	puts "File Path: #{filestuff.path}"
	puts "File Type: #{filestuff.type}"
	puts "File Size: #{filestuff.size} bytes"
	puts "File LC  : #{filestuff.lineCount}"
	puts "Last Mod : #{filestuff.lastModDatetime}"
	puts "Text     : ", filestuff.text
	puts "Is Dirty : #{filestuff.isDirty}"
	puts "Dirty Ind: #{filestuff.dirtyIndicator}"
	
	filestuff = fileService.saveFile("./clients_controller.rb", filestuff.text);

	puts "Full Name: #{filestuff.fullName}"
	puts "File Name: #{filestuff.baseName}"
	puts "File Path: #{filestuff.path}"
	puts "File Type: #{filestuff.type}"
	puts "File Size: #{filestuff.size} bytes"
	puts "File LC  : #{filestuff.lineCount}"
	puts "Last Mod : #{filestuff.lastModDatetime}"
	puts "Text     : ", filestuff.text
	puts "Is Dirty : #{filestuff.isDirty}"
	puts "Dirty Ind: #{filestuff.dirtyIndicator}"
end	
