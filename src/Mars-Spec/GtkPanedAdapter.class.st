"
I'm an adapter for Paned Layouts.
A paned layout will split (horizontally or vertically) a panel and allow its resize. 
"
Class {
	#name : #GtkPanedAdapter,
	#superclass : #GtkLayoutAdapter,
	#instVars : [
		'layout'
	],
	#category : #'Mars-Spec-Layout-Box'
}

{ #category : #private }
GtkPanedAdapter >> addConstraits: constraints toChild: childWidget [
	"adds constraits by child."

	^ childWidget
]

{ #category : #private }
GtkPanedAdapter >> basicAdd: aPresenter constraints: constraints to: gtkWidget [
	| childWidget |

	childWidget := aPresenter buildWithSpec: constraints spec.
	self addConstraits: constraints toChild: childWidget.
	gtkWidget children 
		ifNotEmpty: [ 
			gtkWidget 
				pack2: childWidget 
				resize: constraints canResize 
				shrink: constraints canShrink ]
		ifEmpty: [
			gtkWidget 
				pack1: childWidget 
				resize: constraints canResize 
				shrink: constraints canShrink ].
			
	^ gtkWidget
]

{ #category : #building }
GtkPanedAdapter >> buildWidget [
	"We defer this until layout: (because then I will know what I have to create)"
	
	^ nil
]

{ #category : #private }
GtkPanedAdapter >> calculatePercentAtDirectionOf: aWidget extent: aPoint [
	| pos |
	
	pos := layout isHorizontal 
		ifTrue: [ aPoint x ]
		ifFalse: [ aPoint y ].
		
	^ (pos * layout position) asInteger
]

{ #category : #building }
GtkPanedAdapter >> layout: aLayout [

	layout := aLayout.	
	widget := aLayout direction newWidgetOn: self.
	aLayout position ifNotNil: [ :pos |
		pos < 1 
			ifTrue: [ self setPositionDeferred: aLayout position to: widget ]
			ifFalse: [ self setPosition: aLayout position to: widget ] ].
	widget show.
]

{ #category : #factory }
GtkPanedAdapter >> newHorizontal [

	^ GtkPaned newHorizontal
]

{ #category : #factory }
GtkPanedAdapter >> newVertical [

	^ GtkPaned newVertical
]

{ #category : #private }
GtkPanedAdapter >> setPosition: aNumber to: aWidget [

	aWidget position: (aNumber < 1 
		ifTrue: [ 
			self 
				calculatePercentAtDirectionOf: aWidget 
				extent: aWidget allocation extent ]
		ifFalse: [ 
			aNumber ])
]

{ #category : #private }
GtkPanedAdapter >> setPositionDeferred: aNumber to: aWidget [
	"executes the sizing in deferred way (once the widget receives the allocated signal, 
	 marking the widget has been asigned bounds"
	
	widget connectSizeAllocate: [ :aRect |
		aWidget position: (aNumber < 1 
			ifTrue: [ self calculatePercentAtDirectionOf: aWidget extent: aRect extent ]
			ifFalse: [ aNumber ]).
		widget disconnect: 'size-allocate' ]
]
