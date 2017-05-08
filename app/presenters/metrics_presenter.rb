class MetricsPresenter

  def initialize(data:)
    @data = data
  end

  def organisation_count
    7
  end

  def organisation_singular_noun
    'department'
  end

  def organisation_plural_noun
    'departments'
  end

  def parent_organisation
    'UK government'
  end

  def each(&block)
    @data.map {|data| [data.department, data] }.each(&block)
  end

end
