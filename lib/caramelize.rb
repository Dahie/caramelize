# frozen_string_literal: true

require 'caramelize/version'
require 'caramelize/page'
require 'caramelize/content_transferer'
require 'caramelize/filter_processor'
require 'caramelize/database_connector'
require 'caramelize/health_check'
require 'caramelize/output_wiki/gollum'
require 'caramelize/services/page_builder'
require 'caramelize/input_wiki/wiki'
require 'caramelize/input_wiki/redmine_wiki'
require 'caramelize/input_wiki/wikkawiki'

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8
