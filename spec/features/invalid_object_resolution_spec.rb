require 'spec_helper'

describe 'Invalid object resolution' do
  include_context 'irr queries'

  describe 'Try as-jpnic with JPIRR' do
    context 'When invalid object specified' do
      subject { send_query(irr, 'INVALID') }

      it 'reports an error' do
        expect { subject }.to raise_error
      end
    end

    context 'When a blank String given for IRR object to resolve' do
      subject { send_query(irr, '') }

      it 'reports an error' do
        expect { subject }.to raise_error
      end
    end

    context 'When nil given for IRR object to resolve' do
      subject { send_query(irr, nil) }

      it 'does nothing even reporting the error' do
        expect_any_instance_of(Irrc::Irrd::Client).not_to receive(:connect)
        expect(subject).to eq({})
      end
    end
  end
end
