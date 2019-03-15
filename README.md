# listviewext
extending LCL TListView with additional functionality

When dealing with TListview, I've had a task to synchronize the top item between two TListViews.
However, the current TListView LCL doesn't provide any notification on when scrolling occurred.

In order to overcome that, I've had to "extended" TListView class.
("Extension" is achived due to OOP and RTTI feature and pascal modules, where it's possible to have two classes to be named the same)

The new change introduced is OnAfterScroll event, that's called right after the scrolling is finished.
(Scrolling due to scroll by a scroll bar or keyboard navigation or programmatic scroll)

Works for Windows only. Hopefully only for now.
