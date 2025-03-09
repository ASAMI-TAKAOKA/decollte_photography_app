# 特権管理者を作成（存在しない場合のみ）
AdminUser.find_or_create_by!(username: 'admin') do |admin|
  admin.password = 'UMtDj4ZBv%&d@Tzh'
  admin.password_confirmation = 'UMtDj4ZBv%&d@Tzh'
  admin.role = 1  # roleカラムで特権管理者かどうかを区別する
end

# 一般管理者を作成（存在しない場合のみ）
AdminUser.find_or_create_by!(username: 'regular_admin') do |reqular_admin|
  reqular_admin.password = 'password1234'
  reqular_admin.password_confirmation = 'password1234'
  reqular_admin.role = 0
end
