local env = {}
local env_file = io.open(vim.fn.stdpath 'config' .. '/.env', 'r')
if env_file then
  for line in env_file:lines() do
    local key, value = line:match '^([%w_]+)=(.+)$'
    if key then env[key] = value:match '^"(.*)"$' or value end
  end
  env_file:close()
end

return {
  sqls = {
    settings = {
      sqls = {
        connections = {
          {
            driver = env.DB_DRIVER, -- postgresql, mysql, sqlite3, mssql
            dataSourceName = string.format('host=%s port=%s user=%s password=%s dbname=%s sslmode=disable', env.DB_HOST, env.DB_PORT, env.DB_USER, env.DB_PASSWORD, env.DB_NAME),
          },
        },
      },
    },
  },
}
