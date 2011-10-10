core = require 'open.client/core'

module.exports = class HarnessTemplate extends core.mvc.Template
  root:
    """
    <div class="th_sidebar">Sidebar</div>
    <div class="th_main">Main</div>
    """
  
  
  suiteList:
    """
    <ul></ul>
    """
  
  
  suiteButton:
    """
    <p class="th_title"><%= model.title() %></p>
    <ul class="th_sub_descriptions"></ul>
    """
  
  
  specList:
    """
    <div class="th_title">
      <p>Specs</p>
    </div>
    <div class="th_scroller">
      <ul></ul>
    </div>
    """
  
  
  
  