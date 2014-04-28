module TranslationDbEngine
  module ApplicationHelper
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
