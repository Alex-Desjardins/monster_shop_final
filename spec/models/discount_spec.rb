require 'rails_helper'

RSpec.describe Discount do
  describe 'Relationships' do
      it { should belong_to :merchant }
  end

  describe "validations" do
      it { should validate_presence_of :discount }
      it { should validate_presence_of :amount }
      it { should validate_numericality_of :discount }
      it { should validate_numericality_of :amount }
  end
end
