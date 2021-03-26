#Gravatar = メールアドレスに対して自分のアバター画像を登録するサービスを使用
module UsersHelper
  def gravatar_url(user, options = { size: 80})
      gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
      size = options[:size]
      "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
  end
end
