# frozen_string_literal: true

module Caramelize
  class Page
    attr_accessor :title, :body, :id, :markup, :latest, :time, :message,
                  :author, :author_name

    def initialize(page = {})
      @id =      page[:id]
      @title =   page.fetch(:title, '')
      @body =    page.fetch(:body, '')
      @syntax =  page[:markup]
      @latest =  page[:latest] || false
      @time =    page.fetch(:time, Time.now)
      @message = page.fetch(:message, '')
      @author =  page[:author]
      @author_name = page[:author_name]
    end

    def author_email
      author.email
    end

    def author_name
      author.name
    end

    def author
      @author ||= OpenStruct.new(name: @author_name || 'Caramelize',
                                 email: 'mail@example.com')
    end

    def latest?
      @latest
    end

    def path
      return @title unless @title.index('/')

      "#{title_pieces.first}/#{title_pieces.last.downcase}"
    end

    def title_pieces
      @title.split('/')
    end

    def set_latest
      @latest = true
    end

    def to_s
      @title
    end

    def commit_message
      return "Edit in page #{title}" if message.empty?

      message
    end
  end
end
