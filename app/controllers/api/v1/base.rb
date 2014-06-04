module API
  module V1
    class Base < Grape::API
      mount API::V1::UserRegistration
      mount API::V1::Sessions
      mount API::V1::Users
      mount API::V1::Projects
      mount API::V1::Documents
      mount API::V1::Labels

      add_swagger_documentation base_path: "/api",
                                api_version: 'v1',
                                hide_documentation_path: true
    end
  end
end
