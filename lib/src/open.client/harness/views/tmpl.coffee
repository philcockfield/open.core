core = require 'open.client/core'

module.exports = class HarnessTemplate extends core.mvc.Template
  root:
    """
    <div class="th_sidebar">Sidebar</div>
    <div class="th_main">Main</div>
    """
    
  
  sidebar:
    """
    <ul class="th_descriptions"></ul>
    """
  
  descriptionButton:
    """
    <p class="th_title"><%= model.title() %></p>
    <% if (model.summary()) { %>
      <p class="th_summary"><%= model.summary() %></p>
    <% } %>
    """
  
  
  