TestApp.route('login') do |r|
  r.root do
    r.redirect '/' if current_user
    wedge(:login).to_js :display
  end
end
