(function() {
  jQuery(function($) {
    return $.fn.doubleSelect = function(options) {
      var ajaxSearch, delay, destination, insertButton, removeButton, search, searchBox, selectItem, settings, source, unselectItem, wrapper;
      settings = {
        searchDelay: 500,
        change: function() {}
      };
      $.extend(settings, options);
      if (!this.attr("multiple")) {
        this.attr("multiple", true);
      }
      wrapper = $("<div class='double-select'></div>").insertBefore(this);
      source = $("<select multiple='multiple' class='source' />").prependTo(wrapper);
      removeButton = $("<button class='button remove'><<</button>").appendTo(wrapper);
      searchBox = $("<input type='text' class='text_field' />").appendTo(wrapper);
      insertButton = $("<button class='button insert'>>></button>").appendTo(wrapper);
      destination = wrapper.append($(this).addClass('destination')) && this;
      selectItem = function() {
        $(this).remove().appendTo(destination);
        return settings.change();
      };
      unselectItem = function() {
        $(this).remove().appendTo(source);
        return settings.change();
      };
      destination.children(":not(:selected)").each(function() {
        return $(this).remove().appendTo(source);
      });
      source.delegate("option", "dblclick", selectItem);
      destination.delegate("option", "dblclick", unselectItem);
      insertButton.click(function() {
        return source.find(":selected").each(selectItem);
      });
      removeButton.click(function() {
        return destination.find(":selected").each(unselectItem);
      });
      delay = null;
      search = function() {
        if ($(this).val()) {
          return ajaxSearch();
        }
      };
      ajaxSearch = function() {
        var execute, success;
        execute = function() {
          return $.ajax({
            url: settings.remoteUrl,
            data: {
              q: searchBox.val()
            },
            success: success
          });
        };
        success = function(data) {
          var item, option, _results;
          source.find("option").remove();
          _results = [];
          for (option in data) {
            item = data[option];
            _results.push(destination.find("option[value='" + item.value + "']").length === 0 ? source.append($("<option value='" + item.value + "'>" + item.name + "</option>")) : void 0);
          }
          return _results;
        };
        if (delay != null) {
          clearTimeout(delay);
        }
        return delay = setTimeout(execute, settings.searchDelay);
      };
      searchBox.keyup(search);
      return destination.closest("form:first").submit(function() {
        destination.find("option").attr("selected", true);
        return source.find("option").attr("selected", false);
      });
    };
  });
}).call(this);
