module Caramelize
  class Wikka2Markdown

    # take an input stream and convert all wikka syntax to markdown syntax
    def run body
      body = body.dup
      body.gsub!(/(======)(.*?)(======)/ ) {|s| '# ' + $2 } #h1
      body.gsub!(/(=====)(.*?)(=====)/) {|s| '## ' + $2 }   #h2
      body.gsub!(/(====)(.*?)(====)/) {|s| '### ' + $2 }   #h3
      body.gsub!(/(===)(.*?)(===)/) {|s| '#### ' + $2 }   #h4

      body.gsub!(/(\*\*)(.*?)(\*\*)/) {|s| '**' + $2 + '**' }   #bold
      body.gsub!(/(\/\/)(.*?)(\/\/)/, '*\2*') #italic
      #str.gsub!(/(===)(.*?)(===)/) {|s| '`' + $2 + '`'}   #code
      body.gsub!(/(__)(.*?)(__)/) {|s| '<u>' + $2 + '</u>'}   #underline
      body.gsub!(/(---)/, '  ')   #forced linebreak

      #body.gsub!(/(.*?)(\n\t-)(.*?)/) {|s| $1 + $3 }   #list

      body.gsub!(/(\t-)(.*)/, '*\2')    # unordered list
      body.gsub!(/(~-)(.*)/, '*\2')     # unordered list
      body.gsub!(/(    -)(.*)/, '*\2')     # unordered list
      # TODO ordered lists

      # TODO images: ({{image)(url\=?)?(.*)(}})
      # markdown: ![Tux, the Linux mascot](/assets/images/tux.png)

      # url
      body.gsub!(/[\[]{2}((\w+):[\S][^\| ]*)[\| ](.*)[\]]{2}/,
                 '[\3](\1)')
      body.gsub!(/[\[]{2}((\w+):.*)[\]]{2}/, '<\1>')
      body.gsub!(/[\[]{2}(\w+)\s(.+?)[\]]{2}/, '[[\2|\1]]')
      #body.gsub!(/[]{2}(\w+)\s(.+)\]\]/, ' [[\1 | \2]] ')

      body
    end
  end
end
