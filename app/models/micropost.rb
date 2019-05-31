class Micropost < ApplicationRecord
  belongs_to :user

  scope :order_created, ->{order created_at: :desc}

  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.micropost.length_max}
  validate  :picture_size

  private

  # Validates the size of an uploaded picture.
  def picture_size
    return unless picture.size > Settings.max_upload_size.megabytes
    errors.add :picture, t("less_than_5mb")
  end
end
