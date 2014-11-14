var name = 'form:load';
var event;

if (typeof Prototype !== 'undefined') {
    Event.fire(document, name, void 0, true);
}
event = document.createEvent('Events');
event.initEvent(name, true, true);
document.dispatchEvent(event);