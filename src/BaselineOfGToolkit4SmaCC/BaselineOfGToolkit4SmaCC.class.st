Class {
	#name : #BaselineOfGToolkit4SmaCC,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkit4SmaCC
}

{ #category : #baseline }
BaselineOfGToolkit4SmaCC >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec baseline: 'SmaCC' with: [
				spec repository: 'github://j-brant/SmaCC:09c9dcb8963c2446bd00b9450ae756ca2ddab2dc/src' ].
		spec 
			package: 'GT4SmaCC-Inspector' with: [
				spec requires: #('SmaCC' ). ];
			package: 'GT4SmaCC-Development-UI' with: [
				spec requires: #('SmaCC' ). ];
			package: 'GT4SmaCC-Debugger' with: [
				spec requires: #('GT4SmaCC-Development-UI' ). ];
			package: 'GT4SmaCC-Stylers' with: [
				spec requires: #('SmaCC' ). ];
			package: 'GT4SmaCC-Queries' with: [
				spec requires: #('SmaCC' ). ];
			package: 'GT4SmaCC-Examples' with: [
				spec requires: #('SmaCC' ). ];
			package: 'GT4SmaCC-Rewrite-Engine-UI' with: [
				spec requires: #('SmaCC' ). ]. ].

]
