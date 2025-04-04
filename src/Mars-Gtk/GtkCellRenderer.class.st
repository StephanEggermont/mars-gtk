"
GtkCellRenderer — An object for rendering a single cell

https://developer.gnome.org/gtk3/unstable/GtkCellRenderer.html
"
Class {
	#name : #GtkCellRenderer,
	#superclass : #GObject,
	#category : #'Mars-Gtk-Widget-CellRenderers'
}

{ #category : #private }
GtkCellRenderer class >> cellRendererNew [

	self subclassResponsibility
]

{ #category : #'instance creation' }
GtkCellRenderer class >> new [
	
	^ self cellRendererNew initialize
]

{ #category : #accessing }
GtkCellRenderer >> width [

	^ self gObjectGetInteger: 'width'
]

{ #category : #accessing }
GtkCellRenderer >> width: aNumber [ 

	self gObjectSet: 'width' toInteger: aNumber
]
