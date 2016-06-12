require 'rails_helper'

module Garrison
  RSpec.describe Keeper do
    before { Garrison.lock! ModelA, ModelC }

    let(:user) { User.create!(name: 'user') }


    describe 'check' do
      context 'enable' do
        let(:model) { ModelA.create!(name: 'user', _garrison_lock: false) }
        let(:keeper) { Keeper.new(user) }

        it 'readable' do
          read = false
          keeper.read(model) { read = true }
          expect(read).to be_truthy
        end

        it 'writable' do
          written = false
          keeper.write(model) { written = model.save }
          expect(written).to be_truthy
        end
      end
    end

    describe 'auto lock after check' do
      let(:model) { ModelA.create!(name: 'user', _garrison_lock: false) }
      let(:keeper) { Keeper.new(user) }

      context 'after read' do
        it 'readable' do
          keeper.read(model) { read = true }
          expect { model.save }.to raise_error(Garrison::Locked)
        end
      end

      context 'after wrote' do
        it 'writable' do
          written = false
          keeper.write(model) { written = model.save }
          expect { model.save }.to raise_error(Garrison::Locked)
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
  end

  class ModelCChecker < CheckerAbstract
  end
end

