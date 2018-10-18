class TeacherDisciplineClassroom < ActiveRecord::Base
  acts_as_copy_target

  # acts_as_paranoid

  audited

  include Audit

  belongs_to :teacher
  belongs_to :discipline
  belongs_to :classroom

  validates :teacher, :teacher_api_code, :discipline_api_code, :classroom_api_code, :year, presence: true

  default_scope { where(arel_table[:active].eq(true)) }

  scope :by_classroom, lambda { |classroom| where(classroom: classroom) }
  scope :by_teacher_id, lambda { |teacher_id| where(teacher_id: teacher_id) }
  scope :by_year, lambda { |year| where(year: year) }
end
