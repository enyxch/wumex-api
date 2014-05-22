module API
  module V1
    class Projects < Grape::API
      include API::V1::Defaults
      include API::V1::Authorization

      resource :projects do
        desc "Return list of projects"
        get do
          Project.all # obviously you never want to call #all here
        end
      end
    end
  end
end