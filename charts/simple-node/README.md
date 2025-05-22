
# simple-node Helm Chart

A Helm chart to deploy a simple-node using a Kubernetes StatefulSet. Supports configuration via ConfigMap, persistence, multiple service ports, sidecars, and ingress.

---

## Features

- Deploys simple-node as a StatefulSet with persistent storage
- Configurable via Helm values including custom config files
- Supports mounting config files with subPath
- Multi-port service configuration (HTTP, RPC, WebSocket)
- Optional sidecar containers
- Configurable resource requests and limits
- Supports Kubernetes Ingress with TLS
- ServiceAccount creation option

---

## Prerequisites

- Kubernetes 1.16+ (StatefulSet API version apps/v1)
- Helm 3.x
- Persistent storage (e.g. a StorageClass) for simple-node data persistence
- Sufficient resources: Recommended minimum 2 CPU, 4GB RAM, 700GB SSD

---

## Installing the Chart

Add your Helm repo or use the chart directory:

```bash
helm install simple-node ./simple-node
```

To customize values:

```bash
helm install simple-node ./simple-node -f myvalues.yaml
```

---

## Configuration

The following table lists the main configurable parameters and their default values:

| Parameter              | Description                                  | Default                       |
|------------------------|----------------------------------------------|-------------------------------|
| `image.repository`     | Docker image repository                      | `helo-world`             |
| `image.tag`            | Docker image tag                             | `latest`                      |
| `image.pullPolicy`     | Image pull policy                            | `IfNotPresent`                |
| `appNameOverride`      | Override app name used in labels             | `simple-node`                     |
| `replicas`             | Number of pod replicas                       | `1`                           |
| `persistence.enabled`  | Enable persistent storage                    | `true`                        |
| `persistence.size`     | Persistent volume size                        | `10Gi`                       |
| `config.enabled`       | Enable ConfigMap mount                        | `true`                       |
| `config.data`          | Configuration file contents                   | See `simple-node.conf` example   |
| `service.type`         | Kubernetes service type                       | `ClusterIP`                  |
| `service.ports`        | List of service ports                         |  RPC(8332)                   |
| `resources.requests`   | Pod resource requests                         | CPU: `2`, Memory: `4Gi`     |
| `command`              | Container command override                    | `[]`                         |
| `args`                 | Container args override                       | `[]`                         |
| `ingress.enabled`      | Enable ingress                               | `false`                       |
| `ingress.host`         | Ingress host                                 | `simple-node.example.com`            |

For full configurable options, see [values.yaml](./values.yaml).

---

## Usage

### Custom Config

Modify the simple-node config file via:

```yaml
config:
  enabled: true
  data: |-
    server=1
    printtoconsole=1
```

### Persistence

Ensure your Kubernetes cluster has a default StorageClass or specify one in `persistence.storageClass`.

---

## Notes

- The chart creates a StatefulSet with a PersistentVolumeClaim for blockchain data storage.
- ConfigMap mounts your `simple-node.conf` using `subPath` to keep the config file intact.
- If you want to run with pruned mode or other simple-node Core flags, use the `command` and `args` parameters.

---

## License

This project is licensed under the MIT License.

---