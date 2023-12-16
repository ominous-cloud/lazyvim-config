function bootstrap()
  local config_path = vim.fn.stdpath("config")
  local config_so = config_path .. "/lua/config.so"
  if not vim.loop.fs_stat(config_so) then
    print("config: Bootstraping...")
    vim.cmd.cd(config_path)
    local status = vim.system({"cargo", "xtask", "release"}):wait()
    if status.code == 0 then
      print("config: Done!")
    else
      print("config: Bootstrap failed")
    end
  end
end

return bootstrap
