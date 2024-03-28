# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[edit update destroy]

  def index
    @reports = Report.includes(:user).order(id: :desc).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
  end

  # GET /reports/new
  def new
    @report = current_user.reports.new
  end

  def edit; end

  def create
    @report = current_user.reports.new(report_params)
    mentioning_report_ids = scan_mention_report_ids

    if @report.save
      create_mention(mentioning_report_ids)
      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @report.update(report_params)
      mentioning_report_ids = scan_mention_report_ids
      create_mention(mentioning_report_ids)
      redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @report.destroy

    redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  private

  def set_report
    @report = current_user.reports.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :content)
  end

  def scan_mention_report_ids
    @report.content.scan(%r{http://localhost:3000/reports/(\d+)}).flatten.uniq
  end

  def create_mention(mentioning_ids)
    @report.mentions.destroy_all
    if mentioning_ids.present?
      mentioning_ids.each do |mentioning_id|
        id = mentioning_id.to_i
        @report.mentions.create(mentioned_report_id: id) if id != @report.id && Report.pluck(:id).include?(id)
      end
    end
  end
end
