Class {
	#name : #GtkDropListAdapter,
	#superclass : #GtkAbstractListAdapter,
	#category : #'Mars-Spec-Adapter-List'
}

{ #category : #building }
GtkDropListAdapter >> addModelTo: gtkComboBox [

	super addModelTo: gtkComboBox.
	self setModelTo: gtkComboBox.
	gtkComboBox connectChanged: [ 
		self widgetDo: [ :w | 
			self model selectedIndex: w activeIndex + 1 ] ].
	self model whenSelectionChangedDo: [ 
		gtkComboBox activeIndex: self model selectedIndex - 1 ].
	self model model whenChangedDo: [ 
		self 
			disconnectSelectionEventsOf: gtkComboBox
			during: [ self setModelTo: gtkComboBox ] ]
]

{ #category : #private }
GtkDropListAdapter >> disconnectSelectionEventsOf: aWidget during: aBlock [

	aWidget 
		disconnect: 'changed' 
		during: aBlock
]

{ #category : #accessing }
GtkDropListAdapter >> displayedIcon [
	
	| selectedIndex |
	selectedIndex := widget activeIndex.
	
	selectedIndex = -1 ifTrue: [ ^ nil ].
	
	self model hasIcons ifFalse: [ ^ nil ].
	
	^ (widget model iteratorFromString: selectedIndex asString) gdkPixbufAt: 0 
]

{ #category : #building }
GtkDropListAdapter >> modelItemsAsDisplay [
	
	^ self presenter model items 
		collect: [ :each | self presenter displayForItem: each]
	
]

{ #category : #building }
GtkDropListAdapter >> newTreeStore [

	self presenter hasIcons 
		ifFalse: [ ^ GtkTreeStore newStrings: self modelItemsAsDisplay ].
		
	^ self newTreeStoreWithIcons
]

{ #category : #building }
GtkDropListAdapter >> newTreeStoreWithIcons [
	| store |
	
	store := GtkTreeStore newColumnTypes: { GType GDK_TYPE_PIXBUF. GType G_TYPE_STRING }.

	self presenter model items do: [ :each | 
		store appendNew
			at: 0 putObject: (GdkPixbuf newForm: (self model getIconFor: each));
			at: 1 putString: (self model displayForItem: each)].

	^ store
]

{ #category : #accessing }
GtkDropListAdapter >> selectedIndexes [
	
	^ self widget selectedIndexes 
]

{ #category : #building }
GtkDropListAdapter >> setModelTo: gtkComboBox [
	| columnIndex |

	columnIndex := 0.
	gtkComboBox clear.
	self presenter hasIcons ifTrue: [ 
		gtkComboBox appendPixbufColumn: columnIndex.
		columnIndex := columnIndex + 1 ].
	gtkComboBox appendTextColumn: columnIndex.
	gtkComboBox model: self newTreeStore	

]

{ #category : #building }
GtkDropListAdapter >> takeKeyboardFocus [ 

	^ self doTakeKeyboardFocus
]

{ #category : #building }
GtkDropListAdapter >> widgetClass [
	
	^ GtkComboBoxText
]
