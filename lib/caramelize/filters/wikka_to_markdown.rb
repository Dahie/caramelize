# frozen_string_literal: true

module Caramelize
  class Wikka2Markdown
    attr_reader :source_body

    def initialize(source_body)
      @source_body = source_body
    end

    def run
      # TODO: images: ({{image)(url\=?)?(.*)(}})
      # markdown: ![Tux, the Linux mascot](/assets/images/tux.png)

      replace_headlines
      replace_formatting
      replace_lists
      replace_wiki_links
      replace_links
      replace_inline_code
      replace_code_block

      target_body
    end

    def replace_headlines
      target_body.gsub!(/(======)(.*?)(======)/) { |_s| "# #{::Regexp.last_match(2)}" } # h1
      target_body.gsub!(/(=====)(.*?)(=====)/) { |_s| "## #{::Regexp.last_match(2)}" } # h2
      target_body.gsub!(/(====)(.*?)(====)/) { |_s| "### #{::Regexp.last_match(2)}" } # h3
      target_body.gsub!(/(===)(.*?)(===)/) { |_s| "#### #{::Regexp.last_match(2)}" } # h4
      target_body.gsub!(/(==)(.*?)(==)/) { |_s| "##### #{::Regexp.last_match(2)}" } # h5
    end

    def replace_formatting
      target_body.gsub!(/(\*\*)(.*?)(\*\*)/) { |_s| "**#{::Regexp.last_match(2)}**" } # bold
      target_body.gsub!(%r{(//)(.*?)(//)}, '*\2*') # italic
      target_body.gsub!(/(__)(.*?)(__)/) { |_s| "<u>#{::Regexp.last_match(2)}</u>" } # underline
      target_body.gsub!(/(---)/, '  ') # forced linebreak
    end

    def replace_lists
      target_body.gsub!(/(\t-\s?)(.*)/, '- \2')    # unordered list
      target_body.gsub!(/(~-\s?)(.*)/, '- \2')     # unordered list
      target_body.gsub!(/(    -\s?)(.*)/, '- \2')     # unordered list

      target_body.gsub!(/(~1\)\s?)(.*)/, '1. \2')     # unordered list
      # TODO ordered lists
    end

    def replace_wiki_links
      target_body.gsub!(/\[{2}(\w+)[\s|](.+?)\]{2}/, '[[\2|\1]]')
    end

    def replace_links
      target_body.gsub!(/\[{2}((\w+):\S[^| ]*)[| ](.*)\]{2}/,
                        '[\3](\1)')
      target_body.gsub!(/\[{2}((\w+):.*)\]{2}/, '<\1>')
    end

    def replace_inline_code
      target_body.gsub!(/(%%)(.*?)(%%)/) { |_s| "`#{::Regexp.last_match(2)}`" } # h1
    end

    def replace_code_block
      target_body.gsub!(/^%%(\w+)\s(.*?)%%\s?/m) { "```#{::Regexp.last_match(1)}\n#{::Regexp.last_match(2)}```\n"}
      target_body.gsub!(/^%%\s(.*?)%%\s?/m) { "```\n#{::Regexp.last_match(1)}```\n"}
    end

    def target_body
      @target_body ||= source_body.dup
    end
  end
end
