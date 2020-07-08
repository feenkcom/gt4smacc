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
				spec repository: 'github://j-brant/SmaCC:a89369539cddabd8562d62808ab6728e7f2f6952/src' ].
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
