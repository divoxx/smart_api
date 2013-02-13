require "smart_api/engine"

module SmartApi
  autoload :EndpointDescriptor, "smart_api/endpoint_descriptor"
  autoload :Dsl,                "smart_api/dsl"
  autoload :ParamsHandler,      "smart_api/params_handler"
  autoload :Responder,          "smart_api/responder"
  autoload :Controller,         "smart_api/controller"
end
