Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root to: "case#index"
  get "calendar", to: "calendar#global", as: :global_calendar

  scope "/cases" do
    root to: "case#search", as: :cases
    get "new", to: "case#new", as: :new_case
    put "new", to: "case#create", as: :create_case
  end

  scope "/c/:case_id" do
    root to: "case#show", as: :show_case
    get "edit", to: "case#edit", as: :edit_case
    post "edit", to: "case#update", as: :update_case

    scope "/participants" do
      root to: "participants#index", as: :participants
      get "new", to: "participants#new", as: :new_participant
      post "new", to: "participants#create", as: :create_participant
      get ":participant_id/edit", to: "participants#edit", as: :edit_participant
      post ":participant_id/edit", to: "participants#update", as: :update_participant
    end

    scope "/represent" do
      get "new", to: "representments#new", as: :new_representment
      post "new", to: "representments#create", as: :create_representment
      get "new/:days/days", to: "representments#create_for_days", as: :create_representment_for_days
      get "clear", to: "representments#clear", as: :clear_representment
      get "step", to: "representments#step", as: :step
      get "clear-and-step", to: "representments#clear_and_step", as: :clear_and_step
    end

    scope "/notes" do
      root to: "notes#index", as: :notes
      get "new", to: "notes#new", as: :new_note
      post "new", to: "notes#create", as: :create_note
      get ":note_id/edit", to: "notes#edit", as: :edit_note
      post ":note_id/edit", to: "notes#update", as: :update_note
      get ":note_id/delete", to: "notes#delete", as: :delete_note
      post ":note_id/delete", to: "notes#destroy", as: :destroy_note
    end

    scope "/calendar" do
      root to: "calendar#index", as: :calendar
      get "new", to: "calendar#new", as: :new_event
      post "new", to: "calendar#create", as: :create_event
      get ":event_id/edit", to: "calendar#edit", as: :edit_event
      post ":event_id/edit", to: "calendar#update", as: :update_event
      get ":event_id/delete", to: "calendar#delete", as: :delete_event
      post ":event_id/delete", to: "calendar#destroy", as: :destroy_event
    end

    scope "/documents" do
      root to: "documents#index", as: :documents

      get "fo-:folder_id", to: "documents#folder", as: :folder
      get "fo/new", to: "documents#new_folder", as: :new_folder
      post "fo/new", to: "documents#create_folder", as: :create_folder
      get "fo-:folder_id/edit", to: "documents#edit_folder", as: :edit_folder
      post "fo-:folder_id/edit", to: "documents#update_folder", as: :update_folder

      get "fo-:folder_id/do-:document_id", to: "documents#document", as: :document
      get "fo-:folder_id/do/new", to: "documents#new_document", as: :new_document
      post "fo-:folder_id/do/new", to: "documents#create_document", as: :create_document
      get "fo-:folder_id/do-:document_id/edit", to: "documents#edit_document", as: :edit_document
      post "fo-:folder_id/do-:document_id/edit", to: "documents#update_document", as: :update_document

      get "fo-:folder_id/do-:document_id/i/new", to: "documents#new_document_item", as: :new_document_item
      post "fo-:folder_id/do-:document_id/i/new", to: "documents#create_document_item", as: :create_document_item
    end

    scope "/tasks" do
      root to: "tasks#index", as: :tasks
    end
  end
end
