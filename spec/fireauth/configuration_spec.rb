RSpec.describe Fireauth::Configuration do
  describe '.firebase_api_key' do
    it 'sets default value' do
      config = Fireauth::Configuration.new
      expect(config.firebase_api_key).to eq('')
    end
  end

  describe '.firebase_api_key=' do
    it 'changes default values' do
      config = Fireauth::Configuration.new
      config.firebase_api_key = 'test_api_key'
      expect(config.firebase_api_key).to eq('test_api_key')
    end
  end
end
