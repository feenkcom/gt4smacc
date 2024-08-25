Extension { #name : #SmaCCAbstractRewrite }

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCAbstractRewrite >> asElement [
	self subclassResponsibility
]

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCAbstractRewrite >> gtEditorFor: aView context: aContext [
	<gtView>
	| transformationElement |
	(self topParent isKindOf: SmaCCRewriteFile) ifFalse: [ ^ aView empty ].
	^ aView explicit
		title: 'Editor';
		priority: 10;
		actionDropdownButtonIcon: BrGlamorousVectorIcons filter
			tooltip: 'Filter'
			content: [ :button | 
				transformationElement
					ifNil: [ BlElement new ]
					ifNotNil: [ transformationElement filterDropdownFor: button ] ];
		actionDropdownButtonIcon: BrGlamorousVectorIcons add
			tooltip: 'Add transformation'
			content: [ :button | 
				transformationElement
					ifNil: [ BlElement new ]
					ifNotNil: [ transformationElement addTransformationDropdownFor: button ] ];
		actionDropdownButtonIcon: BrGlamorousVectorIcons remove
			tooltip: 'Delete selected transformation'
			content: [ :button | 
				transformationElement
					ifNil: [ BlElement new ]
					ifNotNil: [ transformationElement deleteTransformationDropdownFor: button ] ];
		actionDropdownButtonIcon: BrGlamorousIcons save
			tooltip: 'Save transformations'
			content: [ :button | 
				| element fileSelectElement |
				fileSelectElement := BrFileSelectOrCreate new
						size: 500 @ 350;
						folder: (self topParent filename
								ifNil: [ '.' asFileReference ]
								ifNotNil: [ :fn | fn parent ]);
						fileFilterBlock: [ :file | file extension = 'rw' ];
						okAction: [ :file :btn | 
							| fn |
							button dispatchEvent: (BrDropdownHideWish new anchor: button).
							fn := file asFileReference.
							fn extension = 'rw' ifFalse: [ fn := fn withExtension: 'rw' ].
							self topParent filename: fn.
							self topParent save.
							transformationElement ifNotNil: [ transformationElement updateRewrites ] ];
						buttonLabel: 'Save';
						padding: (BlInsets all: 20).
				self topParent filename ifNotNil: [ :fn | fileSelectElement file: fn ].
				element := BrVerticalPane new.
				element fitContent.
				element addChild: fileSelectElement.
				element ];
		stencil: [ transformationElement := GtSmaCCTransformationElement new.
			transformationElement rewrites: self topParent.
			transformationElement selectAndScrollToRewrite: self.
			aContext
				at: #model
				ifPresent: [ :model | 
					model announcer
						when: #rewrites
						send: #value
						to: (WeakMessageSend
								receiver: model
								selector: #gtUpdateElement:
								arguments: {transformationElement}) ]
				ifAbsent: [  ].
			transformationElement ]
]

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCAbstractRewrite >> gtSimpleEditorFor: aView [
	<gtView>
	(self topParent isKindOf: SmaCCRewriteFile) ifTrue: [ ^ aView empty ].
	^ aView explicit
		title: 'Editor';
		priority: 10;
		stencil: [ self asElement ]
]
