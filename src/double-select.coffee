jQuery ($) ->
  $.fn.doubleSelect = ->
    this.attr "multiple", true

    wrapper      = $("<div></div>").insertBefore(this)
    source       = $("<select multiple='multiple' />").prependTo(wrapper)
    searchBox    = $("<input type='text' />").appendTo(wrapper)
    insertButton = $("<button>>></button>").appendTo(wrapper)
    removeButton = $("<button><<</button>").appendTo(wrapper)
    destination  = wrapper.append(this) && this

    selectItem = ->
      $(this).remove().appendTo(destination)

    unselectItem = ->
      $(this).remove().appendTo(source)

    destination.children(":not(:selected)").each(unselectItem)

    source.delegate      "option", "dblclick", selectItem
    destination.delegate "option", "dblclick", unselectItem

    insertButton.click -> source.find(":selected").each(selectItem)
    removeButton.click -> destination.find(":selected").each(unselectItem)

    search = ->
      if $(this).val()
        source.children("option").each ->
          $(this).remove() unless $(this).text().indexOf(searchBox.val()) > 0

    searchBox.keyup(search)
