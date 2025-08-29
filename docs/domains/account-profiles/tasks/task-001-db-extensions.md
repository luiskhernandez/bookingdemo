# TASK-001: Enable PostgreSQL Extensions

## Status: 🔴 Not Started

## Description
Enable required PostgreSQL extensions for the application: `pgcrypto` for UUID generation and `citext` for case-insensitive text fields.

## Acceptance Criteria
- [ ] Migration created to enable `pgcrypto` extension
- [ ] Migration created to enable `citext` extension
- [ ] Migrations run successfully in development
- [ ] Migrations are reversible

## Technical Details

### Migration Code
```ruby
class EnablePgExtensions < ActiveRecord::Migration[8.0]
  def change
    enable_extension "pgcrypto"
    enable_extension "citext"
  end
end
```

### Commands
```bash
# Generate migration
bin/rails generate migration EnablePgExtensions

# Run migration
bin/rails db:migrate

# Verify extensions
bin/rails db
\dx
```

## Testing
- Verify extensions are enabled in database
- Ensure UUID generation works
- Test case-insensitive queries with citext

## Dependencies
- PostgreSQL database must be configured

## Notes
- These extensions are foundational and must be completed before creating models
- Required for UUID primary keys and case-insensitive email storage