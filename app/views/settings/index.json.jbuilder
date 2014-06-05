json.array!(@settings) do |setting|
  json.extract! setting, :id, :user_id, :key, :value
  json.url setting_url(setting, format: :json)
end
