require "translation_db_engine/engine"

module TranslationDbEngine
  mattr_accessor :translation_key_class
  mattr_accessor :translation_text_class
  mattr_accessor :translation_language_class

  def self.translation_key_class
    @@translation_key_class.try(:constantize) || TranslationKey
  end

  def self.translation_text_class
    @@translation_text_class.try(:constantize) || TranslationText
  end

  def self.translation_language_class
    @@translation_language_class.try(:constantize) || TranslationLanguage
  end

end
