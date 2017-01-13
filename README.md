## Usage

```
[root@node05 nd]# ./net_dump.sh                                                                                                                           
Error: edit ./net_dump.sh and set SOURCE_CONTAINER and DEST_CONTAINER
```

```
[root@node05 nd]# vi net_dump.sh 
```

```
[root@node05 nd]# time ./net_dump.sh                                                                                                                           
/var/tmp/net_dump_node05_20170113_143831.tgz

real    0m14.281s
user    0m0.080s
sys     0m0.091s
```


## Archive Content

```
|-- daemon
|   |-- commandline
|   |-- daemon.json
|   |-- docker.service
|   |-- info
|   |-- logs
|   `-- version
|-- docker_inspect
|   |-- inspect_repro_nginx_1
|   |-- network_inspect_bridge
|   |-- network_inspect_docker_gwbridge
|   |-- network_inspect_host
|   |-- network_inspect_none
|   `-- network_inspect_repro
|-- hostname
|-- net_dump.sh
|-- network_state
|   |-- container
|   |   |-- bridge_-s_fdb_sh
|   |   |-- ip_-d_-s_addr_sh
|   |   |-- ip_route_sh
|   |   `-- ip_-s_neigh_sh
|   |-- host
|   |   |-- bridge_-s_fdb_sh
|   |   |-- ip_-d_-s_addr_sh
|   |   |-- ip_route_sh
|   |   `-- ip_-s_neigh_sh
|   `-- overlay
|       |-- bridge_-s_fdb_sh
|       |-- ip_-d_-s_addr_sh
|       |-- ip_route_sh
|       `-- ip_-s_neigh_sh
|-- test_results
|   `-- docker_exec_ping
|-- uname_-a
`-- uptime
```

