# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Rails 8.0 application using:
- **Frontend**: Vite + Stimulus.js + Turbo
- **Database**: PostgreSQL
- **Testing**: RSpec with FactoryBot, Shoulda Matchers, and Capybara
- **Code Quality**: Rubocop Rails Omakase
- **Development Tools**: Letter Opener for email preview, dotenv for environment variables

## Essential Commands

### Development
```bash
# Start development server (Rails + Vite)
bin/dev

# Rails console
bin/rails console

# Database operations
bin/rails db:migrate
bin/rails db:rollback
bin/rails db:seed
```

### Testing
```bash
# Run full test suite
bin/rake

# Run RSpec tests
bin/rspec

# Run specific test file
bin/rspec spec/path/to/spec.rb

# Run specific test line
bin/rspec spec/path/to/spec.rb:42

# Run system tests with visible browser
SHOW_BROWSER=1 bin/rspec spec/system
```

### Code Quality
```bash
# Run Rubocop
bin/rubocop

# Auto-fix Rubocop issues
bin/rubocop -a
```

### Setup
```bash
# Initial setup or reset environment
bin/setup          # First time setup
bin/setup --reset  # Drop DB and start fresh
```

## Architecture & Structure

### Frontend Architecture
- **Location**: `app/frontend/` (configured via `config.javascript_path = "frontend"`)
- **Entry Point**: `app/frontend/entrypoints/application.js`
- **Stimulus Controllers**: `app/frontend/controllers/`
- **Styles**: `app/frontend/stylesheets/` with PostCSS
- **Build Tool**: Vite with Rails plugin, configuration in `vite.config.ts`

### Rails Application Structure
- **Time Zone**: America/Bogota (configured in `config/application.rb`)
- **Module Name**: `Bookingdemo`
- **Root Route**: `home#index`
- **Health Check**: `/up` endpoint for monitoring

### Testing Configuration
- **Framework**: RSpec with Rails helpers
- **Factory**: FactoryBot with suffix "_factory" (e.g., `users_factory.rb`)
- **System Tests**: Selenium with Chrome/Headless Chrome
- **Support Files**: Located in `spec/support/` with specific configurations for:
  - Capybara setup
  - FactoryBot integration
  - Shoulda Matchers for model testing
  - System test browser configuration

### Development Tools
- **Email Preview**: Letter Opener configured for development
- **Environment Variables**: Use `.env` file (see `.env.sample` for template)
- **Process Management**: `run-pty.json` manages Rails server and Vite dev server concurrently

## Key Configuration Details

### Vite Configuration
- Import aliases: `~` maps to `app/frontend/`
- Hot reload enabled for development
- Rails environment variables accessible via `import.meta.env`

### Generator Configuration
- JavaScript and stylesheet generators disabled
- Routing and view specs disabled
- FactoryBot uses "_factory" suffix convention

### Database
- PostgreSQL required
- Test database uses transactional fixtures
- Automatic schema maintenance in test environment

## Development Workflow Notes

- Frontend assets are served by Vite in development (port configured in `vite.json`)
- Turbo and Stimulus are pre-configured and imported in the main entry point
- Use `bin/dev` to start both Rails and Vite servers simultaneously
- Browser automation tests can be viewed by setting `SHOW_BROWSER=1`

## Commit Guidelines
- Follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification
- First line: Short, concise, technical summary of changes (50 characters or less)
- Leave a blank line after the frist line
- Add detail bullet points explaining the work done (8-10 lines maimum)
-  Commits should be atomic and focused on a single feature or fix
- Do NOT include any attribution , co-authorship, or mentions of Claude/AI in the commit message
- Focus on what was channged and why, not who created it
