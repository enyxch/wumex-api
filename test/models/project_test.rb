require "test_helper"

class ProjectTest < ActiveSupport::TestCase

  def project
    @project ||= Project.new
  end

  def test_valid
    assert project.valid?
  end

end
