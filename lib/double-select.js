(function() {
  jQuery(function($) {
    return $.fn.doubleSelect = function() {
      var destination, insertButton, removeButton, search, searchBox, selectItem, source, unselectItem, wrapper;
      this.attr("multiple", true);
      wrapper = $("<div></div>").insertBefore(this);
      source = $("<select multiple='multiple' />").prependTo(wrapper);
      searchBox = $("<input type='text' />").appendTo(wrapper);
      insertButton = $("<button>>></button>").appendTo(wrapper);
      removeButton = $("<button><<</button>").appendTo(wrapper);
      destination = wrapper.append(this) && this;
      selectItem = function() {
        return $(this).remove().appendTo(destination);
      };
      unselectItem = function() {
        return $(this).remove().appendTo(source);
      };
      destination.children(":not(:selected)").each(unselectItem);
      source.delegate("option", "dblclick", selectItem);
      destination.delegate("option", "dblclick", unselectItem);
      insertButton.click(function() {
        return source.find(":selected").each(selectItem);
      });
      removeButton.click(function() {
        return destination.find(":selected").each(unselectItem);
      });
      search = function() {
        if ($(this).val()) {
          return source.children("option").each(function() {
            if (!($(this).text().indexOf(searchBox.val()) > 0)) {
              return $(this).remove();
            }
          });
        }
      };
      return searchBox.keyup(search);
    };
  });
}).call(this);
