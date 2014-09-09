Rails.application.routes.draw do
   resources :listings do
     put :copy, on: :member
   end
end
