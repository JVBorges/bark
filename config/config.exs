# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :bark,
  ecto_repos: [Bark.Repo]

# Configures the endpoint
config :bark, BarkWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "OYdc+zu8/xkaPpCOVkunfYczTds2X/zxBsBRwiK/lIfh1jYs40E45JvpnN31bbcE",
  render_errors: [view: BarkWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Bark.PubSub,
  live_view: [signing_salt: "1ENT26Fy"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :waffle,
  storage: Waffle.Storage.S3,
  bucket: System.get_env("AWS_BUCKET_NAME") || "${AWS_BUCKET_NAME}"

config :ex_aws,
  json_codec: Jason,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID") || "${AWS_ACCESS_KEY_ID}",
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY") || "${AWS_SECRET_ACCESS_KEY}",
  region: System.get_env("AWS_REGION") || "${AWS_REGION}"
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
