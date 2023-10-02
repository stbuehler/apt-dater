configure_file(
  configuration: conffile_data,
  input: 'hosts2xml.in',
  output: 'hosts2xml',
  install_dir: pkglibdir,
  install_mode: 'rwxr-xr-x', # 0755
)

install_emptydir(
  pkglibdir,
  install_mode: 'rwxr-xr-x',
)

install_data(
  [
    'cmd',
    'ssh-addonce',
    'tmux-hint',
    'pcre-less',
  ],
  install_dir: pkglibdir,
  install_mode: 'rwxr-xr-x',
)

install_data(
  [
    'adsh',
  ],
  install_dir: get_option('prefix') / get_option('bindir'),
  install_mode: 'rwxr-xr-x',
)
