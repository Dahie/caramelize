# frozen_string_literal: true

require "spec_helper"

describe Caramelize::Services::PageBuilder do
  describe ".build_namespace_overview" do
    subject(:page) { described_class.build_namespace_overview(namespaces) }

    let(:body) do
      "## Overview of namespaces\n  \n* [[Velociraptor|velociraptors/wiki]]  \n* [[Allosaurus|allosaurus/wiki]]"
    end
    let(:expected_page) do
      Caramelize::Page.new(title: "Home",
        body:,
        message: "Create Namespace Overview",
        latest: true)
    end
    let(:namespaces) do
      [
        {identifier: "velociraptors", name: "Velociraptor"},
        {identifier: "allosaurus", name: "Allosaurus"}
      ]
    end

    it "returns page with expected title" do
      expect(page.title).to eql(expected_page.title)
    end

    it "returns page with expected page body" do
      expect(page.body).to eql(expected_page.body)
    end

    it "returns page with expected page latest" do
      expect(page.latest).to eql(expected_page.latest)
    end

    it "returns page with expected message" do
      expect(page.message).to eql(expected_page.message)
    end
  end
end
