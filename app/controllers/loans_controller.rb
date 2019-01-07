class LoansController < ApplicationController
  include UserRoleHelper

  before_filter :is_librarian?, only: [:new, :create, :renew, :return, :index, :new_multi, :loan_multi, :download_csv]
  before_filter :authenticate_user!
  before_filter :find_loan, only: [:renew, :return, :show]
  helper_method :sort_column, :sort_direction

  def new
    if params[:user_id]
      @user = User.find_by(id: params[:user_id])
      unless @user.good_to_borrow?
        flash[:alert] = "User can not borrow at this time because #{@user.description_of_borrowing_problems}"
        redirect_to user_path(@user.id) and return
      end
      @loan = Loan.new(user: @user)
    elsif params[:book_id]
      @book = Book.find_by(id: params[:book_id])
      unless @book.available
        flash[:alert] = "Book is Not Available"
        redirect_to book_path(@book.id) and return
      end
      @loan = Loan.new(book: @book)
    end
  end

  def create
    Book.find_by(id: params[:book_id]).update_availability if params[:book_id] # we're doing this as a stopgap because it's not getting called somewhere else

    @loan = Loan.new(loan_params)

    unless @loan.user.good_to_borrow?
      flash[:alert] = "User can not borrow at this time because #{@loan.user.description_of_borrowing_problems}"
      redirect_to :back and return
    end
    unless @loan.book.available
      flash[:alert] = "Book is Not Available"
      redirect_to :back and return
    end
    if @loan.save
      flash[:notice] = "Loan Created"
    else
      flash[:alert] = "Loan Creation Failed"
    end
    redirect_to :back
  end

  def new_multi
  end

  def loan_multi
    @user = User.find(params[:user_id]) if params[:user_id]
    @books = params[:book_ids].map { |b| Book.find_by(id: b) } if params[:book_ids]
    if message = missing_elements?
      flash[:alert] = message
      redirect_to :back and return
    end

    if @user && !@books.empty?
      @books.each do |book|
        Loan.create(book_id: book.id, user_id: @user.id)
        book.update_availability
      end
      flash[:notice] = "Loan#{params[:book_ids].count > 1 ? "s" : ""} Created"
      redirect_to user_path(@user) and return
    else
      flash[:alert] = "Loan creation failed."
      redirect_to :back and return
    end
  end

  def missing_elements?
    unless params[:user_id]
      return "No user selected."
    end

    unless params[:book_ids]
      return "No items selected."
    end

    unless (@books.reject { |b| b.available }).empty?
      return "One or more of the selected items is unavailable."
    end

    unless @user.good_to_borrow?(params[:book_ids].count)
      return "User can only borrow #{User::MAX_LOANS - @user.loans.active.count} more items."
    end

    false
  end

  def renew
    if @loan.renew_loan
      flash[:notice] = "Loan Renewed"
    else
      flash[:alert] = "Loan Limit Reached"
    end
    redirect_to :back
  end

  def return
    if @loan.update_attributes(returned_date: Time.now.to_date)
      @loan.book.update_availability
      flash[:notice] = "Loan Returned"
    else
      flash[:alert] = "Loan Return Failed"
    end
    redirect_to :back
  end

  def show
    if !is_given_user_or_librarian?(@loan.user) then
      flash[:alert] = "You are not authorized"
      redirect_to root_path
    end
  end

  def index
    @loans = Loan.all.joins(:user, :book)
    .order("returned_date ASC", sort_column + " " + sort_direction)
    .paginate(:page => params[:page], :per_page => 50)
  end

  def overdue_list
    @loans = Loan.overdue.joins(:book, :user)
    .order(sort_column + " " + sort_direction)
    .paginate(:page => params[:page], :per_page => 50)
  end

  def download_csv
    loan_download = LoanDownload.new(Loan)

    send_data loan_download.to_csv, filename: 'loans.csv', type: :csv
  end

  private

  def sort_column(default = "start_date")
    params[:sort] ? params[:sort] : default
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

  def loan_params
    params.require(:loan).permit(:book_id, :user_id, :id)
  end

  def find_loan
    @loan = Loan.find(params[:id])
  end
end
