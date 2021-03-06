class Api::V1::ExamRulesController < Api::V1::BaseController
  respond_to :json

  def index
    exam_rule = classroom.exam_rule
    absence_type_definer = FrequencyTypeDefiner.new(classroom, teacher)
    absence_type_definer.define!
    exam_rule.allow_frequency_by_discipline = (absence_type_definer.frequency_type == FrequencyTypes::BY_DISCIPLINE)
    render json: exam_rule
  end

  private
  def classroom
    Classroom.find(params[:classroom_id])
  end

  def teacher
    Teacher.find(params[:teacher_id])
  end
end
