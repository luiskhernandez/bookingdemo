require 'rails_helper'

RSpec.describe TutorPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:tutor) { create(:tutor, user: user) }
  let(:other_tutor) { create(:tutor, user: other_user) }

  describe "permissions" do
    context "show?, update?, destroy?, dashboard?" do
      it "grants access when user owns the tutor profile" do
        policy = described_class.new(user, tutor)
        expect(policy.show?).to be true
        expect(policy.update?).to be true
        expect(policy.destroy?).to be true
        expect(policy.dashboard?).to be true
      end

      it "denies access when user does not own the tutor profile" do
        policy = described_class.new(user, other_tutor)
        expect(policy.show?).to be false
        expect(policy.update?).to be false
        expect(policy.destroy?).to be false
        expect(policy.dashboard?).to be false
      end

      it "denies access when user is nil" do
        policy = described_class.new(nil, tutor)
        expect(policy.show?).to be false
        expect(policy.update?).to be false
        expect(policy.destroy?).to be false
        expect(policy.dashboard?).to be false
      end
    end

    context "create?" do
      it "grants access when user has no tutor profile" do
        fresh_user = create(:user)
        new_tutor = fresh_user.build_tutor
        policy = described_class.new(fresh_user, new_tutor)
        expect(policy.create?).to be true
      end

      it "denies access when user already has a tutor profile" do
        # Explicitly create and save a tutor for this user
        create(:tutor, user: user)
        new_tutor = build(:tutor, user: user)
        policy = described_class.new(user, new_tutor)
        expect(policy.create?).to be false
      end

      it "denies access when user is nil" do
        new_tutor = build(:tutor)
        policy = described_class.new(nil, new_tutor)
        expect(policy.create?).to be false
      end
    end
  end

  describe "Scope" do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:tutor1) { create(:tutor, user: user1) }
    let!(:tutor2) { create(:tutor, user: user2) }

    it "returns only tutors owned by the current user" do
      scope = Pundit.policy_scope(user1, Tutor)
      expect(scope).to contain_exactly(tutor1)
    end

    it "returns no tutors when not logged in" do
      scope = Pundit.policy_scope(nil, Tutor)
      expect(scope).to be_empty
    end
  end
end