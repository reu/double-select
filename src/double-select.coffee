jQuery ($) ->
  $.fn.doubleSelect = (options) ->
    settings =
      searchDelay: 500
      change: ->

    $.extend settings, options

    this.attr "multiple", true unless this.attr "multiple"

    wrapper      = $("<div class='double-select'></div>").insertBefore(this)
    source       = $("<select multiple='multiple' class='source' />").prependTo(wrapper)
    removeButton = $("<button class='button remove'><<</button>").appendTo(wrapper)
    searchBox    = $("<input type='text' class='text_field' />").appendTo(wrapper)
    insertButton = $("<button class='button insert'>>></button>").appendTo(wrapper)
    destination  = wrapper.append($(this).addClass('destination')) && this

    selectItem = ->
      $(this).attr('selected', '').remove().appendTo(destination)
      settings.change()

    unselectItem = ->
      $(this).attr('selected', '').remove().appendTo(source)
      settings.change()

    destination.children(":not(:selected)").each -> $(this).remove().appendTo(source)
    destination.children("option").attr('selected', '')

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
          if destination.find("option[value='#{item.id}']").length == 0
            source.append $("<option value='#{item.id}'>#{item.name}</option>")

      clearTimeout delay if delay?
      delay = setTimeout execute, settings.searchDelay

    searchBox.keyup(search)

    destination.closest("form:first").submit ->
      destination.find("option").attr("selected", true)
      source.find("option").attr("selected", false)
