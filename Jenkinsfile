def artifactoryRegistry = 'nginx.default:5000'
podTemplate(label: 'docker-pod', containers: [
    containerTemplate(
        name: 'dind', 
        image: 'docker:dind', 
        ttyEnabled: true, 
        privileged: true,
        alwaysPullImage: true,
        command: 'dockerd',
        args: "--host=unix:///var/run/docker.sock --host=tcp://0.0.0.0:2375 --storage-driver=overlay --tls=false --insecure-registry=$artifactoryRegistry"
    )]
  ) {

    node('docker-pod') {
        container('dind') {
            stage('Git clone') {
                git url: 'https://github.com/alextu/devfest-demo.git'
            }

            stage('Docker Build') {
                sh "sed -i s/REGISTRY/${artifactoryRegistry}/ Dockerfile"
                sh "docker build -t ${artifactoryRegistry}/devfest ."
            }
            
            stage('Test image') {
                def stdout = sh(script: "docker run --rm ${artifactoryRegistry}/devfest", returnStdout: true)
                sh "[[ \"${stdout}\"==\"Hello TEAM CHOCOLATINE\" ]] || exit 1"
            }

            stage('Docker push') {
                sh "docker login -u admin -p password ${artifactoryRegistry}"
                sh "docker push ${artifactoryRegistry}/devfest"
            }
        }

    }
}