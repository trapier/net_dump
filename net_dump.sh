#!/bin/bash

# As seen in the NAMES column in `docker ps`
SOURCE_CONTAINER=
DEST_CONTAINER=
# Name of the overlay network
OVERLAY=




if [[ -z $SOURCE_CONTAINER || -z $DEST_CONTAINER ]]; then
	echo Error: edit $0 and set SOURCE_CONTAINER and DEST_CONTAINER
	exit 1
fi

# function to cleanup when we're done
function cleanup {
	rm -rf $dir
}
trap cleanup EXIT

# function to capture command output to a file prepended with the command
exec_cmd() {
    outfile=$1
    shift

    cmd=$1
    shift

    echo "# $cmd $@">> $outfile 2>/dev/null
    $cmd "$@" &>> $outfile

    return $?
}

# establish whether source or dest is the locally running container
while read name; do
	test $name = $SOURCE_CONTAINER && local_container=$SOURCE_CONTAINER && break
	test $name = $DEST_CONTAINER   && local_container=$DEST_CONTAINER   && break
done < <(docker ps --format '{{.Names}}')

# confirm we are on the source or dest host
test -z $local_container && echo Error: must be run from host running either $SOURCE_CONTAINER or $DEST_CONTAINER && exit 1

# populate a temporary directory structure to store information
dir=$(mktemp -d -p /var/tmp)
mkdir -p $dir/network_state/{host,overlay,container} $dir/docker_inspect $dir/test_results

initial_wd=$PWD
cd $dir

# collect basic host info
exec_cmd hostname hostname
exec_cmd uname_-a uname -a
exec_cmd uptime uptime
exec_cmd docker.service systemctl cat docker.service
test -e /etc/docker/daemon.json && \
	exec_cmd daemon.json cat /etc/docker/daemon.json
exec_cmd dockerd_commandline ps h -ww -o args -C dockerd
exec_cmd docker_version docker version
exec_cmd docker_info docker info

# map out file locations for net namespaces
declare -A netns
netns[host]=/proc/$$/ns/net
netns[overlay]=$(echo /var/run/docker/netns/*-$(docker network inspect -f '{{.Id}}' $OVERLAY |cut -c1-9)*)
netns[container]=$(docker inspect -f '{{.NetworkSettings.SandboxKey}}' $local_container)

# collect host, overlay, and container networking info
for nstype in "${!netns[@]}"; do 
	cd $dir/network_state/$nstype
	if [[ $nstype = "overlay" || $nstype = "container" ]]; then
		nsenter="nsenter -m -t $(pidof dockerd) nsenter --net=${netns[$nstype]}"
	else
		nsenter=""
	fi
	if hash ifconfig &>/dev/null; then
		exec_cmd ifconfig_-a        $nsenter ifconfig -a
	elif [ $nstype = "container" ]; then
		docker exec -it $local_container /bin/sh -c "test -e /sbin/ifconfig" && \
		exec_cmd ifconfig_-a docker exec -it $local_container ifconfig -a
        fi
	exec_cmd ip_-d_-s_addr_sh   $nsenter ip -d -s addr sh
	exec_cmd bridge_-s_fdb_sh   $nsenter bridge -s fdb show
	exec_cmd ip_route_sh        $nsenter ip route sh
	exec_cmd ip_-s_neigh_sh     $nsenter ip -s neigh sh
	cd - &>/dev/null
done


# inspect all docker networks present on this host
cd $dir/docker_inspect
for network in $(docker network ls |awk 'NR >1 {print $2}'); do
	exec_cmd network_inspect_$network docker network inspect $network
done

# inspect the local container
exec_cmd inspect_${local_container} docker inspect $local_container

# run test to demonstrate issue 
cd $dir/test_results
if [ $local_container = $SOURCE_CONTAINER ]; then
	exec_cmd docker_exec_ping docker exec -it $local_container ping -c10 $DEST_CONTAINER
else
	exec_cmd docker_exec_ping echo test only run from host of specified source container.  see source capture file for results.
fi

# dump a copy of this script for the archive
cd $initial_wd
cat $0 > $dir/$(basename $0)

# roll up the results
archive_name=`basename -s .sh $0`_`hostname`_`date +%Y%m%d_%H%M%S`
ln -s $dir /var/tmp/$archive_name
cd /var/tmp
tar -hczf ${archive_name}.tgz $archive_name

echo /var/tmp/${archive_name}.tgz
