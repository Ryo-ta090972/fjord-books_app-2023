# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test "editable?" do
    target_user = User.new(email: 'test@example.com', name:'test')
    report = Report.new(user: target_user)
    assert report.editable?(target_user)
  end

  test "created_on" do
    date = '2024-3-27'.to_date
    report = Report.new(created_at: date)
    assert_equal date, report.created_on
  end

  test "save_mentions" do
    mentioning_report = Report.new(content: 'http://localhost:3000/reports/1')
    mentioned_report = Report.new(id: 1)
    mentioning_report.mentioning_reports.each do |report|
      assert_equal mentioned_report, report
    end
  end
end
