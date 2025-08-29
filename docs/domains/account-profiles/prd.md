# Product Requirements Document (PRD) — Multi-Role User Profiles

**Document ID:** PRD-2025-02-UM
**Related Plan:** [Implementation Plan](./plan.md)
**Status:** Draft
**Owner:** \[Presto]
**Last Updated:** 2025-02-29

---

## 1. Overview

We need a **user management system** that allows a person to register with a single account and act as either a **Student** (to book classes) and/or a **Tutor** (to offer classes).

The system must support:

* Single sign-up/sign-in (email + password).
* Independent onboarding flows for Tutor and Student.
* Ability to switch between acting contexts (Tutor or Student).
* Default offering setup for Tutors.

This is the foundation for the booking, availability, and payment features.

---

## 2. Goals

* Enable a single person to **teach and learn** with one login.
* Support **seamless onboarding** for Tutors and Students.
* Allow a user to **switch roles** without creating duplicate accounts.
* Set up a **default LessonType** for new Tutors to simplify onboarding.
* Provide secure authentication and basic authorization.

---

## 3. Non-Goals (Out of Scope)

* Scheduling availability and booking system (covered in separate PRD).
* Payment integration (Stripe, refunds, payouts).
* Reviews/ratings.
* Admin roles or multi-tenant organization accounts.

---

## 4. Feature Roadmap & Dependencies

### Current Phase (This PRD)
* Authentication
* Multi-role Profile System
* Basic Dashboards

### Future Phases
* **Phase 2:** Booking System (PRD-2025-03-BOOK) - Enable lesson scheduling and management
* **Phase 3:** Payment Integration (PRD-2025-04-PAY) - Add Stripe, refunds, payouts
* **Phase 4:** Reviews & Ratings (PRD-2025-05-REV) - Add feedback system

---

## 5. User Stories

### 5.1 Students

* *As a Student, I want to sign up and create my profile* so that I can establish my presence on the platform.
  * **Future Context:** Profile will be used for booking lessons once booking system is released (Phase 2)

* *As a Student, I want to access a dashboard* so that I can view and manage my student profile.
  * **Future Context:** Dashboard will display booked lessons in Phase 2

### 5.2 Tutors

* *As a Tutor, I want to sign up and create my teaching profile* so that I can establish my teaching presence on the platform.
* *As a Tutor, I want to define at least one LessonType* (duration, title) so that my offerings are ready when booking opens.
* *As a Tutor, I want a dashboard* where I can manage my profile and lesson types.
  * **Future Context:** Dashboard will show bookings and availability in Phase 2

### 5.3 Dual-role Users

* *As a person who is both a Tutor and a Student, I want to switch between roles* without logging out/in again.
* *As a dual-role user, I want my profiles separated* so that my Student and Tutor contexts remain independent.
  * **Future Context:** Bookings made as Student won't affect Tutor availability (Phase 2)

### 5.4 System/Admin

* *As the system, I need to ensure only the profile owner can access their dashboards* (authorization).
* *As the system, I need to restrict a Tutor to one LessonType unless explicitly allowed* (guardrail).

---

## 6. Functional Requirements

1. **Authentication**

   * Users register/login with email + password.
   * Password reset and email uniqueness required.
2. **Profile Management**

   * Each User may have:

     * 0–1 Student profile
     * 0–1 Tutor (Tutor) profile
   * Profiles are optional and can be created later via onboarding.
3. **Context Switching**

   * Session-based toggle to act as Student or Tutor.
   * Default context auto-selected if user has only one profile.
4. **Onboarding**

   * Tutor onboarding requires display name, timezone, bio.
   * Student onboarding requires first/last name.
   * Creating a Tutor automatically generates a default LessonType (60m “Standard Class”).
5. **LessonTypes**

   * A Tutor has one LessonType by default.
   * System prevents adding a second LessonType unless `allow_multi_offers` flag is set.
6. **Authorization**

   * Tutors can only manage their own profiles and LessonTypes.
   * Students can only manage their own profile.

---

## 7. Success Metrics

* No duplicate user accounts created for multi-role scenarios.
* Successful profile separation between Student and Tutor contexts.
* **Note:** Detailed metrics tracking (onboarding completion rates, time-to-complete, etc.) will be covered in a separate Analytics PRD.

---

## 8. Risks & Mitigations

* **Confusion about roles**: Mitigated by clear UI for context switching and dashboards.
* **Tutor complexity** (multiple LessonTypes): Mitigated by defaulting to one LessonType and only enabling multi-offer for advanced users.
* **Account sharing**: Not prevented in MVP, may need stronger auth later (2FA).

---

## 9. Dependencies

* Rails 8 + PostgreSQL (UUID, citext).
* Devise (auth).
* Pundit (authorization).
* RSpec + Capybara (test coverage).

---

## 10. Deliverables

* One User model with optional Student and Tutor profiles.
* Tutor onboarding that creates a default LessonType.
* Context switching (session-based).
* Guardrails for LessonTypes (one by default).
* Dashboards for Tutor and Student.
* RSpec + Capybara test coverage.
