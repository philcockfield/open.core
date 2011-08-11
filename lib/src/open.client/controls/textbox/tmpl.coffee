core = require 'open.client/core'

module.exports = class TextboxTmpl extends core.mvc.Template
  root: 
    """
      <span class="core_inner">
        &nbsp;
        <span class="core_watermark"></span>
        <% if (textbox.multiline()) { %>
          <textarea></textarea>
        <% } else { %>
          <input type="<%= inputType %>" />
        <% } %>
      </span>
    """
