module Caramelize
  module WikkaConverter
    
    # take an input stream and convert all wikka syntax to markdown syntax
    def to_markdown body
      body = body.dup
      body.gsub!(/(======)(.*?)(======)/ ) {|s| '# ' + $2 } #h1
      body.gsub!(/(=====)(.*?)(=====)/) {|s| '## ' + $2 }   #h2
      body.gsub!(/(====)(.*?)(====)/) {|s| '### ' + $2 }   #h3
      body.gsub!(/(===)(.*?)(===)/) {|s| '#### ' + $2 }   #h4
  
      body.gsub!(/(\*\*)(.*?)(\*\*)/) {|s| '**' + $2 + '**' }   #bold
      body.gsub!(/(\/\/)(.*?)(\/\/)/) {|s| '_' + $2 + '_' }   #italic
      #str.gsub!(/(===)(.*?)(===)/) {|s| '`' + $2 + '`'}   #code
      body.gsub!(/(__)(.*?)(__)/) {|s| '<u>' + $2 + '</u>'}   #underline
      
      #body.gsub!(/(.*?)(\n\t-)(.*?)/) {|s| $1 + $3 }   #list
      
      body.gsub!(/(\t-)(.*)/) {|s| '*' + $2 }   #list
      #str.gsub!(/(----)/) {|s| '~~~~'}   #seperator


      body.gsub!(/(\[\[)(\w+)\s(.+?)(\]\])/, '[[\3|\2]]')
      #body.gsub!(/\[\[(\w+)\s(.+)\]\]/, ' [[\1 | \2]] ')
      
      
      # TODO more syntax conversion for links and images
      
      body
    end
  end
end
