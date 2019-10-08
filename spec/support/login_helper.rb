module LoginHelper
  def login(account)
    visit login_path
    fill_in "session_username", with: account.username
    fill_in "session_password", with: account.password
    click_button "Login"
  end
end
