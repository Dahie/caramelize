module Caramelize
  module WikkaConverter
    
    # take an input stream and convert all wikka syntax to markdown syntax
    def to_markdown str
      str.gsub!(/(======)(.*?)(======)/ ) {|s| '# ' + $2 } #h1
      str.gsub!(/(=====)(.*?)(=====)/) {|s| '## ' + $2 }   #h2
      str.gsub!(/(====)(.*?)(====)/) {|s| '### ' + $2 }   #h3
      str.gsub!(/(===)(.*?)(===)/) {|s| '#### ' + $2 }   #h4
  
      str.gsub!(/(\*\*)(.*?)(\*\*)/) {|s| '**' + $2 + '**' }   #bold
      str.gsub!(/(\/\/)(.*?)(\/\/)/) {|s| '_' + $2 + '_' }   #italic
      #str.gsub!(/(===)(.*?)(===)/) {|s| '`' + $2 + '`'}   #code
      str.gsub!(/(__)(.*?)(__)/) {|s| '<u>' + $2 + '</u>'}   #underline
      
      #str.gsub!(/(.*?)(\n\t-)(.*?)/) {|s| $1 + '\n' + $3 }   #list
      
      str.gsub!(/(\t-)(.*?)/) {|s| '*' + $2 }   #list
      #str.gsub!(/(----)/) {|s| '~~~~'}   #seperator
      
      
      # TODO more syntax conversion for links and images
      
      str
    end
  end
end
