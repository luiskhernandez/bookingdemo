require 'rails_helper'

RSpec.describe StudentPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:student) { create(:student, user: user) }
  let(:other_student) { create(:student, user: other_user) }

  describe "permissions" do
    context "show?, update?, destroy?, dashboard?" do
      it "grants access when user owns the student profile" do
        policy = described_class.new(user, student)
        expect(policy.show?).to be true
        expect(policy.update?).to be true
        expect(policy.destroy?).to be true
        expect(policy.dashboard?).to be true
      end

      it "denies access when user does not own the student profile" do
        policy = described_class.new(user, other_student)
        expect(policy.show?).to be false
        expect(policy.update?).to be false
        expect(policy.destroy?).to be false
        expect(policy.dashboard?).to be false
      end

      it "denies access when user is nil" do
        policy = described_class.new(nil, student)
        expect(policy.show?).to be false
        expect(policy.update?).to be false
        expect(policy.destroy?).to be false
        expect(policy.dashboard?).to be false
      end
    end

    context "create?" do
      it "grants access when user has no student profile" do
        fresh_user = create(:user)
        new_student = fresh_user.build_student
        policy = described_class.new(fresh_user, new_student)
        expect(policy.create?).to be true
      end

      it "denies access when user already has a student profile" do
        # Explicitly create and save a student for this user
        create(:student, user: user)
        new_student = build(:student, user: user)
        policy = described_class.new(user, new_student)
        expect(policy.create?).to be false
      end

      it "denies access when user is nil" do
        new_student = build(:student)
        policy = described_class.new(nil, new_student)
        expect(policy.create?).to be false
      end
    end
  end

  describe "Scope" do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:student1) { create(:student, user: user1) }
    let!(:student2) { create(:student, user: user2) }

    it "returns only students owned by the current user" do
      scope = Pundit.policy_scope(user1, Student)
      expect(scope).to contain_exactly(student1)
    end

    it "returns no students when not logged in" do
      scope = Pundit.policy_scope(nil, Student)
      expect(scope).to be_empty
    end
  end
end