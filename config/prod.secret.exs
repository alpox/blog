use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or you later on).
config :web, Web.Endpoint,
  secret_key_base: "SMU2XHYuOdUvpZ6wLefd3wMsNcQHq16R2A3i0OLUUx+DfE+rNQQ2m+FFRtS3rpjR"

# Configure your database
config :web, Web.Repo,
  adapter: Ecto.Adapters.Postgres,
  hostname: System.get_env("DB_HOST"),
  username: System.get_env("DB_USER"),
  password: System.get_env("DB_PASS"),
  pool_size: 20
