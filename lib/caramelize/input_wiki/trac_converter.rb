module Caramelize
  module TracConverter
    
    # take an input stream and convert all wikka syntax to markdown syntax
    # taken from 'trac_wiki_to_textile' at 
    def to_textile str
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
      body.gsub!(/=====\s(.+?)\s=====/, "h5. #{'\1'} \n\n")
      body.gsub!(/====\s(.+?)\s====/,   "h4. #{'\1'} \n\n")
      body.gsub!(/===\s(.+?)\s===/,     "h3. #{'\1'} \n\n")
      body.gsub!(/==\s(.+?)\s==/,       "h2. #{'\1'} \n\n")
      body.gsub!(/=\s(.+?)\s=[\s\n]*/,  "h1. #{'\1'} \n\n")
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
    
    # TODO this is so far only copy of textile conversion
    # not tested!
    def to_markdown str
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
