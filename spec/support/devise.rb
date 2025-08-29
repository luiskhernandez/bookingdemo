RSpec.configure do |config|
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Warden::Test::Helpers
  
  config.before(:each, type: :request) do
    Warden.test_mode!
  end
  
  config.after(:each, type: :request) do
    Warden.test_reset!
  end

  config.before(:each) do
    if respond_to?(:controller) && controller
      Devise.mappings.each do |name, mapping|
        request.env["devise.mapping"] = mapping if request
      end
    end
  end
end