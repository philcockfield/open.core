describe 'CSS Styles', ->
  
  describe 'Inset Pane', ->
    beforeAll ->
      div = $ '<div class="core_inset_pane core_shadow_x_8px"></div>'
      page.add div, width:300, height:250
      console.log 'div', div
    
    
  describe 'Scrolling', ->
    div        = null
    syncScroll = (axis) -> core.util.syncScroll div, axis
    beforeAll ->
        div = $ '''
                <div>
                  AbcdefghijklmnopqrstuvwxzyAbcdefghijklmnopqrstuvwxzyAbcdefghijklmnopqrstuvwxzyAbcdefghijklmnopqrstuvwxzyAbcdefghijklmnopqrstuvwxzy
                  Proin tristique iaculis leo, nec hendrerit lacus tristique in. Nulla congue ultricies lorem a viverra. Fusce quis lectus ac enim ultricies molestie. Proin elit arcu, hendrerit facilisis feugiat tempor, accumsan quis nulla. Maecenas gravida ultricies enim quis vulputate. Quisque id velit vitae enim lacinia feugiat ut ut sapien. Fusce semper venenatis sapien id vulputate. Aenean tempor hendrerit pulvinar. Praesent sed tortor vitae magna consequat tempor. Nullam a volutpat eros. Suspendisse sit amet quam ac purus convallis semper vel id erat. Praesent interdum, mauris a hendrerit mattis, sem velit congue velit, vel faucibus nunc nibh vel lectus. Suspendisse mollis, magna non aliquet tempor, massa velit feugiat sem, ut sagittis risus eros a est. Curabitur mattis vulputate nisl, a cursus diam ultricies et. Maecenas nunc dui, pulvinar et semper vitae, accumsan quis libero. Etiam lobortis leo eget purus porttitor vitae adipiscing dolor scelerisque.    
                </div>
                '''
        page.reset()
        page.add div, width: 250, height: 250, border:true
        syncScroll 'y'
    
    it 'Axis: x',    -> syncScroll 'x'
    it 'Axis: y',    -> syncScroll 'y'
    it 'Axis: xy',   -> syncScroll 'xy'
    it 'Axis: null', -> syncScroll null
        
      
      
      
    
    
    
  
  