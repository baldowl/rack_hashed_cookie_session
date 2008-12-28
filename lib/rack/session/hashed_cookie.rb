require 'openssl'

module Rack
  module Session
    # Port of Action Controller's cookie-based session store (Copyright (c)
    # 2004-2008 David Heinemeier Hansson).
    #
    # Rack::Session::HashedCookie provides simple cookie based session
    # management. The session is a Ruby Hash stored as base64 encoded
    # marshalled data set to :key (default: rack.session).
    #
    # Example:
    #
    #     use Rack::Session::Cookie, :key => 'rack.session',
    #                                :domain => 'foo.com',
    #                                :path => '/',
    #                                :expire_after => 2592000,
    #                                :digest => 'SHA256',
    #                                :secret => 'my long secret string'
    #
    # All parameters but :secret are optional.

    class HashedCookie < Cookie
      # Cookies can typically store 4096 bytes.
      MAX = 4096
      SECRET_MIN_LENGTH = 30 # characters

      def initialize(app, options = {})
        @secret = options.delete(:secret)
        @digest = options.delete(:digest) || 'SHA1'
        super
        ensure_secret_secure(@secret)
      end

      private

      # To prevent users from using something insecure like "Password" we make
      # sure that the secret they've provided is at least 30 characters in
      # length.
      def ensure_secret_secure(secret)
        # There's no way we can do this check if they've provided a proc for
        # the secret.
        return true if secret.is_a?(Proc)

        if secret.nil? || secret.empty? || secret !~ /\S/
          raise ArgumentError, "A secret is required to generate an integrity hash for cookie session data"
        end

        if secret.length < SECRET_MIN_LENGTH
          raise ArgumentError, %Q(The value you provided for :secret, "#{secret}", is shorter than the minimum length of #{SECRET_MIN_LENGTH} characters)
        end
      end

      def generate_digest(data)
        key = @secret.respond_to?(:call) ? @secret.call(@session) : @secret
        OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new(@digest), key, data)
      end

      def load_session(env)
        request = Rack::Request.new(env)
        session_data = request.cookies[@key]

        begin
          session_data, digest = session_data.split('--')
          unless digest == generate_digest(session_data)
            env["rack.errors"].puts("Warning! Rack::Session::HashedCookie detected tampered data in the cookie session. Content dropped.")
            raise
          end
          session_data = session_data.unpack("m*").first
          session_data = Marshal.load(session_data)
          env["rack.session"] = session_data
        rescue
          env["rack.session"] = Hash.new
        end

        env["rack.session.options"] = @default_options.dup
      end

      def commit_session(env, status, headers, body)
        session_data = Marshal.dump(env["rack.session"])
        session_data = [session_data].pack("m*")

        digest = generate_digest(session_data)
        session_data = "#{session_data}--#{digest}"

        options = env["rack.session.options"]
        cookie = Hash.new
        if session_data.size > (MAX - @key.size)
          env["rack.errors"].puts("Warning! Rack::Session::HashedCookie data size exceeds 4K. Content dropped.")
          cookie[:value] = ""
        else
          cookie[:value] = session_data
        end
        cookie[:expires] = Time.now + options[:expire_after] unless options[:expire_after].nil?
        response = Rack::Response.new(body, status, headers)
        response.set_cookie(@key, cookie.merge(options))
        response.to_a
      end
    end
  end
end
