require 'rails_helper'

module Garrison
  RSpec.describe Keeper do
    before { Garrison.lock! ModelA, ModelC }

    let(:user) { User.create!(name: 'user') }


    describe 'check' do
      context 'enable' do
        let(:model) { ModelA.create!(name: 'user', _garrison_lock: false) }
        let(:keeper) { Keeper.new(user) }

        it 'read' do
          read = false
          keeper.read(model) { read = true }
          expect(read).to be_truthy
        end

        it 'other read' do
          read = false
          keeper.read_other(model) { read = true }
          expect(read).to be_truthy
        end

        it 'write' do
          written = false
          keeper.write(model) { written = model.save }
          expect(written).to be_truthy
        end

        it 'other write' do
          written = false
          keeper.write_other(model, true) { written = model.save }
          expect(written).to be_truthy
        end
      end
    end

    describe 'auto lock' do
      let(:model) { ModelA.create!(name: 'user', _garrison_lock: false) }
      let(:keeper) { Keeper.new(user) }
      subject { model.save }

      context 'after create' do
        it do
          expect { should }.to raise_error(Garrison::Locked)
        end
      end

      context 'after read' do
        it do
          keeper.read(model)
          expect { should }.to raise_error(Garrison::Locked)
        end
      end

      context 'after wrote' do
        it do
          keeper.write(model)
          expect { should }.to raise_error(Garrison::Locked)
        end
      end
    end
  end

  class ModelAChecker < CheckerAbstract
    def can_read?
      user.name == obj.name
    end

    def can_write?
      user.name == obj.name
    end

    def can_read_other?
      user.name == obj.name
    end

    def can_write_other?
      user.name == obj.name
    end
  end

  class ModelCChecker < CheckerAbstract
  end
end

