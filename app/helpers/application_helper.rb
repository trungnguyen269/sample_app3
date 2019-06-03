module ApplicationHelper
  def full_title page_title
    base_title = I18n.t "main_title"
    if page_title.blank?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def current_relationship
    if current_user.following? @user
      current_user.active_relationships.find_by(followed_id: @user.id)
    else
      current_user.active_relationships.build
    end
  end
end
