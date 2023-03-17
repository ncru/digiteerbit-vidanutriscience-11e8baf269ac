class PaynamicsResponse < ApplicationRecord

  # attr_accessible :merchantid, :request_id, :response_id, :timestamp, :rebill_id, :signature, :ptype, :response_code, :response_message, :response_advise, :processor_response_id, :processor_response_authcode, :created_at, :updated_at

  def successful?
    ['GR001', 'GR002'].include?(self.response_code)
  end

  def pending?
    self.response_code == 'GR033'
  end

  def cancelled?
    self.response_code == 'GR053'
  end
end
