Class {
	#name : 'GtSmaCCTokenSimulationAccept',
	#superclass : 'GtSmaCCSimulationAnnoucement',
	#instVars : [
		'nodes'
	],
	#category : 'GT4SmaCC-Development-UI-Simulation'
}

{ #category : 'instance creation' }
GtSmaCCTokenSimulationAccept class >> input: aString index: anInteger nodes: aCollection [
	^ (self input: aString index: anInteger)
		nodes: aCollection;
		yourself
]

{ #category : 'accessing' }
GtSmaCCTokenSimulationAccept >> nodes [
	^ nodes
]

{ #category : 'accessing' }
GtSmaCCTokenSimulationAccept >> nodes: aCollection [
	nodes := aCollection
]
