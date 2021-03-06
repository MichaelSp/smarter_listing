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
    respond_to do |format|
      format.html { load_collection; resource }
      format.js { resource }
    end
    render 'smarter_listing/new'
  end

  def create
    instance_variable_get(resource_ivar) || instance_variable_set(resource_ivar, model.create(_resource_params))
    render 'smarter_listing/create'
  end

  def copy
    instance_variable_set resource_ivar, resource.respond_to?(:deep_clone) ? resource.deep_clone : resource.dup
    render 'smarter_listing/copy'
  end

  def show
    edit
  end

  def edit
    respond_to do |format|
      format.html { load_collection; resource }
      format.js { resource }
    end
    render 'smarter_listing/edit'
  end

  def multi_edit
    @multi = true
    edit
  end

  def update
    resource.update _resource_params
    render 'smarter_listing/update'
  end

  def destroy
    resource.destroy
    render 'smarter_listing/destroy'
  end

  def restore
    resource.current_user = current_user if resource.respond_to?(:current_user=)
    resource.restore!
    index
  end

  def filter_parameter
    self.class.instance_variable_get :@filter_parameter
  end

  def filtered(model)
    results = if params[:show_deleted] == "1" && model.instance_methods.include?(:deleted?)
                if model.column_names.include?("deleted_at")
                  model.only_deleted
                else
                  results.map(&:deleted?)
                end
              end
    results ||= model.all
    unless params[filter_parameter].blank?
      if model.respond_to?(:search)
        results = results.search { fulltext "#{params[filter_parameter]}" }.results
      elsif model.respond_to?(:search_columns)
        columns = model.search_columns.select{|column| model.column_names.include?(column.to_s)}
        filter = "%#{params[filter_parameter]}%"
        results = results.where columns.map{|column| "#{column} LIKE :query"}.join(" OR "), :query => filter
      elsif model.column_names.include?('name')
        results = results.where("name LIKE ?", "%#{params[filter_parameter]}%")
      end
    end
    results
  end

  def load_collection
    instance_variable_set collection_ivar, smart_listing_create(model.name.tableize.sub('/','_'), filtered(model), partial: "#{current_engine}/#{table_name}/table_header")
  end

  def load_resource
    res = model.find_by_id params[:id]
    res ||= model.new(_resource_params) if action_name == 'new'
    res ||= model.unscoped.find_by_id params[:id] if action_name == 'restore'
    instance_variable_set resource_ivar, res
  end

  def resource
    instance_variable_get(resource_ivar) || load_resource
  end

  def collection
    instance_variable_get(collection_ivar) || load_collection
  end

end
