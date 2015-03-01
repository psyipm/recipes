delayed-change
===============

An AngularJS plugin to group multiple change events into one call. Useful for reducing the
number of calls done to a high-intensive `ng-change` function.

Requirements
============

- AngularJS 1.2.x+

Usage
=====

First, include the `delayed-change` module in your application:

```javascript
angular.module('myApp', ['delayed-change']);
```

Next, use the directive in the same way you would use ng-change

```html
<input ng-model="myModel" delayed-change="myCallback(args)"/>
```

**NOTE**: The callback function given may not be called each and every time the `ng-model` is changed.
This is because the directive tries group multiple changes into one event.

Options
=======
To customize the default options, simply use the `delayed-options` directive:

```html
<input ng-model="myModel" delayed-change="myCallback(args)" delayed-options="myOptions"/>
```

###Available Options:
* `delay` _(default: `300`)_ - The max time to wait before calling change function, in milliseconds
* `invoked` - Function called when change function is invoked
* `start` - Function called before change function is called
* `end` - Function called after change function is called

Author
======

[Jeremy Nauta](https://github.com/jpnauta)


