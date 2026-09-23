# Velero CSI data-mover backup PVCs

Velero's CSI snapshot data mover uses temporary `backupPVC` volumes to read
snapshots into the backup storage location. The node-agent configuration maps
the source `ceph-block` StorageClass to the backup-only `velero-ceph-block`
StorageClass with `readOnly: true`. This requests `ReadOnlyMany` for the
temporary PVC; the backup class adds `noload` so an ext4 snapshot can be
mounted read-only without journal replay. It does not change the default
`ceph-block` StorageClass, application PVCs, or restore volumes.

The `ceph-filesystem` source class already has `readOnly: true` in the
node-agent configuration. It keeps its existing StorageClass, with no RBD-only
mount options. Velero's schedules select labeled PVCs, not the backup
StorageClass itself.

Before deploying, confirm that the cluster's RBD source volumes use ext4
(`noload` is not an XFS mount option), the installed RBD CSI driver can
provision a `ReadOnlyMany` PVC from a snapshot, and both RBD and CephFS
snapshot classes work with the data mover. Do not deploy this change if
either storage backend cannot meet the read-only requirement. On a
SELinux-enabled cluster, investigate Velero's `spcNoRelabeling` requirement
and pod security policy before enabling read-only backup PVCs; that option
has not been enabled here.

The `velero` Argo CD application has automated sync, pruning, and self-healing.
The Rook cluster application does not auto-sync. After reviewing the rendered
resources, the human operator should roll out the change and test an
appropriately labeled RBD PVC and CephFS PVC, one at a time. For each backup,
inspect the temporary PVC's `ReadOnlyMany` access mode, backup pod mount,
`DataUpload` status, completed backup, and a test restore's contents. If a
PVC cannot be provisioned or mounted, inspect its events and CSI/node-agent
logs and stop rollout; Velero may leave the `DataUpload` in `Accepted` until
its prepare timeout and mark the backup partially failed. Do not fall back
to writable backup PVCs. No live-cluster operations are performed by this
repository's local validation.
