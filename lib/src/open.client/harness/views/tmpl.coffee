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
    <%= this.titleBar({ title:title }) %>
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
    <%= this.titleBar({ title:title }) %>
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
    <table class="th_main">
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
    """
  
  
  