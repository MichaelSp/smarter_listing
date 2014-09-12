class ListingsController < ApplicationController

  def edit
    resource
    super
  end

  private
    def resource_params
      params.require(:listing).permit(:name, :content) if params[:listing]
    end
end