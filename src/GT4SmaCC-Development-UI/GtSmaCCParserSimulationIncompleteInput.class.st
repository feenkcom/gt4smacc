Class {
	#name : #GtSmaCCParserSimulationIncompleteInput,
	#superclass : #GtSmaCCSimulationAnnoucement,
	#instVars : [
		'stack'
	],
	#category : 'GT4SmaCC-Development-UI-Simulation'
}

{ #category : #'instance creation' }
GtSmaCCParserSimulationIncompleteInput class >> input: aString stack: nodeCollection [
	^ (self input: aString index: aString size)
		stack: nodeCollection;
		yourself
]

{ #category : #accessing }
GtSmaCCParserSimulationIncompleteInput >> stack [
	^ stack
]

{ #category : #accessing }
GtSmaCCParserSimulationIncompleteInput >> stack: aCollection [
	stack := aCollection
]
