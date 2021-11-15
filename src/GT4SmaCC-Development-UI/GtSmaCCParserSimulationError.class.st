Class {
	#name : #GtSmaCCParserSimulationError,
	#superclass : #GtSmaCCSimulationAnnoucement,
	#instVars : [
		'stack',
		'token'
	],
	#category : 'GT4SmaCC-Development-UI-Simulation'
}

{ #category : #'instance creation' }
GtSmaCCParserSimulationError class >> input: aString stack: nodeCollection token: aSmaCCToken [
	^ (self input: aString index: aSmaCCToken startPosition)
		stack: nodeCollection;
		token: aSmaCCToken;
		yourself
]

{ #category : #accessing }
GtSmaCCParserSimulationError >> stack [
	^ stack
]

{ #category : #accessing }
GtSmaCCParserSimulationError >> stack: aCollection [
	stack := aCollection
]

{ #category : #accessing }
GtSmaCCParserSimulationError >> token [
	^ token
]

{ #category : #accessing }
GtSmaCCParserSimulationError >> token: aSmaCCToken [
	token := aSmaCCToken
]
