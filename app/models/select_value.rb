class SelectValue < ActiveRecord::Base
  def getMonth
     Date.today.month
 end
end
