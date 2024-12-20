Class {
	#name : #GtYAMLCompleter,
	#superclass : #Object,
	#category : #'GT4SmaCC-Completer-YAML'
}

{ #category : #'instance creation' }
GtYAMLCompleter class >> forJSONSchema: anObject [
	| result type |
	anObject isNil ifTrue: [ ^ GtYAMLEmptyCompleter instance ].
	type := anObject type.
	type = 'boolean'
		ifTrue: [ ^ GtYAMLValueCompleter new values: #('true' 'false') ].
	type = 'string'
		ifTrue: [ ^ GtYAMLValueCompleter new
				values: (anObject enum ifNotNil: [ :v | v collect: #asString ] ifNil: [ #() ]) ].
	type = 'array'
		ifTrue: [ ^ GtYAMLListCompleter new
				value: (self forJSONSchema: (anObject resolveSubSchema: anObject items)) ].
	type = 'object'
		ifTrue: [ result := GtYAMLMappingListCompleter new.
			(anObject properties ifNil: [ Dictionary new ])
				keysAndValuesDo: [ :key :each | 
					result
						addItem: (GtYAMLMappingItemCompleter new
								name: key;
								value: (self forJSONSchema: (anObject resolveSubSchema: each));
								yourself) ].
			^ result ].
	type
		ifNil: [ ^ (anObject anyOf ifNil: [ #() ])
				inject: GtYAMLEmptyCompleter instance
				into: [ :sum :each | sum merge: (self forJSONSchema: (anObject resolveSubSchema: each)) ] ].
	^ GtYAMLEmptyCompleter instance
]

{ #category : #converting }
GtYAMLCompleter >> asYAML [
	^ String streamContents: [ :stream | self yamlOn: stream indent: 0 ]
]

{ #category : #accessing }
GtYAMLCompleter >> complete: aString at: positionInteger [
	^ #()
]

{ #category : #accessing }
GtYAMLCompleter >> findCompleterFor: aYAMLNode [
	^ GtYAMLEmptyCompleter instance
]

{ #category : #'as yet unclassified' }
GtYAMLCompleter >> gtYAMLViewFor: aView [
	<gtView>
	^ aView textEditor
		title: 'YAML source';
		text: [ self asYAML asRopedText ];
		styler: YAMLParser gtStyler
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

{ #category : #converting }
GtYAMLCompleter >> yamlOn: stream indent: anInteger [ 
]
