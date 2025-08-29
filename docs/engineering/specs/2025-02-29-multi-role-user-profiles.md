# Technical Spec — Multi-Role User Profiles

**Document ID:** TIP-2025-02-UM
**Related PRD:** [PRD-2025-02-UM Multi-Role User Profiles](../../product/prds/2025-multi-role-user-profiles.md)
**Status:** Draft
**Owner:** Engineering Team
**Last Updated:** 2025-02-29

---

## 1. Overview

**Goal:** Deliver user management where a single account can act as **Tutor** and **Student**, with a default single **LessonType** per Tutor (multi-offer optional), establishing the foundation for future phases.

**Out of scope (this TIP):**
* Scheduling availability and booking system (Phase 2)
* Payment integration (Phase 3)
* Reviews/ratings (Phase 4)
* Admin roles or multi-tenant organization accounts
* Metrics tracking and analytics (separate PRD)

**Primary success criteria:**

* Single login with optional Tutor and Student profiles
* Context switching (act as Tutor vs Student) via session
* CRUD for a default LessonType with guardrails
* Profile separation ensuring independence between roles
* Prevention of duplicate accounts for multi-role scenarios
* Tested with **RSpec** (models/requests) and **Capybara** (system)

---

## 2. Architecture & Data Model (Rails 8 / Postgres)

### Entities

* `User` — account (email, encrypted_password, timezone, preferences)
* `Tutor` — teaching profile (display_name, bio, timezone, settings, default_lesson_type_id)
* `Student` — learning profile (first_name, last_name, settings)
* `LessonType` — offering (title, duration_minutes, active, tutor_id)

### Relationships

* `User` has_one `Tutor`, has_one `Student`
* `Tutor` has_many `LessonType`; optional `default_lesson_type`
* `LessonType` belongs_to `Tutor`

### DB Conventions

* UUID primary keys (`pgcrypto`)
* `citext` for case-insensitive emails
* All timestamps in UTC

---

## 3. Tech Stack & Libraries

* **Ruby** 3.3.x, **Rails** 8.x
* **PostgreSQL** 16+ with `pgcrypto`, `citext`
* **Auth**: Devise
* **AuthZ**: Pundit
* **Frontend**: Hotwire (Turbo/Stimulus) + Tailwind CSS v4
* **Testing**: **RSpec**, **Capybara**, **FactoryBot**, **Shoulda Matchers**, **Database Cleaner**

---

## 4. Assumptions

* A user can hold **both** Tutor and Student profiles
* Most Tutors will have **one** LessonType; multi-offer is opt-in via a flag
* Time presentation respects `User.timezone`; storage remains UTC
* Profiles remain independent - actions as Student don't affect Tutor context
* System prevents duplicate accounts for users wanting multiple roles

---

## 5. API & Routes (HTML first, JSON later)

* Devise routes for `User`
* Onboarding:

  * `GET /onboarding/tutors/new` → form
  * `POST /onboarding/tutors` → creates Tutor **and** default LessonType
  * `GET /onboarding/students/new`
  * `POST /onboarding/students`
* Context switch:

  * `PATCH /profile_session?as=tutor|student|none`
* Tutor area:

  * `GET /tutor/dashboard`
  * `resources :lesson_types` under `/tutors/lesson_types` (CRUD; guardrails)
* Student area:

  * `GET /student/dashboard`

---

## 6. Milestones & Deliverables

### M1 — Project & DB setup

* Rails app, Postgres config, enable `pgcrypto` & `citext`
* UUID primary keys by default
* Deliverable: boots successfully; migrations applied

### M2 — Core models & migrations

* Models: `User`, `Tutor`, `Student`, `LessonType`
* Unique indexes: `tutors.user_id`, `students.user_id`, `lesson_types (tutor_id, title)`
* Deliverable: records creatable in console

### M3 — Devise auth

* Register/Login/Logout flows
* Deliverable: can sign up/in/out; validations for email

### M4 — Onboarding & context switching

* Tutor onboarding creates a default LessonType (60 minutes "Standard Class") and sets it as default
* Student onboarding with required fields (first_name, last_name)
* `ProfileSessionsController` stores acting context in session
* Deliverable: switch context and access dashboards accordingly

### M5 — LessonType management (guardrails)

* CRUD with "single offer unless allowed" rule
* Tutor settings flag `allow_multi_offers`
* Deliverable: UI prevents second offer unless flag enabled

### M6 — Authorization & dashboards

