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

  test 'save_mentions when create report' do
    mentioned_report_1 = reports(:mentioned_report_1)
    mentioning_report = reports(:mentioning_report)
    mentioning_report.save
    assert_not mentioning_report.mentioning_reports.empty?

    mentioning_report.mentioning_reports.each do |report|
      assert_equal mentioned_report_1, report
    end
  end

  test 'save_mentions when update report' do
    mentioned_report_2 = reports(:mentioned_report_2)
    mentioning_report = reports(:mentioning_report)
    new_content = 'http://localhost:3000/reports/2'
    mentioning_report.update(content: new_content)
    assert_not mentioning_report.mentioning_reports.empty?

    mentioning_report.mentioning_reports.each do |report|
      assert_equal mentioned_report_2, report
    end
  end
end
