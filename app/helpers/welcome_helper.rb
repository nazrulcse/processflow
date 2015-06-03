module WelcomeHelper
  def count_history(user_id,task_id)
    UserSubcription.where(:user_id => user_id , task_id: task_id).count
  end
end
