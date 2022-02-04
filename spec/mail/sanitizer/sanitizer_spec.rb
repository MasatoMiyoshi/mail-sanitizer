RSpec.shared_examples_for 'sanitizing bodies' do |num|
  it 'checks sanitized bodies' do
    for i in 1..num do
      dir = "example#{i.to_s.rjust(3, '0')}"
      c_body = File.open("#{fixture_dir}/#{dir}/body.txt").read
      c_sntz = File.open("#{fixture_dir}/#{dir}/sanitized.txt").read
      c_quot = File.open("#{fixture_dir}/#{dir}/quot.txt").read
      c_sign = File.open("#{fixture_dir}/#{dir}/sign.txt").read
      s    = Mail::Sanitizer::Sanitizer.new(c_body)
      sntz = s.sanitize
      expect(sntz).to eq(c_sntz)
      expect(s.quot).to eq(c_quot)
      expect(s.sign).to eq(c_sign)
    end
  end
end

RSpec.describe Mail::Sanitizer do
  describe 'sanitize' do
    context 'when bodies include quoations' do
      let(:fixture_dir) { 'spec/fixtures/quot' }
      it_behaves_like 'sanitizing bodies', 11
    end

    context 'when bodies include signatures' do
      let(:fixture_dir) { 'spec/fixtures/sign' }
      it_behaves_like 'sanitizing bodies', 6
    end

    context 'when bodies include quotations and signatures' do
      let(:fixture_dir) { 'spec/fixtures/quot_sign' }
      it_behaves_like 'sanitizing bodies', 5
    end
  end
end
  
