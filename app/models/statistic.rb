class Statistic < ActiveRecord::Base
  serialize :statistics, Array
  belongs_to :project
end
