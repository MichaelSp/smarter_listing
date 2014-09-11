module SmarterListing
  module Helper

    # def self.included base
    #   base.helper_method :collection_sym, :collection_action, :collection_ivar, :resource_sym, :resource_ivar, :model
    #   base.helper_method :action_copy, :action_edit, :action_destroy, :current_engine
    # end

    def collection_sym
      @collection_sym = nil
      @collection_sym ||= model.to_s.underscore.downcase.pluralize.to_sym
    end

    def collection_action
      @collection_action = nil
      @collection_action ||= model.to_s.underscore.downcase.singularize.to_sym
    end

    def collection_ivar
      "@#{collection_sym}"
    end

    def resource_sym
      @resource_sym ||= model.to_s.underscore.downcase.to_sym
    end

    def resource_ivar
      "@#{resource_sym}"
    end

    def current_engine
      self.class.parent == Object ? '' : self.class.parent.to_s.underscore
    end

    def model
      @model = nil
      @model ||= begin
                   # First priority is the namespaced model, e.g. User::Group
        resource_class ||= begin
          namespaced_class = self.name.sub(/Controller/, '').singularize
          namespaced_class.constantize
        rescue NameError
          nil
        end

        # Second priority is the top namespace model, e.g. EngineName::Article for EngineName::Admin::ArticlesController
        resource_class ||= begin
          namespaced_classes = self.name.sub(/Controller/, '').split('::')
          namespaced_class = [namespaced_classes.first, namespaced_classes.last].join('::').singularize
          namespaced_class.constantize
        rescue NameError
          nil
        end

        # Third priority the camelcased c, i.e. UserGroup
        resource_class ||= begin
          camelcased_class = self.name.sub(/Controller/, '').gsub('::', '').singularize
          camelcased_class.constantize
        rescue NameError
          nil
        end

        # Otherwise use the Group class, or fail
        resource_class ||= begin
          class_name = self.controller_name.classify
          class_name.constantize
        rescue NameError => e
          raise unless e.message.include?(class_name)
          nil
        end
        resource_class
      end
    end

    def action_copy(object, path)
      {
          name: :copy,
          custom_url: path,
          custom_icon: SmartListing.config.classes(:icon_copy),
          custom_title: 'Copy'
      }
    end

    def action_edit(object, path)
      {name: :edit, url: path}
    end

    def action_destroy(object, path)
      {name: :destroy, url: path}
    end
  end
end