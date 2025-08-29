require 'rails_helper'

RSpec.describe LessonTypePolicy, type: :policy do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:tutor) { create(:tutor, user: user) }
  let(:other_tutor) { create(:tutor, user: other_user) }
  let(:lesson_type) { create(:lesson_type, tutor: tutor) }
  let(:other_lesson_type) { create(:lesson_type, tutor: other_tutor) }

  describe "permissions" do
    context "show?" do
      it "grants access to everyone" do
        policy1 = described_class.new(user, lesson_type)
        policy2 = described_class.new(other_user, lesson_type)
        policy3 = described_class.new(nil, lesson_type)
        expect(policy1.show?).to be true
        expect(policy2.show?).to be true
        expect(policy3.show?).to be true
      end
    end

    context "create?, update?, destroy?" do
      it "grants access when user owns the associated tutor" do
        policy = described_class.new(user, lesson_type)
        expect(policy.create?).to be true
        expect(policy.update?).to be true
        expect(policy.destroy?).to be true
      end

      it "denies access when user does not own the associated tutor" do
        policy = described_class.new(other_user, lesson_type)
        expect(policy.create?).to be false
        expect(policy.update?).to be false
        expect(policy.destroy?).to be false
      end

      it "denies access when user is nil" do
        policy = described_class.new(nil, lesson_type)
        expect(policy.create?).to be false
        expect(policy.update?).to be false
        expect(policy.destroy?).to be false
      end

      it "denies access when user has no tutor profile" do
        user_without_tutor = create(:user)
        policy = described_class.new(user_without_tutor, lesson_type)
        expect(policy.create?).to be false
        expect(policy.update?).to be false
        expect(policy.destroy?).to be false
      end
    end
  end

  describe "Scope" do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:tutor1) { create(:tutor, user: user1) }
    let!(:tutor2) { create(:tutor, user: user2) }
    let!(:lesson_type1) { create(:lesson_type, tutor: tutor1, active: true) }
    let!(:lesson_type2) { create(:lesson_type, tutor: tutor2, active: true) }
    let!(:inactive_lesson_type) { create(:lesson_type, tutor: tutor2, active: false) }

    it "returns only lesson types owned by the current tutor user" do
      scope = Pundit.policy_scope(user1, LessonType)
      expect(scope).to contain_exactly(lesson_type1)
    end

    it "returns only active lesson types when not logged in" do
      scope = Pundit.policy_scope(nil, LessonType)
      expect(scope).to contain_exactly(lesson_type1, lesson_type2)
    end

    it "returns only active lesson types when user has no tutor profile" do
      user_without_tutor = create(:user)
      scope = Pundit.policy_scope(user_without_tutor, LessonType)
      expect(scope).to contain_exactly(lesson_type1, lesson_type2)
    end
  end
end