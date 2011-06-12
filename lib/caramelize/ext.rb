require 'gollum'

module Gollum
  class Committer
    def commit
      @options[:parents] = parents
      @options[:actor] = actor
      @options[:last_tree] = nil
      @options[:head] = @wiki.ref
      sha1 = index.commit(@options[:message], @options)
      @callbacks.each do |cb|
        cb.call(self, sha1)
      end
      sha1
    end
  end
end