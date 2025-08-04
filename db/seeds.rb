User.find_or_create_by!(user_id: "hanako") do |user|
  user.name = "hanako"
  user.user_id = "hanako"
  user.password = "hanako"
  user.password_confirmation = "hanako"
end

User.find_or_create_by!(user_id: "taro") do |user|
  user.name = "taro"
  user.user_id = "taro"
  user.password = "taro"
  user.password_confirmation = "taro"
end
