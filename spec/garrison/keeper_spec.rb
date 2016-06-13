require 'rails_helper'

module Garrison
  RSpec.describe Keeper do
    before { Garrison.lock! ModelA, ModelC }
    let(:user) { User.create!(name: 'user') }

    describe 'check' do
      context 'enable' do
        let(:model) { ModelA.create!(name: 'user', garrison_locked: false) }
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
          keeper.write_other(model, writable: true) { written = model.save }
          expect(written).to be_truthy
        end
      end

      context 'disable' do
        let(:model) { ModelC.create!(name: 'user', garrison_locked: false) }
        let(:keeper) { Keeper.new(user) }

        it 'read' do
          expect {
            keeper.read(model)
          }.to raise_error(Garrison::Forbidden)
        end

        it 'write' do
          expect {
            keeper.write(model)
          }.to raise_error(Garrison::Forbidden)
        end
      end

      context 'return result' do
        let(:model) { ModelA.create!(name: 'user', garrison_locked: false) }
        let(:keeper) { Keeper.new(user) }

        it 'read' do
          result = keeper.read(model) do
            model.name
            :abc
          end

          expect(result).to eq(:abc)
        end

        it 'write' do
          result = keeper.write(model) do
            model.save
            :abc
          end

          expect(result).to eq(:abc)
        end
      end
    end

    describe 'auto lock' do
      let(:model) { ModelA.create!(name: 'user', garrison_locked: false) }
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

    describe 'direct chain' do
      context 'return result' do
        let(:model) { DirectObject.new }
        let(:keeper) { Keeper.new(user) }

        it { expect(keeper.(model, :run)).to eq(:run) }
        it { expect(keeper.(model, :run_with_arg, 'a', 'b', 'c')).to eq('abc') }
        it { expect(keeper.(model, :run_with_block) { 'abc' }).to eq('abc') }
        it { expect { keeper.(model, :run_disable) }.to raise_error(Garrison::Forbidden) }
      end

      describe 'lock unlock' do
        context 'enable' do
          let(:model) { ModelA.create!(name: 'user', garrison_locked: false) }
          let(:keeper) { Keeper.new(user) }

          it { expect(keeper.(model, :save)).to be(true) }
        end

        context 'disable' do
          let(:model) { ModelC.create!(name: 'user', garrison_locked: false) }
          let(:keeper) { Keeper.new(user) }

          it { expect { keeper.(model, :save) }.to raise_error(Garrison::Forbidden) }
        end
      end
    end
  end
end

class DirectObject
  def run
    :run
  end

  def run_with_arg(a, b, c)
    [a, b, c].join
  end

  def run_with_block(&block)
    yield
  end

  def run_disable
    true
  end
end

class DirectObjectChecker < Garrison::CheckerAbstract
  def can_run?
    !!user && !!obj
  end

  def can_run_with_arg?
    !!user && !!obj
  end

  def can_run_with_block?
    !!user && !!obj
  end

  def can_run_disable?
    false
  end
end

class ModelAChecker < Garrison::CheckerAbstract
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

  def can_write_disabled?
    user.name != obj.name
  end

  def can_save?
    user.name == obj.name
  end
end

class ModelCChecker < Garrison::CheckerAbstract
  def can_read?
    false
  end

  def can_write?
    false
  end
end
