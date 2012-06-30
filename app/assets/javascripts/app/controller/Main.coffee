Ext.define 'Superfit.controller.Main'
  extend: 'Ext.app.Controller'

  config:
    routes:
      '': 'showMain'
      'enterWOD': 'showEnterWOD'
    refs:
      nav: '#landingNav'
      main: 'main'
      enterWOD: 'enterWOD'
    control:
      nav:
        itemtap: 'onNavTap'


  showMain: () ->
    Ext.Viewport.setActiveItem(@getMain())

  showEnterWOD: () ->
    Ext.Viewport.setActiveItem(@getEnterWOD())

  onNavTap: () ->
    this.redirectTo('enterWOD')