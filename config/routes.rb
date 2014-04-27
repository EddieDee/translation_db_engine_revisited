TranslationDbEngine::Engine.routes.draw do
  get "/", :to => "translation_keys#index"
  resources :translation_keys, :as => "localizations_translation_keys"
end
