Class {
	#name : #GtSmaCCSimulationAccept,
	#superclass : #GtSmaCCSimulationAnnoucement,
	#instVars : [
		'nodes'
	],
	#category : #'GT4SmaCC-Development-UI-Simulation'
}

{ #category : #'instance creation' }
GtSmaCCSimulationAccept class >> input: aString index: anInteger nodes: aCollection [
	^ (self input: aString index: anInteger)
		nodes: aCollection;
		yourself
]

{ #category : #accessing }
GtSmaCCSimulationAccept >> nodes [
	^ nodes
]

{ #category : #accessing }
GtSmaCCSimulationAccept >> nodes: aCollection [
	nodes := aCollection
]
