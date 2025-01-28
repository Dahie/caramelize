# frozen_string_literal: true

require "spec_helper"

describe Caramelize::Page do
  subject(:page) do
    described_class.new(title:,
      message:,
      time: Time.parse("2015-02-12"),
      body: "Dinosaurs are awesome and have feathers!",
      author:)
  end

  let(:message) { "Dinosaurs really had feathers, do not forget!" }
  let(:author) { {name: "Jeff Goldblum", email: "jeff.g@example.com"} }
  let(:title) { "Feathered Dinosaurs" }

  describe "#author" do
    context "without author" do
      let(:author) { nil }

      it "fills with Caramelize user name" do
        expect(page.author.fetch(:name)).to eql("Caramelize")
      end

      it "fills with dummy email" do
        expect(page.author.fetch(:email)).to eql("mail@example.com")
      end
    end

    context "with author" do
      it "fills with author name" do
        expect(page.author.fetch(:name)).to eql(author[:name])
      end

      it "fills with author email" do
        expect(page.author.fetch(:email)).to eql(author[:email])
      end
    end
  end

  describe "#path" do
    context "when title is 'Home'" do
      let(:title) { "Home" }

      it { expect(page.path).to eq "Home" }
    end

    context "when title is 'Feathered Dinosaurs'" do
      it { expect(page.path).to eq "Feathered Dinosaurs" }
    end

    context "when title is 'Space/Feathered Dinosaurs'" do
      let(:title) { "Space/Feathered Dinosaurs" }

      it { expect(page.path).to eq "Space/feathered dinosaurs" }
    end
  end

  describe "#commit_message" do
    context "with page having message" do
      it "uses page.title" do
        expect(page.commit_message).to eq "Dinosaurs really had feathers, do not forget!"
      end
    end

    context "with page having no message" do
      let(:message) { "" }

      it 'creates message "Edit in page Feathered Dinosaurs"' do
        expect(page.commit_message).to eq "Edit in page Feathered Dinosaurs"
      end
    end
  end
end
