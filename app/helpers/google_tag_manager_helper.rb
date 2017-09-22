module GoogleTagManagerHelper
  def tag_manager_js
    return '' if !tag_manager_code
    %{
      <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
      new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
      j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
      'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
      })(window,document,'script','dataLayer','#{tag_manager_code}');</script>
     }.strip.html_safe
  end

  def tag_manager_nojs
    return '' if !tag_manager_code
    %{
      <noscript><iframe src="https://www.googletagmanager.com/ns.html?id=#{tag_manager_code}"
      height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
     }.strip.html_safe
  end

private

  def tag_manager_code
    ENV['TAG_MANAGER_ID']
  end
end
