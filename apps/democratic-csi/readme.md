# Fix filesystem errors

Democratic-csi is configured to automatically fix filesystem errors. However sometimes fsck requires manual intervention.
In this case we can use the following steps to mount the iscsi volume on a system and repair the filesystem:

1. Scale the workload to 0
1. Run sudo iscsiadm -m discovery -t sendtargets -p truenas.mobrockers.com:3260
1. sudo iscsiadm -m node --login --targetname iqn.2005-10.com.mobrockers.truenas:<volume-name>
1. Run sudo iscsiadm -m session -P 3 | grep 'Target\|disk' to confirm successful connection and which block device is used
1. Run sudo (e2)fsck /dev/<blockdevice> and let the volume be fixed
1. Run sudo iscsiadm -m node --logout --targetname iqn.2005-10.com.mobrockers.truenas:<volume-name>
