require 'rails_helper'

RSpec.describe Admin::EnvironmentsController, type: :controller do
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Admin::AccessRequestsController. Be sure to keep this updated too.

  let(:empty_session){ {} }
  let(:valid_session){ {'sso_user' => {}} }
  let(:admin_session){ {'sso_user' => {'permissions'=> [{'roles' => [ 'admin' ]}]}}}

  let(:environment_1) { create(:environment, name: 'dev') }

  # This should return the minimal set of attributes required to create a valid
  # Token. As you add validations to Token, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {
      name: 'dev',
      provisioning_key: file_fixture('test_provisioner.key').read,
      base_url: "https://noms-api.TEST.justice.gov.uk/nomisapi/"
    }
  }

  let(:invalid_attributes) {
    {
      provisioning_key: file_fixture('test_provisioner.key').read
    }
  }

  let(:bad_key) {
    {
      name: 'foobar',
      provisioning_key: 'abcd1234'
    }
  }

  before(:each) do
    allow_any_instance_of(Environment).to receive(:update_properties!).and_return(nil)
  end

  context 'when not logged in' do
    let(:session){ empty_session }

    describe "GET #index" do
      it "redirects to /auth/mojsso" do
        get :index, params: {}, session: session
        expect( response ).to redirect_to '/auth/mojsso'
      end
    end

    describe "GET #show" do
      it "redirects to /auth/mojsso" do
        get :show, params: {id: environment_1.id}, session: session
        expect( response ).to redirect_to '/auth/mojsso'
      end
    end

    describe "GET #new" do
      it "redirects to /auth/mojsso" do
        get :new, params: {}, session: session
        expect( response ).to redirect_to '/auth/mojsso'
      end
    end

    describe "POST #create" do
      it "redirects to /auth/mojsso" do
        post :create, params: {environment: valid_attributes}, session: session
        expect( response ).to redirect_to '/auth/mojsso'
      end
    end

    describe "GET #edit" do
      it "redirects to /auth/mojsso" do
        get :edit, params: {id: environment_1.id}, session: session
        expect( response ).to redirect_to '/auth/mojsso'
      end
    end

    describe "PATCH #update" do
      it "redirects to /auth/mojsso" do
        patch :update,
          params: {id: environment_1.id, environment: valid_attributes},
          session: session
        expect( response ).to redirect_to '/auth/mojsso'
      end
    end
  end

  context 'when logged in' do
    context 'as a user without admin role' do
      let(:session){ valid_session }

      describe "GET #index" do
        it "responds with 403" do
          get :index, params: {}, session: session
          expect( response.status ).to eq(403)
        end
      end

      describe "GET #show" do
        it "responds with 403" do
          get :show, params: {id: environment_1.id}, session: session
          expect( response.status ).to eq(403)
        end
      end

      describe "GET #new" do
        it "responds with 403" do
          get :new, params: {}, session: session
          expect( response.status ).to eq(403)
        end
      end

      describe "POST #create" do
        it "responds with 403" do
          post :create, params: {environment: valid_attributes}, session: session
          expect( response.status ).to eq(403)
        end
      end

      describe "GET #edit" do
        it "responds with 403" do
          get :edit, params: {id: environment_1.id}, session: session
          expect( response.status ).to eq(403)
        end
      end

      describe "PATCH #update" do
        it "responds with 403" do
          patch :update,
            params: {id: environment_1.id, environment: valid_attributes},
            session: session
          expect( response.status ).to eq(403)
        end
      end
    end

    context 'as a user with admin role' do
      let(:session){ admin_session }

      describe "GET #index" do
        it "assigns all environments to @environments" do
          get :index, params: {}, session: session
          expect(assigns(:environments)).to eq([environment_1])
        end
      end

      describe "GET #show" do
        it "assigns the requested environment as @environment" do
          get :show, params: {id: environment_1.id}, session: session
          expect(assigns(:environment)).to eq(environment_1)
        end
      end

      describe "GET #new" do
        it "assigns a new environment to @environment" do
          get :new, params: {}, session: session
          expect(assigns(:environment)).to be_a_new(Environment)
        end
      end

      describe "POST #create" do
        context "with valid params" do
          it "creates a new Environment" do
            expect {
              post :create, params: {environment: valid_attributes}, session: session
            }.to change(Environment, :count).by(1)
          end

          it "assigns a newly created environment as @environment and persists it" do
            post :create, params: {environment: valid_attributes}, session: session
            expect(assigns(:environment)).to be_a(Environment)
            expect(assigns(:environment)).to be_persisted
          end

          it "redirects to the created environment" do
            post :create, params: {environment: valid_attributes}, session: session
            expect(response).to redirect_to(admin_environment_url(assigns(:environment)))
          end
        end

        context "with invalid params" do
          it "assigns a newly created but unsaved environment as @environment" do
            post :create, params: {environment: invalid_attributes}, session: session
            expect(assigns(:environment)).to be_a_new(Environment)
          end

          it "re-renders the 'new' template" do
            post :create, params: {environment: invalid_attributes}, session: session
            expect(response).to render_template("new")
          end
        end
      end

      describe "GET #edit" do
        it "assigns the requested environment as @environment" do
          get :edit, params: {id: environment_1.id}, session: session
          expect(assigns(:environment)).to eq(environment_1)
        end
      end

      describe "PATCH #update" do

        before { create(:environment, name: 'original_name') }
        
        context "with valid params" do
          before do
            patch :update,
              params: {
                id: Environment.last.id,
                environment: valid_attributes.merge(name: 'new_name')
              }, session: session
          end

          it 'updates the environment' do
            expect(Environment.last.name).to eq 'new_name'
          end

          it 'redirects to #show' do
            expect(response).to redirect_to(admin_environment_url)
          end
        end

        context "with invalid params" do
          before do
            patch :update,
              params: {
                id: Environment.last.id,
                environment: invalid_attributes.merge(name: '')
              }, session: session
          end

          it 'does not update the environment' do
            expect(Environment.last.name).to eq 'original_name'
          end

          it 're-renders #edit' do
            expect(response).to render_template("edit")
          end
        end
      end

      describe "DELETE #destroy" do
        it "destroys the requested environment" do
          post :create, params: {environment: valid_attributes}, session: session
          expect(Environment.count).to be(1)
          environment_2 = assigns(:environment)
          delete :destroy, params: {id: environment_2.id}, session: session
          expect(Environment.count).to be(0)
        end

        it "redirects to the environment list" do
          delete :destroy, params: {id: environment_1.id}, session: session
          expect(response).to redirect_to(admin_environments_url)
        end
      end
    end
  end
end
