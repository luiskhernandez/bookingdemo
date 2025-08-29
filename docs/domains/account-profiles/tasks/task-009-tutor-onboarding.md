# TASK-009: Tutor Onboarding Flow

## Status: 🔴 Not Started

## Description
Implement the Tutor onboarding flow that creates a Tutor profile and automatically generates a default LessonType.

## Acceptance Criteria
- [ ] Onboarding form with required fields (display_name, bio, timezone)
- [ ] Creates Tutor profile on submission
- [ ] Automatically creates default LessonType (60 min "Standard Class")
- [ ] Sets default LessonType reference in Tutor
- [ ] Redirects to Tutor dashboard after completion
- [ ] Shows validation errors appropriately
- [ ] Prevents duplicate Tutor profile creation

## Technical Details

### Controller
```ruby
module Onboarding
  class TutorsController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_no_tutor_profile

    def new
      @tutor = current_user.build_tutor
    end

    def create
      @tutor = current_user.build_tutor(tutor_params)
      
      ActiveRecord::Base.transaction do
        @tutor.save!
        create_default_lesson_type!
        session[:acting_as] = 'tutor'
      end

      redirect_to tutor_dashboard_path, 
                  notice: 'Tutor profile created successfully!'
    rescue ActiveRecord::RecordInvalid
      render :new, status: :unprocessable_entity
    end

    private

    def tutor_params
      params.require(:tutor).permit(:display_name, :bio, :timezone)
    end

    def ensure_no_tutor_profile
      redirect_to tutor_dashboard_path if current_user.tutor.present?
    end

    def create_default_lesson_type!
      lesson_type = @tutor.lesson_types.create!(
        title: "Standard Class",
        duration_minutes: 60,
        active: true
      )
      @tutor.update!(default_lesson_type: lesson_type)
    end
  end
end
```

### View (Tailwind)
```erb
<%= form_with model: @tutor, url: onboarding_tutors_path do |f| %>
  <div class="space-y-4">
    <div>
      <%= f.label :display_name, class: "block text-sm font-medium" %>
      <%= f.text_field :display_name, required: true,
          class: "mt-1 block w-full rounded-md border-gray-300" %>
    </div>
    
    <div>
      <%= f.label :bio, class: "block text-sm font-medium" %>
      <%= f.text_area :bio, rows: 4, required: true,
          class: "mt-1 block w-full rounded-md border-gray-300" %>
    </div>
    
    <div>
      <%= f.label :timezone, class: "block text-sm font-medium" %>
      <%= f.time_zone_select :timezone, nil, 
          { default: current_user.timezone },
          class: "mt-1 block w-full rounded-md border-gray-300" %>
    </div>
    
    <%= f.submit "Create Tutor Profile", 
        class: "bg-blue-500 text-white px-4 py-2 rounded" %>
  </div>
<% end %>
```

## Testing Requirements
- System test for complete onboarding flow
- Controller test for profile creation
- Test default LessonType creation
- Test duplicate prevention
- Test validation errors

## Dependencies
- TASK-004: Tutor model created
- TASK-006: LessonType model created
- TASK-007: Devise authentication working

## Notes
- Transaction ensures atomicity of profile + lesson type creation
- Consider adding progress indicator for multi-step form in future
- May need to add image upload for avatar later