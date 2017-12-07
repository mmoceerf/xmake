-- project
set_project("xmake")

-- version
set_version("2.1.8", {build = "%Y%m%d%H%M"})

-- set xmake min version
set_xmakever("2.1.8")

-- set warning all as error
set_warnings("all", "error")

-- set language: c99, c++11
set_languages("c99", "cxx11")

-- disable some compiler errors
add_cxflags("-Wno-error=deprecated-declarations", "-fno-strict-aliasing", "-Wno-error=nullability-completeness")

-- add defines
add_defines("_GNU_SOURCE=1", "_FILE_OFFSET_BITS=64", "_LARGEFILE_SOURCE")

-- set the symbols visibility: hidden
set_symbols("hidden")

-- strip all symbols
set_strip("all")

-- fomit the frame pointer
add_cxflags("-fomit-frame-pointer")

-- for the windows platform (msvc)
if is_plat("windows") then 
    add_cxflags("-MT") 
    add_ldflags("-nodefaultlib:\"msvcrt.lib\"")
    add_links("kernel32", "user32", "gdi32")
end

-- for mode coverage
if is_mode("coverage") then
    add_ldflags("-coverage", "-fprofile-arcs", "-ftest-coverage")
end

-- the readline option
option("readline")
    add_links("readline")
    add_cincludes("readline/readline.h")
    add_cfuncs("readline")
    add_defines("XM_CONFIG_API_HAVE_READLINE")
option_end()

-- the curses option
option("curses")
    add_links("curses")
    if is_plat("linux") then
        add_links("tinfo")
    end
    add_cincludes("curses.h")
    add_defines("XM_CONFIG_API_HAVE_CURSES")
option_end()

-- add projects
includes("src/lcurses", "src/sv","src/luajit", "src/tbox", "src/xmake", "src/demo") 
if is_plat("windows") then
    includes("src/pdcurses")
end
