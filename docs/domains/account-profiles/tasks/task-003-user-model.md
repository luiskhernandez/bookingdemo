# TASK-003: Create User Model

## Status: 🔴 Not Started

## Description
Create the User model with Devise authentication, using UUID primary keys and citext for email storage.

## Acceptance Criteria
- [ ] User model created with UUID primary key
- [ ] Email field uses citext type
- [ ] Devise configured for User model
- [ ] Timezone field with UTC default
- [ ] Preferences JSONB field for future extensibility
- [ ] Model validations in place
- [ ] Tests passing

## Technical Details

### Migration
```ruby
class DeviseCreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: :uuid do |t|
      ## Database authenticatable
      t.citext :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Custom fields
      t.string :timezone, default: "UTC"
      t.jsonb :preferences, default: {}

      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
  end
end
```

### Model
```ruby
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :tutor, dependent: :destroy
  has_one :student, dependent: :destroy

  validates :timezone, presence: true
end
```

## Testing Requirements
- Unit tests for validations
- Test email uniqueness (case-insensitive)
- Test Devise authentication flow
- Factory for user creation

## Dependencies
- TASK-001: PostgreSQL extensions enabled
- TASK-002: UUID configuration complete
- Devise gem installed

## Notes
- This is the core authentication model
- Will be extended with profile associations
- Consider adding trackable module later if needed