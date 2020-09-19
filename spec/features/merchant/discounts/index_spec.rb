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

    it 'I can link to a discounts index page on merchant dashboard' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
      visit '/merchant'
      expect(page).to have_link "Discounts"
      click_link "Discounts"

      expect(current_path).to eq("/merchant/discounts")
      expect(page).to have_content("5% off 10 items")
      expect(page).to have_content("10% off 20 items")
    end

    it "Discounts are specific for each merchant" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@b_user)
      visit '/merchant'

      click_link "Discounts"

      expect(current_path).to eq("/merchant/discounts")
      expect(page).to have_content("10% off 5 items")
      expect(page).to have_content("10% off 10 items")

      expect(page).to_not have_content("5% off 10 items")
      expect(page).to_not have_content("10% off 20 items")
    end
  end
end
