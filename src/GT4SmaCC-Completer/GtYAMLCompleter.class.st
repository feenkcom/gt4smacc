Class {
	#name : #GtYAMLCompleter,
	#superclass : #Object,
	#category : #'GT4SmaCC-Completer-YAML'
}

{ #category : #accessing }
GtYAMLCompleter >> complete: aString at: positionInteger [
	^ #()
]

{ #category : #accessing }
GtYAMLCompleter >> findCompleterFor: aYAMLNode [
	^ GtYAMLEmptyCompleter instance
]

{ #category : #accessing }
GtYAMLCompleter >> labelFor: aString withSearch: subString [
	| text attributes |
	attributes := {BlTextDecorationAttribute new
				color: BrGlamorousColors textHighlightColor;
				thickness: 3;
				underline}.
	text := aString asRopedText glamorousCodeFont.
	(text from: 1 to: subString size) attributes: attributes.
	^ text
]

{ #category : #merging }
GtYAMLCompleter >> merge: aCompleter [
	self subclassResponsibility
]

{ #category : #merging }
GtYAMLCompleter >> mergeFromBlock: aCompleter [
	^ aCompleter
]

{ #category : #merging }
GtYAMLCompleter >> mergeFromEmpty: aCompleter [
	^ self
]

{ #category : #merging }
GtYAMLCompleter >> mergeFromList: aCompleter [
	^ aCompleter	"Pick one"
]

{ #category : #merging }
GtYAMLCompleter >> mergeFromMappingItem: aCompleter [
	^ aCompleter	"Pick one"
]

{ #category : #merging }
GtYAMLCompleter >> mergeFromMappingList: aCompleter [
	^ aCompleter	"Pick one"
]

{ #category : #merging }
GtYAMLCompleter >> mergeFromValue: aCompleter [
	^ aCompleter	"Pick one"
]

{ #category : #accessing }
GtYAMLCompleter >> pathTo: nameString current: aCollection do: aBlock [
	
]
