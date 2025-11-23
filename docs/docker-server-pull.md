# CrocLinux Server Stack: Pre-Pull Instructions

Use these commands to fetch container images before deployment, ensuring repeatable builds and offline availability.

```bash
cd docker
# Export credentials for private registries or overrides
export ELASTIC_PASSWORD=elasticpass
export MISP_API_KEY=<insert-key>
export WAZUH_USER=wazuh
export WAZUH_PASS=<secret>

# Pull all images defined in docker-compose.yml
docker compose pull

# Optional: save images to tarball for air-gapped import
mkdir -p ../release/container-images
for svc in $(docker compose config --services); do
  image=$(docker compose config | awk -v s="$svc" '$1=="image:" && NR>0 {print $2}' | head -n1)
  docker pull "$image"
  docker save "$image" -o ../release/container-images/${svc}.tar
  gzip ../release/container-images/${svc}.tar
  echo "Saved $image to release/container-images/${svc}.tar.gz"
done
```

To deploy after pulling:
```bash
docker compose up -d
docker compose ps
docker compose logs -f wazuh-manager
```

> Tip: run `docker image prune` after saving to reclaim space.
