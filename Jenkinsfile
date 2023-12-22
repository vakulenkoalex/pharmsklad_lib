#!groovy

def function 
node('built-in') {
	copyArtifacts filter: 'lib.groovy', fingerprintArtifacts: true, flatten: true, projectName: 'ScriptForStartBuild'
	function = fileLoader.load('lib.groovy')
}

function.setScript(this)
function.setRunModeOrdinaryApplication()
function.disableScanTask()
function.setPath1C("C:\\Program Files (x86)\\1cv8\\8.3.12.1714")

function.addTest('CodeAnalysisFull')
function.addTest('SonarQube')
function.addTest('PlatformCheck')

function.startBuild()
