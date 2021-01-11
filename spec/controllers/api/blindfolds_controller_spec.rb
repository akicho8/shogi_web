require 'rails_helper'

RSpec.describe Api::BlindfoldsController, type: :controller do
  it "works" do
    get :show
    expect(response).to have_http_status(:success)
  end
end
