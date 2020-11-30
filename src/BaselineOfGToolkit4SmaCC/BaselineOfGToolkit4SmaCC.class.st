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
				spec repository: 'github://j-brant/SmaCC:9f6548b77b68313fbdd9f2fa48e4b2caa8c91e4c/src' ].
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
