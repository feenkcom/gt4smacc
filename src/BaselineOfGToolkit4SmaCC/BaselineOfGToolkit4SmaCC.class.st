Class {
	#name : #BaselineOfGToolkit4SmaCC,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkit4SmaCC
}

{ #category : #baseline }
BaselineOfGToolkit4SmaCC >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ 
			spec 
				baseline: 'SmaCC' 
				with: [ spec repository: 'github://j-brant/SmaCC' ].
			spec
				baseline: 'RemoteRunner'
				with: [ spec repository: 'github://feenkcom/gtoolkit-remoterunner:main/src' ].
			
			spec
				package: 'GT4SmaCC-Inspector' with: [ spec requires: #('SmaCC') ];
				package: 'GT4SmaCC-Debugger'
					with: [ spec requires: #('GT4SmaCC-Development-UI') ];
				package: 'GT4SmaCC-Stylers' with: [ spec requires: #('SmaCC') ];
				package: 'GT4SmaCC-Development-UI' with: [ spec requires: #('SmaCC' 'GT4SmaCC-Stylers') ];
				package: 'GT4SmaCC-Queries' with: [ spec requires: #('SmaCC') ];
				package: 'GT4SmaCC-Examples' with: [ spec requires: #('SmaCC') ];
				package: 'GT4SmaCC-Documentation'
					with: [ spec requires: #('GT4SmaCC-Development-UI') ];
				package: 'GT4SmaCC-Rewrite-Engine-UI' with: [ spec requires: #('SmaCC' 'RemoteRunner') ];
				package: 'GT4SmaCC-Completer' with: [ spec requires: #('SmaCC') ] ]
]
