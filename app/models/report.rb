# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true

  has_many :mentions, dependent: :destroy
  has_many :mentioning_reports, through: :mentions, source: :mentioned_report

  has_many :reverse_of_mentions, class_name: 'Mention', foreign_key: 'mentioned_report_id', dependent: :destroy, inverse_of: 'mentioned_report'
  has_many :mentioned_reports, through: :reverse_of_mentions, source: :report

  after_save :create_mention

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def create_mention
    mentioning_ids = self.content.scan(%r{http://localhost:3000/reports/(\d+)}).flatten.uniq
    report_ids = Report.pluck(:id)
    mentions.destroy_all

    if mentioning_ids.present?
      mentioning_ids.each do |mentioning_id|
        id = mentioning_id.to_i
        self.mentions.create(mentioned_report_id: id) if id != self.id && report_ids.include?(id)
      end
    end
  end
end
