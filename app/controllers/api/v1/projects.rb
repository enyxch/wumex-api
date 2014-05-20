module API
  module V1
    class Projects < Grape::API
      include API::V1::Defaults
      version 'v1' # path-based versioning by default
      format :json # We don't like xml anymore

      resource :projects do
        desc "Return list of projects"
        get do
          Project.all # obviously you never want to call #all here
        end
      end
    end
  end
end