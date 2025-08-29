# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "User authentication flow", type: :system do
  let(:user) { create(:user, email: 'test@example.com', password: 'password', password_confirmation: 'password') }

  before do
    driven_by(:rack_test)
  end

  describe "Home page authentication states" do
    context "when not logged in" do
      it "shows role selection options" do
        visit root_path

        expect(page).to have_content("Choose Your Path")
        expect(page).to have_link("Sign Up as Tutor")
        expect(page).to have_link("Sign Up as Student")
        expect(page).to have_link("Sign In")
        expect(page).not_to have_button("Sign Out")
      end
    end

    context "when logged in but no profiles" do
      before do
        visit new_user_session_path
        fill_in "Email", with: user.email
        fill_in "Password", with: 'password'
        click_button "Sign in"
        visit root_path
      end

      it "shows user dashboard options and logout" do
        expect(page).to have_content("Welcome back, #{user.email}")
        expect(page).to have_link("Create Tutor Profile")
        expect(page).to have_link("Create Student Profile")
        expect(page).to have_button("Sign Out")
        expect(page).not_to have_content("Choose Your Path")
      end

      it "can logout successfully" do
        click_button "Sign Out"

        expect(page).to have_content("Choose Your Path")
        expect(page).to have_link("Sign Up as Tutor")
        expect(page).to have_link("Sign Up as Student")
        expect(page).not_to have_button("Sign Out")
      end
    end

    context "when logged in with tutor profile" do
      before do
        create(:tutor, user: user)
        visit new_user_session_path
        fill_in "Email", with: user.email
        fill_in "Password", with: 'password'
        click_button "Sign in"
        visit root_path
      end

      it "shows tutor dashboard access and logout" do
        expect(page).to have_content("Welcome back, #{user.email}")
        expect(page).to have_link("Go to Tutor Dashboard")
        expect(page).to have_button("Sign Out")
      end
    end

    context "when logged in with student profile" do
      before do
        create(:student, user: user)
        visit new_user_session_path
        fill_in "Email", with: user.email
        fill_in "Password", with: 'password'
        click_button "Sign in"
        visit root_path
      end

      it "shows student dashboard access and logout" do
        expect(page).to have_content("Welcome back, #{user.email}")
        expect(page).to have_link("Go to Student Dashboard")
        expect(page).to have_button("Sign Out")
      end
    end
  end

  describe "Role-based signup flow" do
    it "completes tutor signup flow" do
      visit root_path
      click_link "Sign Up as Tutor"

      expect(current_path).to eq(new_user_registration_path)
      expect(page.current_url).to include("role=tutor")

      fill_in "Email", with: "tutor@example.com"
      fill_in "Password", with: "password"
      fill_in "Password confirmation", with: "password"
      click_button "Sign up"

      expect(current_path).to eq(new_onboarding_tutor_path)
      expect(page).to have_content("Create Your Tutor Profile")
    end

    it "completes student signup flow" do
      visit root_path
      click_link "Sign Up as Student"

      expect(current_path).to eq(new_user_registration_path)
      expect(page.current_url).to include("role=student")

      fill_in "Email", with: "student@example.com"
      fill_in "Password", with: "password"
      fill_in "Password confirmation", with: "password"
      click_button "Sign up"

      expect(current_path).to eq(new_onboarding_student_path)
      expect(page).to have_content("Create Your Student Profile")
    end
  end

  describe "Profile protection" do
    before do
      visit new_user_session_path
      fill_in "Email", with: user.email
      fill_in "Password", with: 'password'
      click_button "Sign in"
    end

    context "user with no profiles" do
      it "redirects from dashboards to home with message" do
        visit tutor_dashboard_path

        expect(current_path).to eq(root_path)
        expect(page).to have_content("Please complete your profile setup to continue")

        visit student_dashboard_path

        expect(current_path).to eq(root_path)
      end

      it "allows access to onboarding pages" do
        visit new_onboarding_tutor_path
        expect(page).to have_content("Create Your Tutor Profile")

        visit new_onboarding_student_path
        expect(page).to have_content("Create Your Student Profile")
      end
    end
  end
end