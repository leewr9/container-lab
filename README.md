# Container Lab

This repository is dedicated to learning and practicing container technologies like Docker and Kubernetes. It includes Dockerfiles, Kubernetes manifests, and example configurations organized for easy experimentation and development.

## Feature

- Practice **Docker**, **Docker Compose**, and **Kubernetes (k8s)** setups
- Modular folders for isolated container and cluster environments
- Quick start with simple Docker Compose and kubectl commands
- Hands-on learning for building, deploying, and managing containers and clusters

## Installation

```bash
git clone https://github.com/leewr9/learning-docker.git
cd learning-docker
```

## Usage

Choose a service or environment you want to practice with:

```bash
cd <folder-name>
```

###  Docker

```bash
# Build Docker image from Dockerfile in current folder
docker build -t <image-name> .

# Run container in detached mode with a specific name
docker run -d --name <container-name> <image-name>

# Stop the running container
docker stop <container-name>

# Remove the stopped container
docker rm <container-name>
```

###  Docker Compose

```bash
# Start services defined in docker-compose.yml in detached mode
docker-compose up -d

# Stop and remove containers, networks defined in docker-compose.yml
docker-compose down
```

### Kubernetes (k8s)

```bash
# Apply all Kubernetes manifests in current directory
kubectl apply -f .

# Delete all Kubernetes resources defined in current directory
kubectl delete -f .
```

## License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.
