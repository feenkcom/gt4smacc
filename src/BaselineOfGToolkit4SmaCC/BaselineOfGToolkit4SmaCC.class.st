Class {
	#name : #BaselineOfGToolkit4SmaCC,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkit4SmaCC
}

{ #category : #baseline }
BaselineOfGToolkit4SmaCC >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec
			baseline: 'SmaCC' with: [
				spec repository: 'github://j-brant/SmaCC:6d1d7f7a031e2d9b94d93416be9ead58b86e5f27/src' ].
		spec
			baseline: 'RemoteRunner' with: [
				spec repository: 'github://feenkcom/gtoolkit-remoterunner:v0.7.196/src' ].

		spec package: 'GT4SmaCC-Inspector' with: [
			spec requires: #(#SmaCC) ].
		spec package: 'GT4SmaCC-Stylers' with: [
			spec requires: #(#SmaCC) ].
		spec package: 'GT4SmaCC-Development-UI' with: [
			spec requires: #(#SmaCC #'GT4SmaCC-Stylers') ].
		spec package: 'GT4SmaCC-Debugger' with: [
			spec requires: #(#'GT4SmaCC-Development-UI') ].
		spec package: 'GT4SmaCC-Queries' with: [
			spec requires: #(#SmaCC) ].
		spec package: 'GT4SmaCC-Examples' with: [
			spec requires: #(#SmaCC) ].
		spec package: 'GT4SmaCC-Documentation' with: [
			spec requires: #(#'GT4SmaCC-Development-UI') ].
		spec package: 'GT4SmaCC-Rewrite-Engine-UI' with: [
			spec requires: #(#SmaCC #RemoteRunner) ].
		spec package: 'GT4SmaCC-Completer' with: [
			spec requires: #(#SmaCC) ].
	]
]
