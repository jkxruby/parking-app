require 'rails_helper'

RSpec.describe Parking, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"

 describe ".validate_end_at_with_amount" do

   it "is invalid without amount" do
     parking = Parking.new( :parking_type => "guest",
                            :start_at => Time.now - 6.hours,
                            :end_at => Time.now)
      expect(parking).to_not be_valid
    end

    it "is invalid without end_at" do
      parking = Parking.new( :parking_type => "guest",
                             :start_at => Time.now - 6.hours,
                             :amount => 999)
       expect(parking).to_not be_valid
     end
   end

# 普通费用测试
  describe ".calculate_amount普通费用 " do
    it " 30 mins should be ¥2 钱不能算错" do
      t = Time.now
      parking = Parking.new(:parking_type => "guest", :start_at => t, :end_at => t + 30.minutes )
      parking.calculate_amount
      expect(parking.amount).to eq(200)
    end

     it " 60 mins should be 2块钱" do
       t = Time.now
       parking = Parking.new( :parking_type => "guest", :start_at => t, :end_at => t + 60.minutes )
       parking.calculate_amount
       expect( parking.amount ).to eq(200)
     end 

  end

end
