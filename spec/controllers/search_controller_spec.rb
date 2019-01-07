# spec/controllers/search_controller_spec.rb
require 'spec_helper'
require 'support/api_utilities'

describe SearchController do

  before :all do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    @user = create :user
    @librarian = create :librarian
  end
  after :all do
    DatabaseCleaner.clean
  end

  before(:each) do
    request.env["HTTP_REFERER"] = root_path
  end

  after :each do
    Warden.test_reset!
  end

  describe '#search' do

    before { sign_in @librarian }

    context 'as librarian' do
      it 'returns results for user terms' do
        get :search, "search" => @user.name
        response.should be_ok
        expect(assigns[:users]).to include(@user)
      end
    end

    it 'does not return results for user search terms' do
      get :search, "search" => @user.name
      response.should be_ok
      expect(assigns).to_not include(:user)
    end

    it 'returns results for good search terms' do
      keyword = FactoryGirl.create(:keyword)
      get :search, "search" => "boogers"
      response.should be_ok
      expect(assigns[:keywords]).to include(keyword)
    end

    it 'returns results for good, multi-word search terms' do
      book = FactoryGirl.create(:book, title: "The True Story of Those Boots")
      get :search, "search" => "True Boots"
      response.should be_ok
      expect(assigns[:books]).to include(book)
    end

    it 'returns only uniq results' do
      FactoryGirl.create(:user, name: "Jingles Abracadabra", preferred_first_name: "Abracadabra")
      get :search, search: "Abracadabra"
      expect(assigns[:users].length).to eq(1)
    end

    it 'returns nothing for unsuccessful searches' do
      get :search, search: "Pegasus"
      response.should be_redirect
      expect(assigns[:authors].empty?).to be_true
    end

    it 'redirects with alert for nil search terms' do
      get :search, search: ""
      flash[:alert].should_not be_nil
      response.should redirect_to root_url
    end

  end

  describe 'scrape' do

    before do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.start
      @user = create :user
      @admin = create :admin
      @isbn = "1234567890"
      create_google_stub(create_google_url(@isbn), "exists")
      create_goodreads_stub(create_goodreads_url(@isbn), "exists")
      create_worldcat_stub(create_worldcat_url(@isbn), "exists")
    end

    after do
      DatabaseCleaner.clean
    end

    after :each do
      Warden.test_reset!
    end

    context 'as non-admin' do

      before { sign_in @user }

      it 'redirects un-authorized users' do
        expect(get :import).to redirect_to(root_path)
        expect(post :scrape, isbn: @isbn).to redirect_to(root_path)
      end
    end

    context 'as admin' do

      before { sign_in @admin }

      context 'success' do
        xit 'redirects to edit book' do
          post :scrape, isbn: [@isbn]
          expect(response).to redirect_to(import_results_path(books: [1]))
        end

        xit 'redirects to edit if book is already in the system' do
          book = Search.scrape(@isbn)
          post :scrape, isbn: [@isbn]
          expect(response).to redirect_to(import_results_path(books: [1]))
        end
      end
    end
  end
end
