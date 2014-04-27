Rails.application.routes.draw do

  mount TranslationDbEngine::Engine => "/translation_db_engine"
end
