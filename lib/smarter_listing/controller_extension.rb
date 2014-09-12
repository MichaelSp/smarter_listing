module SmarterListing::ControllerExtension

  def self.included base
    base.helper_method :collection, :resource
    base.include SmarterListing::Helper
  end

  def index
    collection
    respond_to do |format|
      format.html { render layout: self.class._layout }
      format.js { render action: 'index.js.erb' }
    end
  end

  def new
    instance_variable_get(resource_ivar) || instance_variable_set(resource_ivar, model.new(resource_params))
    render 'smarter_listing/new'
  end

  def create
    instance_variable_get(resource_ivar) || instance_variable_set(resource_ivar, model.create(resource_params))
    render 'smarter_listing/create'
  end

  def copy
    instance_variable_set resource_ivar, resource.dup
    render 'smarter_listing/copy'
  end

  def show
    resource
    render resource, object: resource
  end

  def edit
    resource
    render 'smarter_listing/edit'
  end

  def update
    resource.update resource_params
    render 'smarter_listing/update'
  end

  def destroy
    resource.destroy
    render 'smarter_listing/destroy'
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