require 'rails_helper'

RSpec.describe Product, type: :model do
  it "is valid with a name and a description" do
    product = Product.new(name: "Tomates", description: "Cultivées sans pesticides")
    expect(product).to be_valid
  end
  it "is invalid without a name and a description" do
    product = Product.new(name: nil, description: nil)
    expect(product).not_to be_valid
  end
  it "is invalid without a name" do
    product = Product.new(name: nil, description: "Pas de noms")
    expect(product).not_to be_valid
  end
  it "is invalid without a description" do
    product = Product.new(name: "Tomates", description: nil)
    expect(product).not_to be_valid
  end
end
