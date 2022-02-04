RSpec.describe Mail::Sanitizer do
  describe 'include_email_address?' do
    it 'includes email address' do
      str = 'From (aaa@example.com) Alice wrote:'
      res = Mail::Sanitizer::String.include_email_address?(str)
      expect(res).to eq(true)
    end

    it 'does not include email address' do
      str = 'On www.example.com Alice wrote:'
      res = Mail::Sanitizer::String.include_email_address?(str)
      expect(res).to eq(false)
    end
  end

  describe 'remove_email_address' do
    it 'removes email address' do
      str = 'From (aaa@example.com) Alice wrote:'
      res = Mail::Sanitizer::String.remove_email_address(str)
      expect(res).to eq('From () Alice wrote:')
    end
  end

  describe 'replace_jp_datetime' do
    it 'replaces japanese date notation' do
      str = '2019年4月5日'
      res = Mail::Sanitizer::String.replace_jp_datetime(str)
      expect(res).to eq('2019/4/5')
    end

    it 'replaces japanese time notation' do
      str = '13時27分'
      res = Mail::Sanitizer::String.replace_jp_datetime(str)
      expect(res).to eq('13:27')
    end

    it 'replaces japanese datetime notation' do
      str = '2019年4月5日 13時27分'
      res = Mail::Sanitizer::String.replace_jp_datetime(str)
      expect(res).to eq('2019/4/5 13:27')
    end
  end
end
