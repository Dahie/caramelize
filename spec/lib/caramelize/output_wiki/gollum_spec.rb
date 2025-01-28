# frozen_string_literal: true

require "spec_helper"

describe Caramelize::OutputWiki::Gollum do
  let(:gollum_output) { described_class.new("wiki.git") }

  before do
    allow(gollum_output).to receive(:initialize_repository).and_return true
  end

  describe "#commit_revision" do
    subject(:gollum) { double(:gollum) } # rubocop:todo RSpec/VerifiedDoubles

    let(:title) { "title" }
    let(:author) { {name: "Steven Universe", email: "steven@example.com"} }
    let(:input_page) do
      Caramelize::Page.new(author:,
        body: "body",
        commit_message: "done",
        time: Time.now,
        title:,
        path: title)
    end
    let(:gollum_page) { double(:gollum_page, name: "title", format: :markdown) } # rubocop:todo RSpec/VerifiedDoubles

    before do
      allow(Gollum::Wiki).to receive(:new).and_return(gollum)
    end

    context "when page exists" do
      before do
        allow(gollum).to receive(:page).with(title).and_return(gollum_page) # rubocop:todo RSpec/SubjectStub
      end

      it "updates page" do
        # rubocop:todo RSpec/SubjectStub
        expect(gollum).to receive(:update_page).once.and_return(true) # rubocop:todo RSpec/MessageSpies, RSpec/SubjectStub
        # rubocop:enable RSpec/SubjectStub
        gollum_output.commit_revision(input_page, :markdown)
      end
    end

    context "when page does not exist yet" do
      before do
        allow(gollum).to receive(:page).with(title).and_return(nil) # rubocop:todo RSpec/SubjectStub
      end

      it "creates page" do
        allow(gollum).to receive(:write_page) # rubocop:todo RSpec/SubjectStub
        gollum_output.commit_revision(input_page, :markdown)
        expect(gollum).to have_received(:write_page).once # rubocop:todo RSpec/SubjectStub
      end
    end
  end

  describe "#commit_history" do
    pending("test full history")
  end

  describe "#commit_namespace_overview" do
    let(:namespaces) do
      [
        {dentifier: "velociraptors", name: "Velociraptor"},
        {identifier: "allosaurus", name: "Allosaurus"}
      ]
    end

    context "with 2 pages in namespaces" do
      it "commits page" do
        allow(gollum_output).to receive(:commit_revision)
        gollum_output.commit_namespace_overview(namespaces)
        expect(gollum_output).to have_received(:commit_revision)
      end
    end
  end

  describe "#build_commit" do
    let(:page) do
      Caramelize::Page.new(title: "Feathered Dinosaurs",
        message: "Dinosaurs really had feathers, do not forget!",
        time: Time.parse("2015-02-12"),
        body: "Dinosaurs are awesome and have feathers!",
        author: {name: "Jeff Goldblum", email: "jeff.g@example.com"})
    end

    let(:expected_hash) do
      {
        message: "Dinosaurs really had feathers, do not forget!",
        time: Time.parse("2015-02-12"),
        name: "Jeff Goldblum",
        email: "jeff.g@example.com"
      }
    end

    it "builds commit hash" do
      expect(gollum_output.build_commit(page)).to eq expected_hash
    end

    context "when page has message" do
      it "uses page.title" do
        expect(gollum_output.build_commit(page)[:message])
          .to eq "Dinosaurs really had feathers, do not forget!"
      end
    end

    context "when page has no message" do
      it 'creates message "Edit in page Feathered Dinosaurs"' do
        page.message = ""
        expect(gollum_output.build_commit(page)[:message])
          .to eq "Edit in page Feathered Dinosaurs"
      end
    end
  end
end
