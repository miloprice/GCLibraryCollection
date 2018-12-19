require 'spec_helper'

describe LoanDownload do
  let(:loan) { FactoryGirl.create(:loan) }

  subject { described_class.new(Loan.where(id: loan.id)) }

  describe '#to_csv' do

    it 'generates a CSV' do
      expect(subject.to_csv).to eq(
        "Id,User,Book,Start date,Due date,Returned date,Renewal count\n" \
        "#{loan.id},#{loan.user_id},#{loan.book_id},#{loan.start_date},#{loan.due_date},#{loan.returned_date},#{loan.renewal_count}\n"
      )
    end
  end

end
