# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true

  has_many :mentioning_mentions, class_name: 'Mention', foreign_key: 'mentioning_report_id', dependent: :destroy
  has_many :mentioning, through: :mentioning_mentions, source: :mentioned_report

  has_many :mentioned_mentions, class_name: 'Mention', foreign_key: 'mentioned_report_id', dependent: :destroy
  has_many :mentioned, through: :mentioned_mentions, source: :mentioning_report

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end
end
