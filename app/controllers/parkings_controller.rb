class ParkingsController < ApplicationController
  # setp1 : 显示开始停车的表单
  def new
    @parking = Parking.new
  end

  # step2: 新建一笔停车，并记录开始时间
  def create
    @parking = Parking.new(start_at: Time.now)
    # 有登陆的话，根据用户设定费用，没有登陆，按过客收费
    if current_user
      @parking.parking_type = params[:parking][:parking_type]
      @parking.user = current_user
    else
      @parking.parking_type  = "guest"
    end

    @parking.save!
    redirect_to parking_path(@parking)
  end

  # step3: 如果还没结束，显示结束停车的表单
  # step5: 如何已经结束，显示停车费用
  def show
    @parking = Parking.find(params[:id])
  end

  # step4: 结束一笔停车，记录时间并计费
  def update
    @parking = Parking.find(params[:id])
    @parking.end_at = Time.now
    #@parking.calculate_amount

    @parking.save!
    redirect_to parking_path
  end
end
