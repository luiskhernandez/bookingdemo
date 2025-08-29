# ADR-0002: Use citext for Email Storage

## Status
Accepted

## Context
Email addresses should be treated as case-insensitive for authentication and uniqueness validation. We need to decide how to handle this:
1. Downcase emails in application code
2. Use database-level case-insensitive comparison
3. Use PostgreSQL's citext extension

## Decision
We will use PostgreSQL's `citext` (case-insensitive text) extension for email storage.

## Consequences

### Positive
- **Database-level consistency**: Case-insensitivity enforced at the database level
- **Simplified queries**: No need to downcase in every query
- **Index efficiency**: Indexes work correctly for case-insensitive lookups
- **Data integrity**: Prevents duplicate emails with different casing
- **Performance**: More efficient than using LOWER() in queries

### Negative
- **PostgreSQL dependency**: Ties us to PostgreSQL (not portable to other databases)
- **Extension requirement**: Requires enabling the citext extension
- **Less visible**: Case-insensitivity not obvious from schema alone

## Implementation
```ruby
# Enable extension
class EnableCitext < ActiveRecord::Migration[8.0]
  def change
    enable_extension 'citext'
  end
end

# Use in table
class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.citext :email, null: false
      # other columns...
    end
    
    add_index :users, :email, unique: true
  end
end
```

## Alternatives Considered
1. **Application-level downcasing**: Requires discipline and can be forgotten
2. **Database triggers**: More complex and harder to maintain
3. **Functional indexes with LOWER()**: Less efficient than citext

## References
- PostgreSQL citext documentation
- Email RFC specifications (case-insensitive local parts)
- Rails PostgreSQL adapter documentation