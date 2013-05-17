#Encoding: UTF-8
module Caramelize
  class Trac2Markdown

    def run body
      body = body.dup
      body.gsub!(/\r/, '')
      body.gsub!(/\{\{\{([^\n]+?)\}\}\}/, '@\1@')
      body.gsub!(/\{\{\{\n#!([^\n]+?)(.+?)\}\}\}/m, '<pre><code class="\1">\2</code></pre>')
      body.gsub!(/\{\{\{(.+?)\}\}\}/m, '<pre>\1</pre>')
      # macro
      body.gsub!(/\[\[BR\]\]/, '')
      body.gsub!(/\[\[PageOutline.*\]\]/, '{{toc}}')
      body.gsub!(/\[\[Image\((.+?)\)\]\]/, '!\1!')
      # header
      body.gsub!(/=====\s(.+?)\s=====/, "== #{'\1'} ==\n\n")
      body.gsub!(/====\s(.+?)\s====/,   "=== #{'\1'} ===\n\n")
      body.gsub!(/===\s(.+?)\s===/,     "==== #{'\1'} ====\n\n")
      body.gsub!(/==\s(.+?)\s==/,       "===== #{'\1'} =====\n\n")
      body.gsub!(/=\s(.+?)\s=[\s\n]*/,  "====== #{'\1'} ======\n\n")
      # table
      body.gsub!(/\|\|/,  "|")
      # link
      body.gsub!(/\[(http[^\s\[\]]+)\s([^\[\]]+)\]/, ' "\2":\1' )
      body.gsub!(/\[([^\s]+)\s(.+)\]/, ' [[\1 | \2]] ')
      body.gsub!(/([^"\/\!])(([A-Z][a-z0-9]+){2,})/, ' \1[[\2]] ')
      body.gsub!(/\!(([A-Z][a-z0-9]+){2,})/, '\1')
      # text decoration
      body.gsub!(/'''(.+)'''/, '*\1*')
      body.gsub!(/''(.+)''/, '_\1_')
      body.gsub!(/`(.+)`/, '@\1@')
      # itemize
      body.gsub!(/^\s\s\s\*/, '***')
      body.gsub!(/^\s\s\*/, '**')
      body.gsub!(/^\s\*/, '*')
      body.gsub!(/^\s\s\s\d\./, '###')
      body.gsub!(/^\s\s\d\./, '##')
      body.gsub!(/^\s\d\./, '#')
      body
    end
  end
end