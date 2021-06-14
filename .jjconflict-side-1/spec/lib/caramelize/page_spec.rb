require 'spec_helper'

describe Caramelize::Page do

  let(:message) { 'Dinosaurs really had feathers, do not forget!' }
  let(:author) { OpenStruct.new(name: 'Jeff Goldblum', email: 'jeff.g@example.com') }
  let(:title){ 'Feathered Dinosaurs' }
  subject(:page) do
    Caramelize::Page.new(title: title,
                message: message,
                time: Time.parse('2015-02-12'),
                body: 'Dinosaurs are awesome and have feathers!',
                author: author )
  end


  describe '#author' do
    context 'no author is set' do
      let(:author) { nil }

      it 'fills with Caramelize user' do
        expect(page.author.name).to eql('Caramelize')
        expect(page.author.email).to eql('mail@example.com')
      end
    end

    context 'author is set' do
      it 'fills with Caramelize user' do
        expect(page.author.name).to eql(author.name)
        expect(page.author.email).to eql(author.email)
      end
    end
  end

  describe '#path' do
    context "title is 'Home'" do
      let(:title) { 'Home' }
      it { expect(page.path).to eq 'Home'}
    end

    context "title is 'Feathered Dinosaurs'" do
      it { expect(page.path).to eq 'Feathered Dinosaurs'}
    end

    context "title is 'Space/Feathered Dinosaurs'" do
      let(:title) { 'Space/Feathered Dinosaurs' }
      it { expect(page.path).to eq 'Space/Feathered Dinosaurs'}
    end

    context "title is 'Space/Faring/Feathered Dinosaurs'" do
      let(:title) { 'Space/Faring/Feathered Dinosaurs' }
      it { expect(page.path).to eq 'Space/Faring/Feathered Dinosaurs'}
    end
  end


  describe '#commit_message' do
    context 'page has message' do
      it 'uses page.title' do
        expect(page.commit_message).to eq 'Dinosaurs really had feathers, do not forget!'
      end
    end

    context 'page has no message' do
      let(:message) { '' }

      it 'creates message "Edit in page Feathered Dinosaurs"' do
        expect(page.commit_message).to eq 'Edit in page Feathered Dinosaurs'
      end
    end
  end
end
