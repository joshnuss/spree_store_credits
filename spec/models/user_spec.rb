require 'spec_helper'

describe User do
  let(:user) { User.create(:email => "foo@bar.com", :password => "secret", :password_confirmation => "secret") }

  context "store_credits_total" do
    before do
      user.store_credits.create(:amount => 100, :remaining_amount => 100, :reason => "A")
      user.store_credits.create(:amount => 60,  :remaining_amount => 55,  :reason => "B")
    end

    specify { user.store_credits_total.should == 155.00 }
    specify { user.store_credits.active.should have(2).store_credits }

    context "expired" do
      before do
        Spree::Config.set :store_credits_expiration_days => 10
        user.store_credits.create(:amount => 60, :remaining_amount => 55, :reason => "expired", :created_at => Time.now.advance(:days => -11))
      end

      specify { user.store_credits_total.should == 155.00 }
      specify { user.store_credits.active.should have(2).store_credits }
    end
  end
end
