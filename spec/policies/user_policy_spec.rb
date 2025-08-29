require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe "permissions" do
    context "show?, update?, destroy?" do
      it "grants access when user is the same as record" do
        policy = described_class.new(user, user)
        expect(policy.show?).to be true
        expect(policy.update?).to be true
        expect(policy.destroy?).to be true
      end

      it "denies access when user is different from record" do
        policy = described_class.new(user, other_user)
        expect(policy.show?).to be false
        expect(policy.update?).to be false
        expect(policy.destroy?).to be false
      end

      it "denies access when user is nil" do
        policy = described_class.new(nil, user)
        expect(policy.show?).to be false
        expect(policy.update?).to be false
        expect(policy.destroy?).to be false
      end
    end
  end

  describe "Scope" do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }

    it "returns only the current user when logged in" do
      scope = Pundit.policy_scope(user1, User)
      expect(scope).to contain_exactly(user1)
    end

    it "returns no users when not logged in" do
      scope = Pundit.policy_scope(nil, User)
      expect(scope).to be_empty
    end
  end
end