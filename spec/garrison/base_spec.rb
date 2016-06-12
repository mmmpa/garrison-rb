require 'rails_helper'

RSpec.describe Garrison do
  before { Garrison.lock! ModelA, ModelC }

  describe 'define methods' do
    context 'target class' do
      subject { ModelA.method_defined? :lock_garrison_lock }
      it { should be_truthy }
    end

    context 'not target class' do
      subject { ModelB.method_defined? :lock_garrison_lock }
      it { should be_truthy }
    end
  end

  describe 'lock automatically' do
    context 'target class' do
      describe 'locked' do
        let(:model) { ModelA.new(name: 'user') }
        subject { model.garrison_locked? }
        it { should be_truthy }
      end

      describe 'save' do
        let(:model) { ModelA.new(name: 'user') }
        subject { model.save }
        it { expect { should }.to raise_error(Garrison::Locked) }
      end
    end

    context 'not target class' do
      describe 'locked' do
        let(:model) { ModelB.create!(name: 'user', _garrison_lock: false) }
        subject { model.garrison_locked? }
        it { should be_falsey }
      end

      describe 'save' do
        let(:model) { ModelB.create!(name: 'user', _garrison_lock: false) }
        subject { model.save }
        it { should be_truthy }
      end
    end
  end

  describe 'unlock' do
    context 'target class' do
      let(:model) { ModelA.create!(name: 'user', _garrison_lock: false) }
      subject { model.save }
      before { model.unlock_garrison_lock }
      it { should be_truthy }
    end
  end
end
