Class {
	#name : #GtSmaCCTransformationStackStream,
	#superclass : #Object,
	#traits : 'TAsyncStream',
	#classTraits : 'TAsyncStream classTrait',
	#instVars : [
		'topContext',
		'currentContext'
	],
	#category : #'GT4SmaCC-Rewrite-Engine-UI-Debugging'
}

{ #category : #'instance creation' }
GtSmaCCTransformationStackStream class >> onContext: aContext [
	^ self new context: aContext
]

{ #category : #accessing }
GtSmaCCTransformationStackStream >> context: aContext [
	topContext := aContext
]

{ #category : #'api - stream' }
GtSmaCCTransformationStackStream >> pollNext: anAsynchronousContext [
	| rewriteContext |
	[ currentContext isNil ]
		whileFalse:
			[ rewriteContext := currentContext.
			currentContext := currentContext sender.
			(SmaCCTransformationToolkitDebugSession isRewriteContext: rewriteContext)
				ifTrue: [ ^ AsyncPoll ready: (AsyncOptionalValue some: rewriteContext) ] ].
	^ AsyncPoll ready: AsyncOptionalValue none
]

{ #category : #'api - stream copy' }
GtSmaCCTransformationStackStream >> postSimilarCopy [
	currentContext := topContext
]
