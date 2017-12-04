-- add target
target("lcurses")

    -- make as a static library
    set_kind("static")

    -- add deps
    add_deps("luajit")
    if is_plat("windows") then
        add_deps("pdcurses")
    end

    -- set the object files directory
    set_objectdir("$(buildir)/.objs")

    -- add includes directory
    add_includedirs("$(buildir)/luajit")

    -- add the common source files
    add_files("*.c") 
  
    -- add options
    if is_plat("windows") then
        add_defines("PDCURSES", "XM_CONFIG_API_HAVE_CURSES")
        add_includedirs("../pdcurses")
    else
        add_options("curses")
    end
