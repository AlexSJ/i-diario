class AttendanceRecordReportController < ApplicationController
  before_action :require_current_teacher
  before_action :require_current_school_calendar

  def form
    @attendance_record_report_form = AttendanceRecordReportForm.new(
      unity_id: current_user_unity.id,
      school_calendar_year: current_school_calendar.year
    )
    fetch_collections
  end

  def report
    @attendance_record_report_form = AttendanceRecordReportForm.new(resource_params)
    @attendance_record_report_form.school_calendar = current_school_calendar

    if @attendance_record_report_form.valid?
      attendance_record_report = AttendanceRecordReport.build(current_entity_configuration,
                                                              current_teacher,
                                                              current_school_calendar.year,
                                                              @attendance_record_report_form.start_at,
                                                              @attendance_record_report_form.end_at,
                                                              @attendance_record_report_form.daily_frequencies,
                                                              @attendance_record_report_form.students_enrollments,
                                                              @attendance_record_report_form.school_calendar_events,
                                                              current_school_calendar)
      send_pdf(t("routes.attendance_record"), attendance_record_report.render)
    else
      @attendance_record_report_form.school_calendar_year = current_school_calendar.year
      fetch_collections
      clear_invalid_dates
      render :form
    end
  end

  private

  def fetch_collections
    @number_of_classes = current_school_calendar.number_of_classes
    @teacher = current_teacher
  end

  def resource_params
    params.require(:attendance_record_report_form).permit(:unity_id,
                                                          :classroom_id,
                                                          :discipline_id,
                                                          :class_numbers,
                                                          :start_at,
                                                          :end_at,
                                                          :school_calendar_year,
                                                          :current_teacher_id)
  end

  def clear_invalid_dates
    begin
      resource_params[:start_at].to_date
    rescue ArgumentError
      @attendance_record_report_form.start_at = ''
    end

    begin
      resource_params[:end_at].to_date
    rescue ArgumentError
      @attendance_record_report_form.end_at = ''
    end
  end
end
