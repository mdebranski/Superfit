class Superfit.Navigation extends Spine.Controller

  constructor: ->
    super
    @navigation = $(@template())

    $('.app-container').on 'tap', '.pulldown', @pulldown
    @navigation.on 'tap', 'a', @clicked
    $('.page').on 'pageAnimationEnd', @hideNavigation

  clicked: (e) =>
    e.preventDefault()
    $('.pulldown').removeClass('open')
    @navigation.removeClass('active')

    goTo = -> document.location.href = $(e.target).attr('href')
    _.delay goTo, 300

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

