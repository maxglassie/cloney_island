require 'rails_helper'

feature 'user profile' do
  scenario 'user sees their account information' do
    user = Fabricate(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit user_path(user)

    expect(page).to have_css('#user-info')

    within('#user-info-table') do
      expect(page).to have_content(user.name)
      expect(page).to have_content(user.email)
      expect(page).to have_content(user.phone)
      expect(page).to have_content('Reputation')
    end
  end

  scenario 'user sees their avatar image' do
    user = Fabricate(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit user_path(user)

    expect(page).to have_css('#user-avatar')
  end

  scenario 'user sees their 5 most recent question titles as links' do
    user = Fabricate(:user)
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
end