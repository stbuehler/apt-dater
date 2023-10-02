foreach target: ['apt-dater.xml', 'hosts.xml']
  src = target + '.in'
  configure_file(
    configuration: conffile_data,
    input: src,
    output: target,
    install_dir: pkgetcdir,
    install_mode: 'rw-r-----', # 0640
  )
endforeach

etc_dirs = [
  pkgetcdir,
  pkgetcdir / 'pre-con.d',
  pkgetcdir / 'post-con.d',
  pkgetcdir / 'pre-ins.d',
  pkgetcdir / 'post-ins.d',
  pkgetcdir / 'pre-ref.d',
  pkgetcdir / 'post-ref.d',
  pkgetcdir / 'pre-upg.d',
  pkgetcdir / 'post-upg.d',
]

foreach dir: etc_dirs
  install_emptydir(
    dir,
    install_mode: 'rwxr-x---', # 0750
  )
endforeach

foreach dir: ['post-con.d', 'post-ins.d', 'post-upg.d']
  install_symlink(
    'tmux-hint',
    install_dir: pkgetcdir / dir,
    pointing_to: '../../..' + pkglibdir / 'tmux-hint',
  )
endforeach

install_emptydir(
  pkgetcdir / 'ssh',
  install_mode: 'rwx--x---', # 0710
)

shared_dirs = [
  localstatedir / 'lib' / 'apt-dater' / 'history',
  localstatedir / 'cache' / 'apt-dater' / 'stats',
  localstatedir / 'cache' / 'apt-dater' / 'tmux',
]
foreach dir: shared_dirs
  install_emptydir(
    dir,
    install_mode: 'rwxrws---', # 02770
  )
endforeach
