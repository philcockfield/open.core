core = require 'open.client/core'

module.exports = class HarnessTemplate extends core.mvc.Template
  root:
    """
    <div class="th_sidebar">Sidebar</div>
    <div class="th_main">Main</div>
    """
    
