require 'rails_helper'

RSpec.describe "Onboarding::Students", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/onboarding/students/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/onboarding/students/create"
      expect(response).to have_http_status(:success)
    end
  end

end
