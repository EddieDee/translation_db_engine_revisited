module TranslationDbEngine
  module ApplicationHelper

    def remove_translation_key_link key
      confirm_delete = _("Delete key #{key.key} ?") 
      options = { confirm: confirm_delete, method: :delete }     
      link_to content_tag(:b, 'X', :style => 'color:red'), key, options
    end

    def translation_keys_path
      options = {:routing_type => :path}
      send(build_named_route_call(TranslationDbEngine.translation_key_class, :plural, options))
    end

    def define_named_route route_type, options
      build_named_route_call(TranslationDbEngine.translation_key_class, route_type, options)
    end

    def url_singular_postfix
      define_named_route :singular, {:routing_type => :url}
    end

    def path_singular_postfix
      define_named_route :singular, {:routing_type => :path}      
    end

  end
end
