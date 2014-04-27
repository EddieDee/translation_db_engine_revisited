module TranslationDbEngine
  module ApplicationHelper
    def translation_keys_path
      klass = TranslationDbEngine.translation_key_class
      send(build_named_route_call(klass, :plural, {:routing_type=>:path}))
    end
  end
end
