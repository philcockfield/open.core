core = require 'open.client/core'

module.exports = class TextboxTmpl extends core.mvc.Template
  root: 
    """
      <span class="core_inner">
        &nbsp;
        <span class="core_watermark"></span>
        <input type="text" />
      </span>
    """


###
        {if $type == 'textarea'}
          <textarea></textarea>
        {else}
          <input type="{$type}" />
        {/if}


###    


