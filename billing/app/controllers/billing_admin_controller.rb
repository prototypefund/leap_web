class BillingAdminController < BillingBaseController
  before_filter :authorize_admin

  def show

    br_atleast_90_days = Braintree::Subscription.search do |search|
      search.days_past_due >= 90
    end
    @past_due_atleast_90_days = braintree_resource_collection_to_array(br_atleast_90_days)

    br_all_past_due = Braintree::Subscription.search do |search|
      search.status.is Braintree::Subscription::Status::PastDue
      #cannot search by balance.
    end
    @all_past_due = braintree_resource_collection_to_array(br_all_past_due)

  end

  private

  def braintree_resource_collection_to_array(braintree_resource_collection)
    array = []
    braintree_resource_collection.each do |object|
      array << object
    end
    array
  end

end
