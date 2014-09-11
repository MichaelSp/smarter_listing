module SmarterListing::ControllerExtension

  def self.included base
    base.helper_method :collection, :resource
    base.include SmarterListing::Helper
    base.class_eval do
      # Actions
      define_method :index do
        collection
        respond_to do |format|
          format.html { render layout: self.class._layout }
          format.js { render action: 'index.js.erb' }
        end
      end

      define_method :new do
        instance_variable_get(resource_ivar) || instance_variable_set(resource_ivar, model.new(resource_params))
        render 'smarter_listing/new'
      end

      define_method :create do
        instance_variable_get(resource_ivar) || instance_variable_set(resource_ivar, model.create(resource_params))
        render 'smarter_listing/create'
      end

      define_method :copy do
        instance_variable_set resource_ivar, resource.dup
        render 'smarter_listing/copy'
      end

      define_method :show do
        resource
        render resource, object: resource
      end

      define_method :edit do
        resource
        render 'smarter_listing/edit'
      end

      define_method :update do
        resource.update resource_params
        render 'smarter_listing/update'
      end

      define_method :destroy do
        resource.destroy
        render 'smarter_listing/destroy'
      end
    end
  end

  def filter_parameter
    self.class.instance_variable_get :@filter_parameter
  end

  def filtered(model)
    (!params[filter_parameter].blank?) ? model.search { fulltext "#{params[filter_parameter]}" }.results : model.all
  end

  def load_collection
    instance_variable_set collection_ivar, smart_listing_create(collection_sym, filtered(model), partial: "#{current_engine}/#{collection_sym}/table_header")
  end

  def load_resource
    instance_variable_set resource_ivar, (model.find(params[:id]) rescue (action_name == 'new' ? model.new(resource_params) : nil))
  end

  def resource
    instance_variable_get(resource_ivar) || load_resource
  end

  def collection
    instance_variable_get(collection_ivar) || load_collection
  end

end