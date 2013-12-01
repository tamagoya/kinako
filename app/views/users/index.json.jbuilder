json.array!(@users) do |user|
  json.extract! user, :email, :name, :kidlemail
  json.url user_url(user, format: :json)
end
