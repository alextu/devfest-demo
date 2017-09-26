def artifactoryRegistry = 'nginx.default:5000'
podTemplate(label: 'docker-pod', containers: [
    containerTemplate(
        name: 'dind', 
        image: 'docker:17.09.0-ce-dind', 
        ttyEnabled: true, 
        privileged: true,
        args: "--tls=false --insecure-registry=$artifactoryRegistry"
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