require 'spec_helper'

describe Caramelize::Service::Pagebuilder do
  describe '.build_namespace_overview' do
    let(:body) do
      "## Overview of namespaces\n\n* [[Velociraptor|velociraptors/Wiki]]  \n* [[Allosaurus|allosaurus/Wiki]]  \n"
    end
    let(:expected_page) do
      Caramelize::Page.new(title: 'Home',
                            body: body,
                            message: 'Create Namespace Overview',
                            latest: true)
    end
    let(:namespaces) do
      [
        OpenStruct.new(identifier: 'velociraptors', name: 'Velociraptor'),
        OpenStruct.new(identifier: 'allosaurus', name: 'Allosaurus')
      ]
    end

    it 'returns page with expected attributes' do
      page = described_class.build_namespace_overview
      expected(page.title).to eql(expected_page.title)
      expected(page.body).to eql(expected_page.body)
      expected(page.latest).to eql(expected_page.latest)
      expected(page.message).to eql(expected_page.message)
    end
  end
end
