Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :items do
        get 'find_all', to: "find#index"
        get 'find', to: "find#show"
      end
      resources :items, except: [:new, :edit] do
        scope module: "items" do
          resources :merchants, only: [:index]
        end
      end
      namespace :merchants do
        get 'find_all', to: "find#index"
        get 'find', to: "find#show"
        get 'most_revenue', to: "revenue#most_revenue"
      end

      resources :merchants, except: [:new, :edit] do
        scope module: "merchants" do
          resources :items, only: [:index]
        end
      end
    end
  end
end


# member do
#   get 'merchant', to: "merchant_items#show"
# end
# end
# member do
#   get 'items', to: "merchant_items#index"
# end
