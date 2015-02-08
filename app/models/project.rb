class Project < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :tasks
  has_many :statistics

  def self.create_statistics
     self.all.each do |project|
       create_stats_record('feature', project)
       create_stats_record('bug', project)
     end
  end

  def self.create_stats_record(type, project)
    stats = project.tasks.select('id, count(id) as total, status_id').where('task_type = ?', type).group('status_id')
    statistics = [0, 0, 0, 0, 0, 0]
    stats.each do |stat|
      statistics[stat.status_id] = stat.total
    end
    Statistic.create(:date => Date.today, :statistics => statistics, :statistics_type => type, :project_id => project.id)
  end

end
