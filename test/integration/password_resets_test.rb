test "forgot password form" do
  get new_password_reset_path
  assert_template "password_resets/new"
  # Invalid email
  post password_resets_path, params: {password_reset: {email: ""}}
  assert_not flash.empty?
  assert_template "password_resets/new"
  # Valid email
  post password_resets_path,
    params: {password_reset: {email: @user.email}}
  assert_not_equal @user.reset_digest, @user.reload.reset_digest
  assert_equal 1, ActionMailer::Base.deliveries.size
  assert_not flash.empty?
  assert_redirected_to root_path
end

test "password resets link" do
  get new_password_reset_path
  post password_resets_path,
    params: {password_reset: {email: @user.email}}
  user = assigns(:user)
  # Inactive user
  user.toggle!(:activated)
  get edit_password_reset_path id: user.reset_token, email: user.email
  assert_redirected_to root_path
  user.toggle!(:activated)
  # Wrong email
  get edit_password_reset_path user.reset_token, email: ""
  assert_redirected_to root_path
  # # Right email, wrong token
  get edit_password_reset_path "wrong token", email: user.email
  assert_redirected_to root_path
  # Right email, right token
  get edit_password_reset_path user.reset_token, email: user.email
  assert_template "password_resets/edit"
  assert_select "input[name=email][type=hidden][value=?]", user.email
end

test "password resets form" do
  get new_password_reset_path
  post password_resets_path,
    params: {password_reset: {email: @user.email}}
  user = assigns(:user)
  # Invalid password & confirmation
  patch password_reset_path(user.reset_token),
    params: {email: user.email,
             user: {password: "foobaz",
                    password_confirmation: "barquux"}}
  assert_select "div#error_explanation"
  # Empty password
  patch password_reset_path(user.reset_token),
    params: {email: user.email,
             user: {password: "",
                    password_confirmation: ""}}
  assert_select "div#error_explanation"
  # Valid password & confirmation
  patch password_reset_path(user.reset_token),
    params: {email: user.email,
             user: {password: "foobaz",
                    password_confirmation: "foobaz"}}
  assert is_logged_in?
  assert_not flash.empty?
  assert_redirected_to user
end

test "expired token" do
  get new_password_reset_path
  post password_resets_path,
    params: {password_reset: {email: @user.email}}

  @user = assigns(:user)
  @user.update_attribute(:reset_sent_at, 3.hours.ago)
  patch password_reset_path(@user.reset_token),
    params: {email: @user.email,
             user: {password: "foobar",
                    password_confirmation: "foobar"}}
  assert_response :redirect
  follow_redirect!
  expried = /expired/i
  assert_match expried, response.body
end
