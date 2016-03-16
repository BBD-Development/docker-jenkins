# Jenkins Docker Project
Jenkins docker setup using docker-compose with nginx. Mounts two host directories as a data volumes for data and logs

## Working with the services 
### Build images, create containers, and start services (in the background)
`docker-compose up -d`

### Stop all containers
`docker-compose stop`

### Remove all containers
`docker-compose down`

### View jenkins log in the `jenkinslog/jenkins.log` file
### View jenkins data in the `jenkinsdata` directory
