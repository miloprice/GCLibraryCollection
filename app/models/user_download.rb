class UserDownload
  USER_ATTRIBUTES = %w{
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


  def initialize(user_scope=User)
    @user_scope = user_scope
  end

  def to_csv
    # TODO: it would be better to write to the tempfile rather than keeping this in memory

    CSV.generate do |csv|
      csv << USER_ATTRIBUTES.map(&:humanize)

      @user_scope.find_each do |user|
        csv << USER_ATTRIBUTES.map{|attr| user.public_send(attr) }
      end
    end
  end
end
