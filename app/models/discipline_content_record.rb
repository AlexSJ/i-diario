class DisciplineContentRecord < ActiveRecord::Base
  include Audit

  acts_as_copy_target

  audited
  has_associated_audits

  belongs_to :content_record, dependent: :restrict
  accepts_nested_attributes_for :content_record

  belongs_to :discipline

  scope :by_unity_id, lambda { |unity_id| joins(content_record: :classroom).where(Classroom.arel_table[:unity_id].eq(unity_id) ) }
  scope :by_teacher_id, lambda { |teacher_id| joins(:content_record).where(content_records: { teacher_id: teacher_id }) }
  scope :by_classroom_id, lambda { |classroom_id| joins(:content_record).where(content_records: { classroom_id: classroom_id }) }
  scope :by_discipline_id, lambda { |discipline_id| where(discipline_id: discipline_id )}
  scope :by_classroom_description, lambda { |description| joins(content_record: :classroom).where('classrooms.description ILIKE ?', "%#{description}%" ) }
  scope :by_discipline_description, lambda { |description| joins(:discipline).where('disciplines.description ILIKE ?', "%#{description}%" ) }
  scope :by_date, lambda { |date| joins(:content_record).where(content_records: { record_date: date.to_date }) }
  scope :ordered, -> { joins(:content_record).order(ContentRecord.arel_table[:record_date].desc) }

  validates :content_record, presence: true
  validates :discipline, presence: true

  validate :uniqueness_of_discipline_content_record

  delegate :contents, to: :content_record

  private

  def uniqueness_of_discipline_content_record
    return unless content_record.present? && content_record.classroom.present? && content_record.record_date.present?

    discipline_content_records = DisciplineContentRecord.by_teacher_id(content_record.teacher_id)
      .by_classroom_id(content_record.classroom_id)
      .by_discipline_id(discipline_id)
      .by_date(content_record.record_date)

    discipline_content_records = discipline_content_records.where.not(id: id) if persisted?

    if discipline_content_records.any?
      errors.add(:discipline_id, :discipline_in_use)
    end
  end

end
