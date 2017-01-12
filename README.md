```
[root@node06 nd]# ./net_dump.sh                                                                                                                           
Error: edit ./net_dump.sh and set SOURCE_CONTAINER and DEST_CONTAINER
```

```
[root@node06 nd]# vi net_dump.sh 
```

```
[root@node06 nd]# time ./net_dump.sh                                                                                                                           
/var/tmp/net_dump_node06_20170112_045415.tgz

real    0m14.281s
user    0m0.080s
sys     0m0.091s
```


Contents of archive
```
net_dump_node06_20170112_045415/
|-- daemon.json
|-- dockerd_commandline
|-- docker_inspect
|   |-- inspect_nginx1
|   |-- network_inspect_bridge
|   |-- network_inspect_docker_gwbridge
|   |-- network_inspect_host
|   |-- network_inspect_none
|   `-- network_inspect_repro
|-- docker.service
|-- hostname
|-- net_dump.sh
|-- network_state
|   |-- container
|   |   |-- bridge_-s_fdb_sh
|   |   |-- ifconfig_-a
|   |   |-- ip_-d_-s_addr_sh
|   |   |-- ip_route_sh
|   |   `-- ip_-s_neigh_sh
|   |-- host
|   |   |-- bridge_-s_fdb_sh
|   |   |-- ifconfig_-a
|   |   |-- ip_-d_-s_addr_sh
|   |   |-- ip_route_sh
|   |   `-- ip_-s_neigh_sh
|   `-- overlay
|       |-- bridge_-s_fdb_sh
|       |-- ifconfig_-a
|       |-- ip_-d_-s_addr_sh
|       |-- ip_route_sh
|       `-- ip_-s_neigh_sh
|-- test_results
|   `-- docker_exec_ping
|-- uname_-a
`-- uptime
```

