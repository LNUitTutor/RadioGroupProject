# Class: SpRadioGroupPresenter

I am a presener for reuse. I hold a title and a group of radio buttons. I can help to create and to manage a group of `SpRadioButtonPresenter`s.

### Instance Variables
* `title` - `a SpLabelPresenter` holds the caption of the group
* `items` - `an OrderedCollection` of objects that are displayed as radio buttons
* `buttons` - `an OrderedCollection` of radio buttons
* `display` - `a BlockClosure` an unary block defines the way to display the items
* `columnCount` - `an Integer` between 1 and 4 - the number of columns that the buttons are divided into
* `index` - `an Integer` between 1 and buttons size - the indes of the selected button
* `whenIndexChangedDo` - `a BlockClosure` an unary block - the event handler
* `whenColumnsChangedDo` - `a BlockClosure` an unary block - the event handler
* `isEvenEvent` - `a Boolean` helper variable

### Public API

- `beSingleColumn`, `beDoubleColumn`, `beTripleColumn`, `beQuatroColumn` changes the count of columns of the buttons. The single column is set by default.
- `display: anUnaryBloc` sets a block to define the way to display the items
- `title: aString` sets the caption of the group of the buttons
- `whenColumnsChangedDo: anUnaryBloc` sets the event handler. The `columnsCount` will pass to the block
- `whenIndexChangedDo: anUnaryBloc` sets the event handler. The `index` will pass to the block
- `items: aCollection` changes the collection of objects that are displayed as radio buttons
- `addItem: anObject` adds the item to the collection of objects that are displayed as radio buttons
- `itemSelected` returns the object that corresponds to the selected button
- `columnCount`, `indexSelected`, `title` are simple getters

### Loading and the instance creation
To load the progect execute
```Smalltalk
Metacello new
   baseline: 'RadioGroupProject';
   repository: 'github://LNUitTutor/RadioGroupProject/src';
   load
```

To create an instance use `SpRadioGroupPresenter class >> on: aCollection` or `SpPresenter >> instantiate: SpRadioGroupPresenter on: aCollection`. For example
```Smalltalk
 | group |
 group := (SpRadioGroupPresenter on: 'ABCDEFGH') title: 'Choose a letter'; beDoubleColumn.
 group open
```
By using `SpRadioGroupPresenter new` you will get `SpRadioGroupPresenter on: #( 'Button 1' 'Button 2' 'Button 3' )`
