class LoanDownload < CsvDownload

  private

    def model_attributes
      %w{
        id
        user_id
        book_id
        start_date
        due_date
        returned_date
        renewal_count
      }.freeze
    end

end
