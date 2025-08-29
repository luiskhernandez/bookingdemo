require 'rails_helper'

RSpec.describe "Students::Dashboards", type: :request do
  describe "GET /show" do
    it "redirects to login when not authenticated" do
      get "/student/dashboard"
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

end
