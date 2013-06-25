class Superfit.Navigation extends Spine.Controller

  constructor: ->
    super
    @navigation = $(@template())

    $('.app-container').on 'click', '.pulldown', @pulldown
    @navigation.on 'tap', 'a', (e) => $('.pulldown').removeClass('open')
    $('.page').on 'pageAnimationEnd', @hideNavigation

  hideNavigation: =>
    @navigation.detach();
    $('.pulldown').removeClass('open');
    @navigation.removeClass('active')

  pulldown: (e) =>
    pulldown = $('.pulldown')
    if @navigation.is('.active')
      pulldown.removeClass('open')
      @navigation.removeClass('active')
    else
      pulldown.addClass('open')
      @navigation.prependTo('.current')
      _.defer => @navigation.addClass('active')

