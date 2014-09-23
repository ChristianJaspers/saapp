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
    @params ||= {
      operation: 'create',
      destination: 'checkout',
      product_1_path: '/bettersalesman',
      product_1_quantity: user.sales_reps_count,
      contact_email: user.email,
      contact_fname: ' ',
      contact_lname: ' ',
      referrer: user.id,
      language: user.locale
    }
  end

  def payment_url
    "#{ email_payment_url_base }?#{ escaped_email_url_params }"
  end

  private

  def email_payment_url_base
    'https://sites.fastspring.com/copenhagenapphouse/checkout/bettersalesman'
  end

  def escaped_email_url_params
    {
      quantity: params[:product_1_quantity],
      referrer: params[:referrer],
      contact_email: CGI::escape(params[:contact_email]),
      contact_fname: CGI::escape(params[:contact_fname]),
      contact_lname: CGI::escape(params[:contact_lname]),
    }.map do |k, v|
      "#{k}=#{v}"
    end.join('&')
  end
end
