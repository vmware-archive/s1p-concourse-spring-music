---
platform: linux

image_resource:
  type: docker-image
  source:
    repository: brianbyers/concourse-gradle
    tag: "latest"

inputs:
  - name: git-repo
  - name: version
  - name: release-candidate

outputs:
  - name: final-dir

run:
  path: git-repo/ci/tasks/prepare-final.sh

params:
  base_name:
