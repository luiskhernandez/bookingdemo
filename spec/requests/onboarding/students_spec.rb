require 'rails_helper'

RSpec.describe "Onboarding::Students", type: :request do
  describe "GET /new" do
    it "redirects to login when not authenticated" do
      get "/onboarding/students/new"
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "GET /create" do
    it "returns 404 for invalid GET request" do
      get "/onboarding/students/create"
      expect(response).to have_http_status(:not_found)
    end
  end

end
