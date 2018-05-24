def call(def job) {

    node {
        git url: 'https://github.com/ResearchComputing/mfix_singularity'

        // define the secrets and the env variables
        def secrets = [
            [$class: 'VaultSecret', path: 'secret/mfix/sregistry', secretValues: [
                [$class: 'VaultSecretValue', envVar: 'SREGISTRY', vaultKey: 'sregistry'],
                [$class: 'VaultSecretValue', envVar: 'SREG_ESCAPED', vaultKey: 'sregistry_escaped'],
                [$class: 'VaultSecretValue', envVar: 'MFIX_EXA_TOKEN', vaultKey: 'token']]]
        ]

        // optional configuration, if you do not provide this the next higher configuration
        // (e.g. folder or global) will be used
        def configuration = [$class: 'VaultConfiguration',
                             vaultUrl: 'https://secrets.rc.int.colorado.edu',
                             vaultCredentialId: 'jenkins-approle']

        // inside this block your credentials will be available as env variables
        wrap([$class: 'VaultBuildWrapper', configuration: configuration, vaultSecrets: secrets]) {
            try {
                stage('Clone') {
                    //sh(libraryResource('mfix/clone_exa.sh'))
                }
                stage('Build'){
                    //sh(libraryResource('mfix/build_exa.sh'))
                }
                stage('Push') {
                    //sh(libraryResource('mfix/push_exa.sh'))
                }
                stage('Summit') {
                    sshagent(credentials: ['holtat-scompile']) {
                        //sh 'ssh -o StrictHostKeyChecking=no -l holtat scompile.rc.int.colorado.edu "echo $SREG_ESCAPED > /home/holtat/sreg_tmp"'
                        //sh(libraryResource('mfix/sreg_summit.sh'))
                        sh(libraryResource("${job}"))
                        sh "echo ${job}"
                    }
                }
            } finally {
                step([$class: 'WsCleanup'])
            }

        }
    }
}
