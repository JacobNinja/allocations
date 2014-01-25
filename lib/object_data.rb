class ObjectData

  attr_reader :klass, :id, :references

  def initialize(cluster, klass, id, references=[])
    @klass = klass
    @id = id
    @references = references.reject {|r| r.klass == 'Class' }
    @cluster = cluster
  end

  def to_h
    {cluster: @cluster, klass: @klass, object_id: @id, references: @references.map(&:to_h)}
  end

  def to_json
    to_h.to_json
  end

end