* Pundit policies for Tutor/Student resources
* Basic dashboards gated by context
* Profile separation validation (Student actions don't affect Tutor)
* Deliverable: access control enforced and profiles remain independent

### M7 — Seeds & Test coverage

* Seeds for quick QA (dual profile user)
* **RSpec** model/request/system tests with **Capybara**
* Deliverable: Green test suite in CI

---

## 7. Detailed Tasks (Agent-Friendly)

* Create migration to enable extensions:

  * `pgcrypto`, `citext`
* Create tables (UUID ids):

  * `users(email: citext uniq, encrypted_password, timezone: string default: "UTC", preferences: jsonb {})`
  * `tutors(user: uuid uniq, display_name NOT NULL, bio TEXT, timezone default "UTC", settings: jsonb {}, default_lesson_type_id: uuid fk)`
  * `students(user: uuid uniq, first_name NOT NULL, last_name NOT NULL, settings: jsonb {})`
  * `lesson_types(tutor: uuid, title uniq per tutor, duration_minutes int, active bool default true)`
* Models & validations:

  * `Tutor#allow_multi_offers?` reads `settings["allow_multi_offers"]`
  * Validation: if not allowed, block >1 LessonType
  * Tutor requires: display_name, bio, timezone
  * Student requires: first_name, last_name
* Devise setup for `User` (+ views)
* Pundit install + policies (`TutorPolicy`, `StudentPolicy`)
* Controllers:

  * `Onboarding::TutorsController` (`new/create`) → create default LessonType (60m "Standard Class")
  * `Onboarding::StudentsController`
  * `ProfileSessionsController#update`
  * `Tutors::LessonTypesController` (CRUD; guardrails)
  * `Tutors::DashboardController#show`, `Students::DashboardController#show`
* Views: minimal Tailwind forms
* Seeds with a dual-profile user

---

## 8. Acceptance Criteria

* A signed-in user can create **Tutor** and **Student** profiles independently
* A user can toggle acting context (Tutor/Student) and see the corresponding dashboard
* Tutor onboarding auto-creates a default **LessonType (60 minutes "Standard Class")** and sets it as default
* Attempting to create a second LessonType without `allow_multi_offers` shows a validation error
* Policies prevent accessing or editing another user's profiles/offers
* Profiles remain separated - Student context doesn't affect Tutor settings
* System prevents duplicate accounts for multi-role scenarios
* Test suite passes (see Test Plan)

---

## 9. Test Plan (RSpec + Capybara)

### Unit (models)

* `User`: validations, uniqueness of email
* `Tutor`: `allow_multi_offers?`; "single offer unless allowed"; required fields validation
* `Student`: required fields validation (first_name, last_name)
* `LessonType`: presence, duration allowed set, `(tutor_id, title)` uniqueness

### Request / Controller specs

* Onboarding:

  * POST `/onboarding/tutors` creates Tutor + default LessonType
  * POST `/onboarding/students` creates Student
  * Prevents duplicate profile creation for same user
* Profile session:

  * PATCH `/profile_session?as=tutor` sets session; errors if tutor missing
  * PATCH `/profile_session?as=student` likewise
  * Validates profile independence
* LessonTypes:

  * POST create second lesson type → 422 when flag is false
  * Allowed when `allow_multi_offers` true

### System (Capybara)

* Sign up → create Tutor → redirected to Tutor dashboard and see default LessonType
* Switch context to Student → see Student dashboard
* Try to create second LessonType → UI shows error unless enabled
* Verify profiles remain independent when switching contexts
* Attempt to create duplicate profile → system prevents and shows appropriate message

### Setup

* **FactoryBot** factories for `user_factory`, `tutor_factory`, `student_factory`, `lesson_type_factory`
* Use transactional fixtures or Database Cleaner
* Headless Chrome for Capybara

---

## 10. Security & Privacy

* Devise strong params; secure password storage
* Pundit authorization on all sensitive actions
* Session-stored acting context (no trust without server checks)
* CSRF enabled; only owners can manage their profiles

---

## 11. Observability & Ops

* Basic Rails logs; later: add request IDs
* Health check endpoint (controller returning 200)
* Seeded admin user (optional) for QA
* **Note:** Metrics tracking will be implemented in separate PRD

---

## 12. Risks & Mitigations

* **Ambiguous roles** → Clear context switch + guards in controllers
* **Future multi-offer expansion** → already supported by flag; DB model supports many LessonTypes
* **Migration to booking engine** → designed to plug in availability/booking later (no schema rewrite)

---

## 13. Rollout Plan

* Dev environment → seed users → manual QA (checklist ties to Acceptance Criteria)
---

## 14. Definition of Done (DoD) Checklist

* [ ] All migrations applied; UUID + `citext` active
* [ ] Devise sign up/sign in/out works
* [ ] Onboarding flows create profiles as specified
* [ ] Context switch persists across requests and gates dashboards
* [ ] LessonType guardrails enforced
* [ ] Pundit policies applied in controllers
* [ ] Seeds present and documented
* [ ] RSpec suite green locally (model + request + system)
* [ ] README updated (setup, run, test)
* [ ] Profile independence validated
* [ ] Duplicate account prevention tested

---

## 15. Open Questions

* Allowed `duration_minutes` set: fixed list or any multiple of 15? Answer: fixed list
* Should tutors be able to rename the default LessonType title during onboarding? Answer: Yes
* Do we need locale/i18n from day one? Answer: Yes

---

## 16. Appendix — Sample Commands & Snippets

```bash
# Project already initialized with Rails 8
# Add required gems if not present
bundle add devise pundit

# RSpec already configured
```

**Enable Postgres extensions (migration):**

```ruby
class EnablePgExtensions < ActiveRecord::Migration[8.0]
  def change
    enable_extension "pgcrypto"
    enable_extension "citext"
  end
end
```

**Model guardrail (Tutor):**

```ruby
class Tutor < ApplicationRecord
  belongs_to :user
  has_many :lesson_types, dependent: :destroy
  belongs_to :default_lesson_type, class_name: "LessonType", optional: true

  validates :display_name, presence: true
  validates :bio, presence: true
  validates :timezone, presence: true

  def allow_multi_offers? = settings["allow_multi_offers"] == true

  validate :single_offer_unless_allowed
  def single_offer_unless_allowed
    return if allow_multi_offers?
    errors.add(:base, "Only one lesson type allowed for this profile") if lesson_types.size > 1
  end
end
```

**Capybara system test outline:**

```ruby
require "rails_helper"

RSpec.describe "Tutor onboarding", type: :system do
  it "creates tutor and default lesson type" do
    visit new_user_registration_path
    fill_in "Email", with: "test@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_button "Sign up"

    visit new_onboarding_tutor_path
    fill_in "Display name", with: "Coach Ana"
    fill_in "Bio", with: "Experienced math tutor"
    select "America/Bogota", from: "Timezone"
    click_button "Create Tutor Profile"

    expect(page).to have_content("Tutor dashboard")
    expect(page).to have_content("Standard Class")
    expect(page).to have_content("60 minutes")
  end
end
```
