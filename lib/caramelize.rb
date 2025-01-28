# frozen_string_literal: true

require "caramelize/version"
require "caramelize/page"
require "caramelize/database_connector"
require "caramelize/filters/add_newline_to_page_end"
require "caramelize/filter_processor"
require "caramelize/input_wiki/wiki"
require "caramelize/input_wiki/media_wiki"
require "caramelize/input_wiki/redmine_wiki"
require "caramelize/input_wiki/wikka_wiki"
require "caramelize/content_transferer"
require "caramelize/health_check"
require "caramelize/health_checks/home_page_check"
require "caramelize/health_checks/orphaned_pages_check"
require "caramelize/health_checks/page"
require "caramelize/output_wiki/gollum"
require "caramelize/services/page_builder"

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8
