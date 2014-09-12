class Saasy::BillingForm
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def action
    'http://sites.fastspring.com/copenhagenapphouse/api/order'
  end

  def method
    'POST'
  end

  def authenticity_token
    false
  end

  def params
    {
      operation: 'create',
      destination: 'checkout',
      product_1_path: '/bettersalesman',
      product_1_quantity: user.sales_reps_count,
      contact_email: user.email,
      referrer: user.id,
      language: user.locale
    }
  end
end
