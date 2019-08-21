class Roda
  module RodaPlugins
    module Authenticator
      module RequestMethods
        def authenicate
          admins = YAML.load_file('config/admins.yml').split(' ')
          if admins.include? user
            yield
          else
            throw :halt, [
              401,
              { 'Content-Type' => 'text/json' },
              [
                { status: :unauthorized }.to_json
              ]
            ]
          end
        end

        private def user
          %x[whoami].strip
        end
      end
    end

    register_plugin :authenticator, Authenticator
  end
end
