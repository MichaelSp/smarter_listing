module SmarterListing
  module Helper

    def collection_sym
      @collection_sym ||= model.to_s.underscore.sub('/','_').pluralize.to_sym
    end

    def collection_ivar
      "@#{collection_sym}"
    end

    def resource_sym
      @resource_sym ||= model.to_s.underscore.sub('/','_').to_sym
    end

    def resource_view_path
      path = model.name.tableize
      path = "#{current_engine}/#{path}"
      path
    end

    def resource_ivar
      "@#{resource_sym}"
    end

    def _resource_params
      method = "#{resource_sym}_params".to_sym
      return send method if respond_to? method
      resource_params
    end

    def table_name
      model.name.demodulize.tableize.to_sym
    end

    def current_engine
      object = instance_variables.include?(:@_controller) ? @_controller : self
      object.class.parent == Object ? '' : object.class.parent.to_s.underscore
    end

    def model
      controller = instance_variables.include?(:@_controller) ? @_controller : self
      @model ||= begin
                   # First priority is the namespaced model, e.g. User::Group
        resource_class ||= begin
          namespaced_class = controller.class.name.sub(/Controller/, '').singularize
          namespaced_class.constantize
        rescue NameError
          nil
        end

        # Second priority is the top namespace model, e.g. EngineName::Article for EngineName::Admin::ArticlesController
        resource_class ||= begin
          namespaced_classes = controller.class.name.sub(/Controller/, '').split('::')
          namespaced_class = [namespaced_classes.first, namespaced_classes.last].join('::').singularize
          namespaced_class.constantize
        rescue NameError
          nil
        end

        # Third priority the camelcased c, i.e. UserGroup
        resource_class ||= begin
          camelcased_class = controller.class.name.sub(/Controller/, '').gsub('::', '').singularize
          camelcased_class.constantize
        rescue NameError
          nil
        end

        # Otherwise use the Group class, or fail
        resource_class ||= begin
          class_name = controller.controller_name.classify
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