module IeducarApi
  class PostExams < Base
    def send_post(params = {})
      params.reverse_merge!(path: 'module/Api/Diario')

      raise ApiError.new('É necessário informar as notas') if params[:notas].blank?
      raise ApiError.new('É necessário informar a etapa') if params[:etapa].blank?
      raise ApiError.new('É necessário informar o recurso') if params[:resource].blank?

      super
    end
  end
end
