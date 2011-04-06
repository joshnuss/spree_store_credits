class StoreCredit < ActiveRecord::Base
  validates :amount, :presence => true, :numericality => true
  validates :reason, :presence => true
  validates :user, :presence => true
  
  belongs_to :user

  scope :active, lambda { credit_eligibility_date ? where('created_at > ?', credit_eligibility_date) : scoped }
  
  def self.credit_eligibility_date
    expiration_days = Spree::Config[:store_credits_expiration_days]
    Time.now.advance(:days => -expiration_days.to_i) if expiration_days
  end
end
