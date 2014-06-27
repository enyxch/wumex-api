require 'spec_helper'

describe Invitation do
  
  context "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:inviting_user).class_name('User').with_foreign_key('inviting_user_id') }
  end
  
  it 'has a valid factory' do
    FactoryGirl.create(:invitation).should be_valid
  end
  
  describe "#create" do
    before(:each) do
      @inviting_user = FactoryGirl.create(:user)
      @invited_user = FactoryGirl.create(:user)
      @project = FactoryGirl.create(:project)
    end
      
    it 'should be created' do
      params = invitation_params( :project_id => @project.id, :user_id => @invited_user.id )
      Invitation.create_invitation(params, @inviting_user.id).persisted?.should be_true
    end
    
    it 'should be created without project' do
      params = invitation_params( :project_id => nil, :user_id => @invited_user.id )
      Invitation.create_invitation(params, @inviting_user.id).persisted?.should be_true
    end
    
    it 'should be created without invited user' do
      params = invitation_params( :project_id => @project.id, :user_id => nil )
      Invitation.create_invitation(params, @inviting_user.id).persisted?.should be_true
    end
    
    it 'should be created without inviting user' do
      params = invitation_params( :project_id => @project.id, :user_id => @invited_user.id )
      Invitation.create_invitation(params, nil).persisted?.should be_true
    end
    
    def invitation_params opts = {}
      {
        :notes =>"Test",
        :project_id =>1,
        :user_id =>1
      }.merge(opts)
    end
  end
  
end
