# frozen_string_literal: true

require 'test_helper'
require 'debug' # binding.break

class ReportTest < ActiveSupport::TestCase
  test 'editable?' do
    eligible_user = User.new(email: 'eligible@example.com', name: 'eligible_user')
    ineligible_user = User.new(email: 'ineligible@example.com', name: 'ineligible_user')
    report = Report.new(user: eligible_user)
    assert report.editable?(eligible_user)
    assert_not report.editable?(ineligible_user)
  end

  test 'created_on' do
    current_datetime = DateTime.now
    current_date = Date.today
    report = Report.new(created_at: current_datetime)
    assert_equal current_date, report.created_on
  end

  test 'save_mentions' do
    mentioning_report = Report.new(content: 'http://localhost:3000/reports/1')
    mentioned_report = Report.new(id: 1)
    mentioning_report.mentioning_reports.each do |report|
      assert_equal mentioned_report, report
    end
  end
end
