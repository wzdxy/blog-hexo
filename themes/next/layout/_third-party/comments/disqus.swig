{% if theme.disqus.enable %}

  {% if theme.disqus.count %}
    <script>
      window.addEventListener('load', function(){
        setTimeout(function(){
          var $script = document.createElement('script')
          $script.setAttribute('src', 'https://{{theme.disqus.shortname}}.disqus.com/count.js')
          $script.setAttribute('id', 'dsq-count-scr')
          document.body.appendChild($script)
        }, 200)
      })
      // <script id="dsq-count-scr" src="https://{{theme.disqus.shortname}}.disqus.com/count.js" async></script>
    </script>    
  {% endif %}

  {% if page.comments %}
    <script type="text/javascript">
      var disqus_config = function () {
        this.page.url = '{{ page.permalink }}';
        this.page.identifier = '{{ page.path }}';
        this.page.title = '{{ page.title| addslashes }}';
        {% if __('disqus') !== 'disqus' -%}
          this.language = '{{ __('disqus') }}';
        {% endif -%}
      };
      function loadComments () {
        var d = document, s = d.createElement('script');
        s.src = 'https://{{theme.disqus.shortname}}.disqus.com/embed.js';
        s.setAttribute('data-timestamp', '' + +new Date());
        (d.head || d.body).appendChild(s);
      }
      {% if theme.disqus.lazyload %}
        $(function () {
          var offsetTop = $('#comments').offset().top - $(window).height();
          if (offsetTop <= 0) {
            // load directly when there's no a scrollbar
            loadComments();
          } else {
            $(window).on('scroll.disqus_scroll', function () {
              var scrollTop = document.documentElement.scrollTop;
              if (scrollTop >= offsetTop) {
                $(window).off('.disqus_scroll');
                loadComments();
              }
            });
          }
        });
      {% else %}
      window.addEventListener('load', function(){
        setTimeout(function(){
          loadComments();  
        }, 200)
      })        
      {% endif %}
    </script>
  {% endif %}

{% endif %}
