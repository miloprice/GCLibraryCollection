class UserDownload < CsvDownload

  private

    def model_attributes
      %w{
        id
        created_at
        updated_at
        email
        last_sign_in_at
        notes
        name
        phone
        preferred_first_name
        address
        identification
        do_not_lend
        username
        city
        state
        zip
        deactivated
      }.freeze
    end

end
