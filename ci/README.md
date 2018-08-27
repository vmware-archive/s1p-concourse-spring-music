#Spring music on concourse

![](images/pipeline.png)

* [Concourse](http://councourse.ci)
* Build only once and deploy anywhere
* Every build is a release candidate
* Every build step runs inside a docker container mounting to garden linux cells

## Resources

Resources in concourse are implemented as docker images which contain implementations corresponding their types

* music-repo ([git-resource](https://github.com/concourse/git-resource)): A github repo. E.g. spring music github resource

* version ([semver-resource](https://github.com/concourse/semver-resource)): A file to track the version stored in s3. E.g. 1.0.1 in a file named as current-version

* music-release (([s3-resource](https://github.com/concourse/s3-resource))) A bucket in s3 that stores spring-music artifact E.g. spring-music-1.0.1.war

## Pipeline Progress

### Check out from the music-repo

### Unit testing spring-music

This step runs on a container with gradle and java installed.
Basically it just runs "gradle test" against the music-repo

### Build Binary

* music-repo - Check out the same source version of music-repo as unit step
* version - Checkout the version file from s3
* "gradle assemble" generates the war artifact
* Push the artifact to the s3 resource as music-resource
* Git tag on the music-repo
* Bump the version resource for the next usage

### acceptance-tests

* Pull the binary from music-release
* Deploy to cloudfoundry acceptance tests space
* Run Automation Acceptance Tests suite

### promote-to-uat

* Pull the binary from music-release
* Deploy to cloudfoundry uat space
* Waiting for user acceptance tests

### manual-deploy-to-prod

* Manually trigger the build when the operators are ready
* Pull the binary from music-release
* Deploy to prod

### How to replicate this pipeline in your env

* If you don't already have a Concourse environment, you can quickly spin one up locally with [Vagrant](https://concourse.ci/vagrant.html])

* Download the `fly` CLI by visiting `http://192.168.100.4:8080` and selecting your OS then install

* Fork this github repo to your own github account, [ generate the key pair and add the public key to github ](https://help.github.com/articles/generating-ssh-keys/), and save the private key for future usage.


* Prepare a s3 bucket named as `spring-music-YOURNAME`
  * Create folders `pipeline-artifacts` and `deployments` in the bucket
  * Create a file called `current-version` in the `pipeline-artifacts` folder and give it an initial content of `1.0.0`


* Install PCF Dev ([Vagrant VM](http://pivotal.io/pcf-dev))
 * Setup spaces for development, test, uat and production
  * `cf create-space development`
  * `cf create-space test`
  * `cf create-space uat`
  * `cf create-space production`


* Set your fly endpoint (assuming you are taking the easy way and using vagrant)

  * `fly -t lite login -c http://192.168.100.4:8080`

  * Configure your environment details in [spring-music-pcfdev-credentials.yml](spring-music-pcfdev-credentials.yml)
    E.g.

    ```
    GIT_SPRING_MUSIC_REPO: git@github.com:REPLACE_ME/concourse-spring-music.git
    GIT_BRANCH: master
    CF_API: https://api.local.pcfdev.io
    CF_USER: admin
    CF_PASS: admin
    CF_DEV_ORG: pcfdev-org
    CF_DEV_SPACE: development
    CF_TEST_ORG: pcfdev-org
    CF_TEST_SPACE: test
    CF_UAT_ORG: pcfdev-org
    CF_UAT_SPACE: uat
    CF_PROD_ORG: pcfdev-org
    CF_PROD_SPACE: prod
    S3_ACCESS_KEY_ID: REPLACE_ME
    S3_SECRET_ACCESS_KEY: REPLACE_ME
    S3_BUCKET: REPLACE_ME
    MUSIC_PRIVATE_KEY: |
      -----BEGIN RSA PRIVATE KEY-----
      REPLACE_ME
      -----END RSA PRIVATE KEY-----
    ```

  * `fly -t lite set-pipeline -p spring-music -c ci/spring-music.yml -l spring-music-pcfdev-credentials.yml`
  * `fly -t lite unpause-pipeline -p spring-music`
  * Open `http://192.168.100.4:8080` in your browser and enjoy!

###  __FYI DO NOT COMMIT `spring-music-pcfdev-credentials.yml` as it has all your secrets__
