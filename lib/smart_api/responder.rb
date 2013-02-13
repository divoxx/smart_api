module SmartApi
  class Responder
    def initialize(controller, resources, opts = {})
      @controller = controller
      @request    = @controller.request
      @resources  = resources.dup
      @resource   = @resources.pop
      @options    = opts
    end

    def respond
      if @resource.nil?
        @controller.render status: :not_found
        return
      end

      case
      when @request.get?
        # stale? calls fresh_when that calls head :not_modified if necessary
        if @controller.stale?(@resource)
          @controller.render
        end
      when @request.post?
        if @resource.persisted?
          @controller.render status: :created
        else
          @controller.render status: :bad_request, json: { error: "Invalid attributes", attributes: @resource.errors }
        end
      when @request.put?
        if @resource.persisted? && !@resource.changed?
          @controller.render status: :no_content
        else
          @controller.render status: :bad_request, json: { error: "Invalid attributes", attributes: @resource.errors }
        end
      when @request.delete?
        @controller.render status: :reset_content
      end
    end
  end
end