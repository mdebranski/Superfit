SESSION_EXPIRATION_SECONDS = 3600 * 4 # four hours

# Be sure to restart your server when you modify this file.
if Rails.env.production?
  redis_uri = URI.parse(ENV["REDIS_URL"])
  Superfit::Application.config.session_store :redis_store, expire_in: SESSION_EXPIRATION_SECONDS, servers: {:host => redis_uri.host, :port => redis_uri.port, :password => redis_uri.password, :db => 0, namespace: 'session'}
else
  Superfit::Application.config.session_store :redis_store, expire_in: SESSION_EXPIRATION_SECONDS, servers: {namespace: 'session'}
end
