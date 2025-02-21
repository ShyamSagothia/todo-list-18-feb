require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) {FactoryBot.create(:user)}
  let(:email1) {FactoryBot.create(:user)}
  let(:email2) {FactoryBot.build(:user, email:email1.email)}

  describe 'validations' do
    it "validates presence of email" do
      expect(User.new(email: nil)).to_not be_valid
    end

    it "validates uniqueness of email" do
      # email1 = create(:user)
      aggregate_failures do
        expect(email1).to be_valid
        # email2 = build(:user, email:email1.email)
        expect(email2).to_not be_valid
        expect(email2.errors[:email]).to include("has already been taken")
      end
    end

    # it{ should validate_uniqueness_of(:email) }

    it "validates presence of name" do
      expect(User.new(name: nil)).to_not be_valid
    end

    it "validates presence of password" do
      expect(User.new(password: nil)).to_not be_valid
      expect(user.password.length).to be >= 6
    end
  end


  describe "Association" do
    
    it "should associated with todo list(has many)" do
      user = User.reflect_on_association(:todo_lists)
      expect(user.macro).to eq(:has_many)
    end

    it "should associated with todo list" do
      user = User.reflect_on_association(:collaborators)
      expect(user.macro).to eq(:has_many)
    end

    # it { should have_many :todo_lists, :through => :collaborators }

    it "has many association" do
      expect(subject).to have_many(:todo_lists).through(:collaborators)
    end
  end
  
end
