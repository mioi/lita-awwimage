require 'lita'

module Lita
  module Handlers
    class Awwimage < Handler
      route(/\b(pug|corgi|shiba|cat|giraffe) me\b/i, :single, command: true, help: { "[pug|corgi|shiba|cat|giraffe] me" => "Display a single animal pic" })
      route(/\b(pug|corgi|shiba|cat|giraffe) ?bomb( (\d+))?/i, :bomb, command: true, help: { "[pug|corgi|shiba|cat|giraffe] bomb" => "Display five animals", "[pug|corgi|shiba|cat|giraffe] bomb N" => "Display N animals" })

      BASE_URL = "http://awwimage.herokuapp.com"

      def single(response)
        animal = response.matches[0][0]
        data = MultiJson.load(http.get(BASE_URL + "/random/" + animal).body)
        response.reply data['url']
      end

      def bomb(response)
        animal = response.matches[0][0]
        count = response.matches[0][2] || 5
        data = MultiJson.load(http.get(BASE_URL + "/bomb/" + animal, ":number": count).body)
        data['urls'].each do |url|
          response.reply url
        end
      end
    end
    Lita.register_handler(Awwimage)
  end
end
