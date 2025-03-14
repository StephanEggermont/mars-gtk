Class {
	#name : #GtkButtonAdapter,
	#superclass : #GtkAdapter,
	#category : #'Mars-Spec-Adapter'
}

{ #category : #building }
GtkButtonAdapter >> addModelTo: gtkButton [

	super addModelTo: gtkButton.

	widget := gtkButton.

	self model label isEmptyOrNil ifFalse: [ self updateLabel ].
	self model icon ifNotNil: [ self updateIcon ].
	
	gtkButton connectClicked: [ self model performAction ].
	self model contextMenu ifNotNil: [ :menu |
		self addMenu: menu to: gtkButton ].
	
	model whenLabelChangedDo: [ self updateLabel ].
	model whenIconChangedDo: [ self updateIcon ].

]

{ #category : #events }
GtkButtonAdapter >> clicked [

	self widget clicked
]

{ #category : #accessing }
GtkButtonAdapter >> icon [
	^ widget image
]

{ #category : #factory }
GtkButtonAdapter >> newWidget [ 
	
	^ GtkButton newLabel: self model label asString
]

{ #category : #updating }
GtkButtonAdapter >> updateIcon [

	self widget
		alwaysShowImage;
		image: (GtkImage newForm: self model icon)
]

{ #category : #updating }
GtkButtonAdapter >> updateLabel [

	self widget label: self model label asString
]

{ #category : #updating }
GtkButtonAdapter >> updateTooltip [
	self widget tooltipText: self model help
]
