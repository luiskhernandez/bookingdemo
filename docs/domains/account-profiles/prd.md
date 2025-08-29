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

### 5.1 New Users

* *As a new user, I want to select my intended role (Tutor or Student) from the home page* so that I can start the appropriate sign-up process.
* *As a new user who selected a role, I want to be automatically directed to the appropriate onboarding flow after sign-up* so that I can complete my profile setup seamlessly.

### 5.2 Students

* *As a Student, I want to sign up and create my profile* so that I can establish my presence on the platform.
  * **Future Context:** Profile will be used for booking lessons once booking system is released (Phase 2)

* *As a Student, I want to access a dashboard* so that I can view and manage my student profile.
  * **Future Context:** Dashboard will display booked lessons in Phase 2

### 5.3 Tutors

* *As a Tutor, I want to sign up and create my teaching profile* so that I can establish my teaching presence on the platform.
* *As a Tutor, I want to define at least one LessonType* (duration, title) so that my offerings are ready when booking opens.
* *As a Tutor, I want a dashboard* where I can manage my profile and lesson types.
  * **Future Context:** Dashboard will show bookings and availability in Phase 2

### 5.4 Dual-role Users

* *As a person who is both a Tutor and a Student, I want to switch between roles* without logging out/in again.
* *As a dual-role user, I want my profiles separated* so that my Student and Tutor contexts remain independent.
  * **Future Context:** Bookings made as Student won't affect Tutor availability (Phase 2)

### 5.5 All Authenticated Users

* *As a signed-in user, I want to sign out from any page* so that I can securely end my session.
* *As a signed-in user, I want a clear sign out option on my dashboard* so that I can easily log out when needed.

### 5.6 System/Admin

* *As the system, I need to ensure only the profile owner can access their dashboards* (authorization).
* *As the system, I need to restrict a Tutor to one LessonType unless explicitly allowed* (guardrail).

---

## 6. Functional Requirements

1. **Authentication**

   * Users register/login with email + password.
   * Password reset and email uniqueness required.
   * Sign out functionality available from all authenticated pages.
   * Sign out button prominently displayed on user dashboards.

2. **Role Selection**

   * Home page displays role selection options for non-authenticated users.
   * Two distinct paths: "Become a Tutor" and "Become a Student".
   * Role selection passes role parameter to registration flow.
   * Selected role is preserved through the sign-up process via session storage.

3. **Profile Management**

   * Each User may have:
     * 0–1 Student profile
     * 0–1 Tutor profile
   * Profiles are optional and can be created later via onboarding.
   * Users can have both profiles simultaneously.

4. **Context Switching**

   * Session-based toggle to act as Student or Tutor.
   * Default context auto-selected if user has only one profile.
   * Clear visual indicators for current active context.

5. **Onboarding**

   * Automatic redirect to role-specific onboarding after sign-up based on selected role.
   * Tutor onboarding requires display name, timezone, bio.
   * Student onboarding requires first/last name.
   * Creating a Tutor automatically generates a default LessonType (60m "Standard Class").
   * If no role was pre-selected, users are redirected to home page after sign-up.

6. **LessonTypes**

   * A Tutor has one LessonType by default.
   * System prevents adding a second LessonType unless `allow_multi_offers` flag is set.

7. **Authorization**

   * Tutors can only manage their own profiles and LessonTypes.
   * Students can only manage their own profile.
   * Unauthenticated users cannot access dashboards or profile management pages.

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

## 9. Acceptance Criteria

The feature will be considered complete when:

* Users can register and authenticate with email and password
* Users can select their intended role (Tutor or Student) from the home page before sign-up
* System automatically redirects users to appropriate onboarding flow after sign-up based on role selection
* Users can sign out from their dashboard and other authenticated pages
* Users can create both Tutor and Student profiles independently
* Users can switch between Tutor and Student contexts seamlessly
* Tutor onboarding creates a teaching profile and default lesson offering
* Student onboarding creates a learning profile
* Access controls prevent users from accessing others' profiles
* System prevents duplicate accounts for multi-role users
* Role selection is preserved through the entire sign-up and onboarding process

**Note:** Technical implementation details are covered in the [Implementation Plan](./plan.md).
