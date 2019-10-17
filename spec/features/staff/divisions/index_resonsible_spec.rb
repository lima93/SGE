require 'rails_helper'

describe 'Staff::Divisions::index_responsible', type: :feature do
  let(:staff) { create(:user) }
  let(:department) { create(:department) }
  let(:responsible) { create(:role, :responsible) }
  let(:resource_name) { Division.model_name.human }

  before(:each) do
    login_as(staff, scope: :user)
  end

  context 'with data' do
    it 'showed' do
      divs_user = create_list(:division_users, 3, user: staff, role: responsible)
      visit staff_divisions_path
      within('table tbody') do
        divs_user.each do |divs_user|
          division = divs_user.division
          expect(page).to have_content(division.name)

          expect(page).to have_link(href: staff_department_division_path(division.department, division.id),
                                    count: 2)
          expect(page).to have_link(href: edit_staff_department_division_path(division.department, division))
          expect(page).to have_link(href: staff_department_division_members_path(division.department,
                                                                                 division))
        end
      end
    end
  end
end
