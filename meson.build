project('mnist-parser', 'vala', 'c',
        version: '0.1.0',
        default_options: ['buildtype=release', 'default_library=static'])


if get_option('buildtype') == 'release'
    if meson.get_compiler('c').has_argument('-march=native')
        add_global_arguments('-march=native', language: 'c')
    endif
endif

glib = dependency('glib-2.0')
gobject = dependency('gobject-2.0')
gio = dependency('gio-2.0')
math = meson.get_compiler('c').find_library('m')

optionguess = subproject('optionguess')
optionguess_dep = optionguess.get_variable('optionguess_dep')

deps = [glib, gobject, gio, math, optionguess_dep]

inc = include_directories('src')

src = [
    'src/main.vala',
    'src/mnist.vala',
    'src/mnist-images.vala',
    'src/mnist-labels.vala']

executable('mnist-parser',
    sources: src,
    dependencies: deps,
    install: true)
