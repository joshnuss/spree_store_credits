User.class_eval do
  has_many :store_credits
  
  def store_credits_total
    store_credits.active.sum(:remaining_amount)
  end
end
