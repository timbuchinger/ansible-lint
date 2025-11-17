# AGENTS.md

## Repository Overview

This repository provides a GitHub Action for running `ansible-lint` against Ansible automation projects. It packages ansible-lint in a Docker container with pre-installed Ansible collections for cloud platforms, making it easy to integrate Ansible linting into CI/CD pipelines.

## Purpose

The ansible-lint GitHub Action enables teams to:
- Automatically lint Ansible playbooks, roles, and tasks
- Enforce Ansible best practices and coding standards
- Catch potential issues before deployment
- Integrate with GitHub Actions workflows for continuous integration

## Repository Structure

### Core Files

- **`action.yml`**: GitHub Action metadata and configuration
  - Defines the action interface and Docker runtime
  - Accepts a `filter` input to specify which files to lint (default: `roles/*/tasks/*.yml`)
  
- **`Dockerfile`**: Container image definition
  - Based on Red Hat UBI 8 with Python 3.8
  - Installs ansible-lint version 6.8.6
  - Pre-installs cloud provider Ansible collections:
    - `google.cloud`
    - `amazon.aws` and `community.aws`
    - `azure.azcollection` and `community.azure`
  
- **`requirements.txt`**: Python dependencies
  - ansible
  - ansible-lint==6.8.6

- **`playbook.yml`**: Sample playbook for testing the action

- **`README.md`**: Basic repository documentation

### Workflows

Located in `.github/workflows/`:

- **`ci.yaml`**: Continuous Integration workflow
  - Builds Docker image on push
  - Validates the container can be built successfully
  
- **`release.yaml`**: Release workflow
  - Triggered on version tags (v*.*.*)
  - Pushes built images to Docker Hub
  - Tags images with version and `latest`
  
- **`run-action.yaml`**: Action testing workflow
  - Manual workflow dispatch for testing the action
  - Runs ansible-lint against the sample playbook

## Usage

### Basic Usage

Add this action to your GitHub workflow:

```yaml
- name: Run ansible-lint
  uses: timbuchinger/ansible-lint@main
  with:
    filter: 'roles/*/tasks/*.yml'  # Optional: customize file filter
```

### Custom File Filter

Lint specific files or patterns:

```yaml
- name: Lint playbooks
  uses: timbuchinger/ansible-lint@main
  with:
    filter: 'playbooks/*.yml'
```

### Example Workflow

```yaml
name: Ansible Lint

on: [push, pull_request]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2
      
      - name: Run ansible-lint
        uses: timbuchinger/ansible-lint@main
        with:
          filter: '**/*.yml'
```

## Technical Details

### Docker Image

The action runs in a containerized environment:
- **Base Image**: `registry.access.redhat.com/ubi8/python-38`
- **Security**: Applies critical and important security updates
- **Git Support**: Includes git for repository operations
- **Working Directory**: `/data` (where your repository is mounted)
- **Entrypoint**: `ansible-lint`

### Pre-installed Collections

The container comes with popular cloud provider collections pre-installed, allowing linting of playbooks that use:
- Google Cloud Platform modules
- Amazon Web Services (AWS) modules
- Microsoft Azure modules

This eliminates the need for collection installation during linting.

## Development

### Building Locally

```bash
docker build -t ansible-lint .
```

### Testing the Action

1. Push to the repository
2. Trigger the `run-action.yaml` workflow manually from GitHub Actions tab
3. Review the lint results

### Releasing

1. Create and push a version tag:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```
2. The release workflow automatically builds and publishes to Docker Hub

## Maintenance

### Updating ansible-lint Version

1. Modify `requirements.txt` to specify the desired ansible-lint version
2. Update the Dockerfile if base image changes are needed
3. Test the build locally
4. Create a new release tag

### Adding Collections

To include additional Ansible collections in the container:

1. Add `RUN ansible-galaxy collection install <collection.name>` to the Dockerfile
2. Rebuild and test the image
3. Release a new version

## Contributing

This is a GitHub Action maintained by Tim Buchinger (timbuchinger@gmail.com). 

When contributing:
1. Ensure Docker image builds successfully
2. Test the action with sample playbooks
3. Update documentation for any interface changes
4. Follow semantic versioning for releases

## License

Not specified in the repository.

## Contact

Maintainer: timbuchinger@gmail.com
