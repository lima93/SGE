require 'rails_helper'

describe 'Staff::Documents::update', type: :feature do
  let(:staff) { create(:user) }
  let(:resource_name) { Document.model_name.human }
  let!(:department) { create(:department) }
  let!(:manager) { create(:role, :manager) }
  let!(:division) { create(:division, department_id: department.id) }
  let!(:document) { create(:document, division: division) }

  before(:each) do
    create(:department_users,
           department_id: department.id,
           user_id: staff.id,
           role_id: manager.id)
    login_as(staff, scope: :user)
    visit edit_staff_department_division_document_path(department, division, document)
  end

  context 'when render edit' do
    it 'fields should be filled' do
      expect(page).to have_field('document_title', with: document.title)
      expect(page).to have_field('document_front', with: document.front)
      expect(page).to have_field('document_back', with: document.back)
    end
  end

  context 'with valid fields' do
    it 'update contact' do
      attributes = attributes_for(:document)

      fill_in 'document_title', with: attributes[:title]
      fill_in 'document_front', with: attributes[:front]
      fill_in 'document_back', with: attributes[:back]

      submit_form

      expect(page).to have_current_path staff_department_division_documents_path(department,
                                                                                 division)
      expect(page).to have_flash(:success, text: flash_msg('update.m'))

      within('table tbody') do
        expect(page).to have_content(attributes[:title])
      end
    end
  end

  context 'with invalids fields' do
    it 'show errors when fields are blank', js: true do
      fill_in 'document_title', with: ''
      fill_in 'document_front', with: ''
      fill_in 'document_back', with: ''

      submit_form

      expect(page).to have_flash(:danger, text: flash_errors_msg)

      expect(page).to have_message(sf_blank_error_msg, in: 'div.document_title')
      expect(page).to have_message(sf_blank_error_msg, in: 'div.document_front')
      expect(page).to have_message(sf_blank_error_msg, in: 'div.document_back')
      expect(page).to have_message(sf_blank_error_msg, in: 'div.document_document_users_function')
      expect(page).to have_message(sf_blank_error_msg, in: 'div.document_document_users_user_id')
    end
  end
end
