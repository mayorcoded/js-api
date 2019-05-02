var Container = require("typedi").Container;

class SomeClass {
    someMethod() {
        console.log('Hi, My name is Mayowa');
    }
}

Container.set("some-class", new SomeClass());

module.exports = SomeClass;