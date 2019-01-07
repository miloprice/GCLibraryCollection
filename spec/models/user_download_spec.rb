require 'spec_helper'

describe UserDownload do
  let(:user) { FactoryGirl.create(:user) }

  subject { described_class.new(User.where(id: user.id))}

  describe '#to_csv' do

    it 'generates a CSV' do
      expect(subject.to_csv).to eq(
        "Id,Created at,Updated at,Email,Last sign in at,Notes,Name,Phone,Preferred first name,Address,Identification,Do not lend,Username,City,State,Zip,Deactivated\n" \
        "#{user.id},#{user.created_at},#{user.updated_at},#{user.email},,,#{user.name},#{user.phone},,#{user.address},valid,false,,#{user.city},#{user.state},#{user.zip},false\n"
      )
    end
  end

end
