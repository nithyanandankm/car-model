require 'rails_helper'

describe PricingPolicy do
  describe 'initialize' do
    PricingPolicy::VALID_POLICY.each do |valid_policy|
      it "should allow to initialize with valid policy - #{valid_policy}" do
        pp = PricingPolicy.new(valid_policy.to_s, 12000)
        expect(pp.policy).to eq valid_policy.to_s
      end
    end

    it 'should NOT allow to initialize with an invalid policy' do
      expect { PricingPolicy.new('liquid', 12000) }.to raise_error
    end

    context 'on successful initialization' do
      before :each do
        @pp = PricingPolicy.new('fixed', 12000)
      end

      it 'should set @policy on initialization' do
        expect(@pp.policy).to eq 'fixed'
      end

      it 'should set @base_price on initialization' do
        expect(@pp.base_price).to eq 12000
      end
    end
  end

  describe 'total_price' do
    it 'should not invoke respective method when base_price is 0' do
      pp = PricingPolicy.new('fixed', 0)
      expect(pp).not_to receive(:fixed_price)
      pp.total_price
    end

    PricingPolicy::VALID_POLICY.each do |valid_policy|
      it "should invoke #{valid_policy}_price to find the total price" do
        pp = PricingPolicy.new(valid_policy.to_s, 10)
        expect(pp).to receive("#{valid_policy.to_s}_price")
        pp.total_price
      end
    end
  end

  describe 'fixed_price' do
    it 'should return calculated value' do
      allow_any_instance_of(PricingPolicy).to receive(:parsed_text).and_return('status ' * 100)
      pp = PricingPolicy.new('fixed', 100)
      expect(pp.total_price).to eq 200
    end
  end

  describe 'flexible_price' do
    it 'should return calculated value' do
      allow_any_instance_of(PricingPolicy).to receive(:parsed_text).and_return('a A ' * 50)
      pp = PricingPolicy.new('flexible', 100)
      expect(pp.total_price).to eq 100
    end
  end

  describe 'prestige_price' do
    it 'should return calculated value' do
      xml = Nokogiri::XML '<root>\
        <pubDate>Al Bundy</pubDate>\
        <character>Bud Bundy</character>\
        <pubDate>Marcy Darcy</pubDate></root>'
      allow_any_instance_of(PricingPolicy).to receive(:xml_doc).and_return(xml)
      pp = PricingPolicy.new('prestige', 100)
      expect(pp.total_price).to eq 102
    end
  end
end