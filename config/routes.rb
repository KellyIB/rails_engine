Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do

      resources :items, except: [:new, :show, :edit]
      resources :items, only: [:show] do
        member do
          get 'merchant', to: "merchant_items#show"
        end
      end

      resources :merchants, except: [:new, :edit]
      resources :merchants, only: [:index] do
        member do
          get 'items', to: "merchant_items#index"
        end
      end

    end
  end
end
#
# namespace :api do
#   namespace :v1 do
#     resources :items, except: [:new, :edit]
#     resources :items do
#       member do
#         get 'merchant'
#       end
#     end
#     resources :merchants, except: [:new, :edit]
#     resources :merchants do
#       member do
#         get 'items'
#       end
#     end
#
#   end
# end
