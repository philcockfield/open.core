core = require 'open.client/core'

module.exports = class HarnessTemplate extends core.mvc.Template
  root:
    """
    <div class="th_sidebar"></div>
    <div class="th_main"></div>
    """
  
  titleBar:
    """
    <div class="th_title_bar">
      <p><%= title %></p>
    </div>
    """
    
  
  suiteList:
    """
    <%= tmpl.titleBar({ title:tmpl.strings.suites }) %>
    <div class="th_scroller">
      <ul class="th_suite_root"></ul>
    </div>
    """
  
  
  suiteButton:
    """
    <div class="th_title"></div>
    <ul class="th_sub_suites"></ul>
    """
  
  
  specList:
    """
    <%= tmpl.titleBar({ title:tmpl.strings.specs }) %>
    <div class="th_scroller">
      <ul></ul>
    </div>
    """
  
  
  specButton:
    """
    <%= text %>
    """
  
  
  main:
    """
    <div class="th_host">
      <table>
        <tr class="th_title">
          <td>
            <div class="th_title">
              <p class="th_title"></p>
              <p class="th_summary"></p>
            </div>
          </td>
        </tr>
        <tr class="th_body">
          <td class="th_host"></td>
        </tr>
      </table>
    </div>
    <div class="th_context_pane"></div>
    """
  
  
  contextPane:
    """
    <div class="th_tab_strip">Foo!</div>
    <div class="th_body"></div>
    """
  
  
  
  