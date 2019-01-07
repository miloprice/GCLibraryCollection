LibraryCollection::Application.routes.draw do
  devise_for :users, path_names: { sign_in: "login", sign_out: "logout" }, :controllers => {:registrations => "registrations"}

  resources :authors
  get 'new_author_ajax' => 'authors#new_ajax'

  resources :book_authors
  get 'manage_contributions' => 'book_authors#manage_contributions'
  post 'update_contributions' => 'book_authors#update_contributions'

  resources :books
  post 'list' => 'books#list', defaults: {format: :json}
  get 'clear_list' => 'books#clear_list', defaults: {format: :js}
  get 'show_list' => 'books#show_list'
  post 'remove_copy' => 'books#remove_copy'

  resources :book_uploads, only: [:new, :create]
  resources :genres

  get 'genre_select' => 'inventory#genre_select', as: 'inventory_genre_select'
  get 'inventory_checklist' => 'inventory#checklist', as: 'inventory_checklist'
  post 'update_checklist_item' => 'inventory#update_checklist_item', defaults: {format: :json}
  post 'complete_inventory' => 'inventory#complete_inventory'

  resources :keywords

  resources :loans, only: [ :show, :index, :new, :create ]
  get 'new_multi' => 'loans#new_multi'
  post 'loan_multi' => 'loans#loan_multi'
  post 'renew' => 'loans#renew'
  post 'return' => 'loans#return'
  get 'overdue_list' => 'loans#overdue_list'

  get 'reports' => 'reports#dashboard'
  post 'build_report' => 'reports#build_report', defaults: {format: :json}
  get 'view_report' => 'reports#view_report'

  get 'search' => 'search#search'
  get 'import' => 'search#import'
  get 'import_results' => 'search#import_results'
  post 'scrape' => 'search#scrape'

  post 'send_reminders' => 'users#send_reminders'
  get 'download_loans_csv' => 'loans#download_csv', format: :csv
  get 'download_users_csv' => 'users#download_csv', format: :csv

  post 'generate_report' => 'document_generator#new_report'
  get 'new_author_ajax' => 'authors#new_ajax'
  get 'add_author_ajax' => 'book_authors#add_author'

  get 'admin_dashboard' => 'static_pages#admin_dashboard'
  get 'styleguide' => 'static_pages#styleguide'
  get 'user_guide' => 'static_pages#user_guide'
  get 'about' => 'static_pages#about'

  get 'uploaded_books' => 'book_uploads#uploaded_books'
  get 'uploaded_users' => 'user_uploads#uploaded_users'

  resources :users, only: [ :update, :destroy, :edit, :show, :index ], path: 'manage_users'
  resources :user_uploads, only: [:new, :create]

  post 'generate_report' => 'document_generator#new_report'


  root to: 'static_pages#home'

end
