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
    <ul></ul>
    """
  
  
  suiteButton:
    """
    <p class="th_title"><%= model.title() %></p>
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
    <div class="th_title">
      <p class="th_title"></p>
      <p class="th_summary"></p>
    </div>
    
    <div class="th_host"></div>
    
    """
  
  
  