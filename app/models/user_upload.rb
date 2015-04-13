class UserUpload < ActiveRecord::Base

  include Uploadable

  def make_object(user_data)

    if !user_data["e-mail"].blank?
      # return if User.find_by_email(user_data["e-mail"])
      user = User.create( name: user_data["name"],
                          address: user_data["address"],
                          email: user_data["e-mail"],
                          phone: user_data["phone"],
                          notes: user_data["notes"],
                          identification: user_data["barcode"],
                          password: "gaycitylibrary" )
    else
      user = User.create( name: user_data["name"],
                    address: user_data["address"],
                    username: user_data["name"].delete(" "),
                    phone: user_data["phone"],
                    notes: user_data["notes"],
                    identification: user_data["barcode"],
                    password: "gaycitylibrary" )
    end
    @new_objects << user
  end

  def self.import_requirements?(params)
    params.has_key?(:user_upload) && params[:user_upload].has_key?(:file) && params[:user_upload][:file] != nil
  end
end
