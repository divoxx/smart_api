module SmartApi
  class Responder
    def self.call(*args)
      new(*args).respond
    end

    def initialize(controller, resources, opts = {})
      @controller = controller
      @request    = @controller.request
      @resources  = resources.dup
      @resource   = @resources.pop
      @options    = opts
    end

    def respond
      case
      when @request.get?
        unless cache_fresh?
          if @resource.nil?
            @controller.render status: :not_found
            return
          end

          @controller.render
        end
      when @request.post?
        if @resource.nil?
          @controller.render status: :not_found
          return
        end

        if @resource.persisted?
          @controller.render status: :created
        else
          @controller.render status: :bad_request, json: { error: "Invalid attributes", attributes: @resource.errors }
        end
      when @request.put?
        if @resource.nil?
          @controller.render status: :not_found
          return
        end

        if @resource.persisted? && !@resource.changed?
          @controller.head(:no_content)
        else
          @controller.render status: :bad_request, json: { error: "Invalid attributes", attributes: @resource.errors }
        end
      when @request.delete?
        if @resource.nil?
          @controller.render status: :not_found
          return
        end

        @controller.render status: :reset_content
      end
    end

    private

    def cache_fresh?
      @request.fresh?(@controller.response)
    end
  end
end