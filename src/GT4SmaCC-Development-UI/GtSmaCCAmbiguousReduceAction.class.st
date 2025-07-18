Class {
	#name : #GtSmaCCAmbiguousReduceAction,
	#superclass : #GtSmaCCAmbiguousAction,
	#instVars : [
		'action'
	],
	#category : #'GT4SmaCC-Development-UI-Analysis'
}

{ #category : #comparing }
GtSmaCCAmbiguousReduceAction >> = anObject [
	^ self class = anObject class and: [ self action = anObject action ]
]

{ #category : #accessing }
GtSmaCCAmbiguousReduceAction >> action [
	^ action
]

{ #category : #accessing }
GtSmaCCAmbiguousReduceAction >> action: anObject [
	action := anObject
]

{ #category : #accessing }
GtSmaCCAmbiguousReduceAction >> actionName [
	^ String
		streamContents: [ :str | 
			str << 'Reduce ' << self symbolName << '(' << self productionSize printString
				<< ')' ]
]

{ #category : #comparing }
GtSmaCCAmbiguousReduceAction >> hash [
	^ self class hash hashMultiply bitXor: self action hash
]

{ #category : #accessing }
GtSmaCCAmbiguousReduceAction >> productionSize [
	^ self reduceEntry second
]

{ #category : #accessing }
GtSmaCCAmbiguousReduceAction >> reduceEntry [
	^ parserClass reduceTable at: action >> 2
]

{ #category : #accessing }
GtSmaCCAmbiguousReduceAction >> symbolName [
	^ self symbolNameFor: self reduceEntry first
]
