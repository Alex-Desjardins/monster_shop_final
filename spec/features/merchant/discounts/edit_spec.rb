require 'rails_helper'

RSpec.describe 'Merchant Index Page' do
  describe 'As an employee of a merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'secret')
      @b_user = @merchant_2.users.create(name: 'Brian', address: '123 Main St', city: 'Boise', state: 'ID', zip: 54321, email: 'brian@example.com', password: 'secret')
      @discount1 = @merchant_1.discounts.create!(percentage: 5, item_amount: 10)
      @discount2 = @merchant_1.discounts.create!(percentage: 10, item_amount: 20)
      @discount3 = @merchant_2.discounts.create!(percentage: 10, item_amount: 5)
      @discount4 = @merchant_2.discounts.create!(percentage: 10, item_amount: 10)
    end

    it 'I can link to edit an existing discount on index page' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
      visit '/merchant/discounts'

      within "#discount-#{@discount2.id}" do
        expect(page).to have_link("Edit Discount")
      end

      within "#discount-#{@discount1.id}" do
        expect(page).to have_link("Edit Discount")
        click_link "Edit Discount"
      end
      expect(current_path).to eq("/merchant/discounts/#{@discount1.id}/edit")
    end

    it "Edit discount happy path with pre-populated number fields and flash success" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
      visit "/merchant/discounts/#{@discount1.id}/edit"

      expect(find_field(:percentage).value).to eq @discount1.percentage.to_s
      expect(find_field(:item_amount).value).to eq @discount1.item_amount.to_s

      fill_in :percentage, with: 10
      fill_in :item_amount, with: 3
      click_button "Update Discount"

      expect(page).to have_content("Discount Successfully Updated")
      expect(current_path).to eq("/merchant/discounts")

      within "#discount-#{@discount1.id}" do
        expect(page).to have_content("10% off 3 items")
        expect(page).to have_link("Edit Discount")
      end
    end

    it "Edit discount sad path with pre-populated number fields and flash errors" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
      visit "/merchant/discounts/#{@discount1.id}/edit"

      expect(find_field(:percentage).value).to eq @discount1.percentage.to_s
      expect(find_field(:item_amount).value).to eq @discount1.item_amount.to_s

      fill_in :percentage, with: ""
      fill_in :item_amount, with: 3

      click_button "Update Discount"

      expect(page).to have_content("Percentage can't be blank and Percentage is not a number")

      expect(find_field(:percentage).value).to eq nil
      expect(find_field(:item_amount).value).to eq "3"
    end
  end
end
