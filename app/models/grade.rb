class Grade
  attr_accessor :attributes

  def self.all(collection)
    collection.map do |record|
      new(record)
    end
  end

  def initialize(attributes)
    self.attributes = attributes
  end

  def id
    "#{raw_id}\\#{name}"
  end

  def raw_id
    attributes["id"]
  end

  def name
    attributes["nome"]
  end

  def label
    "#{raw_id} - #{name}"
  end

  def to_s
    name
  end
end
