require 'rails_helper'

feature 'user profile' do
  attr_reader :user
  before(:each) do
    @user = Fabricate(:user)
  end

  scenario 'user sees their own account information' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit user_path(user)

    expect(page).to have_css('#user-info')

    within('#user-info-table') do
      expect(page).to have_content(user.email)
      expect(page).to have_content(user.phone)
      expect(page).to have_content('Reputation')
    end

    within('#user-avatar') do
      expect(page).to have_content(user.name)
    end
  end

  scenario 'user sees their avatar image' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit user_path(user)

    expect(page).to have_css('#user-avatar')
  end

  scenario 'user sees their 5 most recent question titles as links' do
    question1 = Fabricate(:question, user: user, title: 'bad')
    question2 = Fabricate(:question, user: user, title: 'test2')
    question3 = Fabricate(:question, user: user, title: 'test3')
    question4 = Fabricate(:question, user: user, title: 'test4')
    question5 = Fabricate(:question, user: user, title: 'test5')
    question6 = Fabricate(:question, user: user, title: 'test6')

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit user_path(user)

    expect(page).to have_css('#user-show-questions')

    within('#user-show-questions') do
      expect(page).to_not have_content(question1.title)

      expect(page).to have_link(question6.title, href: question_path(question6))
      expect(page).to have_link(question5.title, href: question_path(question5))
      expect(page).to have_link(question4.title, href: question_path(question4))
      expect(page).to have_link(question3.title, href: question_path(question3))
      expect(page).to have_link(question2.title, href: question_path(question2))
    end
  end

  scenario 'user sees their 5 most recent questions answered as links' do
    question1 = Fabricate(:question, title: 'test')
    question2 = Fabricate(:question)
    question3 = Fabricate(:question)
    question4 = Fabricate(:question)
    question5 = Fabricate(:question)
    question6 = Fabricate(:question)

    Fabricate(:answer, user: user, question: question1)
    Fabricate(:answer, user: user, question: question2)
    Fabricate(:answer, user: user, question: question3)
    Fabricate(:answer, user: user, question: question4)
    Fabricate(:answer, user: user, question: question5)
    Fabricate(:answer, user: user, question: question6)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit user_path(user)

    expect(page).to have_css('#user-show-answers')

    within('#user-show-answers') do
      expect(page).to_not have_content(question1.title)

      expect(page).to have_link(question6.title, href: question_path(question6))
      expect(page).to have_link(question5.title, href: question_path(question5))
      expect(page).to have_link(question4.title, href: question_path(question4))
      expect(page).to have_link(question3.title, href: question_path(question3))
      expect(page).to have_link(question2.title, href: question_path(question2))
    end
  end

  scenario 'user sees the 5 most recent comments left on their work' do
    user2 = Fabricate(:user)
    question1 = Fabricate(:question, title: 'test', user: user)
    answer1 = Fabricate(:answer, user: user, question: question1)
    user2.comments.create(body: 'test', commentable: question1)
    user2.comments.create(body: 'test', commentable: question1)
    user2.comments.create(body: 'test', commentable: question1)
    user2.comments.create(body: 'test', commentable: answer1)
    user2.comments.create(body: 'test', commentable: answer1)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit user_path(user)

    expect(page).to have_css('#user-show-comments')

    within('#user-show-comments') do
      expect(page).to have_link(question1.title, href: question_path(question1))
      expect(page).to have_link(question1.title, href: question_path(question1))
      expect(page).to have_link(question1.title, href: question_path(question1))
      expect(page).to have_link(question1.title, href: question_path(question1))
      expect(page).to have_link(question1.title, href: question_path(question1))
    end
  end

  scenario "user visits another user's profile" do
    user = Fabricate(:user)
    user_2 = Fabricate(:user)

    allow_any_instance_of(ApplicationController).to receive(:current_user)
      .and_return(user)

    visit user_path(user_2)

    within('#user-info-table') do
      expect(page).to have_content(user.email)
      expect(page).to_not have_content(user.phone)
      expect(page).to have_content('Reputation')
      expect(page).to_not have_link("Edit Profile")
    end


  end
end
