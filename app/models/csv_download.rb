class CsvDownload

  def initialize(model_scope)
    @model_scope = model_scope
  end

  def to_csv
    # TODO: it would be better to write to the tempfile rather than keeping this in memory

    CSV.generate do |csv|
      csv << model_attributes.map(&:humanize)

      @model_scope.find_each do |record|
        csv << model_attributes.map{|attr| record.public_send(attr) }
      end
    end
  end

  private

    def model_attributes
      []
    end
end
