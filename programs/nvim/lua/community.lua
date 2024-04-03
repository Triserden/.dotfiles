if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.html-css"},
  { import = "astrocommunity.pack.markdown"},
  { import = "astrocommunity.pack.nix"},
  { import = "astrocommunity.pack.rust"},
  { import = "astrocommunity.pack.tailwindcss"},
  { import = "astrocommunity.pack.typescript-all-in-one"},
  { import = "astrocommunity.pack.yaml"},
  { import = "astrocommunity.colorscheme.everforest"},
  { import = "astrocommunity.colorscheme.catppcchin"},
}
  
  -- import/override with your plugins folder
}
