Class {
	#name : #GtSmaCCAttributeQuery,
	#superclass : #GtSmaCCQuery,
	#instVars : [
		'query',
		'attributeName'
	],
	#category : 'GT4SmaCC-Queries'
}

{ #category : #querying }
GtSmaCCAttributeQuery >> <- aValue [
	| results |
	results := GtSmaCCNodeQuery new.
	query
		do: [ :each | 
			each tokenVariables
				do: [ :selector | 
					(self does: attributeName match: selector)
						ifTrue: [ (each perform: selector)
								ifNotNil: [ :token | 
									(self does: aValue match: token source)
										ifTrue: [ results addNode: each ] ] ] ].
			each compositeTokenVariables
				do: [ :selector | 
					(self does: attributeName match: selector)
						ifTrue: [ (each perform: selector)
								ifNotNil: [ :tokens | 
									tokens
										do: [ :token | 
											(self does: aValue match: token source)
												ifTrue: [ results addNode: each ] ] ] ] ] ].
	^ results
]

{ #category : #accessing }
GtSmaCCAttributeQuery >> attributeName [
	^ attributeName
]

{ #category : #accessing }
GtSmaCCAttributeQuery >> attributeName: aName [
	attributeName := aName
]

{ #category : #accessing }
GtSmaCCAttributeQuery >> query [
	^ query
]

{ #category : #accessing }
GtSmaCCAttributeQuery >> query: aSmaCCQuery [
	query := aSmaCCQuery
]
