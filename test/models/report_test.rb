# frozen_string_literal: true

require 'test_helper'
require 'debug' # binding.break

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
    current_date = Date.today
    report = Report.new(created_at: current_datetime)
    assert_equal current_date, report.created_on
  end

  test 'save_mentions when create report' do
    mentioned_report = reports(:mentioned_report_id_1_form_report_id_3)
    mentioning_report = reports(:mentioning_report_id_3_to_report_id_1)
    mentioning_report.save
    assert_not mentioning_report.mentioning_reports.empty?

    mentioning_report.mentioning_reports.each do |mentioning_report|
      assert_equal mentioned_report, mentioning_report
    end
  end

  test 'save_mentions when update report' do
    mentioned_report = reports(:mentioned_report_id_2_form_report_id_3)
    mentioning_report = reports(:mentioning_report_id_3_to_report_id_1)
    new_content = '言及をhttp://localhost:3000/reports/2に変更する'
    mentioning_report.update(content: new_content)
    assert_not mentioning_report.mentioning_reports.empty?

    mentioning_report.mentioning_reports.each do |mentioning_report|
      assert_equal mentioned_report, mentioning_report
    end
  end

  test 'save_mentions when destroy report' do
    mentioning_report = reports(:mentioning_report_id_3_to_report_id_1)
    mentioning_report.save
    assert ReportMention.exists?

    mentioning_report.destroy
    assert_not ReportMention.exists?
  end

  test 'save_mentions case mentioning not exist report' do
    report = reports(:mentioning_report_id_4_to_not_exist_report)
    report.save
    assert_not ReportMention.exists?
  end

  test 'save_mentions case mentioning self report' do
    report = reports(:mentioning_report_id_5_to_self_report)
    report.save
    assert_not ReportMention.exists?
  end
end
