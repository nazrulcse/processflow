json.array!(@comments) do |comment|
  json.extract! comment, :id, :comment, :task_id, :user_id, :parent
  json.url comment_url(comment, format: :json)
end
