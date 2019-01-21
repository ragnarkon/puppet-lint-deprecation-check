require 'spec_helper'

describe 'hiera_function' do
  functions = {
    'hiera'         => "lookup('my_value')",
    'hiera_array'   => "lookup('my_value', { merge => unique })",
    'hiera_hash'    => "lookup('my_value', { merge => hash })",
    'hiera_include' => "lookup('my_value', { merge => unique }).include",
  }

  let(:warn_msg) { 'function has been deprecated' }

  context 'with fix disabled' do
    functions.each_key do |function|
      context "code containing #{function}" do
        let(:code) { "#{function}('my_value')" }

        it 'should detect one problem' do
          expect(problems).to have(1).problem
        end

        it 'should create a warning' do
          expect(problems).to contain_warning("#{function} #{warn_msg}").on_line(1)
        end

        context 'with fix enabled' do
          before { PuppetLint.configuration.fix = true }
          after { PuppetLint.configuration.fix = false }

          it 'should fix one problem' do
            expect(problems).to contain_fixed(msg).on_line(1)
          end

          it "should change #{function} to lookup" do
            expect(manifest).to eq(functions[function])
          end
        end
      end
    end

    context 'code containing lookup' do
      let(:code) { "lookup('my_value')" }

      it 'should not detect a problem' do
        expect(problems).to have(0).problems
      end
    end
  end
end
