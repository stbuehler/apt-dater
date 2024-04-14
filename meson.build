project(
  'apt-dater',
  'c',
  default_options: [
    'buildtype=debugoptimized',
    'c_std=c99', # gnu99?
    'b_ndebug=if-release',
  ],
  version: '1.0.4',
  license: 'GPL-2.1-or-later',
  # license_files: ['COPYING'], # requires meson 1.1
)
bugreport = 'apt-dater@ibh.de'

i18n = import('i18n')

compiler = meson.get_compiler('c')

dep_gthread = dependency('glib-2.0', version: '>=2.3.6')
dep_gmodule = dependency('gio-2.0', version: '>=2.15')
dep_xml = dependency('libxml-2.0')
dep_ncursesw = dependency('ncursesw')
dep_popt = dependency('popt')

pkglibdir = get_option('prefix') / get_option('libdir') / meson.project_name()
sysconfdir = get_option('prefix') / get_option('sysconfdir')
pkgetcdir = sysconfdir / meson.project_name()
localstatedir = get_option('localstatedir')

xmlschemadir = get_option('xmlschemadir')
if xmlschemadir == ''
  xmlschemadir = get_option('prefix') / get_option('datadir') / 'xml' / 'schema' / meson.project_name()
endif

date_exe = find_program('date', native: true)
source_date_epoch = run_command('sh', '-c', 'echo $SOURCE_DATE_EPOCH', check: false).stdout().strip()
if source_date_epoch == ''
  source_date_epoch = run_command(date_exe, '+%s', check: false).stdout().strip()
endif

pymod = import('python')
python_exe = pymod.find_installation('python3')
blob_to_c_inc = files('build/blob_to_c_inc.py')

formatted_date = run_command(
  date_exe, '-u', '-d', '@' + source_date_epoch,
  check: false,
  env: ['LC_ALL=C'],
).stdout().strip()
if formatted_date == ''
  formatted_date = run_command(
    date_exe, '-u', '-r', source_date_epoch,
    check: true,
    env: ['LC_ALL=C'],
  ).stdout().strip()
endif

conffile_data = configuration_data()
conffile_data.set('localstatedir', localstatedir)
conffile_data.set('sysconfdir', sysconfdir)

configuration = configuration_data()
configuration.set_quoted('PACKAGE', meson.project_name())
configuration.set_quoted('PACKAGE_STRING', meson.project_name() + ' ' + meson.project_version())
configuration.set_quoted('PACKAGE_BUGREPORT', bugreport)
configuration.set_quoted('SOURCE_DATE_UTC', formatted_date)
configuration.set_quoted('PKGLIBDIR', pkglibdir)
configuration.set_quoted('sysconfdir', sysconfdir)
configuration.set_quoted('XML_SCHEMA_DIR', xmlschemadir)

# always on.. should probably remove the checks
configuration.set('HAVE_COLOR', 1)
configuration.set('HAVE_USE_DEFAULT_COLORS', 1)
configuration.set('HAVE_FLOCK', 1)

configuration.set('HAVE_GETTEXT', 1)

# currently only looking for ncurses
configuration.set('HAVE_NCURSES_H', 1)

if compiler.has_header('locale.h')
  configuration.set('HAVE_LOCALE_H', 1)
endif

if get_option('xmlreport')
  configuration.set('FEAT_XMLREPORT', 1)
endif
if get_option('autorefresh')
  configuration.set('FEAT_AUTOREF', 1)
endif
if get_option('history')
  configuration.set_quoted('ENV_BINARY', find_program('env', native: false).full_path())
  configuration.set('FEAT_HISTORY', 1)
endif
if get_option('clusters')
  configuration.set('FEAT_CLUSTERS', 1)
endif
if get_option('runcust')
  configuration.set('FEAT_RUNCUST', 1)
endif

dep_tcl = dependency(
  'tcl',
  version: '>=8.0',
  required: get_option('tclfilter'),
)
if dep_tcl.found()
  configuration.set('FEAT_TCLFILTER', 1)
endif

ssh_exe = find_program('ssh', native: false, required: false)
if ssh_exe.found()
  configuration.set_quoted('SSH_BINARY', ssh_exe.full_path())
else
  configuration.set_quoted('SSH_BINARY', 'ssh')
endif

sftp_exe = find_program('sftp', native: false, required: false)
if sftp_exe.found()
  configuration.set_quoted('SFTP_BINARY', sftp_exe.full_path())
else
  configuration.set_quoted('SFTP_BINARY', 'sftp')
endif

if get_option('ttymux') == 'screen'
  screen_exe = find_program('screen', native: false)
  configuration.set_quoted('SCREEN_BINARY', screen_exe.full_path())
  configuration.set_quoted('SCREEN_SOCKPATH', '/var/run/screen')
else
  configuration.set('FEAT_TMUX', 1)
  tmux_exe = find_program('tmux', native: false)
  configuration.set_quoted('TMUX_BINARY', tmux_exe.full_path())
endif

subdir('conf')
subdir('lib')
subdir('etc')
subdir('man')
subdir('po')
subdir('schema')
subdir('src')

summary(
  {
    'pkglibdir': pkglibdir,
    'sysconfdir': sysconfdir,
    'xmlschemadir': xmlschemadir,
    'localstatedir': localstatedir,
  },
  section: 'Directories',
)

path_summary = {}
path_names = [
  'ENV_BINARY',
  'SCREEN_BINARY',
  'SCREEN_SOCKPATH',
  'TMUX_BINARY',
]
foreach name: path_names
  if configuration.has(name)
    path_summary += { name: configuration.get(name) }
  endif
endforeach

summary(
  path_summary,
  section: 'Paths',
)

summary(
  {
    'docs': get_option('docs'),
    'ttymux': get_option('ttymux'),
    'xmlreport': get_option('xmlreport'),
    'autorefresh': get_option('autorefresh'),
    'history': get_option('history'),
    'clusters': get_option('clusters'),
    'runcust': get_option('runcust'),
    'tclfilter': get_option('tclfilter'),
  },
  section: 'Features',
)
