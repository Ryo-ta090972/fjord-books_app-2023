# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test 'editable?' do
    alice = users(:alice)
    bob = users(:bob)
    report = Report.new(user: alice)
    assert report.editable?(alice)
    assert_not report.editable?(bob)
  end

  test 'created_on' do
    current_datetime = DateTime.now
    current_date = Time.zone.today
    report = Report.new(created_at: current_datetime)
    assert_equal current_date, report.created_on
  end

  test 'save_mentions when create report' do
    mentioned_report = reports(:mentioned_report_id1_from_report_id3)
    mentioning_report = reports(:mentioning_report_id3_to_report_id1)
    mentioning_report.save
    assert_not mentioning_report.mentioning_reports.empty?

    mentioning_report.mentioning_reports.each do |report|
      assert_equal mentioned_report, report
    end
  end

  test 'save_mentions when update report' do
    mentioned_report = reports(:mentioned_report_id2_from_report_id3)
    mentioning_report = reports(:mentioning_report_id3_to_report_id1)
    new_content = '言及をhttp://localhost:3000/reports/2に変更する'
    mentioning_report.update(content: new_content)
    assert_not mentioning_report.mentioning_reports.empty?

    mentioning_report.mentioning_reports.each do |report|
      assert_equal mentioned_report, report
    end
  end

  test 'save_mentions when destroy report' do
    mentioning_report = reports(:mentioning_report_id3_to_report_id1)
    mentioning_report.save
    assert ReportMention.exists?

    mentioning_report.destroy
    assert_not ReportMention.exists?
  end

  test 'save_mentions case mentioning not exist report' do
    report = reports(:mentioning_report_id4_to_not_exist_report)
    report.save
    assert_not ReportMention.exists?
  end

  test 'save_mentions case mentioning self report' do
    report = reports(:mentioning_report_id5_to_self_report)
    report.save
    assert_not ReportMention.exists?
  end
end
