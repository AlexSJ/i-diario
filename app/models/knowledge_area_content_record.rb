class KnowledgeAreaContentRecord < ActiveRecord::Base
  include Audit

  acts_as_copy_target

  audited
  has_associated_audits

  belongs_to :content_record, dependent: :destroy
  belongs_to :knowledge_area

  accepts_nested_attributes_for :content_record

  scope :by_unity_id, lambda { |unity_id| joins(content_record: :classroom).where(content_records: { classrooms: { unity_id: unity_id } }) }
  scope :by_teacher_id, lambda { |teacher_id| joins(:content_record).where(content_records: { teacher_id: teacher_id }) }
  scope :by_classroom_id, lambda { |classroom_id| joins(:content_record).where(content_records: { classroom_id: classroom_id }) }
  scope :by_knowledge_area_id, lambda { |knowledge_area_id| where(knowledge_area_id: knowledge_area_id) }
  scope :by_date, lambda { |date| joins(:content_record).where(content_records: { date: date.to_date }) }
  scope :ordered, -> { joins(:content_record).order(ContentRecord.arel_table[:record_date].desc) }

  validates :content_record, presence: true
  validates :knowledge_area, presence: true

  validate :uniqueness_of_knowledge_area_content_record

  private

  def uniqueness_of_knowledge_area_content_record
    return unless content_record.present? && content_record.classroom.present?

    knowledge_area_content_records = KnowledgeAreaContentRecord.by_teacher_id(content_record.teacher_id)
      .by_classroom_id(content_record.classroom_id)
      .by_knowledge_area_id(knowledge_area_id)
      .by_date(content_record.content_date)

    knowledge_area_content_records = knowledge_area_content_records.where.not(id: id) if persisted?

    if knowledge_area_content_records.any?
      content_record.errors.add(:content_date, :taken)
    end
  end

end
