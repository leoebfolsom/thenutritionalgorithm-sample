module Api::V1
  class ListsController < ApiController
    before_action :set_list, only: [:show]

    respond_to :json

    def show
    end

    private

    def set_list
      @list = List.find(params[:id])
      @quantities = @list.quantities
    end
  end
end