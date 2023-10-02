if get_option('ttymux') == 'screen'
  ttymux_src = ['screen.h', 'screen.c', conf_generated.get('screenrc.inc')]
else
  ttymux_src = ['tmux.h', 'tmux.c', conf_generated.get('tmux.conf.inc')]
endif
if get_option('runcust')
  runcust_src = ['runcust.h', 'runcust.c']
else
  runcust_src = []
endif

config_h = configure_file(
  configuration: configuration,
  output: 'config.h',
)

shared_src = [
  conf_generated.get('apt-dater.xml.inc'),
  conf_generated.get('hosts.xml.inc'),
  '../include/adproto.h',
  'apt-dater.c',
  'apt-dater.h',
  'colors.c',
  'colors.h',
  'completion.c',
  'completion.h',
  'exec.c',
  'exec.h',
  'extern.h',
  'keyfiles.c',
  'keyfiles.h',
  'lock.c',
  'lock.h',
  'parsecmd.c',
  'parsecmd.h',
  'report.c',
  'report.h',
  'sighandler.c',
  'sighandler.h',
  'stats.c',
  'stats.h',
  'ui.c',
  'ui.h',
  'autoref.c',
  'autoref.h',
  'tag.c',
  'tag.h',
  'history.c',
  'history.h',
  'env.c',
  'env.h',
  'clusters.c',
  'clusters.h',
  'glue.c',
  'glue.h',
  'ttymux.c',
  'ttymux.h',
] + ttymux_src + runcust_src

add_project_arguments('-DHAVE_CONFIG_H', language : 'c')

deps = [
  dep_gthread,
  dep_gmodule,
  dep_xml,
  dep_tcl,
  dep_ncursesw,
  dep_popt,
]


shared_lib = static_library(
  'shared',
  shared_src,
  dependencies: deps,
)

executable(
  'apt-dater',
  ['main.c'],
  link_with: shared_lib,
  dependencies: deps,
)

executable(
  'adsh',
  ['adsh.c'],
  link_with: shared_lib,
  dependencies: deps,
)
