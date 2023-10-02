opt_docs = get_option('docs')
if opt_docs.allowed()
  xsltproc_exe = find_program(
    'xsltproc',
    required: opt_docs,
  )

  fs = import('fs')

  docbook_xsl_search = [
    '/usr/share/xml/docbook/stylesheet/nwalsh'
  ]
  docbook_xsl_found = false
  foreach docbook_xsl: docbook_xsl_search
    if fs.is_dir(docbook_xsl)
      docbook_xsl_found = true
      break
    endif
  endforeach

  opt_docs = opt_docs.require(
    docbook_xsl_found,
    error_message: 'Couldn\'t find docbook stylesheet',
  )
endif

if opt_docs.allowed()
  custom_target(
    'apt-dater.xml.html',
    command: [ xsltproc_exe, '-o', '@OUTPUT@', '--nonet', docbook_xsl / 'html' / 'docbook.xsl', '@INPUT@' ],
    input: 'apt-dater.xml.xml',
    output: 'apt-dater.xml.html',
    build_by_default: true,
  )
  custom_target(
    'apt-dater.xml.5',
    command: [ xsltproc_exe, '-o', '@OUTPUT@', '--nonet', docbook_xsl / 'manpages' / 'docbook.xsl', '@INPUT@' ],
    input: 'apt-dater.xml.xml',
    output: 'apt-dater.xml.5',
    install_dir: get_option('mandir') / 'man5',
    build_by_default: true,
  )

  custom_target(
    'apt-dater.html',
    command: [ xsltproc_exe, '-o', '@OUTPUT@', '--nonet', docbook_xsl / 'html' / 'docbook.xsl', '@INPUT@' ],
    input: 'apt-dater.xml',
    output: 'apt-dater.html',
    build_by_default: true,
  )
  custom_target(
    'apt-dater.8',
    command: [ xsltproc_exe, '-o', '@OUTPUT@', '--nonet', docbook_xsl / 'manpages' / 'docbook.xsl', '@INPUT@' ],
    input: 'apt-dater.xml',
    output: 'apt-dater.8',
    install_dir: get_option('mandir') / 'man8',
    build_by_default: true,
  )
endif
