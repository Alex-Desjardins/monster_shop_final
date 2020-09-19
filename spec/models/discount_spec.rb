require 'rails_helper'

RSpec.describe Discount do
  describe 'Relationships' do
      it { should belong_to :merchant }
  end

  describe "validations" do
      it { should validate_presence_of :percentage }
      it { should validate_presence_of :item_amount }
      it { should validate_numericality_of :percentage }
      it { should validate_numericality_of :item_amount }
  end
end
