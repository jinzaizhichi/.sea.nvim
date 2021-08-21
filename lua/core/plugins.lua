local plugins_configure = {}

plugins_configure.plugins_groups = {}
--let g:vimwiki_map_prefix='<leader>o'
plugins_configure.plugin_configure_root = 'configure.'
plugins_configure["all_loaded_module"] = {}

if FEATURE_GROUPS['default'] == true then
    plugins_configure.plugins_groups['default'] = {
        ["nerd_commenter"] = {disable=false},       -- for quick comment
        ["ultisnips"] = {disable=false},            -- for snippets
        ["snippets"] = {disable=false},             -- predefined snippets templete
        ['linediff'] = {disable=false},             -- diff view for two lines
        ['multiple_cursor'] = {disable=false},      --  multiple cursor to change multi line in the same time
        ['undotree'] = {disable=false},             -- record all the change history
        ['repeat'] = {disable=false},               -- repeat some user defined commond
        ['surround'] = {disable=false},             -- change, make or delete the surrounding
        ['emacs_commandline'] = {disable=false},    -- use emacs key binding in commondline
        ['auto_pairs'] = {disable=false},           -- auto complete pairs
        ['bbye'] = {disable=false},                 -- when you close the buffer the window could be reserve
        ['indent_line'] = {disable=false},          -- display the indent line
        ['better_fold'] = {disable=false},          -- display better fold
        ['which_key'] = {disable=false, opt=false},             -- key binding suggestion
        ['asynctasks'] = {disable=false},             -- key binding suggestion
    }
end

if FEATURE_GROUPS['coc_complete'] == true then
    plugins_configure.plugins_groups['coc_complete'] = {
        ['coc'] = {disable=false},
    }
end

plugins_configure.plugins_groups['org_my_life'] = {
    ['calendar'] = {disable=false},
    ['vimwiki'] = {disable=false},
    ['table_mode'] = {disable=false},
    ['md_bullets'] = {disable=false},
    ['org_bullets'] = {disable=false},
    ['orgmode'] = {disable=false},
}

plugins_configure.plugins_groups['git'] = {
    ['gitsigns'] = {disable=false},
    ['fugitive'] = {disable=false},
}

plugins_configure.plugins_groups['enhance'] = {
    --['hlslens'] = {disable=false}, -- TODO: neovim 0.6 +
    ['todo_comments'] = {disable=false},
    ['zen_mode'] = {disable=false},
    ['ts_text_object'] = {disable=false},
    ['speed_date'] = {disable=false},
    ['translate'] = {disable=false},
    ['notify'] = {disable=false},
    --['high_str'] = {disable=true},
    ['colorizer'] = {disable=false},
}

-- main language
plugins_configure.plugins_groups['special_for_language'] = {
    ['python_fold'] = {disable=true},
    ['markdown_preview'] = {disable=false},
}

plugins_configure.plugins_groups['debug_adapter'] = {
    --['dap'] = {disable=false},
    ['dap_python'] = {disable=false},
    ['dap_ui'] = {disable=false}
}

if FEATURE_GROUPS['buildin_complete'] == true then
    plugins_configure.plugins_groups['coc_complete'] = {
        ["lsp_config"] = {disable=false},
        ["nvim_comp"] = {disable=false},
        ['lsp_icon'] = {disable=false},
        ['lsp_installer'] = {disable=false},
        ['fold_expr'] = {disable=false},
    }
end

if FEATURE_GROUPS['colorschemes'] == true then
    plugins_configure.plugins_groups['colorschemes'] = {
        ["nord"] = {disable=false, opt=true},
        ["github_nvim_theme"] = {disable=false, opt=true},
        ['gruvbox_material'] = {disable=false, opt=true},
        ['rose_pine'] = {disable=false, opt=true}
    }
end


if FEATURE_GROUPS['beauty_vim'] == true then
    plugins_configure.plugins_groups['beauty_vim'] = {
        ["lualine"] = {disable=false},
        ["bufferline"] = {disable=false},
        ["dashboard"] = {disable=false},
    }
end

if FEATURE_GROUPS['file_and_view'] == true then
    if FEATURE_GROUPS['coc_complete'] == true then
        plugins_configure.plugins_groups['file_and_view'] = {
            ['tree_sitter'] = {disable=false},
            ["telescope"] = {disable=false},
            ["files_tree"] = {disable=false},
            ["vista"] = {disable=false},
            ["navigator"] = {disable=true},     -- TODO: this plugin will be useful, but too beta
            ['ctrlsf'] = {disable=false},               -- search the same token under cursor
            ['spectre'] = {disable=false},               -- search the and replace token by reg exp
        }
    end
    if FEATURE_GROUPS['buildin_complete'] == true then
        plugins_configure.plugins_groups['file_and_view'] = {
            ['tree_sitter'] = {disable=false},
            ["telescope"] = {disable=false},
            ["files_tree"] = {disable=false},
            ["file_symbols"] = {disable=false},
            ["navigator"] = {disable=true},     -- TODO: this plugin will be useful, but too beta
            ['ctrlsf'] = {disable=false},               -- search the same token under cursor
            ['spectre'] = {disable=false},               -- search the and replace token by reg exp
        }
    end
end

if FEATURE_GROUPS['move_behavior'] == true then
    plugins_configure.plugins_groups['move_behavior'] = {
        ["accelerate_jk"] = {disable=false},
        ["scroll"] = {disable=false},
    }
end

plugins_configure.setup = function()
    packer.startup(function()
        for group_name, plugins_group in pairs(plugins_configure.plugins_groups) do
            if FEATURE_GROUPS[group_name] == nil then
                print(group_name.." is not in FEATURE_GROUPS")
            elseif FEATURE_GROUPS[group_name] == true then
                for plugin_name, is_active in pairs(plugins_group) do
                    core = require(plugins_configure.plugin_configure_root..plugin_name).core
                    for key, value in pairs(is_active) do
                        core[key] = value
                    end
                    if core.disable == false then
                        plugins_configure.all_loaded_module[plugin_name] = true-- added to all_loaded_module
                    end
                    use(core)
                    --print(core[1]..' is loaded')
                end
            end
        end
    end
    )
end

plugins_configure.create_mapping = function()
    for group_name, plugins_group in pairs(plugins_configure.plugins_groups) do
        --print(group_name)
        if FEATURE_GROUPS[group_name] == true then
            for plugin_name, is_active in pairs(plugins_group) do
                if is_active['disable'] == false then
                    --print(plugin_name)
                    require(plugins_configure.plugin_configure_root..plugin_name).mapping()
                end
            end
        end
    end
end
return plugins_configure
