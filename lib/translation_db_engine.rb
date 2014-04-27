require "translation_db_engine/engine"

module TranslationDbEngine
  mattr_accessor :translation_key_class

  def self.translation_key_class
    @@translation_key_class.constantize
  end 
end
