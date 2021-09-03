Extension { #name : 'SmaCCParseNode' }

{ #category : '*GT4SmaCC-Queries' }
SmaCCParseNode >> / aName [
	^ self asQueryResult / aName
]

{ #category : '*GT4SmaCC-Queries' }
SmaCCParseNode >> // aName [
	^ self asQueryResult // aName
]

{ #category : '*GT4SmaCC-Queries' }
SmaCCParseNode >> //@ aName [
	^ self asQueryResult //@ aName
]

{ #category : '*GT4SmaCC-Queries' }
SmaCCParseNode >> /@ aName [
	^ self asQueryResult /@ aName
]

{ #category : '*GT4SmaCC-Queries' }
SmaCCParseNode >> @ aName [
	^ self asQueryResult @ aName
]

{ #category : '*GT4SmaCC-Queries' }
SmaCCParseNode >> \ anObject [
	^ self asQueryResult \ anObject
]

{ #category : '*GT4SmaCC-Queries' }
SmaCCParseNode >> \\ aName [
	^ self asQueryResult \\ aName
]

{ #category : '*GT4SmaCC-Queries' }
SmaCCParseNode >> asQueryResult [
	^ GtSmaCCNodeQuery new
		addNode: self;
		yourself
]
