module TranslationDbEngine
  class TranslationKeysController < ApplicationController
    before_filter :authenticate
    before_filter :find_translation_key, :only=>%w[show edit update destroy]    
    before_filter :set_locales
    
    def set_locales
      @locales = TranslationDbEngine.translation_key_class.available_locales 
    end

    def index
      set_height
      @translation_keys = TranslationDbEngine.translation_key_class.find(:all)
    end

    def new
      set_height
      @translation_key = TranslationDbEngine.translation_key_class.new
      add_default_locales_to_translation
      render :action=>:edit
    end

    def create
      return unless can? :create, @translation_key

      @translation_key = TranslationDbEngine.translation_key_class.new(params[:translation_key])
      if @translation_key.save
        flash[:notice] = _('Created!')
        redirect_to translation_key_path(@translation_key)
      else
        flash[:error] = _('Failed to save!')
        render :action=>:edit
      end
    end

    def show
      set_height
      add_default_locales_to_translation
      render :action=>:edit
    end

    def edit
      set_height
    end

    def update
      unless can? :update, TranslationDbEngine.translation_text_class
        flash[:error] = _('No permission')
        render :action=>:edit
      end

      if @translation_key.update_attributes(accessible_attributes)
        flash[:notice] = _('Saved!')
        redirect_to @translation_key
      else
        flash[:error] = _('Failed to save!')
        render :action=>:edit
      end
    end

    def destroy
      unless can? :destroy, @translation_key
        flash[:error] = _('No permission')
        redirect_to translation_keys_path
      end
      @translation_key.destroy
      redirect_to translation_keys_path
    end

    private 

    # Authorization is done by current_user_account#accessible_locales_as_array
    #
    # >> current_user_account.accessible_locales_as_array
    # => ["en", "fr"]
    def accessible_attributes
      accessible = current_user_account.accessible_locales_as_array
      ids = record_attributes['translations_attributes'].values.map { |i| i["id"].to_i }
      locales_from_db = TranslationDbEngine.translation_text_class.select(:id, :locale).where(id: ids)
      locale_array_from_db = locales_from_db.map { |l| 
        [l.id, l.locale] 
      }
      to_be_removed = locale_array_from_db.select do |item|
        !accessible.include? item[1]
      end.map {|i| i[0].to_i }
      result = {}
      record_attributes['translations_attributes'].each {|k,v| 
        next if to_be_removed.include? v["id"].to_i
        result[k] = v
      }
      accessible = record_attributes.dup # Lets not override 
      accessible['translations_attributes'] = result
      accessible
    end

    def record_attributes
      params[record_key]
    end

    def record_key
      model_name_from_record_or_class(@translation_key).singular_route_key.to_sym
    end

    protected

    def self.tbe_config
      @@tbe_config ||= YAML::load(File.read(Rails.root.join('config','translation_db_engine.yml'))).with_indifferent_access rescue {}
    end

    def choose_layout
      self.class.tbe_config[:layout] || 'application'
    end

    def authenticate
      return unless auth = self.class.tbe_config[:auth]
      authenticate_or_request_with_http_basic do |username, password|
        username == auth[:name] && password == auth[:password]
      end
    end

    def find_translation_key
      @translation_key = TranslationDbEngine.translation_key_class.find(params[:id])
    end

    def add_default_locales_to_translation
      existing_translations = @translation_key.translations.map(&:locale)
      missing_translations = TranslationDbEngine.translation_key_class.available_locales.map(&:to_sym) - existing_translations.map(&:to_sym)
      missing_translations.each do |locale|
        @translation_key.translations.build(:locale => locale)
      end
    end
  end
end
