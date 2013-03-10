require 'spec_helper'

describe PagesController do
  
  describe "GET #index" do
    let(:get_index) { -> { get :index} }
    
    it "requires you to be signed in" do
      get_index
      expect(response).to require_sign_in
    end
    
    describe "when logged in" do
      let!(:domain1) { create :domain }
      let!(:domain2) { create :domain }
      let(:mailbox) { create :mailbox, domain: domain1 }
      before(:each) do
        set_current_mailbox(mailbox)
      end
      
      it "renders the index view" do
        get :index
        expect(response).to render_template(:index)
      end
      
      context "with a standard account" do
        it "does not assign a list of domains" do
          # expect get_index.to
          expect(assigns(:domains)).to be_nil
        end
      end
      
      context "as a domain_admin" do
        let(:mailbox) { create :domain_admin_mailbox, domain: domain1 }
      end
      
      context "as a site_admin" do
        let(:mailbox) { create :site_admin_mailbox, domain: domain1 }
        
        it "assigns a list of domains" do
          get :index
          expect(assigns(:domains)).to match_array [domain1, domain2]
        end
      end

    end
  end
end
