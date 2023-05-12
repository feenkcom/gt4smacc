Class {
	#name : #GtJSONEmptyCompleter,
	#superclass : #GtJSONCompleter,
	#classInstVars : [
		'instance'
	],
	#category : #'GT4SmaCC-Completer-JSON'
}

{ #category : #'instance creation' }
GtJSONEmptyCompleter class >> instance [
	^ instance ifNil: [ instance := self new ]
]
