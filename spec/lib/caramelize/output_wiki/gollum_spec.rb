# frozen_string_literal: true

require 'spec_helper'

describe Caramelize::OutputWiki::Gollum do
  let(:gollum_output) { described_class.new('wiki.git') }

  before do
    allow(gollum_output).to receive(:initialize_repository).and_return true
  end

  describe '#commit_revision' do
    let(:title) { 'title' }
    let(:author) { double(name: 'Steven Universe', email: 'steven@example.com') }
    let(:input_page) do
      double(author:,
             body: 'body',
             commit_message: 'done',
             time: Time.now,
             title:,
             path: title)
    end
    let(:gollum_page) do
      double(:gollum_page,
             name: 'title',
             format: :markdown)
    end
    let(:markup) { :markdown }
    let(:gollum) { double(:gollum) }

    before do
      allow(Gollum::Wiki).to receive(:new).and_return(gollum)
    end

    context 'when page exists' do
      before do
        allow(gollum).to receive(:page).with(title).and_return(gollum_page)
      end

      it 'updates page' do
        expect(gollum).to receive(:update_page).once.and_return(true)
        gollum_output.commit_revision(input_page, markup)
      end
    end

    context 'when page does not exist yet' do
      before do
        allow(gollum).to receive(:page).with(title).and_return(nil)
      end

      it 'creates page' do
        expect(gollum).to receive(:write_page).once
        gollum_output.commit_revision(input_page, markup)
      end
    end
  end

  describe '#commit_history' do
    pending
  end

  describe '#commit_namespace_overview' do
    let(:namespaces) do
      [
        { dentifier: 'velociraptors', name: 'Velociraptor' },
        { identifier: 'allosaurus', name: 'Allosaurus' }
      ]
    end

    context 'with 2 pages in namespaces' do
      it 'commits page' do
        allow(gollum_output).to receive(:commit_revision)
        gollum_output.commit_namespace_overview(namespaces)
        expect(gollum_output).to have_received(:commit_revision)
      end
    end
  end

  describe '#build_commit' do
    let(:page) do
      Caramelize::Page.new(title: 'Feathered Dinosaurs',
                           message: 'Dinosaurs really had feathers, do not forget!',
                           time: Time.parse('2015-02-12'),
                           body: 'Dinosaurs are awesome and have feathers!',
                           author: double(name: 'Jeff Goldblum', email: 'jeff.g@example.com'))
    end

    let(:expected_hash) do
      {
        message: 'Dinosaurs really had feathers, do not forget!',
        time: Time.parse('2015-02-12'),
        name: 'Jeff Goldblum',
        email: 'jeff.g@example.com'
      }
    end

    it 'builds commit hash' do
      expect(gollum_output.build_commit(page)).to eq expected_hash
    end

    context 'when page has message' do
      it 'uses page.title' do
        expect(gollum_output.build_commit(page)[:message])
          .to eq 'Dinosaurs really had feathers, do not forget!'
      end
    end

    context 'when page has no message' do
      it 'creates message "Edit in page Feathered Dinosaurs"' do
        page.message = ''
        expect(gollum_output.build_commit(page)[:message])
          .to eq 'Edit in page Feathered Dinosaurs'
      end
    end
  end
end
