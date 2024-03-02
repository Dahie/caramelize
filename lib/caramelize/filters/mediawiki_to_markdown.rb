# frozen_string_literal: true

module Caramelize
  class MediawikiToMarkdown
    attr_reader :source_body

    def initialize(source_body)
      @source_body = source_body
    end

    def run
      replace_headlines
      replace_formatting
      replace_lists
      replace_wiki_links
      replace_links
      replace_images

      target_body
    end

    def replace_headlines
      target_body.gsub!(/(== )(.*?)( ==)/) { |_s| "# #{::Regexp.last_match(2)}" } # h1
      target_body.gsub!(/(=== )(.*?)( ===)/) { |_s| "## #{::Regexp.last_match(2)}" } # h2
      target_body.gsub!(/(==== )(.*?)( ====)/) { |_s| "### #{::Regexp.last_match(2)}" } # h3
      target_body.gsub!(/(===== )(.*?)( =====)/) { |_s| "#### #{::Regexp.last_match(2)}" } # h4
      target_body.gsub!(/(====== )(.*?)( ======)/) { |_s| "##### #{::Regexp.last_match(2)}" } # h5
    end

    def replace_formatting
      target_body.gsub!(/('')(.*?)('')/) { |_s| "**#{::Regexp.last_match(2)}**" } # bold
      target_body.gsub!(%r{(//)(.*?)(//)}, '*\2*') # italic
      target_body.gsub!(/(---)/, '  ') # forced linebreak
    end

    def replace_lists
      target_body.gsub!(/(\*\s?)(.*)/, '- \2') # unordered list
      target_body.gsub!(/(\*\*\s?)(.*)/, '    - \2') # unordered list
      target_body.gsub!(/(\*\*\*\s?)(.*)/, '       - \2') # unordered list

      target_body.gsub!(/(#\)\s?)(.*)/, '1. \2') # ordered list
      target_body.gsub!(/(##\)\s?)(.*)/, '    1. \2') # ordered list
      target_body.gsub!(/(###\)\s?)(.*)/, '        1. \2') # ordered list
    end

    def replace_wiki_links
      target_body.gsub!(/\[{2}(\w+)[\s|](.+?)\]{2}/, '[[\2|\1]]')
    end

    def replace_links
      target_body.gsub!(/\[((\w+):\S[^| ]*)[| ](.*)\]/,
                        '[\3](\1)')
      target_body.gsub!(/\[((\w+):.*)\]/, '<\1>')
    end

    def replace_images
      # {{image class="center" alt="DVD logo" title="An image link" url="images/dvdvideo.gif" link="RecentChanges"}}
      target_body.gsub!(/{{image\s(.*)}}/) do |match|
        url = match[1].gsub(/url="([^"]*)"/)
        link = match[1].gsub(/link="([^"]*)"/)
        alt = match[1].gsub(/alt="([^"]*)"/)

        return "![#{alt}](#{url})" if link.nil? || link.empty?

        "[[<img src=\"#{url}\" alt=\"#{alt}\">]]"
      end
    end

    def target_body
      @target_body ||= source_body.dup
    end
  end
end
