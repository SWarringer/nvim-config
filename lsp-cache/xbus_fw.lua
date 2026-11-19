-- lsp-cache config for xbus_fw (see :help lsp-cache-config)
-- Compile DB: `lum compdb <target>` (bear inside the xbus container), then :LspCache sync
return {
  -- Generated headers to keep a copy of, so clangd resolves them after `make clean`.
  generated_include_dirs = { "build_dir/proto/proto_file_gen" },

  python = {
    version = "3.11", -- same as the xbus build container
    requirements = {
      "make/common/venv_requirements/requirements_*.txt",
      "tools/test/bacnet_sim/requirements.txt",
    },
  },

  -- The arm toolchain lives in the xbus container; copy its system headers out.
  toolchain = {
    run = { "lum", "xbus" },
    compilers = { "arm-none-eabi-gcc", "arm-none-eabi-g++" },
  },
}
