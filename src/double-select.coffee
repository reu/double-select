jQuery ($) ->
  $.fn.doubleSelect = (options) ->
    settings =
      searchDelay: 500

    $.extend settings, options

    this.attr "multiple", true if this.attr "multiple"

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

    delay = null

    search = ->
      ajaxSearch() if $(this).val()

    ajaxSearch = ->
      execute = ->
        $.ajax
          url: settings.remoteUrl
          data:
            q: searchBox.val()
          success: success

      success = (data) ->
        source.find("option").remove()
        for option, item of data
          if destination.find("option[value='#{item.value}']").length == 0
            source.append $("<option value='#{item.value}'>#{item.name}</option>")

      clearTimeout delay if delay?
      delay = setTimeout execute, settings.searchDelay

    searchBox.keyup(search)
