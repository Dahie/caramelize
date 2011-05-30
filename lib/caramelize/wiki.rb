class Wiki
  
  attr_accessor :revisions, :title, :description
  
  def initialize revisions
    @revisions = revisions
  end
  
  def revisions_by_title title
    # new array only containing pages by this name sorted by time
    # TODO this is probably bad for renamed pages if supported
    @revisions.reject { |revision| revision.title != title }.sort { |x,y| x.time <=> y.time }
  end
end
