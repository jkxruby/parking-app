class Parking < ApplicationRecord
  validates_presence_of :parking_type, :start_at
  validates_inclusion_of :parking_type, in: ['guest', 'short-term', 'long-term']

  before_validation :step_amount
  validate :validate_end_at_with_amount

  belongs_to :user, :optional => true

  def validate_end_at_with_amount
  #   errors.add(:amount, "有结束时间就必须有金额") if end_at.present? && amount.blank?
  #
  #   errors.add(:end_at, "有金额必须有结束时间") if end_at.blank? && amount.present?
  # end

  # 计算停了多少分钟
  def duration
    (end_at - start_at) / 60
  end

  def setup_amount
    # 如果有开始时间和结束时间，则可以计算价格
    # if amount.blank? && start_at.present? && end_at.present?
    #
    #  total = 0
    #  if duration <= 60
    #    total = 200
    #  else
    #    total += 200
    #    left_duration = duration - 60
    #    total += ( left_duration.to_f / 30 ).ceil * 100
    #  end
    #  self.amount = total
# 除错方法
  puts "------"
  puts self.parking_type
  puts "-------"


    if self.amount.blank? && self.start_at.present? && self.end_at.present?
      if self.user.blank?
        self.amount = calculate_guest_term_amount  # 一般费率
      elsif self.parking_type == "long-term"
          self.amount = calculate_long_term_amount # 短期费率
      elsif self.parking_type == "short-term"
        self.amount = calculate_short_term_amount  # 长期费率
      end
    end
  end
end 

  def calculate_guest_term_amount
    if duration <= 60
      self.amount = 200
    else
      self.amount = 200 + ((duration - 60).to_f / 30).ceil * 100
    end
  end

def calculate_short_term_amount
 if duration <= 60
   self.amount = 200
 else
   self.amount = 200 + ((duration - 60).to_f / 30).ceil * 50
 end
end

def calculate_long_term_amount
 if duration <= 360
   self.amount = 1200
 elsif duration <= 1440 && duration > 360
   self.amount = 1600
 end


end



end
