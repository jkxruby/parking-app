require 'rails_helper'

RSpec.describe Parking, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  describe '.validate_end_at_with_amount' do
    it 'is invalid without amount' do
      parking = Parking.new(parking_type: 'guest',
                            start_at: Time.now - 6.hours,
                            end_at: Time.now)
      expect(parking).to_not be_valid
    end

    it 'is invalid without end_at' do
      parking = Parking.new(parking_type: 'guest',
                            start_at: Time.now - 6.hours,
                            amount: 999)
      expect(parking).to_not be_valid
    end
  end

  # 费用测试
  describe ".calculate_amount普通／登陆会员费用 " do

     before do
       # 把每个测试都会用到的@time提取出来，这个before区块会在这个describe内的所有测试前执行
       @time = Time.new(2017, 3, 27, 8, 0 ,0) #固定一个时间比 Time.now 更好，这样每次跑测试才能确保结果一样
     end

    context 'guest' do

      before do
        # 把每个测试都用到的@parking 提取出来，这个before区块会在这个context内的所有测试前执行
        @parking = Parking.new(:parking_type => "guest", :user => @user, :start_at => @time)
      end

      it " 30 mins should be ¥2 钱不能算错" do 
      @parking.end_at = @time + 30.minutes
      @parking.calculate_amount
      expect(@parking.amount).to eq(200)
      end

      it " 60 mins should be 2块钱" do
        t = Time.now
        @parking.end_at = @time + 60.minutes
        @parking.calculate_amount
        expect( @parking.amount ).to eq(200)

      end

      it "61 mins should be ¥3(61分钟三块钱)" do
        @parking.end_at = @time + 61.minutes
        @parking.calculate_amount
        expect( @parking.amount ).to eq(300)
      end

      it " 90 mins should be 3元" do
        @parking.end_at = @time + 90.minutes
        @parking.calculate_amount
        expect( @parking.amount ).to eq(300)
      end

      it "120mins should be 4块钱" do
        @parking.end_at = @time + 120.minutes
        @parking.calculate_amount
        expect( @parking.amount ).to eq(400)

      end
    end

    context 'short-term' do

           before do
          # 把每个测试都会用到的 @user 和 @parking 提取出来
          @user = User.create( :email => "test@example.com", :password => "123455678")
          @parking = Parking.new( :parking_type => "short-term", :user => @user, :start_at => @time )
        end


      it "30 mins should be ¥2" do
        @parking.end_at = @time + 30.minutes
        @parking.calculate_amount
        expect(@parking.amount).to eq(200)

      end

      it "60 mins should be ¥2" do
        @parking.end_at = @time + 60.minutes
        @parking.calculate_amount
        expect(@parking.amount).to eq(200)
      end

      it "61 mins should be ¥2.5" do
        @parking.end_at = @time + 61.minutes
        @parking.calculate_amount
        expect(@parking.amount).to eq(250)
      end

      it "90 mins should be ¥2.5" do
        @parking.end_at = @time + 90.minutes
        @parking.calculate_amount
        expect(@parking.amount).to eq(250)

      end

      it "120 mins should be ¥3" do
        @parking.end_at = @time + 120.minutes
        @parking.calculate_amount
        expect(@parking.amount).to eq(300)

      end
    end
  end
end
