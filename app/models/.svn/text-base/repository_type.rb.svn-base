class RepositoryType < ActiveRecord::Base
  has_many :repositories
  has_many :projects, :through => :repositories
  
  validates_presence_of :name
end
