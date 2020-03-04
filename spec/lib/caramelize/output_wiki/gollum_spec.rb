require 'spec_helper'

describe Caramelize::OutputWiki::Gollum do
  let(:gollum_output) { described_class.new('wiki.git') }
  before do
    allow(gollum_output).to receive(:initialize_repository).and_return true
  end

  describe '#commit_history' do
    pending
  end

  describe '#commit_namespace_overview' do
    let(:namespaces) do
      [
        OpenStruct.new(identifier: 'velociraptors', name: 'Velociraptor'),
        OpenStruct.new(identifier: 'allosaurus', name: 'Allosaurus')
      ]
    end

    context '2 pages in namespaces' do
      it 'commits page' do
        allow(gollum_output).to receive(:commit_revision)
        gollum_output.commit_namespace_overview(namespaces)
        expect(gollum_output).to have_received(:commit_revision)
      end
    end
  end

  describe '#build_commit' do
    let(:page) do
      Caramelize::Page.new( title: 'Feathered Dinosaurs',
                message: 'Dinosaurs really had feathers, do not forget!',
                time: Time.parse('2015-02-12'),
                body: 'Dinosaurs are awesome and have feathers!',
                author: OpenStruct.new(name: 'Jeff Goldblum', email: 'jeff.g@example.com') )
    end

    let(:expected_hash) do
      {
        message: 'Dinosaurs really had feathers, do not forget!',
        authored_date: Time.parse('2015-02-12'),
        committed_date: Time.parse('2015-02-12'),
        name: 'Jeff Goldblum',
        email: 'jeff.g@example.com'
      }
    end

    it 'builds commit hash' do
      expect(gollum_output.build_commit(page)).to eq expected_hash
    end

    context 'page has message' do
      it 'uses page.title' do
        expect(gollum_output.build_commit(page)[:message])
          .to eq 'Dinosaurs really had feathers, do not forget!'
      end
    end

    context 'page has no message' do
      it 'should create message "Edit in page Feathered Dinosaurs"' do
        page.message = ''
        expect(gollum_output.build_commit(page)[:message])
          .to eq 'Edit in page Feathered Dinosaurs'
      end
    end
  end
end
