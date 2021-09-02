Class {
	#name : 'GtSmaCCCoderAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'coder'
	],
	#category : 'GT4SmaCC-Development-UI-Coders'
}

{ #category : 'instance creation' }
GtSmaCCCoderAnnouncement class >> forCoder: aCoder [
	^ self new
		coder: aCoder;
		yourself
]

{ #category : 'accessing' }
GtSmaCCCoderAnnouncement >> coder [
	^ coder
]

{ #category : 'accessing' }
GtSmaCCCoderAnnouncement >> coder: anObject [
	coder := anObject
]
