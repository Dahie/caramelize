module Caramelize
  module InputWiki
    module Phpbb3
      class HomePage < Page
        attr_reader :input_wiki

        def initialize(input_wiki)
          super(
            title: 'Home',
            markup: :markdown,
            latest: true,
            message: 'Home page listing all topics'
          )
          @input_wiki = input_wiki
        end

        def body
          body = "# Home\n\n"
          forums.each do |forum|
            body << "## #{forum['forum_name']}\n\n"

            topics.select { |t| t['forum_id'] == forum['forum_id'] }.each do |topic|
              time = format_time(topic['topic_time'])
              url = [forum['forum_name'],
                     time.year,
                     time.month,
                     parameterice(topic['topic_title'])].join('/')

              body << "* [#{time} - #{topic['topic_title']}](#{url})\n"
            end
            body << "\n"
          end
          body
        end

        private

        def forums
          input_wiki.forums.sort {|a, b| a['forum_name'] <=> b['forum_name']}
        end

        def topics
          input_wiki.topics
            .select { |t| t['topic_approved'] == 1 }
            .sort {|a, b| a['topic_time'] <=> b['topic_time']}
        end

        def posts
          input_wiki.posts
        end

        def users
          input_wiki.users
        end

        def format_time(time)
          Time.at(time)
        end

        def parameterice(string)
          string.gsub(/[\[\]]/, '-')
        end
      end
    end
  end
end
