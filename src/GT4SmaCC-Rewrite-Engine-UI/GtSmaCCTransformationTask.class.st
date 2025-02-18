Class {
	#name : #GtSmaCCTransformationTask,
	#superclass : #GtRrTask,
	#instVars : [
		'rewritesFile',
		'filename',
		'commonParentDirectory',
		'inputParserName',
		'outputParserName',
		'outputDirectory',
		'lineEnding'
	],
	#classVars : [
		'RewriteFiles'
	],
	#category : #'GT4SmaCC-Rewrite-Engine-UI-RemoteRunner'
}

{ #category : #accessing }
GtSmaCCTransformationTask class >> leJsonV4Name [
	^ #smaccTransformationTask
]

{ #category : #accessing }
GtSmaCCTransformationTask class >> rewriteFiles [
	^ RewriteFiles ifNil: [ RewriteFiles := Dictionary new ]
]

{ #category : #accessing }
GtSmaCCTransformationTask >> commonParentDirectory [
	^ commonParentDirectory
]

{ #category : #accessing }
GtSmaCCTransformationTask >> commonParentDirectory: anObject [
	commonParentDirectory := anObject
]

{ #category : #accessing }
GtSmaCCTransformationTask >> filename [
	^ filename
]

{ #category : #accessing }
GtSmaCCTransformationTask >> filename: anObject [
	filename := anObject
]

{ #category : #accessing }
GtSmaCCTransformationTask >> inputParserName [
	^ inputParserName
]

{ #category : #accessing }
GtSmaCCTransformationTask >> inputParserName: anObject [
	inputParserName := anObject
]

{ #category : #accessing }
GtSmaCCTransformationTask >> lineEnding [
	^ lineEnding
]

{ #category : #accessing }
GtSmaCCTransformationTask >> lineEnding: anObject [
	lineEnding := anObject
]

{ #category : #running }
GtSmaCCTransformationTask >> loadRewritesFile [
	[ | rewrites |
	rewrites := self class rewriteFiles
			at: rewritesFile
			ifAbsentPut: [ SmaCCRewriteRuleFileParser parseFile: rewritesFile ].
	rewrites isUpToDate ifTrue: [ ^ rewrites ].
	self class rewriteFiles removeKey: rewritesFile ] repeat
]

{ #category : #accessing }
GtSmaCCTransformationTask >> outputDirectory [
	^ outputDirectory
]

{ #category : #accessing }
GtSmaCCTransformationTask >> outputDirectory: anObject [
	outputDirectory := anObject
]

{ #category : #accessing }
GtSmaCCTransformationTask >> outputParserName [
	^ outputParserName
]

{ #category : #accessing }
GtSmaCCTransformationTask >> outputParserName: anObject [
	outputParserName := anObject
]

{ #category : #accessing }
GtSmaCCTransformationTask >> rewritesFile [
	^ rewritesFile
]

{ #category : #accessing }
GtSmaCCTransformationTask >> rewritesFile: anObject [
	rewritesFile := anObject
]

{ #category : #running }
GtSmaCCTransformationTask >> run [
	result := SmaCCRewriteResult new.
	SmaCCRewriteProcessor new
		rules: self loadRewritesFile;
		parserClass: inputParserName asClass;
		validationParserClass: (outputParserName ifNotNil: [ outputParserName asClass ]);
		outputDirectory: outputDirectory;
		baseDirectory: commonParentDirectory;
		lineEnding: (lineEnding ifNil: [ String lf ]);
		processFile: filename usingResult: result.
	result transformation
		ifNotNil: [ :transformation | result transformation: transformation displayString ].
	^ result
]
