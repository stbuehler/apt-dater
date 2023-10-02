_conf_generated = {}

foreach target: ['apt-dater.xml', 'hosts.xml']
  src = target + '.in'
  _conf_generated += {
    target: configure_file(
      configuration: conffile_data,
      input: src,
      output: target,
    )
  }
endforeach

xxd_exe = find_program('xxd', native: true)

conf_generated = {}
foreach src: ['apt-dater.xml', 'hosts.xml', 'screenrc', 'tmux.conf']
  target = src + '.inc'
  conf_generated += {
    target: custom_target(
      target,
      command: [ xxd_exe, '--name', '@PLAINNAME@', '-i', '@INPUT@', '@OUTPUT@' ],
      input: _conf_generated.get(src, src),
      output: target,
      build_by_default: true,
    )
  }
endforeach
