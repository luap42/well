// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "./popper"
import "./bootstrap"
import "trix"
import "@rails/actiontext"


/* what the newly created button does */
Trix.config.textAttributes.highlighted = {
    tagName: 'mark'
}

Trix.config.textAttributes.h2 = {
    tagName: 'h2'
}

Trix.config.textAttributes.underlined = {
    tagName: 'u'
}

/* insert the button visual in the default toolbar */
addEventListener("trix-initialize", function(event) {
    var highlightedButtonHTML = '<button type="button" class="trix-button" data-trix-attribute="highlighted">Mark</button>'
    var h2ButtonHTML = '<button type="button" class="trix-button" data-trix-attribute="h2">H2</button>'
    var underlinedButtonHTML = '<button type="button" class="trix-button" data-trix-attribute="underlined">Unter</button>'

    event.target.toolbarElement.
    querySelector(".trix-button-group").
    insertAdjacentHTML("beforeend", highlightedButtonHTML)

    event.target.toolbarElement.
    querySelector(".trix-button-group").
    insertAdjacentHTML("beforeend", h2ButtonHTML)

    event.target.toolbarElement.
    querySelector(".trix-button-group").
    insertAdjacentHTML("beforeend", underlinedButtonHTML)
})