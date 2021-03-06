require 'rails_helper'

RSpec.describe Question, type: :model do
  context "relationships" do
    it { should belong_to(:user) }
    it { should belong_to(:best_answer) }
    it { should belong_to(:category) }
    it { should have_many(:answers) }
    it { should have_many(:comments) }
    it { should have_many(:upvotes) }
    it { should have_many(:downvotes) }
  end

  context "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
  end

  describe ".answer_count" do
    let(:user) { Fabricate(:user, name: "we the best") }
    let(:question) { Fabricate(:question, title: "Why do they try to stop us?", user: user) }

    before do
      question.answers.create(body: "blessup", user: user)
      question.answers.create(body: "we the best", user: user)
      question.answers.create(body: "$$$", user: user)
    end

    it "returns the question's answer count" do
      expect(question.answer_count).to eq(3)
    end
  end

  describe ".current_user_upvote_correction" do
    it "checks if a user's upvote exists on a question and deletes it" do
      user_1 = Fabricate(:user)
      user_2 = Fabricate(:user)
      user_3 = Fabricate(:user)
      user_4 = Fabricate(:user)

      question = Fabricate(:question, title: "Why are we the best?", body: "Bless Up", user: user_1)

      question.upvotes.create(creator: user_2.id, user_id: user_1.id)
      question.upvotes.create(creator: user_3.id, user_id: user_1.id)
      question.upvotes.create(creator: user_4.id, user_id: user_1.id)

      expect(question.upvotes.count).to be(3)

      question.current_user_upvote_correction(user_2.id)

      expect(question.upvotes.count).to be(2)
    end
  end

  describe ".current_user_upvote_correction" do
    it "checks if a user's upvote exists on a question and deletes it" do
      user_1 = Fabricate(:user)
      user_2 = Fabricate(:user)
      user_3 = Fabricate(:user)
      user_4 = Fabricate(:user)

      question = Fabricate(:question, title: "Why are we the best?", body: "Bless Up", user: user_1)

      question.downvotes.create(creator: user_2.id, user_id: user_1.id)
      question.downvotes.create(creator: user_3.id, user_id: user_1.id)
      question.downvotes.create(creator: user_4.id, user_id: user_1.id)

      expect(question.downvotes.count).to be(3)

      question.current_user_downvote_correction(user_2.id)

      expect(question.downvotes.count).to be(2)
    end
  end

  describe ".sort_by_best_answer" do
    let(:question) { Fabricate(:question) }
    let!(:answer) { Fabricate(:answer, question: question) }
    let!(:answer_2) { Fabricate(:answer, question: question) }

    it "sorts answers so that the best answer is always first" do
      question.best_answer = answer
      question.save

      expect(question.sort_by_best_answer).to eq([answer, answer_2])
    end
  end
end
