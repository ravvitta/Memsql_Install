file=memsql_cluster_install.yaml
contents=\"\"\"`cat $file`\"\"\"; python  -c "import os;print $contents.format(**os.environ)" > memsql_cluster_install.yaml