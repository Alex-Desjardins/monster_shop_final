require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Cart Discount Show Page' do
  describe 'As a Visitor' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @megan.discounts.create!(percentage: 5, item_amount: 5)
      @megan.discounts.create!(percentage: 10, item_amount: 10)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 50)
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 25)

      visit "/items/#{@giant.id}"
      click_button 'Add to Cart'

      visit "/items/#{@ogre.id}"
      click_button 'Add to Cart'

      visit '/cart'
    end

    it "I dont see discouts applied if item_amount minimum isnt met" do
      within "#item-#{@ogre.id}" do
        expect(page).to have_content('Subtotal: $20.00')
      end

      within "#item-#{@giant.id}" do
        expect(page).to have_content('Subtotal: $50.00')
      end

      expect(page).to have_content('Total: $70.00')
    end

    it 'I can see item subtotal prices and cart total price reflect applied discounts' do
      4.times do
        within "#item-#{@ogre.id}" do
          click_button 'More of This!'
        end
      end

      within "#item-#{@ogre.id}" do
        expect(page).to have_content('Subtotal(5% Discount Applied): $95.00')
      end

      within "#item-#{@giant.id}" do
        expect(page).to have_content('Subtotal: $50.00')
      end

      expect(page).to have_content('Total: $145.00')
    end

    it "Cart automatically applies greater discount to items" do
      9.times do
        within "#item-#{@ogre.id}" do
          click_button 'More of This!'
        end
      end

      within "#item-#{@ogre.id}" do
        expect(page).to have_content('Subtotal(10% Discount Applied): $180')
      end

      within "#item-#{@giant.id}" do
        expect(page).to have_content('Subtotal: $50.00')
      end

      expect(page).to have_content('Total: $230.00')
    end

    it "Cart automatically applies discount to multiple items" do
      9.times do
        within "#item-#{@ogre.id}" do
          click_button 'More of This!'
        end
      end

      within "#item-#{@ogre.id}" do
        expect(page).to have_content('Subtotal(10% Discount Applied): $180')
      end

      4.times do
        within "#item-#{@giant.id}" do
          click_button 'More of This!'
        end
      end

      within "#item-#{@giant.id}" do
        expect(page).to have_content('Subtotal(5% Discount Applied): $237.50')
      end

      expect(page).to have_content('Total: $417.50')
    end
  end
end
