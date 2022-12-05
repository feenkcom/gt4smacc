Extension { #name : #GtCoderNavigationTabsStencil }

{ #category : #'*GT4SmaCC-Development-UI' }
GtCoderNavigationTabsStencil >> gtAddParserTab: look [
	<gtCreateComponentTab: 100>
	^ BrTab new
		aptitude: BrGlamorousTabAptitude new;
		label: 'SmaCC';
		stencil: [ | element |
			element := GtSmaCCCreateParserElement new.
			element
				behaviorBlock: [ :cls | 
					look fireEvent: BrDropdownHideWish new.
					navigationModel selectClass: cls ].
			navigationModel selectedPackageDo: [ :package | element forPackage: package ].
			navigationModel selectedTagDo: [ :tag | element forPackageTag: tag ].
			element ]
]
