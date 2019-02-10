Class {
	#name : #GtSmaCCKeywordTokensStylerRule,
	#superclass : #GtSmaCCStylerRule,
	#instVars : [
		'ids'
	],
	#category : #'GT4SmaCC-Stylers'
}

{ #category : #initialization }
GtSmaCCKeywordTokensStylerRule >> initializeForParser: parserClass [
	| keywords |
	keywords := parserClass scannerClass keywordMap.
	ids := Set new.
	keywords
		do: [ :each | 
			each
				do: [ :id | 
					id isCollection
						ifTrue: [ ids add: id first ]
						ifFalse: [ ids add: id ] ] ]
]

{ #category : #asserting }
GtSmaCCKeywordTokensStylerRule >> shouldApplyToToken: aSmaCCToken [
	^ ids includes: aSmaCCToken ids first
]
