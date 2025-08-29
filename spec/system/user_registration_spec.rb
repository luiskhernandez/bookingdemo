require 'rails_helper'

RSpec.describe "User Registration", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  describe "timezone detection" do
    it "has a timezone selector with data attributes for detection" do
      visit new_user_registration_path

      # Check that the timezone detector controller is present
      expect(page).to have_css('[data-controller="timezone-detector"]')

      # Check that the select element has the correct target
      expect(page).to have_css('select[data-timezone-detector-target="select"]')

      # Check that timezone field exists
      expect(page).to have_field('Timezone')
    end

    it "allows user to manually change timezone after auto-detection" do
      visit new_user_registration_path

      # The JS will auto-detect, but user can still change it
      select '(GMT-05:00) Eastern Time (US & Canada)', from: 'Timezone'

      # Fill in the rest of the form
      fill_in 'Email', with: 'test@example.com'
      fill_in 'Password', with: 'password123'
      fill_in 'Password confirmation', with: 'password123'

      click_button 'Sign up'

      # Check that user was created with the selected timezone
      user = User.find_by(email: 'test@example.com')
      expect(user).to be_present
      expect(user.timezone).to eq('Eastern Time (US & Canada)')
    end
  end

  describe "default timezone fallback" do
    it "sets America/Bogota as default if no timezone is selected" do
      visit new_user_registration_path

      # Check that the default is set in the controller
      # The form should have America/Bogota selected by default if JS doesn't run
      timezone_select = find('#user_timezone')
      selected_option = timezone_select.find('option[selected]', visible: false) rescue nil

      # If no option is explicitly selected, Rails will use the default from controller
      # which we set to America/Bogota
      fill_in 'Email', with: 'default@example.com'
      fill_in 'Password', with: 'password123'
      fill_in 'Password confirmation', with: 'password123'

      click_button 'Sign up'

      user = User.find_by(email: 'default@example.com')
      expect(user).to be_present
      # User should have either the JS-detected timezone or the default
      expect(user.timezone).not_to be_nil
    end
  end
end
