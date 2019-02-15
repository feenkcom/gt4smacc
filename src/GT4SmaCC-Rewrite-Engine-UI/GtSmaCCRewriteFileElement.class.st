Class {
	#name : #GtSmaCCRewriteFileElement,
	#superclass : #GtSmaCCRewriteAccordion,
	#category : #'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : #initialization }
GtSmaCCRewriteFileElement >> contentElement [
	^ BrSimpleList new
		vFitContent;
		stencil: [ :each :index | 
			each element
				margin:
					(BlInsets
						top: 2
						left: 5
						bottom: 5
						right: 5);
				yourself ];
		items: rewrite rewrites;
		yourself
]

{ #category : #updating }
GtSmaCCRewriteFileElement >> updateContent [
	rewrite isRoot
		ifTrue: [ self expand ].
	super updateContent
]
