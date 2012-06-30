Ext.define "Superfit.view.Main"
  extend: Ext.Container
  xtype: 'main'

  config:
    fullscreen: true
    layout: 'vbox'
    items: [
      {
        xtype: 'toolbar'
        title: 'Superfit - June 29, 2012'
        docked: 'top'
      },
      {
        xtype: 'list'
        id: 'landingNav'
        store:
          fields: ['name']
          data: [{name: 'Enter WOD'}, {name: 'Enter Food'}]
        itemTpl: '{name}'
      }
    ]
