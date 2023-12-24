return function()
  local config_path = vim.fn.stdpath("config")
  local so_file = config_path .. "/lua/mvim.so"
  if not vim.loop.fs_stat(so_file) then
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
