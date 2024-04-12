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
    datetime = DateTime.new(1993, 2, 24, 12, 30, 45)
    date = Date.new(1993, 2, 24)
    report = Report.new(created_at: datetime)
    assert_equal date, report.created_on
  end

  test 'save_mentions when create report' do
    mentioned_report = reports(:report_id1)
    mentioning_report = reports(:report_id2)
    mentioning_report.content = 'http://localhost:3000/reports/1の日報を読みながら過ごした。'
    mentioning_report.save
    assert_not mentioning_report.mentioning_reports.empty?

    mentioning_report.mentioning_reports.each do |report|
      assert_equal mentioned_report, report
    end
  end

  test 'save_mentions when update report' do
    mentioned_report = reports(:report_id1)
    mentioning_report = reports(:report_id2)
    mentioning_report.update(content: 'http://localhost:3000/reports/1の日報を読みながら過ごした。')
    assert_not mentioning_report.mentioning_reports.empty?

    mentioning_report.mentioning_reports.each do |report|
      assert_equal mentioned_report, report
    end
  end

  test 'save_mentions when destroy report' do
    mentioning_report = reports(:report_id2)
    mentioning_report.content = 'http://localhost:3000/reports/1の日報を読みながら過ごした。'
    mentioning_report.save
    assert ReportMention.exists?

    mentioning_report.destroy
    assert_not ReportMention.exists?
  end

  test 'save_mentions case mentioning not exist report' do
    mentioning_report = reports(:report_id2)
    mentioning_report.content = 'http://localhost:3000/reports/99の日報を読みながら過ごした。'
    mentioning_report.save
    assert_not ReportMention.exists?
  end

  test 'save_mentions case mentioning self report' do
    mentioning_report = reports(:report_id2)
    mentioning_report.content = '自分自身のhttp://localhost:3000/reports/2の日報を読みながら過ごした。'
    mentioning_report.save
    assert_not ReportMention.exists?
  end
end
